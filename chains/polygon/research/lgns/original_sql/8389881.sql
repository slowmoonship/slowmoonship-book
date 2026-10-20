-- Query 09：LGNS/DAI Pair 固定截止Burn明细、直接接收地址聚合与大额事件
-- 统一截止：2026-08-18 09:28:58 UTC，与Query 01/05固定快照完全一致；不包含之后新增事件。
-- Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；token0=Polygon DAI，token1=LGNS。
-- 事件语义：Uniswap V2 Pair 的 Burn(sender, amount0, amount1, to) 表示销毁 LP 后把 token0/token1 转给事件字段 to。
-- 地址归因：sender 是调用 Pair.burn 的地址，可能是 Router；evt_tx_from 是发起交易的钱包；to 是 Burn 明确记录的代币直接接收地址。
-- 因此 beneficiary_address 仅表示“本次 Burn 的直接接收地址”，不声称它是资金后续最终控制人或项目方地址。
-- to 为零地址或缺失时不强行归因，beneficiary_address=NULL 且 beneficiary_method='unresolved'。
-- decimals：DAI 与 LGNS 精度从 tokens.supply_latest 动态读取；amount0/amount1 分别按对应精度缩放。
-- 去重：事件唯一键为 evt_tx_hash+evt_index；decoded Burn 表每行作为真实日志保留，并输出 raw/unique/duplicate 核验。
-- LP tokens burned：Burn 事件本身没有 LP 数量字段；本 Query 不通过同交易其他 Transfer 猜测，因此不输出该字段。
-- 经济含义：dai_removed/lgns_removed 是 Pair 在 Burn 中直接转出的数量，不等于受益地址的最终利润或净资产变化。

