-- Purpose:
-- Validate Bitcoin core table grains, parent/child counts, outpoint references,
-- coinbase exceptions, fee arithmetic, and script/address availability on a bounded sample.
--
-- Source table grain:
-- bitcoin.blocks: one row per canonical Bitcoin block.
-- bitcoin.transactions: one row per transaction.
-- bitcoin.inputs: one row per transaction input.
-- bitcoin.outputs: one row per transaction output.
--
-- Time range:
-- One complete UTC day for partition pruning; one sampled block for exact parent/child QA.
-- Input-to-previous-output QA is capped at 1,000 same-day reference candidates.

-- Fix a reproducible complete UTC day relative to execution time.
WITH params AS (
    SELECT
        CURRENT_DATE - INTERVAL '2' DAY AS qa_date
),

-- Read the Bitcoin height range for that complete UTC day.
day_bounds AS (
    SELECT
        MIN(b.height) AS min_block_height,
        MAX(b.height) AS max_block_height
    FROM bitcoin.blocks AS b
    CROSS JOIN params AS p
    WHERE b.date = p.qa_date
),

-- Select one recent block inside the pruned day for exact row-count checks.
block_sample AS (
    SELECT
        b.date,
        b.time,
        b.height,
        b.hash,
        b.transaction_count
    FROM bitcoin.blocks AS b
    CROSS JOIN params AS p
    WHERE b.date = p.qa_date
    ORDER BY b.height DESC
    LIMIT 1
),

-- Keep every transaction in the sampled block.
transaction_sample AS (
    SELECT
        t.*
    FROM bitcoin.transactions AS t
    CROSS JOIN params AS p
    INNER JOIN block_sample AS b
        ON t.block_height = b.height
       AND t.block_hash = b.hash
    WHERE t.block_date = p.qa_date
),

-- Keep every input in the sampled block.
input_sample AS (
    SELECT
        i.*
    FROM bitcoin.inputs AS i
    CROSS JOIN params AS p
    INNER JOIN block_sample AS b
        ON i.block_height = b.height
       AND i.block_hash = b.hash
    WHERE i.block_date = p.qa_date
),

-- Keep every output in the sampled block.
output_sample AS (
    SELECT
        o.*
    FROM bitcoin.outputs AS o
    CROSS JOIN params AS p
    INNER JOIN block_sample AS b
        ON o.block_height = b.height
       AND o.block_hash = b.hash
    WHERE o.block_date = p.qa_date
),

-- Aggregate transaction-grain key, count, coinbase, and fee checks.
transaction_stats AS (
    SELECT
        COUNT(*) AS transaction_rows,
        COUNT(DISTINCT id) AS distinct_transaction_ids,
        SUM(input_count) AS declared_input_rows,
        SUM(output_count) AS declared_output_rows,
        COUNT_IF(is_coinbase) AS coinbase_transaction_rows,
        COUNT_IF(
            NOT is_coinbase
            AND ABS((input_value - output_value) - fee) > 0.00000001
        ) AS fee_formula_mismatch_rows
    FROM transaction_sample
),

-- Aggregate input-grain key and coinbase exception checks.
input_stats AS (
    SELECT
        COUNT(*) AS input_rows,
        COUNT(DISTINCT ROW(tx_id, index)) AS distinct_input_keys,
        COUNT_IF(is_coinbase) AS coinbase_input_rows,
        COUNT_IF(
            is_coinbase
            AND spent_tx_id IS NULL
            AND spent_output_number IS NULL
        ) AS coinbase_inputs_without_previous_outpoint
    FROM input_sample
),

-- Aggregate output-grain key and address/script availability checks.
output_stats AS (
    SELECT
        COUNT(*) AS output_rows,
        COUNT(DISTINCT ROW(tx_id, index)) AS distinct_output_keys,
        COUNT_IF(address IS NULL) AS null_address_rows,
        COUNT_IF(type IS NULL) AS null_script_type_rows
    FROM output_sample
),

