-- Source table grain:
-- One row in ethereum.blocks represents one canonical Ethereum execution-layer block.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.
-- Timestamp usage:
-- ethereum.blocks.date is the UTC partition date, while time is the block timestamp.

-- Read only the required date partitions and fields.
WITH filtered_blocks AS (
    SELECT
        date,   -- UTC partition date of the block
        number, -- Canonical Ethereum block number
        time    -- UTC timestamp at which the block was produced
    FROM ethereum.blocks
    WHERE date >= CURRENT_DATE - INTERVAL '90' DAY
      AND date < CURRENT_DATE
),

-- Order blocks by height and attach the previous block timestamp.
block_intervals AS (
    SELECT
        date,                                            -- UTC calendar date of the current block
        number,                                          -- Current block number
        time,                                            -- Current block timestamp
        LAG(time) OVER (ORDER BY number) AS previous_block_time -- Previous canonical block timestamp
    FROM filtered_blocks
),

-- Aggregate block-level rows into one row per UTC day.
daily_blocks AS (
    SELECT
        date,                                            -- UTC calendar date
        COUNT(*) AS block_count,                         -- Number of canonical block rows
        MIN(number) AS first_block_number,               -- Lowest block number observed that day
        MAX(number) AS last_block_number,                -- Highest block number observed that day
        AVG(
            CASE
                WHEN CAST(previous_block_time AS DATE) = date
                THEN DATE_DIFF('millisecond', previous_block_time, time) / 1000.0
            END
        ) AS avg_block_interval_seconds,                 -- Mean consecutive-block interval within the same UTC day
        COUNT(*) - COUNT(DISTINCT number) AS duplicate_block_numbers -- QA: duplicate block-number rows; expected to be zero
    FROM block_intervals
    GROUP BY date
)

SELECT
    date AS date,                                        -- UTC calendar date
    block_count AS block_count,                          -- Number of Ethereum blocks
    first_block_number AS first_block_number,            -- First block number observed that day
    last_block_number AS last_block_number,              -- Last block number observed that day
    avg_block_interval_seconds AS avg_block_interval_seconds, -- Average same-day consecutive block interval in seconds
    duplicate_block_numbers AS duplicate_block_numbers   -- QA duplicate count; expected zero
FROM daily_blocks
ORDER BY date;