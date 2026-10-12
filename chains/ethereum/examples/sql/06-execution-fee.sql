-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Scope: fixed ordinary type-2 non-blob transaction, verified effective price from explorer.
-- Integer Wei stays exact; ETH display is approximate. Do not use this as a universal blob total.
SELECT hash, gas_used, gas_price,
       CAST(gas_used AS DECIMAL(20,0))*CAST(gas_price AS DECIMAL(20,0)) AS execution_fee_wei,
       CAST(gas_used AS DOUBLE)*CAST(gas_price AS DOUBLE)/1e18 AS execution_fee_eth_display
FROM ethereum.transactions
WHERE block_date=DATE '2026-06-29' AND hash=0xdd757281a1bb25e5d54f660cd418b41a6c1d1634896908454de7b025975c13bb
  AND COALESCE(cardinality(blob_versioned_hashes),0)=0;
