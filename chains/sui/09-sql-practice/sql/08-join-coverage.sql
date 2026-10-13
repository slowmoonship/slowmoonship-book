-- STATIC_CHECKED; bounded backbone match coverage.
SELECT count(*) AS transaction_rows,
       count_if(c.sequence_number IS NULL) AS unmatched_checkpoint_rows
FROM sui.transactions t
LEFT JOIN sui.checkpoints c
  ON c.sequence_number = t.checkpoint AND c.date = DATE '2026-08-24'
WHERE t.date = DATE '2026-08-24';
