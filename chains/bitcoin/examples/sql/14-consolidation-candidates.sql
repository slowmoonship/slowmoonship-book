-- SQL 14: 多输入整合结构候选
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 25条结构候选；不证明共同所有权或业务整合
-- Evidence: HEURISTIC; DOUBLE BTC is approximate, not integer audit proof.
SELECT id, input_count, output_count, input_value, output_value, fee
FROM bitcoin.transactions WHERE block_date=DATE '2017-08-24' AND NOT is_coinbase
 AND input_count >= 5 AND output_count=1
ORDER BY input_count DESC LIMIT 25;
