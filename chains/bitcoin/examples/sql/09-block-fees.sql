-- SQL 09: 区块手续费与交易汇总核对
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 块840000；普通交易每交易一次汇总；DOUBLE差额非整数精度证明
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
WITH fees AS (
 SELECT block_height, block_hash, SUM(fee) AS sum_fee_btc
 FROM bitcoin.transactions WHERE block_date=DATE '2024-04-20' AND block_height=840000
   AND NOT is_coinbase GROUP BY block_height, block_hash
)
SELECT b.height, b.hash, b.total_fees, f.sum_fee_btc, b.total_fees-f.sum_fee_btc AS float_delta_btc
FROM bitcoin.blocks b LEFT JOIN fees f ON b.height=f.block_height AND b.hash=f.block_hash
WHERE b.date=DATE '2024-04-20' AND b.height=840000;
