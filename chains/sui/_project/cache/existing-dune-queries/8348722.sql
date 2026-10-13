WITH ptb AS (
    SELECT
        transaction_count, -- PTB 中 transaction_count
        execution_success -- Transaction Block 是否成功
    FROM sui.transactions
    WHERE date >= CURRENT_DATE - INTERVAL '90' DAY
      AND NOT is_system_txn
),

bucketed AS (
    SELECT
        CASE
            WHEN transaction_count = 1 THEN 1
            WHEN transaction_count <= 3 THEN 2
            WHEN transaction_count <= 5 THEN 3
            WHEN transaction_count <= 10 THEN 4
            WHEN transaction_count <= 20 THEN 5
            WHEN transaction_count <= 50 THEN 6
            ELSE 7
        END AS bucket_order, -- PTB 复杂度分桶排序

        CASE
            WHEN transaction_count = 1 THEN '1'
            WHEN transaction_count <= 3 THEN '2-3'
            WHEN transaction_count <= 5 THEN '4-5'
            WHEN transaction_count <= 10 THEN '6-10'
            WHEN transaction_count <= 20 THEN '11-20'
            WHEN transaction_count <= 50 THEN '21-50'
            ELSE '50+'
        END AS bucket_label, -- PTB transaction_count 分桶

        execution_success -- 是否执行成功
    FROM ptb
)

SELECT
    bucket_order, -- 分桶排序
    bucket_label, -- 分桶名称
    COUNT(*) AS transaction_blocks, -- 该复杂度 Transaction Blocks 数量

    100.0 * COUNT_IF(NOT execution_success)
        / NULLIF(COUNT(*), 0)
        AS failure_rate_pct -- 该 PTB 复杂度下失败率
FROM bucketed
GROUP BY 1, 2
ORDER BY bucket_order;