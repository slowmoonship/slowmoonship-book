-- Purpose:
-- Validate exact candidate keys and parent-child row relationships for curated
-- token transfers, DEX segments, vote transactions, and rewards on bounded samples.
--
-- Source table grain:
-- tokens_solana.transfers: one instruction-level transfer row.
-- dex_solana.trades: one pool execution / route-segment row.
-- solana.vote_transactions: one vote transaction row.
-- solana.rewards: one reward-distribution row.
--
-- Time range:
-- The first ten UTC minutes of a fully indexed day two UTC days ago,
-- capped at 10,000 rows per source table.

-- Define one stable ten-minute window and its date/month partitions.
WITH window_bounds AS (
    SELECT
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY AS start_time,
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY + INTERVAL '10' MINUTE AS end_time,
        CAST(date_trunc('day', current_timestamp) - INTERVAL '2' DAY AS date) AS partition_date,
        CAST(date_trunc('month', current_timestamp - INTERVAL '2' DAY) AS date) AS partition_month
),

-- Read a bounded curated transfer sample after block_date pruning.
token_transfer_sample AS (
    SELECT
        unique_instruction_key,
        tx_id,
        from_token_account,
        from_owner,
        to_token_account,
        to_owner,
        token_version,
        action,
        amount_usd
    FROM tokens_solana.transfers
    CROSS JOIN window_bounds
    WHERE block_date = partition_date
      AND block_time >= start_time
      AND block_time < end_time
    LIMIT 10000
),

-- Read a bounded curated DEX segment sample after month/date pruning.
dex_segment_sample AS (
    SELECT
        tx_id,
        outer_instruction_index,
        inner_instruction_index,
        project,
        project_program_id,
        trader_id,
        trade_source,
        amount_usd
    FROM dex_solana.trades
    CROSS JOIN window_bounds
    WHERE block_month = partition_month
      AND block_date = partition_date
      AND block_time >= CAST(start_time AS timestamp)
      AND block_time < CAST(end_time AS timestamp)
    LIMIT 10000
),

-- Read a bounded vote-transaction sample after date pruning.
vote_transaction_sample AS (
    SELECT
        id,
        signature,
        block_slot,
        index,
        success,
        version
    FROM solana.vote_transactions
    CROSS JOIN window_bounds
    WHERE block_date = partition_date
      AND block_time >= CAST(start_time AS timestamp)
      AND block_time < CAST(end_time AS timestamp)
    LIMIT 10000
),

-- Read a bounded reward sample after date pruning.
reward_sample AS (
    SELECT
        block_slot,
        recipient,
        reward_type,
        lamports,
        commission
    FROM solana.rewards
    CROSS JOIN window_bounds
    WHERE block_date = partition_date
      AND block_time >= CAST(start_time AS timestamp)
      AND block_time < CAST(end_time AS timestamp)
    LIMIT 10000
),

-- Aggregate exact transfer-key and token-account/owner distinction checks.
token_transfer_qa AS (
    SELECT
        'token_transfer_grain' AS qa_check,
        COUNT(*) AS sample_rows,
        COUNT(DISTINCT unique_instruction_key) AS candidate_unique_keys,
        COUNT(DISTINCT tx_id) AS related_parent_count,
        COUNT(*) - COUNT(DISTINCT tx_id) AS extra_rows_over_parent_count,
        COUNT_IF(amount_usd IS NULL) AS null_value_rows,
        CONCAT(
            'token_account_owner_differences=',
            CAST(COUNT_IF(
                (from_token_account IS NOT NULL AND from_owner IS NOT NULL AND from_token_account <> from_owner)
                OR (to_token_account IS NOT NULL AND to_owner IS NOT NULL AND to_token_account <> to_owner)
            ) AS varchar),
            '; token_versions=', ARRAY_JOIN(ARRAY_SORT(ARRAY_AGG(DISTINCT token_version)), ','),
            '; actions=', ARRAY_JOIN(ARRAY_SORT(ARRAY_AGG(DISTINCT action)), ',')
        ) AS detail
    FROM token_transfer_sample
),

