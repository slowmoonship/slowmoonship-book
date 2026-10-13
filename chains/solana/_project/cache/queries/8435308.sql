-- Purpose:
-- Show produced Solana block/slot rows and the pre-aggregated non-vote transaction
-- counts stored on each block, without scanning the much larger transaction table.
--
-- Source table grain:
-- solana.blocks has one row per produced block at an observed slot.
-- A slot with no row is not automatically classified here as a skipped slot.
--
-- Time range:
-- The most recent 90 complete UTC calendar days. The date partition is filtered directly.

-- Read only the block fields needed for block and transaction-layer aggregates.
WITH filtered_blocks AS (
    SELECT
        date,
        time,
        slot,
        total_non_vote_transactions,
        successful_non_vote_transactions,
        failed_non_vote_transactions,
        total_vote_transactions
    FROM solana.blocks
    WHERE date >= current_date - INTERVAL '90' DAY
      AND date < current_date
),

-- Compute the previous produced-block timestamp for observed interval measurement.
block_intervals AS (
    SELECT
        date,
        time,
        slot,
        total_non_vote_transactions,
        successful_non_vote_transactions,
        failed_non_vote_transactions,
        total_vote_transactions,
        LAG(time) OVER (ORDER BY slot) AS previous_produced_block_time
    FROM filtered_blocks
),

-- Aggregate one row per complete UTC date.
daily_blocks AS (
    SELECT
        date,
        COUNT(*) AS block_count,
        MIN(slot) AS first_slot,
        MAX(slot) AS last_slot,
        AVG(
            CASE
                WHEN previous_produced_block_time IS NOT NULL
                THEN date_diff('millisecond', previous_produced_block_time, time) / 1000.0
            END
        ) AS avg_block_interval_seconds,
        SUM(total_non_vote_transactions) AS transaction_count,
        SUM(successful_non_vote_transactions) AS successful_transactions,
        SUM(failed_non_vote_transactions) AS failed_transactions,
        SUM(total_vote_transactions) AS vote_transaction_count
    FROM block_intervals
    GROUP BY 1
)

SELECT
    date,                                                    -- Complete UTC calendar date
    block_count,                                             -- Produced block rows observed in solana.blocks
    first_slot,                                              -- Lowest observed produced slot on the date
    last_slot,                                               -- Highest observed produced slot on the date
    avg_block_interval_seconds,                              -- Mean time between consecutive produced block rows
    transaction_count,                                       -- Non-vote transactions aggregated from block rows
    successful_transactions,                                 -- Successful non-vote transactions aggregated from blocks
    failed_transactions,                                     -- Failed non-vote transactions aggregated from blocks
    CAST(failed_transactions AS double)
        / NULLIF(transaction_count, 0) AS failure_rate,       -- Failed share of non-vote transactions
    vote_transaction_count                                   -- Vote transactions kept separate from non-vote transactions
FROM daily_blocks
ORDER BY date