-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one standard USDT Transfer log. Raw amount is exact; display uses approximate DOUBLE.
WITH event_rows AS (
 SELECT tx_hash, "index" AS log_index, contract_address, topic1, topic2, data,
        varbinary_substring(topic1,13,20) AS token_sender,
        varbinary_substring(topic2,13,20) AS token_recipient,
        varbinary_to_uint256(data) AS amount_raw
 FROM ethereum.logs
 WHERE block_date = DATE '2026-10-08' AND tx_hash = 0x458584a9b39f8bcfc215cc5990f1776ed5cc485dc56ffb02927032ca79a537ca
   AND contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
   AND topic0 = keccak(to_utf8('Transfer(address,address,uint256)'))
   AND varbinary_length(topic1)=32 AND varbinary_length(topic2)=32
   AND varbinary_length(data)=32 AND topic3 IS NULL
)
SELECT *, CAST(amount_raw AS DOUBLE)/1e6 AS amount_display_approx FROM event_rows;
