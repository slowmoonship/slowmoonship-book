-- Query 07：LGNS 已确认核心协议地址集合与外部世界之间的 Polygon DAI 边界现金流
-- 口径视角：正向流入是“外部地址 -> 系统地址”，流出是“系统地址 -> 外部地址”；系统内部互转不计入外部现金流。
-- 地址集合只含此前已确认的六个核心合约，不把任何未知钱包、Router 或交易对手自动归为项目方。
-- 系统地址及角色：
-- 1) LGNS     0xeB51D9A39AD5EEF215dC0Bf39a8821ff804A0F01
-- 2) sLGNS    0x99a57e6c8558bc6689f894e068733adf83c19725
-- 3) Staking  0x1964Ca90474b11FFD08af387b110ba6C96251Bfc
-- 4) Treasury 0x7B9B7d4F870A38e92c9a181B00f9b33cc8Ef5321
-- 5) Turbine  0x07Ff4e06865de4934409Aa6eCea503b08Cc1C78d
-- 6) Pair     0x882df4B0fB50a229C3B4124EB18c759911485bFb
-- DAI 地址：Polygon DAI 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063。
-- decimals：从 tokens.supply_latest 动态读取 Polygon DAI decimals，再将 Transfer.value 原始整数缩放为 DAI。
-- 去重：maker_polygon.dai_evt_transfer 中一个日志以 evt_tx_hash+evt_index 唯一；本 Query 不删除事件，
-- 并输出全历史 raw/unique/duplicate 计数，若 duplicate 不为 0 则不得将金额用于结论。
-- 经济含义：这里是六个已确认系统地址集合的边界现金流，不等于 Pair Swap 净流量，更不等同于项目收入或用户损失。

