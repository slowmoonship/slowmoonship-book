-- STATIC_CHECKED; not executed. One-day bounded Package-call metrics.
-- NOT a count of all DEX swaps or all internal runtime function calls.
WITH selected_calls AS (
  SELECT transaction_digest
  FROM sui.move_call
  WHERE date = DATE '2026-08-24'
    AND package = 0x9c872ebd643d9d911c43a9c5facb69b617ca1281285b8c7f84eddeb9560e1133
), call_counts AS (
  SELECT transaction_digest, count(*) AS package_call_rows
  FROM selected_calls GROUP BY 1
), object_counts AS (
  SELECT r.transaction_digest, count(*) AS object_relationship_rows,
         count(DISTINCT r.object_id) AS distinct_object_ids
  FROM sui.transaction_objects r
  WHERE r.date = DATE '2026-08-24'
    AND EXISTS (SELECT 1 FROM call_counts c WHERE c.transaction_digest = r.transaction_digest)
  GROUP BY 1
), event_counts AS (
  SELECT e.transaction_digest, count(*) AS all_event_rows
  FROM sui.events e
  WHERE e.date = DATE '2026-08-24'
    AND EXISTS (SELECT 1 FROM call_counts c WHERE c.transaction_digest = e.transaction_digest)
  GROUP BY 1
)
SELECT t.transaction_digest, t.execution_success, c.package_call_rows,
       coalesce(o.object_relationship_rows, 0) AS object_relationship_rows,
       coalesce(o.distinct_object_ids, 0) AS distinct_object_ids,
       coalesce(e.all_event_rows, 0) AS all_event_rows
FROM sui.transactions t
JOIN call_counts c ON c.transaction_digest = t.transaction_digest
LEFT JOIN object_counts o ON o.transaction_digest = t.transaction_digest
LEFT JOIN event_counts e ON e.transaction_digest = t.transaction_digest
WHERE t.date = DATE '2026-08-24' AND t.is_system_txn = false;