-- Select bounded non-coinbase inputs that spend outputs created on the same QA day.
reference_candidates AS (
    SELECT
        i.tx_id,
        i.index,
        i.spent_tx_id,
        i.spent_output_number,
        i.value,
        i.spent_block_height
    FROM bitcoin.inputs AS i
    CROSS JOIN params AS p
    CROSS JOIN day_bounds AS d
    WHERE i.block_date = p.qa_date
      AND NOT i.is_coinbase
      AND i.spent_block_height BETWEEN d.min_block_height AND d.max_block_height
    ORDER BY i.block_height DESC, i.index
    LIMIT 1000
),

-- Match each spending input to the historical transaction output it references
-- using previous transaction ID plus previous output index (the Bitcoin outpoint).
reference_matches AS (
    SELECT
        i.tx_id AS spending_tx_id,
        i.index AS input_index,
        i.spent_tx_id AS previous_tx_id,
        i.spent_output_number AS previous_output_index,
        i.value AS input_value_btc,
        o.value AS previous_output_value_btc,
        o.tx_id AS matched_output_tx_id
    FROM reference_candidates AS i
    CROSS JOIN params AS p
    LEFT JOIN bitcoin.outputs AS o
        ON o.tx_id = i.spent_tx_id
       AND o.index = i.spent_output_number
       AND o.block_height = i.spent_block_height
       AND o.block_date = p.qa_date
),

-- Summarize the bounded outpoint relationship and copied value consistency.
reference_stats AS (
    SELECT
        COUNT(*) AS reference_candidate_rows,
        COUNT(matched_output_tx_id) AS matched_previous_output_rows,
        COUNT_IF(
            matched_output_tx_id IS NOT NULL
            AND ABS(input_value_btc - previous_output_value_btc) <= 0.00000001
        ) AS matched_value_rows
    FROM reference_matches
)

SELECT
    p.qa_date AS qa_date,                                           -- Complete UTC date used by every partition filter
    b.height AS sampled_block_height,                              -- Height of the exact block sample
    b.transaction_count AS block_declared_transaction_count,       -- Transaction count stored on the block row
    t.transaction_rows,                                            -- Actual transaction rows joined to the sampled block
    t.distinct_transaction_ids,                                    -- Exact distinct txids inside the sampled block
    t.declared_input_rows,                                         -- Sum of transaction.input_count in the sampled block
    i.input_rows,                                                   -- Actual unnested input rows in the sampled block
    i.distinct_input_keys,                                         -- Exact distinct (tx_id, input index) keys
    t.declared_output_rows,                                        -- Sum of transaction.output_count in the sampled block
    o.output_rows,                                                  -- Actual unnested output rows in the sampled block
    o.distinct_output_keys,                                        -- Exact distinct (tx_id, output index) outpoints
    t.coinbase_transaction_rows,                                   -- Coinbase transactions in the sampled block
    i.coinbase_input_rows,                                         -- Coinbase inputs in the sampled block
    i.coinbase_inputs_without_previous_outpoint,                    -- Coinbase inputs whose previous outpoint fields are NULL
    t.fee_formula_mismatch_rows,                                   -- Non-coinbase rows where input minus output differs from fee
    r.reference_candidate_rows,                                    -- Same-day spending inputs capped at 1,000
    r.matched_previous_output_rows,                                -- Candidates matched to exactly referenced output rows
    r.matched_value_rows,                                          -- Matched rows whose input and previous-output BTC values agree
    o.null_address_rows,                                           -- Sample outputs with no parsed address
    o.null_script_type_rows                                        -- Sample outputs with no parsed script type
FROM params AS p
CROSS JOIN block_sample AS b
CROSS JOIN transaction_stats AS t
CROSS JOIN input_stats AS i
CROSS JOIN output_stats AS o
CROSS JOIN reference_stats AS r