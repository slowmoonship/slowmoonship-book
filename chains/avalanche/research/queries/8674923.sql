-- Recent partition-pruned sample ordered for deterministic freshness inspection; not aggregate statistics.
SELECT
    block_time,
    block_number,
    hash,
    block_hash,
    "from",
    "to",
    success,
    type,
    gas_price,
    gas_used,
    max_fee_per_gas,
    priority_fee_per_gas
FROM avalanche_c.transactions
WHERE block_date >= current_date - interval '1' day
ORDER BY block_time DESC, hash DESC
LIMIT 10