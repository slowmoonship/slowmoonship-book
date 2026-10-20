-- Query 02：LGNS/DAI 每日 Swap 买卖成交
-- 数据来源：Dune 当前 Polygon QuickSwap V2 decoded Swap 事件表。
-- Pair 已确认 token0=Polygon DAI、token1=LGNS；精度从 tokens.supply_latest 动态读取。
-- 买入 LGNS：amount0In(DAI)>0 且 amount1Out(LGNS)>0，即用 DAI 换出 LGNS。
-- 卖出 LGNS：amount1In(LGNS)>0 且 amount0Out(DAI)>0，即用 LGNS 换出 DAI。
-- other 表示不符合上述单向交换结构的事件，保留计数但不伪装成买入或卖出。
-- decoded 表按交易哈希和日志索引对应原始日志；本 Query 不额外去重。
-- 首笔流动性事件为 2024-03-06，底层从 2024-03-01 开始，覆盖完整生命周期并利于日期裁剪。
-- 为适配免费引擎，本 SQL 只对底层 Swap 做一次日聚合；全局验证只在日结果上使用窗口函数。

WITH token_decimals AS (
    -- 只读取 Polygon 上 DAI 与 LGNS 两个 token 的精度。
    SELECT
        MAX(CASE
            WHEN token_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
            THEN decimals
        END) AS dai_decimals,       -- token0 Polygon DAI 精度
        MAX(CASE
            WHEN token_address = 0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
            THEN decimals
        END) AS lgns_decimals       -- token1 Origin LGNS 精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'    -- blockchain 是分区字段，先限定 Polygon
      AND token_address IN (         -- 只保留本 Pair 的 token0/token1
          0x8f3cf7ad23cd3cadbd9735aff958023239c6a063,
          0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
      )
),
pair_swap AS (
    -- 在 decoded Swap 表底层同时按日期和 Pair 地址早过滤。
    SELECT
        evt_block_time AS block_time,             -- Swap 区块时间
        evt_block_number AS block_number,         -- Swap 区块号
        evt_tx_hash AS tx_hash,                   -- Swap 交易哈希
        evt_index AS evt_index,                   -- Swap 日志索引
        CAST(amount0In AS DOUBLE) AS dai_in_raw,   -- Pair 收到的 token0 DAI 原始量
        CAST(amount0Out AS DOUBLE) AS dai_out_raw, -- Pair 转出的 token0 DAI 原始量
        CAST(amount1In AS DOUBLE) AS lgns_in_raw,  -- Pair 收到的 token1 LGNS 原始量
        CAST(amount1Out AS DOUBLE) AS lgns_out_raw -- Pair 转出的 token1 LGNS 原始量
    FROM quickswap_polygon.uniswapv2pair_evt_swap
    WHERE evt_block_date >= DATE '2024-03-01'
        -- 该日期早于首笔已确认流动性事件，保留完整 Pair 生命周期。
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 最底层只读取目标 LGNS/DAI Pair。
),
classified_swap AS (
    -- 根据四个 amountIn/amountOut 字段识别买卖方向并换算 decimals。
    SELECT
        s.block_time,                                           -- Swap 区块时间
        s.block_number,                                         -- Swap 区块号
        s.tx_hash,                                              -- Swap 交易哈希
        s.evt_index,                                            -- Swap 日志索引
        CASE
            WHEN s.dai_in_raw > 0
             AND s.lgns_out_raw > 0
             AND s.dai_out_raw = 0
             AND s.lgns_in_raw = 0
            THEN 'buy'
            WHEN s.lgns_in_raw > 0
             AND s.dai_out_raw > 0
             AND s.dai_in_raw = 0
             AND s.lgns_out_raw = 0
            THEN 'sell'
            ELSE 'other'
        END AS trade_direction,                                 -- buy、sell 或 other
        s.dai_in_raw / POWER(10, d.dai_decimals) AS dai_in,    -- Pair 收到的 DAI
        s.dai_out_raw / POWER(10, d.dai_decimals) AS dai_out,  -- Pair 转出的 DAI
        s.lgns_in_raw / POWER(10, d.lgns_decimals) AS lgns_in, -- Pair 收到的 LGNS
        s.lgns_out_raw / POWER(10, d.lgns_decimals) AS lgns_out -- Pair 转出的 LGNS
    FROM pair_swap s
    CROSS JOIN token_decimals d
        -- 单行 token_decimals 只提供 DAI/LGNS 缩放参数。
    WHERE d.dai_decimals IS NOT NULL
      AND d.lgns_decimals IS NOT NULL
        -- 精度缺失时不输出误缩放金额。
),
daily_base AS (
    -- 单次扫描同时生成日成交、日级验证指标和当日 3 笔稳定伪随机样本。
    SELECT
        CAST(date_trunc('day', block_time) AS DATE) AS date, -- UTC 日期
        SUM(CASE
            WHEN trade_direction = 'buy' THEN 1 ELSE 0
        END) AS buy_count,                                  -- LGNS 买入次数
        SUM(CASE
            WHEN trade_direction = 'sell' THEN 1 ELSE 0
        END) AS sell_count,                                 -- LGNS 卖出次数
        COUNT(*) AS swap_count,                             -- 全部 Swap 次数，含 other
        SUM(CASE
            WHEN trade_direction = 'buy' THEN lgns_out ELSE 0
        END) AS buy_lgns,                                   -- LGNS 买入量
        SUM(CASE
            WHEN trade_direction = 'sell' THEN lgns_in ELSE 0
        END) AS sell_lgns,                                  -- LGNS 卖出量
        SUM(CASE
            WHEN trade_direction = 'buy' THEN dai_in ELSE 0
        END) AS buy_volume_dai,                             -- 买入 LGNS 支付的 DAI
        SUM(CASE
            WHEN trade_direction = 'sell' THEN dai_out ELSE 0
        END) AS sell_volume_dai,                            -- 卖出 LGNS 收到的 DAI
        SUM(dai_in - dai_out) AS net_dai_flow,              -- Pair DAI 净流入：DAI 入减 DAI 出
        MIN(block_time) AS day_history_start,               -- 当日最早 Swap 时间
        MAX(block_time) AS day_history_end,                 -- 当日最晚 Swap 时间
        SUM(CASE
            WHEN trade_direction = 'other' THEN 1 ELSE 0
        END) AS day_unclassified_count,                     -- 当日 other Swap 数
        min_by(
            CONCAT(
                'tx=0x', to_hex(tx_hash), ',block=', CAST(block_number AS VARCHAR),
                ',direction=', trade_direction, ',dai_in=', CAST(dai_in AS VARCHAR),
                ',dai_out=', CAST(dai_out AS VARCHAR), ',lgns_in=', CAST(lgns_in AS VARCHAR),
                ',lgns_out=', CAST(lgns_out AS VARCHAR)
            ),
            xxhash64(tx_hash),
            3
        ) AS day_samples                                    -- 当日按事件键哈希选出的 3 笔样本
    FROM classified_swap
    GROUP BY 1
),
daily_validated AS (
    -- 只在小型日结果上计算全历史起止、总行数与 other 总数，避免再次扫描 Swap 表。
    SELECT
        date,                                               -- UTC 日期
        buy_count,                                          -- LGNS 买入次数
        sell_count,                                         -- LGNS 卖出次数
        swap_count,                                         -- 全部 Swap 次数
        buy_lgns,                                           -- LGNS 买入量
        sell_lgns,                                          -- LGNS 卖出量
        buy_volume_dai,                                     -- 买入 LGNS 的 DAI 成交额
        sell_volume_dai,                                    -- 卖出 LGNS 的 DAI 成交额
        net_dai_flow,                                       -- Pair 视角 DAI 净流入
        MIN(day_history_start) OVER () AS history_start,    -- 全历史最早 Swap 时间
        MAX(day_history_end) OVER () AS history_end,        -- 全历史最晚 Swap 时间
        SUM(swap_count) OVER () AS raw_swap_count,          -- 全历史 Swap 总数
        SUM(day_unclassified_count) OVER () AS unclassified_swap_count, -- 全历史 other 数
        day_samples                                         -- 当日 3 笔审计样本
    FROM daily_base
)
SELECT
    date,                                                   -- 日期
    buy_count,                                              -- LGNS 买入次数
    sell_count,                                             -- LGNS 卖出次数
    swap_count,                                             -- 全部 Swap 次数
    buy_lgns,                                               -- LGNS 买入量
    sell_lgns,                                              -- LGNS 卖出量
    buy_volume_dai,                                         -- 买入 LGNS 的 DAI 成交额
    sell_volume_dai,                                        -- 卖出 LGNS 的 DAI 成交额
    buy_volume_dai-sell_volume_dai AS result_volume_dai,
    sum(buy_volume_dai-sell_volume_dai) over (order by date) AS result_volume_byday,
    net_dai_flow,                                           -- Pair 视角 DAI 净流入
    history_start,                                          -- Swap 历史起点
    history_end,                                            -- Swap 历史终点
    raw_swap_count,                                         -- 原始 Swap 总数
    unclassified_swap_count,                                -- 无法可靠归类的 Swap 数
    element_at(day_samples, 1) AS sample_event_1,           -- 当日抽查样本 1
    element_at(day_samples, 2) AS sample_event_2,           -- 当日抽查样本 2
    element_at(day_samples, 3) AS sample_event_3            -- 当日抽查样本 3
FROM daily_validated
ORDER BY date ASC
    -- 按日期升序，直接供柱状图使用。