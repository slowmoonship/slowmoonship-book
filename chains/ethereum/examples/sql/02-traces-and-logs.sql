-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one record per trace OR log; UNION is a labeled evidence list, never a money ledger.
SELECT 'trace' AS record_kind, tx_hash,
       array_join(transform(trace_address, x -> CAST(x AS VARCHAR)), '.') AS locator,
       "from" AS source_address, "to" AS destination_address,
       value AS native_value_wei, success
FROM ethereum.traces
WHERE block_date = DATE '2026-10-08' AND tx_hash = 0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
UNION ALL
SELECT 'log' AS record_kind, tx_hash, CAST("index" AS VARCHAR) AS locator,
       contract_address AS source_address, CAST(NULL AS VARBINARY) AS destination_address,
       CAST(NULL AS UINT256) AS native_value_wei, CAST(NULL AS BOOLEAN) AS success
FROM ethereum.logs
WHERE block_date = DATE '2026-10-08' AND tx_hash = 0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537;
