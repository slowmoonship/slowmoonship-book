WITH filtered_fees AS (
    SELECT
        block_date,
        gas_used,
        currency_symbol,
        tx_fee
    FROM gas.fees
    WHERE blockchain = 'polygon'
      AND block_month >= CAST(
            date_trunc(
                'month',
                date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY
            ) AS date
        )
      AND block_month <= CAST(
            date_trunc(
                'month',
                date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '1' DAY
            ) AS date
        )
      AND block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
daily_fees AS (
    SELECT
        block_date AS date,
        currency_symbol,
        COUNT(*) AS transaction_count,
        SUM(gas_used) AS total_gas_used,
        SUM(tx_fee) AS total_fees_native,
        AVG(tx_fee) AS avg_fee_native
    FROM filtered_fees
    GROUP BY 1, 2
)
SELECT
    date,
    currency_symbol,
    transaction_count,
    total_gas_used,
    total_fees_native,
    avg_fee_native
FROM daily_fees
ORDER BY date, currency_symbol;