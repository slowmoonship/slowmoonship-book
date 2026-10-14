-- SQL 07: 地址在指定高度的确认余额
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 一个地址，完整历史至481824；成本需审核；余额非可立即花费金额；P2PKH案例地址
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
-- Full historical coverage is necessary. Review scan cost before any execution.
-- This example does not execute. It excludes mempool and does not assess spendability.
WITH created AS (
 SELECT tx_id, "index", value, type FROM bitcoin.outputs
 WHERE block_date BETWEEN DATE '2009-01-03' AND DATE '2017-08-24'
   AND block_height <= 481824 AND address='19iDMsP8ZGzWMTEeNwKgHxij4ABteCPSK3' AND type <> 'nulldata'
), spent AS (
 SELECT spent_tx_id, spent_output_number FROM bitcoin.inputs
 WHERE block_date BETWEEN DATE '2009-01-03' AND DATE '2017-08-24'
   AND block_height <= 481824 AND NOT is_coinbase
)
SELECT COUNT(*) AS address_unspent_outputs,
       SUM(c.value) AS approximate_confirmed_balance_btc,
       SUM(CAST(round(c.value*100000000) AS BIGINT)) AS approximate_confirmed_balance_sat
FROM created c LEFT JOIN spent s
 ON c.tx_id=s.spent_tx_id AND c."index"=s.spent_output_number
WHERE s.spent_tx_id IS NULL;
