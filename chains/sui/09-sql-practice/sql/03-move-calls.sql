-- STATIC_CHECKED; official GraphQL PTB has 18 MoveCall commands.
-- This is a comparison target, not a claimed Dune query result.
SELECT transaction_digest, cmd_idx, package, module, "function"
FROM sui.move_call
WHERE date = DATE '2026-08-24'
  AND transaction_digest = '5ounE6vvNursjwLpNCUgF8ybtnNfqVbV91fYdpACgBHq'
ORDER BY cmd_idx;
