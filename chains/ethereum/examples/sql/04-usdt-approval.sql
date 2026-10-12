-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one Approval log. This amount is an allowance statement, not transferred assets.
SELECT tx_hash, "index" AS log_index, contract_address,
       varbinary_substring(topic1,13,20) AS owner,
       varbinary_substring(topic2,13,20) AS spender,
       varbinary_to_uint256(data) AS allowance_raw
FROM ethereum.logs
WHERE block_date = DATE '2026-06-08' AND tx_hash = 0xcb961e7be2376292335004a134aa87cb775e624e3db5883c5ac1babdf70ff1ad
  AND contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
  AND topic0 = keccak(to_utf8('Approval(address,address,uint256)'))
  AND varbinary_length(topic1)=32 AND varbinary_length(topic2)=32
  AND varbinary_length(data)=32 AND topic3 IS NULL;
