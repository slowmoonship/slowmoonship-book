-- SMS HYPE 17: per-day CoreWriter trace count over the last 30 complete UTC days.
-- Source: hyperevm.traces."to" = 0x3333...3333 (CoreWriter).
-- This is the per-day time series complement to the aggregate QA10 finding
-- ("6,678 CoreWriter traces on 2026-09-10").

SELECT
    block_date,
    COUNT(*) AS corewriter_traces,
    COUNT(DISTINCT tx_hash) AS distinct_tx,
    COUNT(DISTINCT "from") AS distinct_callers
FROM hyperevm.traces
WHERE block_date >= CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE)
  AND block_date < CURRENT_DATE
  AND "to" = 0x3333333333333333333333333333333333333333
GROUP BY block_date
ORDER BY block_date;
