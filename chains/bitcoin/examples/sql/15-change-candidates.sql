-- SQL 15: 找零候选与反例
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 较大输出找零候选；等额不判；LIMIT可能截断交易仅展示；不用来证明经济量
-- Evidence: HEURISTIC; DOUBLE BTC is approximate, not integer audit proof.
WITH t AS (
 SELECT id FROM bitcoin.transactions
 WHERE block_date=DATE '2017-08-24' AND NOT is_coinbase AND input_count=1 AND output_count=2
), o AS (
 SELECT tx_id, "index", value, address, type FROM bitcoin.outputs
 WHERE block_date=DATE '2017-08-24'
)
SELECT o.*, 'HEURISTIC_SMALLER_OUTPUT_AS_PAYMENT' AS rule,
       CASE WHEN o.value=MAX(o.value) OVER (PARTITION BY o.tx_id)
         AND MIN(o.value) OVER (PARTITION BY o.tx_id) <> MAX(o.value) OVER (PARTITION BY o.tx_id)
        THEN 'CHANGE_CANDIDATE' ELSE 'UNRESOLVED' END AS change_candidate
FROM t JOIN o ON t.id=o.tx_id ORDER BY o.tx_id, o."index" LIMIT 50;
