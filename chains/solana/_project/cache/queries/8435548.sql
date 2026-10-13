-- Purpose:
-- Show curated Solana token-transfer activity while preserving the distinction
-- between token accounts, owners, and mints.
--
-- Source table grain:
-- tokens_solana.transfers has one instruction-level transfer row. One transaction
-- can produce multiple transfer rows, so transfer_count is not transaction count.
--
-- Time range:
-- Seven complete UTC calendar days ending two days before today. The block_date
-- partition is filtered directly because the full table is approximately 33,057 GB.

-- Read only transfer identity and token-account/owner/mint fields.
WITH filtered_transfers AS (
    SELECT
        block_date,
        unique_instruction_key,
        tx_id,
        token_mint_address,
        from_token_account,
        to_token_account,
        from_owner,
        to_owner,
        token_version,
        action
    FROM tokens_solana.transfers
    WHERE block_date >= current_date - INTERVAL '9' DAY
      AND block_date < current_date - INTERVAL '2' DAY
),

-- Aggregate curated transfer activity by complete UTC date.
daily_token_transfers AS (
    SELECT
        block_date AS date,
        COUNT(*) AS transfer_count,
        approx_distinct(unique_instruction_key) AS approximate_unique_transfer_keys,
        approx_distinct(tx_id) AS approximate_unique_transactions,
        approx_distinct(token_mint_address) AS unique_mints,
        approx_distinct(from_token_account) AS approximate_unique_from_token_accounts,
        approx_distinct(to_token_account) AS approximate_unique_to_token_accounts,
        approx_distinct(from_owner) AS approximate_unique_from_owners,
        approx_distinct(to_owner) AS approximate_unique_to_owners,
        approx_distinct(token_version) AS observed_token_versions,
        approx_distinct(action) AS observed_action_types,
        COUNT_IF(token_mint_address IS NULL) AS null_mint_rows
    FROM filtered_transfers
    GROUP BY 1
)

SELECT
    date,                                       -- Complete UTC calendar date
    transfer_count,                             -- Instruction-level curated token transfer rows
    approximate_unique_transfer_keys,           -- Approximate distinct Dune transfer instruction keys
    approximate_unique_transactions,            -- Approximate transactions containing transfers
    unique_mints,                                -- Approximate distinct token mint addresses
    approximate_unique_from_token_accounts,      -- Approximate source token accounts, not owners
    approximate_unique_to_token_accounts,        -- Approximate destination token accounts, not owners
    approximate_unique_from_owners,              -- Approximate source owners when available
    approximate_unique_to_owners,                -- Approximate destination owners when available
    observed_token_versions,                     -- Distinct SPL/native token-version labels observed
    observed_action_types,                       -- Distinct curated transfer action labels observed
    null_mint_rows                               -- Transfer rows without a mint address
FROM daily_token_transfers
ORDER BY date