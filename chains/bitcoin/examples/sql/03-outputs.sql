-- SQL 03: 展开全部输出
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 每创建输出一行；不代表当前未花费
-- Evidence: INDEXED_STRUCTURE; DOUBLE BTC is approximate, not integer audit proof.
SELECT tx_id, "index" AS vout, value AS output_btc, address, type, script_hex
FROM bitcoin.outputs
WHERE block_date = DATE '2009-01-12' AND block_height = 170 AND tx_id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
ORDER BY "index";
