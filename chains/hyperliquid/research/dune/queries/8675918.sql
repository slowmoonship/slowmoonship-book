-- Dashboard 03: HyperEVM Contract Activity — runtime evidence
WITH filtered_logs AS (
    SELECT
        block_date,
        tx_hash,
        contract_address
    FROM hyperevm.logs
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
)

SELECT
    block_date AS date,
    COUNT(*) AS log_count,
    COUNT(DISTINCT tx_hash) AS unique_transactions,
    COUNT(DISTINCT contract_address) AS unique_contract_addresses
FROM filtered_logs
GROUP BY 1
ORDER BY date;
