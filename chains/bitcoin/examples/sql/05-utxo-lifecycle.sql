-- SQL 05: 一个输出的有界生命周期
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: Case07种子输出零；花费窗口2010-11-16至18，空值不代表今日UTXO
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
WITH born AS (
 SELECT tx_id, "index", block_height, block_time, value, script_hex
 FROM bitcoin.outputs
 WHERE block_date = DATE '2009-01-12' AND tx_id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 AND "index" = 0
), spent AS (
 SELECT tx_id, "index" AS vin, block_height, block_time, spent_tx_id, spent_output_number
 FROM bitcoin.inputs
 WHERE block_date BETWEEN DATE '2010-11-16' AND DATE '2010-11-18' AND NOT is_coinbase
   AND spent_tx_id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 AND spent_output_number = 0
)
SELECT b.*, s.tx_id AS spending_txid, s.vin, s.block_height AS spending_height,
       CASE WHEN s.tx_id IS NULL THEN 'NO_SPEND_FOUND_IN_WINDOW' ELSE 'SPENT_IN_WINDOW' END AS observation
FROM born b LEFT JOIN spent s ON s.spent_tx_id=b.tx_id AND s.spent_output_number=b."index";
