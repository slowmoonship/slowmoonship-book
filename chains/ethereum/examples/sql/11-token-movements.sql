-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: curated asset movement for WETH; includes modeled Deposit/Withdrawal rows.
-- Do not UNION with raw events/native traces and then sum as if disjoint.
SELECT unique_key,tx_hash,evt_index,trace_address,token_standard,contract_address,
       "from","to",amount_raw,amount,amount_usd
FROM tokens.transfers
WHERE blockchain='ethereum' AND block_month=DATE '2026-10-01'
  AND block_date=DATE '2026-10-08' AND tx_hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
  AND contract_address=0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2;
