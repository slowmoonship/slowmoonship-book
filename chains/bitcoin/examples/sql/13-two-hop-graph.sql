-- SQL 13: 两层输出花费依赖
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 创建分区2009-01-12与2010-11-16至18；花费分区2010-11-16至18；不分配输入到新输出经济份额；可有多分支
-- Evidence: INDEXED_STRUCTURE; DOUBLE BTC is approximate, not integer audit proof.
WITH o AS (
 SELECT tx_id, "index", value FROM bitcoin.outputs
 WHERE block_date = DATE '2009-01-12'
    OR block_date BETWEEN DATE '2010-11-16' AND DATE '2010-11-18'
), i AS (
 SELECT tx_id, "index", spent_tx_id, spent_output_number FROM bitcoin.inputs
 WHERE block_date BETWEEN DATE '2010-11-16' AND DATE '2010-11-18' AND NOT is_coinbase
), first_hop AS (
 SELECT o.tx_id AS parent_txid, o."index" AS parent_vout, i.tx_id AS child_txid, i."index" AS child_vin
 FROM o JOIN i ON o.tx_id=i.spent_tx_id AND o."index"=i.spent_output_number
 WHERE o.tx_id=0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
), second_hop AS (
 SELECT DISTINCT o.tx_id AS parent_txid, o."index" AS parent_vout, i.tx_id AS child_txid, i."index" AS child_vin
 FROM first_hop f JOIN o ON o.tx_id=f.child_txid
 JOIN i ON i.spent_tx_id=o.tx_id AND i.spent_output_number=o."index"
)
SELECT 1 AS depth, * FROM first_hop UNION ALL SELECT 2 AS depth, * FROM second_hop;