WITH token_decimals AS (
    -- 只读取 Polygon DAI 与 LGNS 两个 token 的当前精度。
    SELECT
        MAX(CASE
            WHEN token_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
            THEN decimals END) AS dai_decimals,                  -- token0 Polygon DAI 精度
        MAX(CASE
            WHEN token_address = 0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
            THEN decimals END) AS lgns_decimals                  -- token1 LGNS 精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'
        -- blockchain 是元数据分区字段，只读取 Polygon。
      AND token_address IN (
          0x8f3cf7ad23cd3cadbd9735aff958023239c6a063,
          0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
      )
        -- 仅保留 Pair 的 token0/token1。
),
burn_raw AS (
    -- 从 QuickSwap V2 decoded Burn 表提取目标 Pair 全历史逐事件字段。
    SELECT
        b.evt_block_time AS block_time,                           -- Burn 区块时间
        b.evt_block_number AS block_number,                       -- Burn 区块号
        b.evt_tx_hash AS tx_hash,                                -- Burn 交易哈希
        b.evt_index AS evt_index,                                -- Burn 日志索引
        b.sender,                                                 -- 调用 Pair.burn 的地址，可能是 Router
        b."to" AS recipient_to,                                  -- Pair 直接转出 token0/token1 的接收地址
        b.evt_tx_from AS tx_from,                                -- 发起交易的外层地址
        CAST(b.amount0 AS DOUBLE) AS dai_removed_raw,             -- token0 DAI 原始数量
        CAST(b.amount1 AS DOUBLE) AS lgns_removed_raw             -- token1 LGNS 原始数量
    FROM quickswap_polygon.uniswapv2pair_evt_burn b
    WHERE b.evt_block_date >= DATE '2024-03-01'
        -- 早于首笔 Pair 事件，覆盖固定研究生命周期起点并启用日期分区裁剪。
      AND b.evt_block_date <= DATE '2026-08-18'
        -- 固定截止日期；与Query 01/05统一，避免后续执行静默扩大生命周期。
      AND b.evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻；排除Burn差异核对中确认的后续11条事件。
      AND b.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 最底层只读取目标 LGNS/DAI Pair。
),
scaled_and_attributed AS (
    -- 换算 token 数量，并依据 Burn.to 字段做“直接接收地址”归因。
    SELECT
        r.block_time,                                            -- Burn 区块时间
        r.block_number,                                          -- Burn 区块号
        r.tx_hash,                                               -- Burn 交易哈希
        r.evt_index,                                             -- Burn 日志索引
        r.sender,                                                -- Pair.burn 调用者
        r.recipient_to AS "to",                                  -- Burn 明确记录的直接接收地址
        r.tx_from,                                               -- 外层交易发起地址
        r.dai_removed_raw / POWER(10, d.dai_decimals)
            AS dai_removed,                                      -- 本次 Burn 移出的 DAI
        r.lgns_removed_raw / POWER(10, d.lgns_decimals)
            AS lgns_removed,                                     -- 本次 Burn 移出的 LGNS
        CASE
            WHEN r.recipient_to IS NULL
              OR r.recipient_to = 0x0000000000000000000000000000000000000000
            THEN NULL
            ELSE r.recipient_to
        END AS beneficiary_address,                              -- Burn.to 的非零直接接收地址
        CASE
            WHEN r.recipient_to IS NULL
              OR r.recipient_to = 0x0000000000000000000000000000000000000000
            THEN 'unresolved'
            ELSE 'burn_event_to_direct_recipient'
        END AS beneficiary_method,                               -- 归因依据：事件 to，而非 sender 猜测
        CASE
            WHEN r.recipient_to IS NULL
              OR r.recipient_to = 0x0000000000000000000000000000000000000000
            THEN 'unresolved_zero_or_null_to'
            WHEN r.recipient_to = r.tx_from
             AND r.sender = r.tx_from
            THEN 'to_sender_tx_from_all_match'
            WHEN r.recipient_to = r.tx_from
            THEN 'to_matches_tx_from'
            WHEN r.sender = r.tx_from
            THEN 'direct_caller_to_distinct_recipient'
            ELSE 'sender_or_router_distinct_from_recipient'
        END AS address_pattern                                  -- sender/to/tx_from 主要关系模式
    FROM burn_raw r
    CROSS JOIN token_decimals d
        -- token_decimals 只有一行，将 DAI/LGNS 精度应用于全部 Burn。
    WHERE d.dai_decimals IS NOT NULL
      AND d.lgns_decimals IS NOT NULL
        -- 任一精度缺失时不输出误缩放金额。
),
event_totals AS (
    -- 汇总 Burn 全局数量、金额及唯一事件键，作为质量和集中度分母。
    SELECT
        COUNT(*) AS burn_event_count,                             -- Burn 原始事件总数
        COUNT(DISTINCT CONCAT(
            to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
        )) AS unique_burn_event_count,                           -- 唯一 tx_hash+evt_index 数
        COUNT(*) - COUNT(DISTINCT CONCAT(
            to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
        )) AS duplicate_event_rows,                              -- 重复事件行数，预期为 0
        SUM(dai_removed) AS total_dai_removed_all,                -- 全历史累计移除 DAI
        SUM(lgns_removed) AS total_lgns_removed_all,              -- 全历史累计移除 LGNS
        SUM(CASE WHEN beneficiary_address IS NULL
            THEN 1 ELSE 0 END) AS unresolved_event_count         -- 无法取得非零直接接收地址的事件数
    FROM scaled_and_attributed
),
beneficiary_stats AS (
    -- 按非零 Burn.to 直接接收地址聚合移除次数、金额和时间边界。
    SELECT
        beneficiary_address,                                     -- Burn 直接接收地址
        COUNT(*) AS remove_count,                                -- 该地址接收 Burn 的次数
        SUM(dai_removed) AS total_dai_removed,                    -- 该地址累计直接收到的 DAI
        SUM(lgns_removed) AS total_lgns_removed,                  -- 该地址累计直接收到的 LGNS
        MIN(block_time) AS first_remove_time,                     -- 首次直接接收时间
        MAX(block_time) AS last_remove_time                       -- 最后直接接收时间
    FROM scaled_and_attributed
    WHERE beneficiary_address IS NOT NULL
        -- unresolved 事件不强行并入任何地址排名。
    GROUP BY 1
),
ranked_beneficiaries AS (
    -- 按累计 DAI 降序排名；地址作为并列时的确定性排序键。
    SELECT
        b.beneficiary_address,                                   -- Burn 直接接收地址
        b.remove_count,                                          -- 移除次数
        b.total_dai_removed,                                      -- 累计移除 DAI
        b.total_lgns_removed,                                     -- 累计移除 LGNS
        b.first_remove_time,                                      -- 首次移除时间
        b.last_remove_time,                                       -- 最后移除时间
        b.total_dai_removed / NULLIF(t.total_dai_removed_all, 0e0)
            AS share_of_total_removed_dai,                       -- 占全部 Burn DAI 的比例
        ROW_NUMBER() OVER (
            ORDER BY b.total_dai_removed DESC, b.beneficiary_address
        ) AS beneficiary_rank                                    -- 直接接收地址排名
    FROM beneficiary_stats b
    CROSS JOIN event_totals t
        -- event_totals 只有一行，提供全部移除 DAI 分母。
),
concentration AS (
    -- 汇总 Top 1、Top 10、Top 20 集中度，避免在逐事件行上重复求和。
    SELECT
        MAX(CASE WHEN beneficiary_rank = 1
            THEN beneficiary_address END) AS top1_beneficiary_address, -- Top 1 直接接收地址
        MAX(CASE WHEN beneficiary_rank = 1
            THEN total_dai_removed END) AS top1_total_dai_removed,     -- Top 1 累计 DAI
        SUM(CASE WHEN beneficiary_rank <= 10
            THEN total_dai_removed ELSE 0e0 END)
            / NULLIF(MAX(t.total_dai_removed_all), 0e0)
            AS top10_share_of_total_removed_dai,                 -- Top 10 占全部移除 DAI
        SUM(CASE WHEN beneficiary_rank <= 20
            THEN total_dai_removed ELSE 0e0 END)
            / NULLIF(MAX(t.total_dai_removed_all), 0e0)
            AS top20_share_of_total_removed_dai                  -- Top 20 占全部移除 DAI
    FROM ranked_beneficiaries b
    CROSS JOIN event_totals t
        -- event_totals 只有一行，提供统一分母。
),
events_enriched AS (
    -- 把地址级统计回接每笔 Burn；LEFT JOIN 保留 unresolved 事件。
    SELECT
        e.block_time,                                            -- Burn 区块时间
        e.block_number,                                          -- Burn 区块号
        e.tx_hash,                                               -- Burn 交易哈希
        e.evt_index,                                             -- Burn 日志索引
        e.sender,                                                -- Pair.burn 调用地址
        e."to",                                                  -- Burn 直接接收地址字段
        e.tx_from,                                               -- 外层交易发起地址
        e.dai_removed,                                           -- 单笔移除 DAI
        e.lgns_removed,                                          -- 单笔移除 LGNS
        e.beneficiary_address,                                   -- 非零 Burn.to 直接接收地址
        e.beneficiary_method,                                    -- 直接接收地址归因方法
        e.address_pattern,                                       -- sender/to/tx_from 模式
        b.remove_count,                                          -- 该直接接收地址移除次数
        b.total_dai_removed,                                      -- 该地址累计移除 DAI
        b.total_lgns_removed,                                     -- 该地址累计移除 LGNS
        b.first_remove_time,                                      -- 该地址首次移除时间
        b.last_remove_time,                                       -- 该地址最后移除时间
        b.share_of_total_removed_dai,                             -- 该地址占全部移除 DAI
        b.beneficiary_rank,                                      -- 该地址累计 DAI 排名
        ROW_NUMBER() OVER (
            PARTITION BY e.beneficiary_address
            ORDER BY e.dai_removed DESC, e.block_time, e.evt_index
        ) AS beneficiary_event_rank,                             -- 每个地址仅 rank=1 行承载图表汇总值
        ROW_NUMBER() OVER (
            ORDER BY e.dai_removed DESC, e.block_time, e.evt_index
        ) AS largest_event_rank                                  -- 单笔 DAI 移除事件排名
    FROM scaled_and_attributed e
    LEFT JOIN ranked_beneficiaries b
        ON e.beneficiary_address = b.beneficiary_address
        -- 仅按明确的非零 Burn.to 地址连接，不使用 sender 代替受益地址。
)
SELECT
    e.block_time,                                                -- Burn 区块时间
    e.block_number,                                              -- Burn 区块号
    e.tx_hash,                                                   -- Burn 交易哈希
    e.evt_index,                                                 -- Burn 日志索引
    e.sender,                                                    -- Pair.burn 调用者，可能是 Router
    e."to",                                                      -- Burn 明确的 token0/token1 直接接收地址
    e.tx_from,                                                   -- 外层交易发起地址
    e.dai_removed,                                               -- 单笔移除 DAI
    e.lgns_removed,                                              -- 单笔移除 LGNS
    e.beneficiary_address,                                       -- 直接接收地址；不是后续最终控制人结论
    e.beneficiary_method,                                        -- 归因方法
    e.address_pattern,                                           -- sender/to/tx_from 关系模式
    e.remove_count,                                              -- 地址累计移除次数
    e.total_dai_removed,                                         -- 地址累计移除 DAI
    e.total_lgns_removed,                                        -- 地址累计移除 LGNS
    e.first_remove_time,                                         -- 地址首次移除时间
    e.last_remove_time,                                          -- 地址最后移除时间
    e.share_of_total_removed_dai,                                -- 地址占全部移除 DAI 比例
    e.beneficiary_rank,                                          -- 地址排名
    e.largest_event_rank,                                        -- 单笔事件排名
    CASE WHEN e.beneficiary_rank <= 20
          AND e.beneficiary_event_rank = 1
        THEN CONCAT('0x', to_hex(e.beneficiary_address))
    END AS chart_beneficiary_address,                            -- Top 20 图表类别，仅地址首行非空
    CASE WHEN e.beneficiary_rank <= 20
          AND e.beneficiary_event_rank = 1
        THEN e.total_dai_removed
    END AS chart_total_dai_removed,                              -- Top 20 图表累计 DAI，仅地址首行非空
    t.burn_event_count,                                          -- 全历史 Burn 数
    t.unique_burn_event_count,                                   -- 全历史唯一 Burn 数
    t.duplicate_event_rows,                                      -- 重复 Burn 数
    t.total_dai_removed_all,                                     -- 全历史累计移除 DAI
    t.total_lgns_removed_all,                                    -- 全历史累计移除 LGNS
    CONCAT('0x', to_hex(c.top1_beneficiary_address))
        AS top1_beneficiary_address,                             -- Top 1 直接接收地址文本
    c.top1_total_dai_removed,                                    -- Top 1 累计移除 DAI
    c.top10_share_of_total_removed_dai,                          -- Top 10 集中度
    c.top20_share_of_total_removed_dai,                          -- Top 20 集中度
    t.unresolved_event_count                                     -- unresolved Burn 事件数
FROM events_enriched e
CROSS JOIN event_totals t
    -- event_totals 只有一行，将全局质量与总额附到每笔 Burn。
CROSS JOIN concentration c
    -- concentration 只有一行，将 Top 集中度附到每笔 Burn。
ORDER BY e.dai_removed DESC, e.block_time ASC, e.evt_index ASC
    -- 最大单笔优先，结果前 100 行即 Largest Liquidity Removal Events 表所需 Top 100。