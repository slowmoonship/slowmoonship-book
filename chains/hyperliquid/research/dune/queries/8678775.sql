-- SMS HYPE 13: HyperEVM contracts interacted with via log-side emissions.
-- Source: hyperevm.logs.contract_address over the last 30 complete UTC days.
-- log-side is the safer contract-side signal because every event log is produced
-- by an EVM contract; the column is never NULL.

SELECT
    contract_address,
    COUNT(*) AS log_count,
    COUNT(DISTINCT tx_hash) AS tx_with_log_count,
    COUNT(DISTINCT topic0) AS distinct_topic0
FROM hyperevm.logs
WHERE block_date >= CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE)
  AND block_date < CURRENT_DATE
GROUP BY contract_address
ORDER BY log_count DESC
LIMIT 15;
