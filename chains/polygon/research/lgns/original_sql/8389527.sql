
/*
LGNS Liquidity Event Sanity Check ｜ LGNS流动性事件数据质量核验
05B：LGNS/DAI Pair Mint/Burn 唯一性与集中度核验（固定快照）

固定快照截止：
2026-08-18 09:28:58 UTC，与 Query 01（ID 8369227）截止一致。

口径：
1. Mint/Burn 分别来自当前 Dune Catalog 确认的 QuickSwap decoded 事件表。
2. Pair = 0x882d...5bFb；token0=Polygon DAI，token1=LGNS。
3. Mint 代表添加流动性，Burn 代表移除流动性。
4. 唯一事件键 = evt_tx_hash + evt_index；同一交易内对 evt_index 精确去重。
5. 两类事件使用 UNION ALL，因为 topic 互斥；不含 JOIN，不存在 JOIN 扩行。
6. Top 20 transaction/block/day 以主结果中的数组形式返回。
*/

WITH liquidity_events AS (
    -- 提取目标 Pair 的 Mint 事件。
    SELECT
        evt_block_time AS block_time,                    -- Mint 区块时间
        evt_block_number AS block_number,                -- Mint 区块号
        evt_tx_hash AS tx_hash,                          -- Mint 交易哈希
        evt_index AS event_index,                        -- Mint 日志索引
        'mint' AS event_type                             -- 事件类型：添加流动性
    FROM quickswap_polygon.uniswapv2pair_evt_mint
    WHERE evt_block_date >= DATE '2024-03-01'            -- 早于 Pair 首笔事件
      AND evt_block_date <= DATE '2026-08-18'            -- 固定快照截止日期
      AND evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
                                                         -- 对齐 Query 01 精确截止
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                                                         -- 只读取 LGNS/DAI Pair

    UNION ALL                                            -- Mint/Burn topic互斥，保留每条真实日志

    -- 提取目标 Pair 的 Burn 事件。
    SELECT
        evt_block_time AS block_time,                    -- Burn 区块时间
        evt_block_number AS block_number,                -- Burn 区块号
        evt_tx_hash AS tx_hash,                          -- Burn 交易哈希
        evt_index AS event_index,                        -- Burn 日志索引
        'burn' AS event_type                             -- 事件类型：移除流动性
    FROM quickswap_polygon.uniswapv2pair_evt_burn
    WHERE evt_block_date >= DATE '2024-03-01'            -- 早于 Pair 首笔事件
      AND evt_block_date <= DATE '2026-08-18'            -- 固定快照截止日期
      AND evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
                                                         -- 对齐 Query 01 精确截止
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                                                         -- 只读取 LGNS/DAI Pair
),

liquidity_by_tx AS (
    -- 按交易压缩 Mint/Burn；同一交易内 evt_index 即复合事件键的第二部分。
    SELECT
        CAST(block_time AS DATE) AS event_date,          -- UTC 日期
        block_number,                                    -- 区块号
        tx_hash,                                         -- 交易哈希
        COUNT(*) AS event_count,                         -- 该交易 Mint+Burn 原始数
        COUNT(DISTINCT event_index)
            AS unique_event_key_count,                   -- 该交易唯一事件键数
        COUNT_IF(event_type = 'mint') AS mint_count,     -- 该交易 Mint 数
        COUNT_IF(event_type = 'burn') AS burn_count,     -- 该交易 Burn 数
        COUNT(DISTINCT CASE
            WHEN event_type = 'mint' THEN event_index
        END) AS unique_mint_count,                       -- 该交易唯一 Mint 键数
        COUNT(DISTINCT CASE
            WHEN event_type = 'burn' THEN event_index
        END) AS unique_burn_count,                       -- 该交易唯一 Burn 键数
        MIN(block_time) AS first_event_time,             -- 该交易最早流动性事件时间
        MAX(block_time) AS last_event_time               -- 该交易最晚流动性事件时间
    FROM liquidity_events
    GROUP BY
        CAST(block_time AS DATE),                        -- 日期粒度
        block_number,                                    -- 区块粒度
        tx_hash                                          -- 交易粒度
),

