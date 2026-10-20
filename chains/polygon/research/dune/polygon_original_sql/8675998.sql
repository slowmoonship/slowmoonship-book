WITH filtered_dex_trades AS (
    SELECT
        block_date,
        amount_usd,
        taker,
        project
    FROM dex_evm.trades
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
daily_dex_activity AS (
    SELECT
        block_date AS date,
        COUNT(*) AS trade_segment_count,
        SUM(amount_usd) AS dex_volume_usd,
        approx_distinct(taker) AS unique_traders,
        approx_distinct(project) AS unique_projects
    FROM filtered_dex_trades
    GROUP BY 1
)
SELECT
    date,
    trade_segment_count,
    dex_volume_usd,
    unique_traders,
    unique_projects
FROM daily_dex_activity
ORDER BY date;