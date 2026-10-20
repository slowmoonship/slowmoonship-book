-- Query 06：LGNS/DAI Pair 的 DAI 资金流守恒
-- 视角：全部净流量均从 LGNS/DAI Pair 地址 0x882d...5bfb 的视角计算；正数表示 DAI 进入 Pair，负数表示 DAI 离开 Pair。
-- token0/token1：该 Pair 已确认 token0=Polygon DAI（0x8f3c...a063，18位精度），token1=LGNS（0xeb51...0f01，9位精度）。
-- 数据复用：Swap 日结果来自 query_8369303，Mint/Burn 日结果来自 query_8369227，避免重新扫描约 3.04 亿条 Swap。
-- decimals：两个被复用 Query 已从 tokens.supply_latest 动态读取 decimals 后换算；储备抽样使用 decoded Sync.reserve0，并从 tokens.supply_latest 动态读取 DAI decimals 后缩放。
-- 去重：本 Query 不再改变上游事件粒度；Query 05 已证明上游 evt_tx_hash+evt_index 唯一，日结果按 date 各一行。
-- 经济含义：Swap 净流量反映交易者与 Pair 的 DAI 交换，Liquidity 净流量反映 LP 添加/移除 DAI；两者之和才是 Pair 的事件口径 DAI 净变化。
-- 余额验证：只读取五个明确日期分区的 Pair DAI 实际余额，避免为逐日 reserve 再扫描约 3 亿条 Sync；以首日隐含期初余额作为基线。

