-- Purpose:
-- Display real Bitcoin inputs and the exact previous transaction outputs they spend.
--
-- Source table grain:
-- bitcoin.inputs has one row per transaction input.
-- bitcoin.outputs has one row per transaction output; (tx_id, index) is the outpoint.
--
-- Time range:
-- One complete UTC day ending two days before today. The sample is restricted to
-- inputs whose previous outputs were also created on that day, then capped at 25 rows.

-- Fix one complete UTC day for both input and output partition pruning.
WITH params AS (
    SELECT
        CURRENT_DATE - INTERVAL '2' DAY AS qa_date
),

-- Find the Bitcoin height range created on the selected output day.
day_bounds AS (
    SELECT
        MIN(height) AS min_block_height,
        MAX(height) AS max_block_height
    FROM bitcoin.blocks AS b
    CROSS JOIN params AS p
    WHERE b.date = p.qa_date
),

-- Select bounded non-coinbase spending inputs whose referenced output height
-- falls inside the same complete UTC day.
reference_candidates AS (
    SELECT
        i.block_time,
        i.block_height,
        i.tx_id,
        i.index,
        i.spent_block_height,
        i.spent_tx_id,
        i.spent_output_number,
        i.value
    FROM bitcoin.inputs AS i
    CROSS JOIN params AS p
    CROSS JOIN day_bounds AS d
    WHERE i.block_date = p.qa_date
      AND NOT i.is_coinbase
      AND i.spent_block_height BETWEEN d.min_block_height AND d.max_block_height
    ORDER BY i.block_height DESC, i.index
    LIMIT 100
),

-- Match each spending input to the historical transaction output it references
-- using previous transaction ID plus previous output index (the outpoint key).
matched_references AS (
    SELECT
        i.block_time AS current_block_time,
        i.block_height AS current_block_height,
        i.tx_id AS spending_tx_id,
        i.index AS input_index,
        i.spent_tx_id AS previous_tx_id,
        i.spent_output_number AS previous_output_index,
        o.block_height AS previous_output_block_height,
        o.value AS previous_output_value_btc,
        i.value AS input_value_btc,
        ABS(i.value - o.value) <= 0.00000001 AS value_matches,
        o.address AS previous_output_address,
        o.type AS previous_output_script_type
    FROM reference_candidates AS i
    CROSS JOIN params AS p
    INNER JOIN bitcoin.outputs AS o
        ON o.tx_id = i.spent_tx_id
       AND o.index = i.spent_output_number
       AND o.block_height = i.spent_block_height
       AND o.block_date = p.qa_date
)

SELECT
    current_block_time,                 -- Timestamp of the transaction that spends the previous output
    current_block_height,               -- Block height of the spending transaction
    spending_tx_id,                     -- Transaction ID containing the current input
    input_index,                        -- Input position inside the spending transaction
    previous_tx_id,                     -- Transaction ID that created the referenced previous output
    previous_output_index,              -- Output index inside the previous transaction
    previous_output_block_height,       -- Block height where the previous output was created
    previous_output_value_btc,          -- BTC value stored on the referenced output row
    input_value_btc,                    -- BTC value copied onto the spending input row
    value_matches,                      -- Whether input and referenced-output BTC values agree
    previous_output_address,            -- Parsed address representation when available
    previous_output_script_type         -- Parsed locking-script classification
FROM matched_references
ORDER BY current_block_time DESC, spending_tx_id, input_index
LIMIT 25