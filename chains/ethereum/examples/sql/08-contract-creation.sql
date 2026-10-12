-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: recorded creation. Internal deployments need not have NULL top-level To.
SELECT block_time, block_number, tx_hash, address, "from", varbinary_length(code) AS code_bytes
FROM ethereum.creation_traces
WHERE block_month=DATE '2026-02-01' AND block_number=24523650
  AND tx_hash=0xcaa01f67726fdecf671f8f6a1b0b2cd832f1e8b43571b843100b12a8e5818fca;
