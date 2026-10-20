WITH filtered_transactions AS (
    SELECT
        block_date,
        success,
        "from" AS from_address,
        "to" AS to_address
    FROM polygon.transactions
    WHERE block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
daily_transactions AS (
    SELECT
        block_date AS date,
        COUNT(*) AS transaction_count,
        COUNT_IF(success) AS successful_transactions,
        COUNT_IF(NOT success) AS failed_transactions,
        CAST(COUNT_IF(NOT success) AS double)
            / NULLIF(COUNT(*), 0) AS failure_rate,
        approx_distinct(from_address) AS unique_from_addresses,
        approx_distinct(to_address) AS unique_to_addresses
    FROM filtered_transactions
    GROUP BY 1
)
SELECT
    date,
    transaction_count,
    successful_transactions,
    failed_transactions,
    failure_rate,
    unique_from_addresses,
    unique_to_addresses
FROM daily_transactions
ORDER BY date;