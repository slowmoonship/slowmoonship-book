WITH filtered_blocks AS (
    SELECT
        date,
        time,
        number
    FROM polygon.blocks
    WHERE date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY
            AS date
        )
      AND date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
sequenced_blocks AS (
    SELECT
        date,
        number,
        time,
        lag(time) OVER (
            PARTITION BY date
            ORDER BY number
        ) AS previous_block_time
    FROM filtered_blocks
),
daily_blocks AS (
    SELECT
        date,
        COUNT(*) AS block_count,
        MIN(number) AS first_block_number,
        MAX(number) AS last_block_number,
        AVG(
            date_diff('millisecond', previous_block_time, time) / 1000.0
        ) AS avg_block_interval_seconds
    FROM sequenced_blocks
    GROUP BY 1
)
SELECT
    date,
    block_count,
    first_block_number,
    last_block_number,
    avg_block_interval_seconds
FROM daily_blocks
ORDER BY date;