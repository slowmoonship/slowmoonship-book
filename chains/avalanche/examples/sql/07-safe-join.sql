-- 各明细分支先汇总到交易粒度
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
WITH l AS (
 SELECT tx_hash, count(*) AS log_count FROM avalanche_c.logs
 WHERE block_date = DATE '2026-10-01' GROUP BY 1
), r AS (
 SELECT tx_hash, count(*) AS trace_count FROM avalanche_c.traces
 WHERE block_date = DATE '2026-10-01' GROUP BY 1
)
SELECT t.hash, coalesce(l.log_count, 0) AS log_count,
       coalesce(r.trace_count, 0) AS trace_count, t.value
FROM avalanche_c.transactions t
LEFT JOIN l ON l.tx_hash = t.hash
LEFT JOIN r ON r.tx_hash = t.hash
WHERE t.block_date = DATE '2026-10-01'
ORDER BY t.hash LIMIT 100;
