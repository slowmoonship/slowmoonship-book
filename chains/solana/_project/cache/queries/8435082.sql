-- Purpose:
-- Validate Solana transaction, instruction-call, and account-activity row identities
-- on a bounded structural sample before creating dashboard metrics.
--
-- Source table grain:
-- solana.transactions: one non-vote transaction row.
-- solana.instruction_calls: one outer or inner instruction call row.
-- solana.account_activity: one observed transaction-account activity row.
--
-- Time range:
-- The first ten UTC minutes of the most recent fully indexed day (two UTC days ago),
-- capped at 10,000 source rows per table. This avoids near-real-time indexing lag.
-- The LIMIT changes only the QA sample size; it does not redefine source-table grain.

-- Define a ten-minute window two complete UTC days ago and its date partition.
WITH window_bounds AS (
    SELECT
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY AS start_time,
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY + INTERVAL '10' MINUTE AS end_time,
        CAST(date_trunc('day', current_timestamp) - INTERVAL '2' DAY AS date) AS partition_date
),

-- Read a bounded transaction sample after date and timestamp pruning.
transaction_sample AS (
    SELECT
        id,
        signature,
        success,
        version,
        signers,
        pre_balances,
        post_balances
    FROM solana.transactions
    CROSS JOIN window_bounds
    WHERE block_date = partition_date
      AND block_time >= start_time
      AND block_time < end_time
    LIMIT 10000
),

-- Read a bounded instruction sample after block_time pruning.
instruction_sample AS (
    SELECT
        tx_id,
        outer_instruction_index,
        inner_instruction_index,
        executing_account,
        is_inner
    FROM solana.instruction_calls
    CROSS JOIN window_bounds
    WHERE block_time >= start_time
      AND block_time < end_time
    LIMIT 10000
),

-- Read a bounded account-activity sample after block_time pruning.
account_sample AS (
    SELECT
        tx_id,
        address,
        balance_change,
        token_balance_change,
        signed,
        writable
    FROM solana.account_activity
    CROSS JOIN window_bounds
    WHERE block_time >= start_time
      AND block_time < end_time
    LIMIT 10000
),

-- Measure transaction identity, status, version, and array shape in the bounded sample.
transaction_qa AS (
    SELECT
        COUNT(*) AS row_count,
        COUNT(DISTINCT id) AS unique_ids,
        COUNT_IF(id IS NULL OR signature IS NULL) AS null_id_or_signature_rows,
        COUNT_IF(id <> signature) AS id_signature_mismatch_rows,
        COUNT_IF(success) AS successful_rows,
        COUNT_IF(NOT success) AS failed_rows,
        COUNT(DISTINCT version) AS observed_versions,
        AVG(CAST(cardinality(signers) AS double)) AS avg_signers_per_transaction,
        COUNT_IF(cardinality(pre_balances) <> cardinality(post_balances)) AS pre_post_balance_length_mismatches
    FROM transaction_sample
),

-- Measure instruction identity and outer/inner classification in the bounded sample.
instruction_qa AS (
    SELECT
        COUNT(*) AS row_count,
        COUNT(DISTINCT tx_id) AS unique_transactions,
        COUNT(DISTINCT
            CONCAT(
                COALESCE(tx_id, ''),
                '|',
                COALESCE(CAST(outer_instruction_index AS varchar), 'null'),
                '|',
                COALESCE(CAST(inner_instruction_index AS varchar), 'outer')
            )
        ) AS unique_instruction_keys,
        COUNT_IF(NOT is_inner) AS outer_instruction_rows,
        COUNT_IF(is_inner) AS inner_instruction_rows,
        COUNT_IF(is_inner AND inner_instruction_index IS NULL) AS inner_rows_missing_inner_index,
        COUNT_IF(NOT is_inner AND inner_instruction_index IS NOT NULL) AS outer_rows_with_inner_index,
        COUNT(DISTINCT executing_account) AS unique_programs
    FROM instruction_sample
),

