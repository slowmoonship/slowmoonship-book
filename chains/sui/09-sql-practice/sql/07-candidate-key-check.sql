-- STATIC_CHECKED; must run before assuming transaction_digest is unique.
SELECT transaction_digest, count(*) AS rows_per_digest
FROM sui.transactions
WHERE date = DATE '2026-08-24'
GROUP BY transaction_digest
HAVING transaction_digest IS NULL OR count(*) > 1;
