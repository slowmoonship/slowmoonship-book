-- USDT 加工转移样本与估值覆盖
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT block_time, tx_hash, evt_index, "from", "to", amount_raw,
       amount, amount_usd, price_usd
FROM tokens.transfers
WHERE blockchain = 'avalanche_c'
  AND block_date = DATE '2026-10-12'
  AND block_time >= from_iso8601_timestamp('2026-10-12T00:00:00Z')
  AND block_time < from_iso8601_timestamp('2026-10-13T00:00:00Z')
  AND contract_address = 0x9702230a8ea53601f5cd2dc00fdbc13d4df4a8c7
ORDER BY block_time, tx_hash, evt_index LIMIT 100;