-- Aggregate exact DEX candidate-key and multi-segment transaction checks.
dex_segment_qa AS (
    SELECT
        'dex_segment_grain' AS qa_check,
        COUNT(*) AS sample_rows,
        COUNT(DISTINCT CONCAT(
            COALESCE(tx_id, ''), '|',
            COALESCE(CAST(outer_instruction_index AS varchar), 'null'), '|',
            COALESCE(CAST(inner_instruction_index AS varchar), 'null'), '|',
            COALESCE(project_program_id, ''), '|',
            COALESCE(project, '')
        )) AS candidate_unique_keys,
        COUNT(DISTINCT tx_id) AS related_parent_count,
        COUNT(*) - COUNT(DISTINCT tx_id) AS extra_rows_over_parent_count,
        COUNT_IF(amount_usd IS NULL) AS null_value_rows,
        CONCAT(
            'projects=', CAST(COUNT(DISTINCT project) AS varchar),
            '; trade_sources=', CAST(COUNT(DISTINCT trade_source) AS varchar),
            '; traders=', CAST(COUNT(DISTINCT trader_id) AS varchar)
        ) AS detail
    FROM dex_segment_sample
),

-- Aggregate exact vote-transaction identity checks.
vote_transaction_qa AS (
    SELECT
        'vote_transaction_grain' AS qa_check,
        COUNT(*) AS sample_rows,
        COUNT(DISTINCT id) AS candidate_unique_keys,
        COUNT(DISTINCT block_slot) AS related_parent_count,
        COUNT(*) - COUNT(DISTINCT block_slot) AS extra_rows_over_parent_count,
        COUNT_IF(id IS NULL OR signature IS NULL) AS null_value_rows,
        CONCAT(
            'id_signature_mismatches=', CAST(COUNT_IF(id <> signature) AS varchar),
            '; versions=', CAST(COUNT(DISTINCT version) AS varchar),
            '; successful=', CAST(COUNT_IF(success) AS varchar)
        ) AS detail
    FROM vote_transaction_sample
),

-- Aggregate reward candidate-key and block relationship checks.
reward_qa AS (
    SELECT
        'reward_grain' AS qa_check,
        COUNT(*) AS sample_rows,
        COUNT(DISTINCT CONCAT(
            COALESCE(CAST(block_slot AS varchar), ''), '|',
            COALESCE(recipient, ''), '|',
            COALESCE(reward_type, '')
        )) AS candidate_unique_keys,
        COUNT(DISTINCT block_slot) AS related_parent_count,
        COUNT(*) - COUNT(DISTINCT block_slot) AS extra_rows_over_parent_count,
        COUNT_IF(recipient IS NULL OR reward_type IS NULL) AS null_value_rows,
        CONCAT(
            'reward_types=', CAST(COUNT(DISTINCT reward_type) AS varchar),
            '; nonzero_lamports=', CAST(COUNT_IF(lamports <> 0) AS varchar),
            '; commission_present=', CAST(COUNT_IF(commission IS NOT NULL) AS varchar)
        ) AS detail
    FROM reward_sample
),

-- Assemble one row for each bounded grain test.
combined_qa AS (
    SELECT * FROM token_transfer_qa
    UNION ALL
    SELECT * FROM dex_segment_qa
    UNION ALL
    SELECT * FROM vote_transaction_qa
    UNION ALL
    SELECT * FROM reward_qa
)

SELECT
    qa_check,                         -- Name of the bounded grain test
    sample_rows,                      -- Source rows inspected after the 10,000-row cap
    candidate_unique_keys,            -- Exact distinct candidate keys in the sample
    related_parent_count,             -- Exact distinct parent transaction or block count
    extra_rows_over_parent_count,     -- Rows beyond one per parent, demonstrating 1-to-many structure
    null_value_rows,                  -- Rows missing the layer-specific QA value
    detail                            -- Additional exact field-coverage checks
FROM combined_qa
ORDER BY qa_check