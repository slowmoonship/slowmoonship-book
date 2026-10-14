-- 区块与交易的定位一致性
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT b.number, b.hash, b.time, count(t.hash) AS indexed_transactions
FROM avalanche_c.blocks b
LEFT JOIN avalanche_c.transactions t
  ON t.block_hash = b.hash
 AND t.block_date >= DATE '2026-10-01' AND t.block_date < DATE '2026-10-02'
WHERE b.date = DATE '2026-10-01'
GROUP BY 1, 2, 3 ORDER BY b.number LIMIT 100;
