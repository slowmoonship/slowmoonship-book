
/*
LGNS Core Event Sanity Check ｜ LGNS核心事件数据质量核验
05A：LGNS/DAI Pair Swap 唯一性与集中度核验（固定快照）

固定快照截止：
2026-08-18 09:44:54 UTC，与 Query 02（ID 8369303）的已知结果截止一致。

口径：
1. 当前 Dune Catalog 确认数据源为
   quickswap_polygon.uniswapv2pair_evt_swap。
2. Pair = 0x882d...5bFb；token0=Polygon DAI，token1=LGNS。
3. 唯一事件键 = evt_tx_hash + evt_index。
   先按交易聚合；同一交易内 COUNT(DISTINCT evt_index)
   精确等于唯一复合键数，再跨交易求和。
4. 不含 JOIN，不存在 JOIN 扩行。
5. 先压缩到交易粒度，再用 GROUPING SETS 一次生成
   summary、block、day；Top 20 作为数组保存在主结果行。
6. raw != unique 才属于重复事件键错误；数量大本身不构成错误。
*/

WITH swap_by_tx AS (
    -- 唯一一次 decoded Swap 底层扫描，按交易聚合。
    SELECT
        CAST(evt_block_time AS DATE) AS event_date,      -- Swap 的 UTC 日期
        evt_block_number AS block_number,               -- Swap 区块号
        evt_tx_hash AS tx_hash,                          -- Swap 交易哈希
        COUNT(*) AS event_count,                         -- 该交易的原始 Swap 行数
        COUNT(DISTINCT evt_index)
            AS unique_event_key_count,                   -- 该交易唯一 tx_hash+evt_index 数
        MIN(evt_block_time) AS first_event_time,         -- 该交易最早 Swap 时间
        MAX(evt_block_time) AS last_event_time           -- 该交易最晚 Swap 时间
    FROM quickswap_polygon.uniswapv2pair_evt_swap
    WHERE evt_block_date >= DATE '2024-03-01'            -- 早于 Pair 首笔事件，启用日期裁剪
      AND evt_block_date <= DATE '2026-08-18'            -- 固定快照截止日期
      AND evt_block_time <= TIMESTAMP '2026-08-18 09:44:54'
                                                         -- 对齐 Query 02 的精确截止时间
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                                                         -- 只读取 LGNS/DAI Pair
    GROUP BY
        CAST(evt_block_time AS DATE),                    -- 保留日期粒度
        evt_block_number,                                -- 保留区块粒度
        evt_tx_hash                                      -- 交易粒度
),

rollups AS (
    -- 在已压缩的交易数据上同时生成全局、区块和日期汇总。
    SELECT
        CASE
            WHEN GROUPING(event_date) = 1
             AND GROUPING(block_number) = 1
            THEN 'summary'
            WHEN GROUPING(event_date) = 0
             AND GROUPING(block_number) = 0
            THEN 'block'
            ELSE 'day'
        END AS rollup_type,                              -- summary/block/day 汇总类型
        event_date,                                      -- block/day 对应 UTC 日期
        block_number,                                    -- block 汇总对应区块号
        SUM(event_count) AS event_count,                 -- 当前汇总范围的原始事件数
        SUM(unique_event_key_count)
            AS unique_event_key_count,                   -- 当前汇总范围的唯一事件键数
        COUNT(*) AS distinct_tx_count,                   -- 当前汇总范围的唯一交易数
        COUNT(DISTINCT block_number)
            AS distinct_block_count,                     -- 当前汇总范围的唯一区块数
        MAX(event_count) AS max_events_per_tx,           -- 当前范围内单交易最大事件数
        MIN(first_event_time) AS history_start,          -- 当前范围最早事件时间
        MAX(last_event_time) AS history_end,             -- 当前范围最晚事件时间
        MAX_BY(
            CONCAT(
                'tx=0x', to_hex(tx_hash),
                ',block=', CAST(block_number AS VARCHAR),
                ',date=', CAST(event_date AS VARCHAR),
                ',raw=', CAST(event_count AS VARCHAR),
                ',unique=', CAST(unique_event_key_count AS VARCHAR)
            ),
            event_count,
            20
        ) AS top_transactions                            -- 当前范围事件最多的20笔交易
    FROM swap_by_tx
    GROUP BY GROUPING SETS (
        (),                                              -- 全局 summary
        (event_date, block_number),                      -- block 汇总
        (event_date)                                     -- day 汇总
    )
)

SELECT
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS raw_event_count,                                -- 全历史 Swap 原始行数
    MAX(unique_event_key_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_event_key_count,                       -- 全历史唯一 tx_hash+evt_index 数
    MAX(distinct_tx_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_tx_count,                              -- 全历史唯一 Swap 交易数
    MAX(distinct_block_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS distinct_block_count,                           -- 全历史唯一含 Swap 区块数
    MAX(max_events_per_tx) FILTER (
        WHERE rollup_type = 'summary'
    ) AS max_events_per_tx,                              -- 单笔交易最大 Swap 数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'block'
    ) AS max_events_per_block,                           -- 单区块最大 Swap 数
    CAST(MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) AS DOUBLE)
        / NULLIF(MAX(distinct_block_count) FILTER (
            WHERE rollup_type = 'summary'
        ), 0) AS avg_events_per_block,                   -- 每个含 Swap 区块的平均事件数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'day'
    ) AS max_daily_events,                               -- 单日最大 Swap 数
    MIN(history_start) FILTER (
        WHERE rollup_type = 'summary'
    ) AS history_start,                                  -- 全历史最早 Swap 时间
    MAX(history_end) FILTER (
        WHERE rollup_type = 'summary'
    ) AS history_end,                                    -- 全历史最晚 Swap 时间
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
    ) AS top_20_transactions,                            -- 事件最多的20笔交易
    MAX_BY(
        CONCAT(
            'block=', CAST(block_number AS VARCHAR),
            ',date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR),
            ',unique=', CAST(unique_event_key_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE rollup_type = 'block'
    ) AS top_20_blocks,                                  -- 事件最多的20个区块
    MAX_BY(
        CONCAT(
            'date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR),
            ',unique=', CAST(unique_event_key_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE rollup_type = 'day'
    ) AS top_20_days,                                    -- 事件最多的20个日期
    303088242 AS query_02_snapshot_raw_count,            -- Query 02固定快照已知原始数
    MAX(event_count) FILTER (
        WHERE rollup_type = 'summary'
    ) = 303088242 AS matches_query_02_snapshot           -- 是否与Query 02快照一致
FROM rollups
