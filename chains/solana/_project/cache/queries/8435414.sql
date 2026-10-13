-- Purpose:
-- Show deterministic Solana account-activity and native SOL state-change metrics for
-- one index-aligned address-prefix cohort. Accounts are on-chain accounts, not users.
--
-- Source table grain:
-- solana.account_activity has one row per transaction x account.
-- This query changes grain to complete UTC date for addresses whose indexed prefix is '25'.
--
-- Time range:
-- Seven complete UTC calendar days ending two days before today. The address_prefix='25'
-- predicate makes the scan reproducible and index-aligned. Results describe this cohort only
-- and must not be scaled or presented as full-network account activity.

-- Read account identity and state-change fields for one deterministic indexed cohort.
WITH filtered_account_activity AS (
    SELECT
        block_date,
        address,
        tx_id,
        signed,
        writable,
        balance_change
    FROM solana.account_activity
    WHERE address_prefix = '25'
      AND block_time >= CAST(current_date - INTERVAL '9' DAY AS timestamp)
      AND block_time < CAST(current_date - INTERVAL '2' DAY AS timestamp)
),

-- Aggregate account activity and native SOL state changes by complete UTC date.
daily_prefix_cohort AS (
    SELECT
        block_date AS date,
        COUNT(*) AS account_activity_rows,
        approx_distinct(address) AS approximate_unique_accounts,
        approx_distinct(tx_id) AS approximate_unique_transactions,
        COUNT_IF(signed) AS signer_account_rows,
        COUNT_IF(writable) AS writable_account_rows,
        COUNT_IF(balance_change <> 0) AS balance_change_records,
        approx_distinct(CASE WHEN balance_change <> 0 THEN address END) AS accounts_with_balance_change
    FROM filtered_account_activity
    GROUP BY 1
)

SELECT
    date,                               -- Complete UTC calendar date
    account_activity_rows,              -- Transaction-account rows for address_prefix='25'
    approximate_unique_accounts,        -- Approximate on-chain accounts in the prefix cohort, not users
    approximate_unique_transactions,    -- Approximate transactions represented in the cohort
    signer_account_rows,                -- Cohort rows where the account signed
    writable_account_rows,              -- Cohort rows where the account was writable
    balance_change_records,             -- Cohort rows with non-zero native SOL balance delta
    accounts_with_balance_change        -- Approximate cohort accounts with non-zero SOL delta
FROM daily_prefix_cohort
ORDER BY date