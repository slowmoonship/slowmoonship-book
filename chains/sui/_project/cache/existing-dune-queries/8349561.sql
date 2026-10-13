WITH ranked AS (
    SELECT
        date, -- 日期
        object_id, -- Shared Object ID
        transaction_blocks, -- 该对象涉及 Transaction Blocks

        ROW_NUMBER() OVER (
            PARTITION BY date
            ORDER BY transaction_blocks DESC
        ) AS object_rank, -- 当日 Shared Object 活跃度排名

        SUM(transaction_blocks) OVER (
            PARTITION BY date
        ) AS total_transaction_blocks -- 当日所有 Shared Object 的对象-交易关系总量
    FROM query_8348381
)

SELECT
    date, -- 日期

    100.0 * SUM(
        CASE WHEN object_rank <= 1 THEN transaction_blocks ELSE 0 END
    ) / NULLIF(MAX(total_transaction_blocks), 0)
        AS top_1_share_pct, -- Top 1 Shared Object 占比

    100.0 * SUM(
        CASE WHEN object_rank <= 5 THEN transaction_blocks ELSE 0 END
    ) / NULLIF(MAX(total_transaction_blocks), 0)
        AS top_5_share_pct, -- Top 5 Shared Objects 占比

    100.0 * SUM(
        CASE WHEN object_rank <= 10 THEN transaction_blocks ELSE 0 END
    ) / NULLIF(MAX(total_transaction_blocks), 0)
        AS top_10_share_pct, -- Top 10 Shared Objects 占比

    COUNT(*) AS active_shared_objects -- 当日出现的 Shared Objects 数量
FROM ranked
GROUP BY 1
ORDER BY date;