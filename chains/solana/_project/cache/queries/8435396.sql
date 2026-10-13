-- Purpose:
-- Rank executing Solana program IDs by instruction-call rows without applying
-- unverified protocol labels.
--
-- Source table grain:
-- query_8435352 has one row per date x program_id x outer/inner layer.
-- This query changes grain to one row per program_id over the seven-day window.
--
-- Time range:
-- Seven complete UTC calendar days inherited from Query 8435352.

-- Sum outer and inner instruction rows for each executing program.
WITH program_totals AS (
    SELECT
        program_id,
        SUM(instruction_count) AS instruction_count
    FROM query_8435352
    WHERE program_id IS NOT NULL
    GROUP BY 1
),

-- Compute the denominator once for instruction-share calculation.
window_total AS (
    SELECT
        SUM(instruction_count) AS total_instruction_count
    FROM program_totals
),

-- Rank programs and retain only the ten highest instruction counts.
ranked_programs AS (
    SELECT
        p.program_id,
        p.instruction_count,
        CAST(p.instruction_count AS double)
            / NULLIF(w.total_instruction_count, 0) AS share_of_instructions,
        ROW_NUMBER() OVER (ORDER BY p.instruction_count DESC, p.program_id) AS program_rank
    FROM program_totals p
    CROSS JOIN window_total w
)

SELECT
    program_rank,            -- Rank by instruction-call rows in the seven-day window
    program_id,              -- Executing Solana program account; no unverified label is added
    instruction_count,       -- Outer plus inner instruction-call rows for the program
    share_of_instructions    -- Program instruction rows divided by all instruction rows
FROM ranked_programs
WHERE program_rank <= 10
ORDER BY program_rank