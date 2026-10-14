-- SQL 06: 地址窗口内未花费候选
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 仅2017-08-24创建候选，块481824末；不覆盖更早地址输出；普通花费只可能在创建后
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
WITH created AS (
 SELECT tx_id, "index", value, script_hex, type FROM bitcoin.outputs
 WHERE block_date = DATE '2017-08-24' AND block_height <= 481824 AND address='19iDMsP8ZGzWMTEeNwKgHxij4ABteCPSK3'
), spent AS (
 SELECT spent_tx_id, spent_output_number FROM bitcoin.inputs
 WHERE block_date = DATE '2017-08-24' AND block_height <= 481824 AND NOT is_coinbase
)
SELECT c.* FROM created c LEFT JOIN spent s
 ON c.tx_id=s.spent_tx_id AND c."index"=s.spent_output_number
WHERE s.spent_tx_id IS NULL;
