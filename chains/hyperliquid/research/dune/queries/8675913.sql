-- Dashboard 02: HyperEVM Daily Transactions — runtime evidence
WITH filtered_transactions AS (
    SELECT
        block_date,
        success,
        "from" AS from_address
    FROM hyperevm.transactions
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
)

SELECT
    block_date AS date,
    COUNT(*) AS transaction_count,
    COUNT_IF(success) AS successful_transactions,
    COUNT_IF(NOT success) AS failed_transactions,
    CAST(COUNT_IF(NOT success) AS DOUBLE)
        / NULLIF(CAST(COUNT(*) AS DOUBLE), 0.0) AS failure_rate,
    COUNT(DISTINCT from_address) AS unique_from_addresses
FROM filtered_transactions
GROUP BY 1
ORDER BY date;
