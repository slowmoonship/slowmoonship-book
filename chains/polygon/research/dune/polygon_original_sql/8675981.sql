WITH filtered_creation_traces AS (
    SELECT
        block_time,
        address AS contract_address,
        "from" AS creator_address
    FROM polygon.creation_traces
    WHERE block_month >= CAST(
            date_trunc(
                'month',
                date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            ) AS date
        )
      AND block_month <= CAST(
            date_trunc(
                'month',
                date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '1' DAY
            ) AS date
        )
      AND block_time >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS timestamp
        )
      AND block_time < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS timestamp
        )
),
daily_contract_creation AS (
    SELECT
        CAST(date_trunc('day', block_time) AS date) AS date,
        COUNT(*) AS contract_creation_count,
        approx_distinct(contract_address) AS unique_contract_addresses,
        approx_distinct(creator_address) AS unique_creators
    FROM filtered_creation_traces
    GROUP BY 1
)
SELECT
    date,
    contract_creation_count,
    unique_contract_addresses,
    unique_creators
FROM daily_contract_creation
ORDER BY date;