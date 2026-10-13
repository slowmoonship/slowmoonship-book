-- STATIC_CHECKED; official GraphQL returned 19 events with hasNextPage=false.
-- Event JSON is retained without guessing a universal Swap amount field.
SELECT transaction_digest, event_index, package, module, event_type, event_json
FROM sui.events
WHERE date = DATE '2026-08-24'
  AND transaction_digest = '5ounE6vvNursjwLpNCUgF8ybtnNfqVbV91fYdpACgBHq'
ORDER BY event_index;
