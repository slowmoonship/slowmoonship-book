-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one transaction. Each branch is aggregated BEFORE joining.
WITH tx AS (
 SELECT hash, value, success FROM ethereum.transactions
 WHERE block_date=DATE '2026-10-08' AND hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
), trace_summary AS (
 SELECT tx_hash,COUNT(*) AS trace_records FROM ethereum.traces
 WHERE block_date=DATE '2026-10-08' AND tx_hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537 GROUP BY 1
), log_summary AS (
 SELECT tx_hash,COUNT(*) AS log_records FROM ethereum.logs
 WHERE block_date=DATE '2026-10-08' AND tx_hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537 GROUP BY 1
)
SELECT t.hash,t.value,t.success,COALESCE(r.trace_records,0) AS trace_records,
       COALESCE(l.log_records,0) AS log_records
FROM tx t LEFT JOIN trace_summary r ON t.hash=r.tx_hash
LEFT JOIN log_summary l ON t.hash=l.tx_hash;
