-- SMS HYPE 14: top contracts by inbound transactions over the last 30 complete UTC days.
-- Source: hyperevm.transactions."to". This is a tx-side complement to SMS HYPE 13
-- (which is log-side). A row here means at least one transaction targeted that
-- address; "to" is not guaranteed to be a contract — it can also be an EOA.
-- We exclude NULL destinations (contract-creation transactions) so the panel
-- focuses on destination contracts.

SELECT
    t."to" AS destination_address,
    COUNT(*) AS tx_in_count,
    COUNT(DISTINCT t."from") AS distinct_senders,
    SUM(CASE WHEN t.success THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN NOT t.success THEN 1 ELSE 0 END) AS failure_count
FROM hyperevm.transactions t
WHERE t.block_date >= CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE)
  AND t.block_date < CURRENT_DATE
  AND t."to" IS NOT NULL
GROUP BY t."to"
ORDER BY tx_in_count DESC
LIMIT 15;
