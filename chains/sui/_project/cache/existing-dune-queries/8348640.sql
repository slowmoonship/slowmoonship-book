WITH checkpoint_raw AS (
    SELECT
        date, -- Checkpoint 日期
        sequence_number, -- 当前 Checkpoint 顺序号
        timestamp_ms, -- 当前 Checkpoint 时间戳
        LAG(sequence_number) OVER (
            ORDER BY sequence_number
        ) AS prev_sequence_number, -- 前一个 Checkpoint 顺序号
        LAG(timestamp_ms) OVER (
            ORDER BY sequence_number
        ) AS prev_timestamp_ms -- 前一个 Checkpoint 时间戳
    FROM sui.checkpoints
    WHERE date >= CURRENT_DATE - INTERVAL '91' DAY
),

checkpoint_gap AS (
    SELECT
        date, -- 日期
        sequence_number, -- Checkpoint 顺序号
        sequence_number - prev_sequence_number AS sequence_step, -- Checkpoint 顺序号步长
        CAST(timestamp_ms - prev_timestamp_ms AS DOUBLE) / 1000.0 AS checkpoint_gap_seconds -- Checkpoint 时间间隔，秒
    FROM checkpoint_raw
),

bucketed AS (
    SELECT
        CASE
            WHEN checkpoint_gap_seconds < 0.5 THEN 1
            WHEN checkpoint_gap_seconds < 1.0 THEN 2
            WHEN checkpoint_gap_seconds < 2.0 THEN 3
            WHEN checkpoint_gap_seconds < 3.0 THEN 4
            WHEN checkpoint_gap_seconds < 5.0 THEN 5
            WHEN checkpoint_gap_seconds < 10.0 THEN 6
            WHEN checkpoint_gap_seconds < 30.0 THEN 7
            ELSE 8
        END AS bucket_order, -- 分桶排序字段

        CASE
            WHEN checkpoint_gap_seconds < 0.5 THEN '0-0.5s'
            WHEN checkpoint_gap_seconds < 1.0 THEN '0.5-1s'
            WHEN checkpoint_gap_seconds < 2.0 THEN '1-2s'
            WHEN checkpoint_gap_seconds < 3.0 THEN '2-3s'
            WHEN checkpoint_gap_seconds < 5.0 THEN '3-5s'
            WHEN checkpoint_gap_seconds < 10.0 THEN '5-10s'
            WHEN checkpoint_gap_seconds < 30.0 THEN '10-30s'
            ELSE '30s+'
        END AS bucket_label -- Checkpoint Gap 分桶名称
    FROM checkpoint_gap
    WHERE date >= CURRENT_DATE - INTERVAL '90' DAY
      AND sequence_step = 1
)

SELECT
    bucket_order, -- 分桶排序
    bucket_label, -- 分桶名称
    COUNT(*) AS checkpoint_count -- 该区间 Checkpoint 间隔数量
FROM bucketed
GROUP BY 1, 2
ORDER BY bucket_order;