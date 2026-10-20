WITH filtered_logs AS (
    SELECT
        block_date,
        tx_hash,
        contract_address,
        topic0
    FROM polygon.logs
    WHERE block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
daily_event_logs AS (
    SELECT
        block_date AS date,
        COUNT(*) AS log_count,
        approx_distinct(tx_hash) AS unique_transactions,
        approx_distinct(contract_address) AS unique_contracts,
        approx_distinct(topic0) AS unique_topic0
    FROM filtered_logs
    GROUP BY 1
)
SELECT
    date,
    log_count,
    unique_transactions,
    unique_contracts,
    unique_topic0
FROM daily_event_logs
ORDER BY date;