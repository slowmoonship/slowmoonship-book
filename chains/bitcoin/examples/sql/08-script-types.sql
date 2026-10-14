-- SQL 08: 输出脚本类型分布
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 一个UTC日；输出粒度；不是用户数或经济付款量
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
SELECT type, COUNT(*) AS created_outputs, SUM(value) AS approximate_created_btc
FROM bitcoin.outputs WHERE block_date = DATE '2024-04-20'
GROUP BY type ORDER BY created_outputs DESC;
