-- STATIC_CHECKED: Catalog verified 2026-10-10; not executed on Dune (402).
-- Grain: one transaction, assuming candidate key uniqueness has been checked.
SELECT t.transaction_digest, t.sender, t.execution_success,
       t.checkpoint, c.epoch, c.timestamp_ms,
       t.total_gas_cost, t.computation_cost, t.storage_cost, t.storage_rebate,
       t.transaction_json, t.effects_json
FROM sui.transactions t
LEFT JOIN sui.checkpoints c
  ON c.sequence_number = t.checkpoint
 AND c.date = DATE '2023-05-08'
WHERE t.date = DATE '2023-05-08'
  AND t.transaction_digest = 'VYZrgeBbYxFaEnm792GKxZB1N5Y4UFiCCetwyic5p6f';
