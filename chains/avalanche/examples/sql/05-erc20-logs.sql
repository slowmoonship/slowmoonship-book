-- Case 02 的原始日志候选
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT tx_hash, "index", contract_address, topic0, topic1, topic2, topic3, data
FROM avalanche_c.logs
WHERE block_date = DATE '2026-10-12'
  AND tx_hash = 0x017c257f6fd9abff097e0740e27422d19e1e0ad7c8973e247827495f847b3242
ORDER BY "index";