WITH liquidity_daily AS (
    -- 复用 Query 01 的每日 Mint/Burn 结果；每个日期只有一行。
    SELECT
        date,                                                   -- UTC 日期
        COALESCE(add_dai, 0e0) AS liquidity_add_dai,            -- Mint 对应进入 Pair 的 DAI
        COALESCE(remove_dai, 0e0) AS liquidity_remove_dai,      -- Burn 对应离开 Pair 的 DAI
        COALESCE(add_dai, 0e0) - COALESCE(remove_dai, 0e0)
            AS liquidity_net_dai,                               -- Pair 视角流动性 DAI 净流入
        history_start AS liquidity_history_start,               -- Query 01 的历史起点
        history_end AS liquidity_history_end,                   -- Query 01 的历史终点
        raw_event_count AS liquidity_raw_event_count            -- Query 01 的 Mint/Burn 原始事件数
    FROM query_8369227
        -- Saved Query Result 引用避免再次读取底层 Mint/Burn 表。
),
swap_daily AS (
    -- 复用 Query 02 的每日 Swap 结果；buy 是 DAI 进入 Pair，sell 是 DAI 离开 Pair。
    SELECT
        date,                                                   -- UTC 日期
        COALESCE(buy_volume_dai, 0e0) AS swap_dai_in,           -- 已分类买入 LGNS 时进入 Pair 的 DAI
        COALESCE(sell_volume_dai, 0e0) AS swap_dai_out,         -- 已分类卖出 LGNS 时离开 Pair 的 DAI
        COALESCE(buy_volume_dai, 0e0)
            - COALESCE(sell_volume_dai, 0e0) AS swap_net_dai,   -- 按指定公式计算的 Swap DAI 净流入
        COALESCE(net_dai_flow, 0e0) AS decoded_swap_net_dai,    -- Query 02 全部 Swap（含 other）的 DAI 净流入
        COALESCE(net_dai_flow, 0e0)
            - (
                COALESCE(buy_volume_dai, 0e0)
                - COALESCE(sell_volume_dai, 0e0)
            ) AS unclassified_net_dai_gap,                      -- 197 笔 other 对净流量造成的差额
        history_start AS swap_history_start,                    -- Query 02 的历史起点
        history_end AS swap_history_end,                        -- Query 02 的历史终点
        raw_swap_count,                                        -- Query 02 的全部 Swap 数
        unclassified_swap_count                                -- Query 02 无法严格归类为 buy/sell 的事件数
    FROM query_8369303
        -- Saved Query Result 引用避免重新扫描底层约 3.04 亿条 Swap。
),
daily_flow AS (
    -- FULL OUTER JOIN 保留只有 Swap 或只有流动性事件的日期，防止日期缺口被静默丢弃。
    SELECT
        COALESCE(s.date, l.date) AS date,                       -- 两类事件的并集 UTC 日期
        COALESCE(s.swap_dai_in, 0e0) AS swap_dai_in,            -- 当日 Swap DAI 流入
        COALESCE(s.swap_dai_out, 0e0) AS swap_dai_out,          -- 当日 Swap DAI 流出
        COALESCE(s.swap_net_dai, 0e0) AS swap_net_dai,          -- 当日已分类 Swap DAI 净流入
        COALESCE(s.decoded_swap_net_dai, 0e0)
            AS decoded_swap_net_dai,                           -- 当日全部 decoded Swap DAI 净流入
        COALESCE(s.unclassified_net_dai_gap, 0e0)
            AS unclassified_net_dai_gap,                       -- 当日未分类事件净流量差额
        COALESCE(l.liquidity_add_dai, 0e0)
            AS liquidity_add_dai,                              -- 当日添加流动性的 DAI
        COALESCE(l.liquidity_remove_dai, 0e0)
            AS liquidity_remove_dai,                           -- 当日移除流动性的 DAI
        COALESCE(l.liquidity_net_dai, 0e0)
            AS liquidity_net_dai,                              -- 当日流动性 DAI 净流入
        COALESCE(s.swap_net_dai, 0e0)
            + COALESCE(l.liquidity_net_dai, 0e0)
            AS total_pair_net_dai_flow,                        -- 指定公式：Swap净流量+Liquidity净流量
        COALESCE(s.decoded_swap_net_dai, 0e0)
            + COALESCE(l.liquidity_net_dai, 0e0)
            AS decoded_total_pair_net_dai_flow,                -- 含 other 的事件口径 Pair 总净流量
        s.swap_history_start,                                  -- Swap 历史起点
        s.swap_history_end,                                    -- Swap 历史终点
        l.liquidity_history_start,                             -- 流动性历史起点
        l.liquidity_history_end,                               -- 流动性历史终点
        s.raw_swap_count,                                      -- 全部 Swap 事件数
        s.unclassified_swap_count,                             -- 未分类 Swap 事件数
        l.liquidity_raw_event_count                            -- 全部 Mint/Burn 事件数
    FROM swap_daily s
    FULL OUTER JOIN liquidity_daily l
        ON s.date = l.date
        -- 只按唯一日键连接，避免多对多 JOIN 放大金额。
),
cumulative_flow AS (
    -- 在每日唯一粒度上计算累计量；窗口顺序为 UTC 日期升序。
    SELECT
        date,                                                   -- UTC 日期
        swap_dai_in,                                            -- 当日 Swap DAI 流入
        swap_dai_out,                                           -- 当日 Swap DAI 流出
        swap_net_dai,                                           -- 当日已分类 Swap DAI 净流入
        decoded_swap_net_dai,                                   -- 当日全部 Swap DAI 净流入
        unclassified_net_dai_gap,                               -- 当日未分类事件净差
        liquidity_add_dai,                                      -- 当日添加流动性 DAI
        liquidity_remove_dai,                                   -- 当日移除流动性 DAI
        liquidity_net_dai,                                      -- 当日流动性 DAI 净流入
        total_pair_net_dai_flow,                                -- 当日指定口径 Pair 总净流入
        decoded_total_pair_net_dai_flow,                        -- 当日含 other 的 Pair 总净流入
        SUM(swap_net_dai) OVER (ORDER BY date)
            AS cumulative_swap_net_dai,                         -- 累计已分类 Swap DAI 净流入
        SUM(liquidity_net_dai) OVER (ORDER BY date)
            AS cumulative_liquidity_net_dai,                    -- 累计流动性 DAI 净流入
        SUM(total_pair_net_dai_flow) OVER (ORDER BY date)
            AS cumulative_total_pair_net_dai,                   -- 累计指定口径 Pair 总 DAI 净流入
        SUM(decoded_total_pair_net_dai_flow) OVER (ORDER BY date)
            AS cumulative_decoded_total_pair_net_dai,           -- 累计含 other 的 Pair 总 DAI 净流入
        swap_history_start,                                     -- Swap 历史起点
        swap_history_end,                                       -- Swap 历史终点
        liquidity_history_start,                                -- 流动性历史起点
        liquidity_history_end,                                  -- 流动性历史终点
        raw_swap_count,                                         -- 全部 Swap 事件数
        unclassified_swap_count,                                -- 未分类 Swap 数
        liquidity_raw_event_count                               -- 全部 Mint/Burn 数
    FROM daily_flow
),
reserve_sample_dates(date) AS (
    -- 固定抽取历史起点、三个代表日期和 Query 01 当前截止日，共五个 Sync 日期分区。
    VALUES
        (DATE '2024-03-06'),                                    -- 历史起点
        (DATE '2024-12-31'),                                    -- 代表日期一
        (DATE '2025-06-30'),                                    -- 代表日期二
        (DATE '2025-12-31'),                                    -- 代表日期三
        (DATE '2026-08-18')                                     -- 当前可共同核对截止日
),
token_decimals AS (
    -- 动态读取 Polygon DAI 精度，避免在 reserve0 换算时把 18 位精度写成不可验证常量。
    SELECT
        MAX(decimals) AS dai_decimals                            -- Polygon DAI 当前元数据精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'
        -- blockchain 是目录分区字段，只读取 Polygon。
      AND token_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
        -- 只读取 Pair token0 Polygon DAI 的元数据。
),
pair_reserve_samples AS (
    -- 从目标 Pair 的 decoded Sync 事件读取五个抽样日的日终 reserve0；reserve0 即 DAI 储备。
    SELECT
        s.evt_block_date AS date,                               -- Sync 事件 UTC 日期
        MAX_BY(
            CAST(s.reserve0 AS DOUBLE) / POWER(10, d.dai_decimals),
            s.evt_block_number * 1000000 + s.evt_index
        ) AS reserve_dai                                       -- 当日最后一个 Sync 的 DAI 储备
    FROM quickswap_polygon.uniswapv2pair_evt_sync s
    INNER JOIN reserve_sample_dates r
        ON s.evt_block_date = r.date
        -- 只连接五个明确日期，让 evt_block_date 分区裁剪生效。
    CROSS JOIN token_decimals d
        -- token_decimals 只有一行，仅提供 DAI 缩放参数。
    WHERE s.evt_block_date IN (
          DATE '2024-03-06',
          DATE '2024-12-31',
          DATE '2025-06-30',
          DATE '2025-12-31',
          DATE '2026-08-18'
      )
        -- 明确写出五个日期分区，不扫描完整 Sync 历史。
      AND s.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只读取 LGNS/DAI QuickSwap V2 Pair。
      AND d.dai_decimals IS NOT NULL
        -- 缺少 DAI 精度时不输出误缩放储备。
    GROUP BY 1
),
flow_with_balance AS (
    -- LEFT JOIN 只为五个日期附加实际余额，其余日期保留流量但余额为空。
    SELECT
        f.*,                                                    -- 继承已列明的每日流量与累计字段
        r.reserve_dai AS pair_dai_balance                      -- 抽样日 Pair Sync DAI 储备
    FROM cumulative_flow f
    LEFT JOIN pair_reserve_samples r
        ON f.date = r.date
        -- 日键一对一连接，不改变每日结果粒度。
),
opening_reference AS (
    -- 首日余额减首日累计流量，得到隐含期初余额基线，避免武断假设部署前余额必为零。
    SELECT
        MAX(CASE
            WHEN date = DATE '2024-03-06'
            THEN pair_dai_balance - cumulative_decoded_total_pair_net_dai
        END) AS opening_dai_balance_offset                     -- 隐含期初 DAI 余额
    FROM flow_with_balance
)
SELECT
    f.date,                                                     -- UTC 日期
    f.swap_dai_in,                                              -- 当日已分类 Swap DAI 流入 Pair
    f.swap_dai_out,                                             -- 当日已分类 Swap DAI 流出 Pair
    f.swap_net_dai,                                             -- 当日 Swap DAI 净流入=in-out
    f.liquidity_add_dai,                                        -- 当日 LP 添加 DAI
    f.liquidity_remove_dai,                                     -- 当日 LP 移除 DAI
    f.liquidity_net_dai,                                        -- 当日 LP DAI 净流入=add-remove
    f.total_pair_net_dai_flow,                                  -- 当日 Pair 总净流入=swap+liquidity
    f.cumulative_swap_net_dai,                                  -- 累计 Swap DAI 净流入
    f.cumulative_liquidity_net_dai,                             -- 累计流动性 DAI 净流入
    f.cumulative_total_pair_net_dai,                            -- 累计 Pair 总 DAI 净流入
    f.decoded_swap_net_dai,                                     -- 当日含 other 的 decoded Swap 净流入
    f.unclassified_net_dai_gap,                                 -- 当日 other 对净流量的差额
    f.cumulative_decoded_total_pair_net_dai,                    -- 累计含 other 的 Pair 总净流入
    f.pair_dai_balance,                                         -- 五个抽样日的 Pair DAI 实际余额
    o.opening_dai_balance_offset,                               -- 由首日反推的期初余额基线
    CASE
        WHEN f.pair_dai_balance IS NULL
          OR o.opening_dai_balance_offset IS NULL
        THEN NULL
        ELSE f.pair_dai_balance
            - (
                f.cumulative_decoded_total_pair_net_dai
                + o.opening_dai_balance_offset
            )
    END AS flow_reconciliation_gap,                             -- 实际余额减事件流推算余额
    CASE
        WHEN f.pair_dai_balance IS NULL THEN 'NOT_SAMPLED'
        WHEN o.opening_dai_balance_offset IS NULL THEN 'NO_OPENING_BASELINE'
        WHEN ABS(
            f.pair_dai_balance
            - (
                f.cumulative_decoded_total_pair_net_dai
                + o.opening_dai_balance_offset
            )
        ) <= 0.01 THEN 'PASS_WITHIN_0.01_DAI'
        ELSE 'DIFFERENCE_REQUIRES_EXPLANATION'
    END AS reconciliation_status,                               -- 抽样守恒状态；阈值只吸收浮点舍入误差
    f.swap_history_start,                                       -- Swap 历史起点
    f.swap_history_end,                                         -- Swap 历史终点
    f.liquidity_history_start,                                  -- 流动性历史起点
    f.liquidity_history_end,                                    -- 流动性历史终点
    f.raw_swap_count,                                           -- 全部 Swap 事件数
    f.unclassified_swap_count,                                  -- 未分类 Swap 数
    f.liquidity_raw_event_count                                 -- 全部 Mint/Burn 事件数
FROM flow_with_balance f
CROSS JOIN opening_reference o
    -- opening_reference 只有一行，仅把统一期初基线附到每日结果。
ORDER BY f.date ASC
    -- 按 UTC 日期升序，直接供累计折线图与每日柱状图使用。