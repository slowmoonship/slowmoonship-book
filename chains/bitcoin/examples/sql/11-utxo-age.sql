-- SQL 11: 已花费输出年龄
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 仅种子输出于2010-11-16至18花费；块时间差非精确持有时间
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
WITH s AS (
 SELECT tx_id, spent_tx_id, spent_output_number, block_height, block_time, value
 FROM bitcoin.inputs WHERE block_date BETWEEN DATE '2010-11-16' AND DATE '2010-11-18'
   AND NOT is_coinbase AND spent_tx_id=0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
), b AS (
 SELECT tx_id, "index", block_height, block_time
 FROM bitcoin.outputs WHERE block_date=DATE '2009-01-12' AND tx_id=0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16
), ages AS (
 SELECT s.*, s.block_height-b.block_height AS age_blocks,
        date_diff('second',b.block_time,s.block_time)/86400.0 AS age_days
 FROM s JOIN b ON s.spent_tx_id=b.tx_id AND s.spent_output_number=b."index"
)
SELECT * FROM ages ORDER BY block_height;
