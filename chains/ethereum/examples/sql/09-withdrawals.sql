-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: withdrawal operation; no ordinary user tx hash. amount is GWEI, not WEI.
SELECT block_number, block_time, "index" AS withdrawal_index, validator_index, address,
       amount AS amount_gwei, CAST(amount AS DOUBLE)/1e9 AS amount_eth_display
FROM ethereum.withdrawals
WHERE block_date=DATE '2026-10-08'
ORDER BY "index" LIMIT 50;
