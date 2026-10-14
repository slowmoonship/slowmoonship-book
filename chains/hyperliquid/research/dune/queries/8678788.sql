-- SMS HYPE 16: per-read-precompile activity over the latest complete UTC day.
-- Source: hyperevm.traces."to" in the documented L1Read.sol range 0x0800..0x0814.
-- This extends D10 (8675927) by tightening the window to a single day, returning
-- all 21 precompile addresses regardless of traffic, and reporting a call-rate
-- relative to total transactions in that day.

WITH
day_window AS (
    SELECT CAST(CURRENT_DATE - INTERVAL '1' DAY AS DATE) AS day
),
totals AS (
    SELECT COUNT(*) AS total_tx
    FROM hyperevm.transactions t, day_window d
    WHERE t.block_date = d.day
),
calls AS (
    SELECT
        "to" AS precompile_address,
        COUNT(*) AS call_count
    FROM hyperevm.traces tr, day_window d
    WHERE tr.block_date = d.day
      AND tr."to" IN (
          0x0000000000000000000000000000000000000800,
          0x0000000000000000000000000000000000000801,
          0x0000000000000000000000000000000000000802,
          0x0000000000000000000000000000000000000803,
          0x0000000000000000000000000000000000000804,
          0x0000000000000000000000000000000000000805,
          0x0000000000000000000000000000000000000806,
          0x0000000000000000000000000000000000000807,
          0x0000000000000000000000000000000000000808,
          0x0000000000000000000000000000000000000809,
          0x000000000000000000000000000000000000080a,
          0x000000000000000000000000000000000000080b,
          0x000000000000000000000000000000000000080c,
          0x000000000000000000000000000000000000080d,
          0x000000000000000000000000000000000000080e,
          0x000000000000000000000000000000000000080f,
          0x0000000000000000000000000000000000000810,
          0x0000000000000000000000000000000000000811,
          0x0000000000000000000000000000000000000812,
          0x0000000000000000000000000000000813,
          0x0000000000000000000000000000000814
      )
    GROUP BY "to"
)

SELECT
    (SELECT day FROM day_window) AS day,
    precompile_address,
    call_count,
    CAST(call_count AS DOUBLE) / NULLIF((SELECT total_tx FROM totals), 0e0) AS call_share_of_transactions
FROM calls
ORDER BY call_count DESC;
