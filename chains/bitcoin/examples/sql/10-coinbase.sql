-- SQL 10: Coinbase补贴、费用与领取
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 每块Coinbase；平台奖励列需解释，允许少领；输出成熟期另查
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
SELECT b.height, b.mint_reward AS indexed_subsidy_btc, b.total_fees AS indexed_fees_btc,
       b.total_reward AS indexed_reward_btc, t.output_value AS coinbase_outputs_btc
FROM bitcoin.blocks b JOIN bitcoin.transactions t
 ON b.hash=t.block_hash AND b.height=t.block_height
WHERE b.date=DATE '2024-04-20' AND t.block_date=DATE '2024-04-20'
 AND b.height=840000 AND t.is_coinbase;
