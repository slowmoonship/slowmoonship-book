-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one top-level transaction. Value is requested native wei, not total asset flow.
SELECT hash, block_number, block_hash, block_time, "from", "to", value,
       nonce, "index", data, type, success, gas_used, gas_price
FROM ethereum.transactions
WHERE block_date = DATE '2026-06-29'
  AND block_number = 25421774 AND hash = 0xdd757281a1bb25e5d54f660cd418b41a6c1d1634896908454de7b025975c13bb;
