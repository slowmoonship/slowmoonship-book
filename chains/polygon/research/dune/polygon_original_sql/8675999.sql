WITH filtered_transfers AS (
    SELECT
        block_date,
        contract_address,
        "from" AS from_address,
        "to" AS to_address
    FROM tokens.transfers
    WHERE blockchain = 'polygon'
      AND block_month >= CAST(
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
      AND block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
daily_token_transfers AS (
    SELECT
        block_date AS date,
        COUNT(*) AS transfer_count,
        approx_distinct(contract_address) AS unique_tokens,
        approx_distinct(from_address) AS unique_senders,
        approx_distinct(to_address) AS unique_receivers
    FROM filtered_transfers
    GROUP BY 1
)
SELECT
    date,
    transfer_count,
    unique_tokens,
    unique_senders,
    unique_receivers
FROM daily_token_transfers
ORDER BY date;