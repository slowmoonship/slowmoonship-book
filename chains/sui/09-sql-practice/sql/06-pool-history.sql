-- STATIC_CHECKED; observed early history slice, not the complete lifetime.
SELECT object_id, version, digest, checkpoint, timestamp_ms,
       owner_type, owner_address, object_status, previous_transaction, object_json
FROM sui.objects
WHERE date = DATE '2024-11-23'
  AND object_id = 0x0df4f02d0e210169cb6d5aabd03c3058328c06f2c4dbb0804faa041159c78443
  AND version >= 426673878 AND version <= 426674009
ORDER BY version;
