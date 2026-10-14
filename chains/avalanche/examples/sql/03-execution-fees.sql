-- 观测到的 C-Chain 执行费
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT date_trunc('day', block_time) AS day,
       sum(CAST(gas_used AS double) * CAST(gas_price AS double) / 1e18) AS observed_execution_fee_avax
FROM avalanche_c.transactions
WHERE block_date >= DATE '2026-10-01' AND block_date < DATE '2026-10-03'
  AND block_time >= TIMESTAMP '2026-10-01 00:00:00'
  AND block_time < TIMESTAMP '2026-10-03 00:00:00'
GROUP BY 1 ORDER BY 1;
