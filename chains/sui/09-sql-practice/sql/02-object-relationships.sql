-- STATIC_CHECKED; not executed. A missing match is retained and classified.
-- Object-state window is explicit and may omit older unchanged inputs.
SELECT r.transaction_digest, r.object_id, r.version, r.input_kind, r.object_status,
       o.type_, o.owner_type, o.owner_address, o.coin_type, o.coin_balance,
       CASE WHEN o.object_id IS NULL THEN 'NO_STATE_MATCH_IN_WINDOW'
            ELSE 'STATE_MATCH' END AS match_status
FROM sui.transaction_objects r
LEFT JOIN sui.objects o
  ON o.object_id = r.object_id AND o.version = r.version
 AND o.date >= DATE '2023-05-01' AND o.date < DATE '2023-05-09'
WHERE r.date = DATE '2023-05-08'
  AND r.transaction_digest = 'VYZrgeBbYxFaEnm792GKxZB1N5Y4UFiCCetwyic5p6f';
