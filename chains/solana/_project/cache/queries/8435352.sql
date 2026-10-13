-- Purpose:
-- Build one reusable seven-day aggregation that preserves the three structural
-- dimensions needed for total instructions, outer/inner CPI, and program activity.
--
-- Source table grain:
-- solana.instruction_calls has one row per outer or inner instruction call.
-- This query changes grain to complete UTC date x executing program x outer/inner layer.
--
-- Time range:
-- Seven complete UTC calendar days ending two days before today. The two-day lag
-- avoids near-real-time indexing gaps observed in account-oriented Solana datasets.

-- Read only the partition, program, CPI-layer, and transaction identity fields.
WITH filtered_instruction_calls AS (
    SELECT
        block_date,
        executing_account,
        is_inner,
        tx_id
    FROM solana.instruction_calls
    WHERE block_time >= CAST(current_date - INTERVAL '9' DAY AS timestamp)
      AND block_time < CAST(current_date - INTERVAL '2' DAY AS timestamp)
),

-- Aggregate instruction calls at date x program x outer/inner grain.
daily_program_layer AS (
    SELECT
        block_date AS date,
        executing_account AS program_id,
        is_inner,
        COUNT(*) AS instruction_count,
        approx_distinct(tx_id) AS approximate_unique_transactions
    FROM filtered_instruction_calls
    GROUP BY 1, 2, 3
)

SELECT
    date,                                -- Complete UTC calendar date
    program_id,                          -- Executing Solana program account
    is_inner,                            -- True for inner/CPI calls; false for outer instructions
    instruction_count,                   -- Instruction-call rows at this date-program-layer grain
    approximate_unique_transactions      -- Approximate transactions calling this program in this layer
FROM daily_program_layer
ORDER BY date, instruction_count DESC