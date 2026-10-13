-- Purpose:
-- Demonstrate how a raw Solana instruction becomes a named IDL-decoded
-- System Program transfer row, and verify the raw-to-decoded identity join.
--
-- Source table grain:
-- system_program_solana.system_program_call_transfer: one IDL-decoded System Program
-- transfer instruction row. solana.instruction_calls: one outer or inner instruction call row.
--
-- Time range:
-- The first ten UTC minutes of the most recent fully indexed day (two UTC days ago),
-- capped at 100 decoded rows to keep this supporting QA query inexpensive.

-- Define a stable ten-minute sample window.
WITH window_bounds AS (
    SELECT
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY AS start_time,
        date_trunc('day', current_timestamp) - INTERVAL '2' DAY + INTERVAL '10' MINUTE AS end_time
),

-- Read a bounded IDL-decoded System Program transfer sample.
decoded_sample AS (
    SELECT
        call_block_time,
        call_block_slot,
        call_tx_id,
        call_tx_index,
        call_outer_instruction_index,
        call_inner_instruction_index,
        call_executing_account,
        call_is_inner,
        call_program_name,
        call_instruction_name,
        account_from,
        account_to,
        lamports
    FROM system_program_solana.system_program_call_transfer
    CROSS JOIN window_bounds
    WHERE call_block_time >= start_time
      AND call_block_time < end_time
    LIMIT 100
),

-- Match each decoded row to the raw instruction identity using NULL-safe inner indexes.
raw_matches AS (
    SELECT
        d.call_block_time,
        d.call_block_slot,
        d.call_tx_id,
        d.call_tx_index,
        d.call_outer_instruction_index,
        d.call_inner_instruction_index,
        d.call_executing_account,
        d.call_is_inner,
        d.call_program_name,
        d.call_instruction_name,
        d.account_from,
        d.account_to,
        d.lamports,
        COUNT(r.tx_id) AS raw_match_count
    FROM decoded_sample d
    LEFT JOIN solana.instruction_calls r
      ON r.block_time >= CAST((SELECT start_time FROM window_bounds) AS timestamp)
     AND r.block_time < CAST((SELECT end_time FROM window_bounds) AS timestamp)
     AND r.tx_id = d.call_tx_id
     AND r.outer_instruction_index = d.call_outer_instruction_index
     AND r.inner_instruction_index IS NOT DISTINCT FROM d.call_inner_instruction_index
     AND r.executing_account = d.call_executing_account
    GROUP BY
        d.call_block_time,
        d.call_block_slot,
        d.call_tx_id,
        d.call_tx_index,
        d.call_outer_instruction_index,
        d.call_inner_instruction_index,
        d.call_executing_account,
        d.call_is_inner,
        d.call_program_name,
        d.call_instruction_name,
        d.account_from,
        d.account_to,
        d.lamports
)

SELECT
    call_block_time AS block_time,                              -- UTC timestamp of the decoded instruction
    call_block_slot AS block_slot,                              -- Solana slot containing the instruction
    call_tx_id AS tx_id,                                        -- Transaction signature shared with the raw instruction
    call_tx_index AS tx_index,                                  -- Transaction position inside the block
    call_outer_instruction_index AS outer_instruction_index,    -- Top-level instruction index inside the transaction
    call_inner_instruction_index AS inner_instruction_index,    -- CPI instruction index; NULL for an outer instruction
    call_executing_account AS program_id,                        -- Executing System Program account
    call_is_inner AS is_inner,                                  -- True when this transfer is an inner/CPI instruction
    call_program_name AS program_name,                          -- IDL namespace label supplied by Dune
    call_instruction_name AS instruction_name,                  -- Human-readable IDL instruction name
    account_from,                                               -- Named decoded source account argument
    account_to,                                                 -- Named decoded destination account argument
    lamports,                                                   -- IDL-decoded transfer amount in lamports
    raw_match_count                                             -- Matching raw instruction rows for this decoded identity
FROM raw_matches
ORDER BY block_time, tx_index, outer_instruction_index, inner_instruction_index