-- SMS HYPE 11: HyperEVM transaction type distribution over the last 30 complete UTC days.
-- Source: hyperevm.transactions.type. Raw enum labels observed at runtime 2026-09-11
-- over a 7D window: DynamicFee, Legacy, AccessList (see SMS HYPE 11 sampler 8678769).
-- We re-run the same enumeration on a 30D window and add a per-type success share.

WITH base AS (
    SELECT
        type,
        success
    FROM hyperevm.transactions
    WHERE block_date >= CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE)
      AND block_date < CURRENT_DATE
)

SELECT
    type AS transaction_type,
    COUNT(*) AS tx_count,
    CAST(COUNT(*) AS DOUBLE) / SUM(COUNT(*)) OVER () AS tx_share,
    SUM(CASE WHEN success THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN NOT success THEN 1 ELSE 0 END) AS failure_count,
    CAST(SUM(CASE WHEN success THEN 1 ELSE 0 END) AS DOUBLE)
        / NULLIF(CAST(COUNT(*) AS DOUBLE), 0e0) AS success_rate
FROM base
GROUP BY type
ORDER BY tx_count DESC;
