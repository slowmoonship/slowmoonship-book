-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one retained non-root CALL carrying native value.
-- NOT a complete ETH ledger: excludes root, create, selfdestruct, withdrawals, fees and historical rewards.
-- Exclude locally successful descendants inside a failed ancestor subtree.
WITH bounded_traces AS (
 SELECT tx_hash, trace_address, "from", "to", type, call_type, value, success, tx_success
 FROM ethereum.traces
 WHERE block_date = DATE '2026-10-08' AND tx_hash = 0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
)
SELECT t.tx_hash,t.trace_address,t."from",t."to",t.value AS value_wei
FROM bounded_traces t
LEFT JOIN bounded_traces a
  ON a.tx_hash=t.tx_hash AND a.success=false
 AND cardinality(a.trace_address)<=cardinality(t.trace_address)
 AND slice(t.trace_address,1,cardinality(a.trace_address))=a.trace_address
WHERE t.type='call' AND t.call_type='call' AND t.value>0
  AND t.success=true AND t.tx_success=true AND cardinality(t.trace_address)>0
  AND a.tx_hash IS NULL;
