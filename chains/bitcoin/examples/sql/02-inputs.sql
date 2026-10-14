-- SQL 02: 展开全部输入
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 每输入一行；金额来自前序索引；BTC DOUBLE
-- Evidence: INDEXED_STRUCTURE; DOUBLE BTC is approximate, not integer audit proof.
SELECT tx_id, "index" AS vin_index, spent_tx_id, spent_output_number,
       value AS input_btc, script_hex, script_signature_hex, witness_data, sequence, is_coinbase
FROM bitcoin.inputs
WHERE block_date = DATE '2009-01-12' AND block_height = 170 AND tx_id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
ORDER BY "index";
