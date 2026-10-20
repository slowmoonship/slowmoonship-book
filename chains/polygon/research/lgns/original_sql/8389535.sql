
/*
LGNS Staked Event Sanity Check ｜ LGNS质押事件数据质量核验
05C：Staked(address,uint256) 单次扫描质量核验（固定快照）

截止：2026-08-18 10:13:12 UTC，与 Query 03（ID 8369505）一致。

口径：
1. Staking = 0x1964...1Bfc；Dune无decoded表，使用polygon.logs。
2. topic0 = Staked(address,uint256)；topic1 = indexed staker/recipient。
3. 唯一键 = tx_hash + log index。
4. GROUPING SETS在一次底层扫描中生成transaction/block/day/staker四种粒度：
   transaction粒度内COUNT(DISTINCT log index)精确得到唯一复合键数；
   staker粒度每行代表一个唯一staker。
5. 无JOIN，不存在扩行。
*/

WITH grouped AS (
    -- 一次扫描目标Staked日志，同时生成交易、区块、日期、staker四种聚合。
    SELECT
        CASE
            WHEN GROUPING(tx_hash) = 0
            THEN 'transaction'
            WHEN GROUPING(block_number) = 0
            THEN 'block'
            WHEN GROUPING(event_date) = 0
            THEN 'day'
            ELSE 'staker'
        END AS group_type,                               -- transaction/block/day/staker
        event_date,                                      -- transaction/block/day的UTC日期
        block_number,                                    -- transaction/block的区块号
        tx_hash,                                         -- transaction的交易哈希
        staker_topic,                                    -- staker分组的indexed地址topic
        COUNT(*) AS event_count,                         -- 当前分组原始Staked数
        COUNT(DISTINCT log_index)
            AS unique_log_index_count,                   -- transaction分组内唯一log index数
        MIN(block_time) AS first_event_time,             -- 当前分组最早时间
        MAX(block_time) AS last_event_time               -- 当前分组最晚时间
    FROM (
        -- 最底层只投影质量核验需要的列，并立即按日期、合约、topic过滤。
        SELECT
            CAST(block_time AS DATE) AS event_date,      -- UTC日期
            block_time,                                  -- 区块时间
            block_number,                                -- 区块号
            tx_hash,                                     -- 交易哈希
            "index" AS log_index,                        -- 日志索引
            topic1 AS staker_topic                       -- indexed staker/recipient
        FROM polygon.logs
        WHERE block_date >= DATE '2024-03-06'            -- Staking部署日期
          AND block_date <= DATE '2026-08-18'            -- 固定截止日期
          AND block_time <= TIMESTAMP '2026-08-18 10:13:12'
                                                         -- 对齐Query 03精确截止
          AND contract_address = 0x1964ca90474b11ffd08af387b110ba6c96251bfc
                                                         -- 只读取目标Staking
          AND topic0 = 0x9e71bc8eea02a63969f509818f2dafb9254532904319f9dbda79b67bd34a5f3d
                                                         -- Staked(address,uint256)确认topic0
    ) base
    GROUP BY GROUPING SETS (
        (event_date, block_number, tx_hash),             -- 交易粒度
        (event_date, block_number),                      -- 区块粒度
        (event_date),                                    -- 日期粒度
        (staker_topic)                                   -- 唯一staker粒度
    )
)

SELECT
    SUM(event_count) FILTER (
        WHERE group_type = 'day'
    ) AS raw_staked_count,                               -- 全历史Staked原始数
    SUM(unique_log_index_count) FILTER (
        WHERE group_type = 'transaction'
    ) AS distinct_event_key_count,                       -- 全历史唯一tx_hash+log index数
    COUNT(*) FILTER (
        WHERE group_type = 'transaction'
    ) AS distinct_tx_count,                              -- 唯一Staked交易数
    COUNT(*) FILTER (
        WHERE group_type = 'staker'
    ) AS distinct_staker_count,                          -- 唯一staker/recipient数
    COUNT(*) FILTER (
        WHERE group_type = 'block'
    ) AS distinct_block_count,                           -- 唯一含Staked区块数
    MAX(event_count) FILTER (
        WHERE group_type = 'transaction'
    ) AS max_events_per_tx,                              -- 单交易最大Staked数
    MAX(event_count) FILTER (
        WHERE group_type = 'block'
    ) AS max_events_per_block,                           -- 单区块最大Staked数
    CAST(SUM(event_count) FILTER (
        WHERE group_type = 'day'
    ) AS DOUBLE)
        / NULLIF(COUNT(*) FILTER (
            WHERE group_type = 'block'
        ), 0) AS avg_events_per_block,                   -- 每个含Staked区块平均事件数
    MAX(event_count) FILTER (
        WHERE group_type = 'day'
    ) AS max_daily_events,                               -- 单日最大Staked数
    MIN(first_event_time) FILTER (
        WHERE group_type = 'day'
    ) AS history_start,                                  -- 全历史最早Staked时间
    MAX(last_event_time) FILTER (
        WHERE group_type = 'day'
    ) AS history_end,                                    -- 全历史最晚Staked时间
    SUM(event_count) FILTER (
        WHERE group_type = 'day'
    ) = SUM(unique_log_index_count) FILTER (
        WHERE group_type = 'transaction'
    ) AS raw_equals_unique,                              -- 原始数是否等于唯一事件键数
    SUM(event_count) FILTER (
        WHERE group_type = 'day'
    ) - SUM(unique_log_index_count) FILTER (
        WHERE group_type = 'transaction'
    ) AS duplicate_event_rows,                           -- 重复事件键行数
    MAX_BY(
        CONCAT(
            'tx=0x', to_hex(tx_hash),
            ',block=', CAST(block_number AS VARCHAR),
            ',date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR),
            ',unique=', CAST(unique_log_index_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE group_type = 'transaction'
    ) AS top_20_transactions,                            -- Staked最多的20笔交易
    MAX_BY(
        CONCAT(
            'block=', CAST(block_number AS VARCHAR),
            ',date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE group_type = 'block'
    ) AS top_20_blocks,                                  -- Staked最多的20个区块
    MAX_BY(
        CONCAT(
            'date=', CAST(event_date AS VARCHAR),
            ',raw=', CAST(event_count AS VARCHAR)
        ),
        event_count,
        20
    ) FILTER (
        WHERE group_type = 'day'
    ) AS top_20_days,                                    -- Staked最多的20个日期
    74521621 AS query_03_snapshot_raw_count,             -- Query 03固定快照原始数
    SUM(event_count) FILTER (
        WHERE group_type = 'day'
    ) = 74521621 AS matches_query_03_snapshot            -- 是否与Query 03快照一致
FROM grouped