WITH system_addresses(address, role) AS (
    -- 仅列入已有语义确认的六个 LGNS 核心地址；UNKNOWN 地址不得加入本集合。
    VALUES
        (0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01, 'lgns'),       -- LGNS 代币合约
        (0x99a57e6c8558bc6689f894e068733adf83c19725, 'slgns'),      -- sLGNS 代币合约
        (0x1964ca90474b11ffd08af387b110ba6c96251bfc, 'staking'),    -- Staking 合约
        (0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321, 'treasury'),   -- Treasury 合约
        (0x07ff4e06865de4934409aa6ecea503b08cc1c78d, 'turbine'),     -- Turbine 合约
        (0x882df4b0fb50a229c3b4124eb18c759911485bfb, 'pair')         -- LGNS/DAI Pair
),
token_decimals AS (
    -- 只读取 Polygon DAI 元数据；blockchain 过滤用于分区裁剪。
    SELECT
        MAX(decimals) AS dai_decimals                            -- Polygon DAI 精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'
        -- 只保留 Polygon，避免同地址跨链歧义。
      AND token_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
        -- 只读取本 Query 唯一资产 Polygon DAI。
),
boundary_transfer_raw AS (
    -- 在 DAI 专用 decoded Transfer 表底层按日期、合约地址和六个系统端点尽早过滤。
    SELECT
        t.evt_block_time AS block_time,                           -- DAI Transfer 区块时间
        t.evt_block_date AS block_date,                           -- DAI Transfer UTC 日期分区
        t.evt_tx_hash AS tx_hash,                                -- 交易哈希
        t.evt_index AS evt_index,                                -- 日志索引
        t."from" AS from_address,                                -- DAI 发送地址
        t."to" AS to_address,                                    -- DAI 接收地址
        CAST(t.value AS DOUBLE) AS amount_raw                     -- DAI 原始 uint256 数量
    FROM maker_polygon.dai_evt_transfer t
    WHERE t.evt_block_date >= DATE '2024-03-01'
        -- 早于 LGNS/DAI Pair 首笔事件，覆盖本项目完整已知生命周期并启用日期分区裁剪。
      AND t.contract_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
        -- maker decoded 表仍显式限定 Polygon DAI 合约，防止 ABI 表口径漂移。
      AND (
          t."from" IN (
              0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
              0x99a57e6c8558bc6689f894e068733adf83c19725,
              0x1964ca90474b11ffd08af387b110ba6c96251bfc,
              0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
              0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
              0x882df4b0fb50a229c3b4124eb18c759911485bfb
          )
          OR t."to" IN (
              0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
              0x99a57e6c8558bc6689f894e068733adf83c19725,
              0x1964ca90474b11ffd08af387b110ba6c96251bfc,
              0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
              0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
              0x882df4b0fb50a229c3b4124eb18c759911485bfb
          )
      )
        -- 至少一个端点必须属于六地址系统边界，普通 DAI 转账不会进入后续计算。
),
classified_transfer AS (
    -- 两次 LEFT JOIN 识别发送端和接收端是否在系统集合；每个地址在 VALUES 中唯一，不会放大事件。
    SELECT
        r.block_time,                                            -- Transfer 区块时间
        r.block_date AS date,                                    -- UTC 日期
        r.tx_hash,                                               -- 交易哈希
        r.evt_index,                                             -- 日志索引
        r.from_address,                                          -- DAI 发送地址
        r.to_address,                                            -- DAI 接收地址
        fs.role AS from_system_role,                             -- 发送端系统角色；外部地址为空
        ts.role AS to_system_role,                               -- 接收端系统角色；外部地址为空
        r.amount_raw / POWER(10, d.dai_decimals) AS dai_amount, -- 按动态 decimals 换算的 DAI
        CASE
            WHEN fs.address IS NULL AND ts.address IS NOT NULL
                THEN 'external_in'
            WHEN fs.address IS NOT NULL AND ts.address IS NULL
                THEN 'external_out'
            WHEN fs.address IS NOT NULL AND ts.address IS NOT NULL
                THEN 'internal'
            ELSE 'outside'
        END AS flow_type                                         -- 边界方向：外部流入、外部流出或内部互转
    FROM boundary_transfer_raw r
    LEFT JOIN system_addresses fs
        ON r.from_address = fs.address
        -- 识别发送端是否属于系统；未知地址保持 NULL，不做主观归因。
    LEFT JOIN system_addresses ts
        ON r.to_address = ts.address
        -- 识别接收端是否属于系统；未知地址保持 NULL。
    CROSS JOIN token_decimals d
        -- token_decimals 只有一行，仅提供 DAI 缩放参数。
    WHERE d.dai_decimals IS NOT NULL
        -- 元数据缺失时不输出误缩放金额。
),
daily_base AS (
    -- 在唯一日期粒度同时计算金额、交易数、外部地址数和事件键质量指标。
    SELECT
        date,                                                    -- UTC 日期
        SUM(CASE WHEN flow_type = 'external_in'
            THEN dai_amount ELSE 0e0 END) AS external_dai_in,    -- 外部进入六地址系统的 DAI
        SUM(CASE WHEN flow_type = 'external_out'
            THEN dai_amount ELSE 0e0 END) AS external_dai_out,   -- 六地址系统流向外部的 DAI
        SUM(CASE WHEN flow_type = 'internal'
            THEN dai_amount ELSE 0e0 END)
            AS internal_dai_transfer,                            -- 六地址内部互转 DAI，不计边界现金流
        COUNT(DISTINCT CASE WHEN flow_type = 'external_in'
            THEN tx_hash END) AS external_in_tx_count,           -- 外部流入的唯一交易数
        COUNT(DISTINCT CASE WHEN flow_type = 'external_out'
            THEN tx_hash END) AS external_out_tx_count,          -- 外部流出的唯一交易数
        COUNT(DISTINCT CASE WHEN flow_type = 'external_in'
            THEN from_address END)
            AS unique_external_in_addresses,                     -- 向系统转入 DAI 的唯一外部发送地址数
        COUNT(DISTINCT CASE WHEN flow_type = 'external_out'
            THEN to_address END)
            AS unique_external_out_addresses,                    -- 从系统收到 DAI 的唯一外部接收地址数
        SUM(CASE WHEN flow_type = 'internal'
            THEN 1 ELSE 0 END) AS internal_transfer_event_count, -- 系统内部 DAI Transfer 事件数
        COUNT(*) AS day_raw_event_count,                          -- 当日全部边界相关 DAI Transfer 数
        COUNT(DISTINCT CONCAT(
            to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
        )) AS day_unique_event_count,                            -- 当日唯一 tx_hash+evt_index 数
        MIN(block_time) AS day_history_start,                    -- 当日最早边界 Transfer 时间
        MAX(block_time) AS day_history_end                       -- 当日最晚边界 Transfer 时间
    FROM classified_transfer
    WHERE flow_type IN ('external_in', 'external_out', 'internal')
        -- outside 理论上已由底层端点过滤排除；再次限定使边界口径显式可审计。
    GROUP BY 1
),
daily_validated AS (
    -- 仅在小型日结果上计算全历史质量指标，避免再次扫描原始 Transfer 表。
    SELECT
        date,                                                    -- UTC 日期
        external_dai_in,                                         -- 当日外部 DAI 流入
        external_dai_out,                                        -- 当日外部 DAI 流出
        external_dai_in - external_dai_out
            AS net_external_dai,                                 -- 系统视角当日外部 DAI 净流入
        internal_dai_transfer,                                   -- 当日内部 DAI 互转
        external_in_tx_count,                                    -- 当日外部流入交易数
        external_out_tx_count,                                   -- 当日外部流出交易数
        unique_external_in_addresses,                            -- 当日外部流入地址数
        unique_external_out_addresses,                           -- 当日外部流出地址数
        internal_transfer_event_count,                           -- 当日内部互转事件数
        SUM(day_raw_event_count) OVER ()
            AS raw_boundary_event_count,                         -- 全历史边界相关事件数
        SUM(day_unique_event_count) OVER ()
            AS unique_boundary_event_count,                      -- 全历史唯一事件键数
        SUM(day_raw_event_count - day_unique_event_count) OVER ()
            AS duplicate_event_rows,                             -- 全历史重复事件行数，预期为 0
        MIN(day_history_start) OVER () AS history_start,         -- 全历史最早边界 Transfer
        MAX(day_history_end) OVER () AS history_end              -- 全历史最晚边界 Transfer
    FROM daily_base
)
SELECT
    date,                                                        -- UTC 日期
    external_dai_in,                                             -- 外部地址向系统输入的 DAI
    external_dai_out,                                            -- 系统向外部地址输出的 DAI
    net_external_dai,                                            -- 系统视角外部 DAI 净流入=in-out
    internal_dai_transfer,                                       -- 系统地址之间互转 DAI，不计净外部流量
    external_in_tx_count,                                        -- 外部流入唯一交易数
    external_out_tx_count,                                       -- 外部流出唯一交易数
    unique_external_in_addresses,                                -- 外部流入唯一地址数
    unique_external_out_addresses,                               -- 外部流出唯一地址数
    SUM(external_dai_in) OVER (ORDER BY date)
        AS cumulative_external_dai_in,                           -- 累计外部 DAI 流入
    SUM(external_dai_out) OVER (ORDER BY date)
        AS cumulative_external_dai_out,                          -- 累计外部 DAI 流出
    SUM(net_external_dai) OVER (ORDER BY date)
        AS cumulative_net_external_dai,                          -- 累计系统视角外部 DAI 净流入
    internal_transfer_event_count,                               -- 内部互转事件数
    raw_boundary_event_count,                                    -- 边界相关原始事件数
    unique_boundary_event_count,                                 -- 边界相关唯一事件数
    duplicate_event_rows,                                        -- 重复事件行数
    6 AS core_system_address_count,                              -- 本 Query 明确使用的系统地址数量
    history_start,                                               -- 边界现金流历史起点
    history_end                                                  -- 边界现金流历史终点
FROM daily_validated
ORDER BY date ASC
    -- 日期升序，供累计折线图与每日流入/流出柱状图直接使用。