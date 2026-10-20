WITH filtered_traces AS (
    SELECT
        block_date,
        tx_hash,
        type,
        "to" AS destination_address
    FROM polygon.traces
    WHERE block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
daily_contract_execution AS (
    SELECT
        block_date AS date,
        COUNT(*) AS trace_count,
        approx_distinct(tx_hash) AS unique_transactions,
        COUNT_IF(lower(type) = 'call') AS call_count,
        approx_distinct(destination_address) AS unique_destination_addresses
    FROM filtered_traces
    GROUP BY 1
)
SELECT
    date,
    trace_count,
    unique_transactions,
    call_count,
    unique_destination_addresses
FROM daily_contract_execution
ORDER BY date;