rollups AS (
    -- 从交易粒度同时生成全局、区块、日期三层汇总。
    SELECT
        CASE
            WHEN GROUPING(event_date) = 1
             AND GROUPING(block_number) = 1
            THEN 'summary'
            WHEN GROUPING(event_date) = 0
             AND GROUPING(block_number) = 0
            THEN 'block'
            ELSE 'day'
        END AS rollup_type,                              -- summary/block/day
        event_date,                                      -- block/day对应日期
        block_number,                                    -- block对应区块
        SUM(event_count) AS event_count,                 -- 当前范围原始事件数
        SUM(unique_event_key_count)
            AS unique_event_key_count,                   -- 当前范围唯一事件键数
        SUM(mint_count) AS mint_count,                   -- 当前范围 Mint 数
        SUM(burn_count) AS burn_count,                   -- 当前范围 Burn 数
        SUM(unique_mint_count) AS unique_mint_count,     -- 当前范围唯一 Mint 数
        SUM(unique_burn_count) AS unique_burn_count,     -- 当前范围唯一 Burn 数
        COUNT(*) AS distinct_tx_count,                   -- 当前范围唯一交易数
        COUNT(DISTINCT block_number)
            AS distinct_block_count,                     -- 当前范围唯一区块数
        MAX(event_count) AS max_events_per_tx,           -- 当前范围单交易最大事件数
        MIN(first_event_time) AS history_start,          -- 当前范围最早时间
        MAX(last_event_time) AS history_end,             -- 当前范围最晚时间
        MAX_BY(
            CONCAT(
                'tx=0x', to_hex(tx_hash),
                ',block=', CAST(block_number AS VARCHAR),
                ',date=', CAST(event_date AS VARCHAR),
                ',raw=', CAST(event_count AS VARCHAR),
                ',unique=', CAST(unique_event_key_count AS VARCHAR),
                ',mint=', CAST(mint_count AS VARCHAR),
                ',burn=', CAST(burn_count AS VARCHAR)
            ),
            event_count,
            20
        ) AS top_transactions                            -- 事件数最多的20笔交易
    FROM liquidity_by_tx
    GROUP BY GROUPING SETS (
        (),                                              -- 全局
        (event_date, block_number),                      -- 区块
        (event_date)                                     -- 日期
    )
)

SELECT
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS raw_event_count,                                -- Mint+Burn 原始总数
    MAX(unique_event_key_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_event_key_count,                       -- Mint+Burn 唯一事件键总数
    MAX(mint_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS mint_count,                                     -- Mint 原始总数
    MAX(unique_mint_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS unique_mint_count,                              -- 唯一 Mint 事件数
    MAX(burn_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS burn_count,                                     -- Burn 原始总数
    MAX(unique_burn_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS unique_burn_count,                              -- 唯一 Burn 事件数
    MAX(distinct_tx_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_tx_count,                              -- 唯一流动性事件交易数
    MAX(distinct_block_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_block_count,                           -- 唯一含流动性事件区块数
    MAX(max_events_per_tx) FILTER (
        WHERE rollup_type = 'summary'
    ) AS max_events_per_tx,                              -- 单交易最大 Mint/Burn 数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'block'
    ) AS max_events_per_block,                           -- 单区块最大 Mint/Burn 数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'day'
    ) AS max_daily_events,                               -- 单日最大 Mint/Burn 数
    MIN(history_start) FILTER (
        WHERE rollup_type = 'summary'
    ) AS history_start,                                  -- 全历史最早流动性事件时间
    MAX(history_end) FILTER (
        WHERE rollup_type = 'summary'
    ) AS history_end,                                    -- 全历史最晚流动性事件时间
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) = MAX(unique_event_key_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS raw_equals_unique,                              -- 原始数是否等于唯一事件键数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) - MAX(unique_event_key_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS duplicate_event_rows,                           -- 重复事件键行数
    ARBITRARY(top_transactions) FILTER (
        WHERE rollup_type = 'summary'
    ) AS top_20_transactions,                            -- Top 20交易
    MAX_BY(
        CONCAT(
            'block=', CAST(block_number AS VARCHAR),
            ',date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR),
            ',unique=', CAST(unique_event_key_count AS VARCHAR),
            ',mint=', CAST(mint_count AS VARCHAR),
            ',burn=', CAST(burn_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE rollup_type = 'block'
    ) AS top_20_blocks,                                  -- Top 20区块
    MAX_BY(
        CONCAT(
            'date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR),
            ',unique=', CAST(unique_event_key_count AS VARCHAR),
            ',mint=', CAST(mint_count AS VARCHAR),
            ',burn=', CAST(burn_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE rollup_type = 'day'
    ) AS top_20_days,                                    -- Top 20日期
    725139 AS query_01_snapshot_raw_count,               -- Query 01固定快照原始数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) = 725139 AS matches_query_01_snapshot              -- 是否与Query 01快照一致
FROM rollups
