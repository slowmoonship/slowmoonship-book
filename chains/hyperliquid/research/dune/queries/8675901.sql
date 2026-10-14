-- Dashboard 01: HyperEVM Daily Blocks — runtime evidence
WITH block_sequence AS (
    SELECT
        date AS block_date,
        time AS block_time,
        number AS block_number,
        LAG(time) OVER (ORDER BY number) AS previous_block_time
    FROM hyperevm.blocks
    WHERE date >= CURRENT_DATE - INTERVAL '91' DAY
      AND date < CURRENT_DATE
),

daily_blocks AS (
    SELECT
        block_date AS date,
        COUNT(*) AS block_count,
        MIN(block_number) AS first_block_number,
        MAX(block_number) AS last_block_number,
        AVG(
            CAST(
                DATE_DIFF('millisecond', previous_block_time, block_time)
                AS DOUBLE
            )
        ) / 1000.0 AS avg_block_interval_seconds
    FROM block_sequence
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
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
