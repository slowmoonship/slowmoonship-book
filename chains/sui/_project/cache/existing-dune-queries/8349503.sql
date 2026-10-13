--https://dune.com/queries/8348381
WITH object_activity AS (
    SELECT
        object_id, -- Shared Object ID
        SUM(transaction_blocks) AS transaction_blocks, -- 观察期涉及该对象的 Transaction Blocks
        SUM(interaction_rows) AS interaction_rows, -- 观察期对象关系记录数量
        COUNT(DISTINCT date) AS active_days, -- 观察期活跃天数
        MIN(date) AS first_seen_date, -- 观察期首次出现日期
        MAX(date) AS last_seen_date -- 观察期最后出现日期
    FROM query_8348381
    WHERE date >= CURRENT_DATE - INTERVAL '30' DAY
    GROUP BY 1
)

SELECT
    CONCAT('0x', LOWER(TO_HEX(object_id))) AS object_id, -- Shared Object 十六进制 ID
    transaction_blocks, -- 涉及该对象的 Transaction Blocks
    interaction_rows, -- 对象关系记录数量
    active_days, -- 活跃天数
    first_seen_date, -- 首次出现日期
    last_seen_date -- 最后出现日期
FROM object_activity
ORDER BY transaction_blocks DESC
LIMIT 20;