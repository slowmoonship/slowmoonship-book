-- SMS HYPE 15: HyperEVM contract deployments over the last 30 complete UTC days.
-- Source: hyperevm.creation_traces. The table lacks a block_date partition; we filter
-- on block_time using the standard UTC date arithmetic.
-- Grain: 1 row = 1 contract-creation trace candidate; distinct addresses may
-- include redeploys to the same address if any (not deduplicated here).

SELECT
    CAST(block_time AS DATE) AS block_date,
    COUNT(*) AS creation_traces,
    COUNT(DISTINCT address) AS distinct_addresses
FROM hyperevm.creation_traces
WHERE block_time >= CAST(CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE) AS TIMESTAMP)
  AND block_time < CAST(CAST(CURRENT_DATE AS DATE) AS TIMESTAMP)
GROUP BY CAST(block_time AS DATE)
ORDER BY block_date;