-- Measure transaction-account pair identity and state-change fields in the bounded sample.
account_qa AS (
    SELECT
        COUNT(*) AS row_count,
        COUNT(DISTINCT address) AS unique_accounts,
        COUNT(DISTINCT tx_id) AS unique_transactions,
        COUNT(DISTINCT CONCAT(COALESCE(tx_id, ''), '|', COALESCE(address, ''))) AS unique_tx_account_pairs,
        COUNT_IF(balance_change <> 0) AS native_balance_change_rows,
        COUNT_IF(token_balance_change <> DECIMAL '0') AS token_balance_change_rows,
        COUNT_IF(address IS NULL OR tx_id IS NULL) AS null_identity_rows,
        COUNT_IF(signed) AS signer_account_rows,
        COUNT_IF(writable) AS writable_account_rows
    FROM account_sample
),

-- Convert transaction checks into a common row-oriented QA result.
transaction_result AS (
    SELECT
        'transactions_identity' AS qa_check,
        row_count AS sample_rows,
        'unique_ids' AS metric_1_name,
        CAST(unique_ids AS double) AS metric_1_value,
        'id_signature_mismatches' AS metric_2_name,
        CAST(id_signature_mismatch_rows AS double) AS metric_2_value,
        'observed_versions' AS metric_3_name,
        CAST(observed_versions AS double) AS metric_3_value,
        CONCAT(
            'success=', CAST(successful_rows AS varchar),
            '; failed=', CAST(failed_rows AS varchar),
            '; avg_signers=', CAST(ROUND(avg_signers_per_transaction, 3) AS varchar),
            '; null_ids=', CAST(null_id_or_signature_rows AS varchar),
            '; pre_post_length_mismatches=', CAST(pre_post_balance_length_mismatches AS varchar)
        ) AS caveat_or_detail
    FROM transaction_qa
),

-- Convert instruction checks into the common QA result.
instruction_result AS (
    SELECT
        'instruction_call_grain' AS qa_check,
        row_count AS sample_rows,
        'unique_instruction_keys' AS metric_1_name,
        CAST(unique_instruction_keys AS double) AS metric_1_value,
        'unique_transactions' AS metric_2_name,
        CAST(unique_transactions AS double) AS metric_2_value,
        'unique_programs' AS metric_3_name,
        CAST(unique_programs AS double) AS metric_3_value,
        CONCAT(
            'outer=', CAST(outer_instruction_rows AS varchar),
            '; inner=', CAST(inner_instruction_rows AS varchar),
            '; inner_missing_index=', CAST(inner_rows_missing_inner_index AS varchar),
            '; outer_with_inner_index=', CAST(outer_rows_with_inner_index AS varchar)
        ) AS caveat_or_detail
    FROM instruction_qa
),

-- Convert account-activity checks into the common QA result.
account_result AS (
    SELECT
        'account_activity_pair_grain' AS qa_check,
        row_count AS sample_rows,
        'unique_tx_account_pairs' AS metric_1_name,
        CAST(unique_tx_account_pairs AS double) AS metric_1_value,
        'unique_accounts' AS metric_2_name,
        CAST(unique_accounts AS double) AS metric_2_value,
        'unique_transactions' AS metric_3_name,
        CAST(unique_transactions AS double) AS metric_3_value,
        CONCAT(
            'native_change_rows=', CAST(native_balance_change_rows AS varchar),
            '; token_change_rows=', CAST(token_balance_change_rows AS varchar),
            '; signer_rows=', CAST(signer_account_rows AS varchar),
            '; writable_rows=', CAST(writable_account_rows AS varchar),
            '; null_identity_rows=', CAST(null_identity_rows AS varchar)
        ) AS caveat_or_detail
    FROM account_qa
),

-- Assemble one comparable QA row per core table layer.
combined_results AS (
    SELECT * FROM transaction_result
    UNION ALL
    SELECT * FROM instruction_result
    UNION ALL
    SELECT * FROM account_result
)

SELECT
    qa_check,                 -- Name of the structural QA check
    sample_rows,              -- Number of capped source rows inspected
    metric_1_name,            -- Name of the first layer-specific QA metric
    metric_1_value,           -- Value of the first layer-specific QA metric
    metric_2_name,            -- Name of the second layer-specific QA metric
    metric_2_value,           -- Value of the second layer-specific QA metric
    metric_3_name,            -- Name of the third layer-specific QA metric
    metric_3_value,           -- Value of the third layer-specific QA metric
    caveat_or_detail          -- Additional counts needed to interpret the grain
FROM combined_results
ORDER BY qa_check