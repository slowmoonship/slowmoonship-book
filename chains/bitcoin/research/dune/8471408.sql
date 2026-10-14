-- Purpose:
-- Measure daily Bitcoin block production, observed block intervals, transaction counts,
-- and block-level reward components for the structural dashboard.
--
-- Source table grain:
-- bitcoin.blocks has one row per canonical Bitcoin block.
--
-- Time range:
-- The most recent 90 complete UTC calendar days ending two days before today.

-- Read only the partitioned 90-day block window and compute the prior block timestamp.
WITH filtered_blocks AS (
    SELECT
        date,
        time,
        height,
        hash,
        transaction_count,
        total_fees,
        total_reward,
        mint_reward,
        LAG(time) OVER (ORDER BY height) AS previous_block_time
    FROM bitcoin.blocks
    WHERE date >= CURRENT_DATE - INTERVAL '91' DAY
      AND date < CURRENT_DATE - INTERVAL '1' DAY
),

-- Aggregate one canonical block row per day into dashboard metrics.
daily_blocks AS (
    SELECT
        date,
        COUNT(*) AS block_count,
        MIN(height) AS first_block_height,
        MAX(height) AS last_block_height,
        AVG(
            CAST(date_diff('second', previous_block_time, time) AS DOUBLE) / 60.0
        ) AS avg_block_interval_minutes,
        SUM(transaction_count) AS transaction_count,
        SUM(total_fees) AS total_fees_btc,
        SUM(total_reward) AS total_reward_btc,
        SUM(mint_reward) AS mint_reward_btc
    FROM filtered_blocks
    GROUP BY 1
)

SELECT
    date,                                                -- Complete UTC calendar date
    block_count,                                         -- Canonical Bitcoin block rows mined on the date
    first_block_height,                                  -- Lowest canonical block height observed on the date
    last_block_height,                                   -- Highest canonical block height observed on the date
    avg_block_interval_minutes,                          -- Mean observed minutes since the prior canonical block
    transaction_count,                                   -- Transactions declared by block rows, including coinbase
    total_fees_btc,                                      -- Transaction fees assigned to miners, in BTC
    total_reward_btc,                                    -- Coinbase reward total: subsidy plus fees, in BTC
    mint_reward_btc                                      -- Newly minted block subsidy, in BTC
FROM daily_blocks
ORDER BY date