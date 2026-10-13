-- Purpose:
-- Separate outer instructions from inner/CPI instructions and quantify their share.
--
-- Source table grain:
-- query_8435352 has one row per complete UTC date x program_id x outer/inner layer,
-- derived from one raw instruction-call row per outer or inner instruction.
--
-- Time range:
-- Seven complete UTC calendar days inherited from Query 8435352.

-- Collapse the reusable program-layer aggregate to one row per date.
WITH daily_instruction_layers AS (
    SELECT
        date,
        SUM(CASE WHEN NOT is_inner THEN instruction_count ELSE 0 END) AS outer_instruction_count,
        SUM(CASE WHEN is_inner THEN instruction_count ELSE 0 END) AS inner_instruction_count
    FROM query_8435352
    GROUP BY 1
)

SELECT
    date,                                                        -- Complete UTC calendar date
    outer_instruction_count,                                     -- Top-level instruction-call rows
    inner_instruction_count,                                     -- Inner/CPI instruction-call rows
    CAST(inner_instruction_count AS double)
        / NULLIF(outer_instruction_count + inner_instruction_count, 0)
        AS inner_instruction_share                               -- Inner rows divided by all instruction rows
FROM daily_instruction_layers
ORDER BY date