-- Case 02 的调用树候选
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT tx_hash, trace_address, type, call_type, "from", "to", value,
       success, tx_success, error, input, output
FROM avalanche_c.traces
WHERE block_date = DATE '2026-10-12'
  AND tx_hash = 0x017c257f6fd9abff097e0740e27422d19e1e0ad7c8973e247827495f847b3242
ORDER BY trace_address;
