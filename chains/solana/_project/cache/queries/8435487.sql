-- Purpose:
-- Show native SOL balance-change activity for the deterministic address-prefix cohort
-- without interpreting state deltas as SOL transfer volume.
--
-- Source table grain:
-- solana.account_activity has one row per transaction x account.
-- This query changes grain to complete UTC date for addresses whose indexed prefix is '25'.
--
-- Time range:
-- Seven complete UTC calendar days ending two days before today.
-- Results describe the prefix cohort only and are not full-network estimates.

-- Read only native SOL state-change fields for the indexed cohort.
WITH filtered_sol_state_changes AS (
    SELECT
        block_date,
        address,
        balance_change
    FROM solana.account_activity
    WHERE address_prefix = '25'
      AND block_time >= CAST(current_date - INTERVAL '9' DAY AS timestamp)
      AND block_time < CAST(current_date - INTERVAL '2' DAY AS timestamp)
      AND balance_change <> 0
),

-- Aggregate state-change rows and observed accounts by complete UTC date.
daily_sol_state_changes AS (
    SELECT
        block_date AS date,
        COUNT(*) AS balance_change_records,
        approx_distinct(address) AS accounts_with_balance_change
    FROM filtered_sol_state_changes
    GROUP BY 1
)

SELECT
    date,                            -- Complete UTC calendar date
    balance_change_records,          -- Prefix-cohort rows with non-zero native SOL balance delta
    accounts_with_balance_change     -- Approximate prefix-cohort accounts with non-zero SOL delta
FROM daily_sol_state_changes
ORDER BY date