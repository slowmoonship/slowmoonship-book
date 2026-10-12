-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: DEX execution segment, not a user intention. USD is modeled and may be NULL.
SELECT blockchain,project,version,tx_hash,evt_index,project_contract_address,
       token_sold_address,token_bought_address,token_sold_amount_raw,token_bought_amount_raw,
       token_sold_amount,token_bought_amount,amount_usd,amount_usd IS NULL AS usd_missing,tx_from
FROM dex_evm.trades
WHERE blockchain='ethereum' AND block_month=DATE '2026-10-01'
  AND block_date=DATE '2026-10-08' AND tx_hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
ORDER BY evt_index;
