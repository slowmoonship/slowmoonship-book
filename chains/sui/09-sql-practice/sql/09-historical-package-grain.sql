-- STATIC_CHECKED; not executed. Adapted locally from slowmoonship Query 8348409 v5.
-- Source: https://dune.com/queries/8348409 ; the remote Query was not modified.
-- Grain: one day and one Package; calls and transactions are separate measures.
SELECT date, package,
       count(*) AS move_call_rows,
       count(DISTINCT transaction_digest) AS transaction_count
FROM sui.move_call
WHERE date = DATE '2026-08-24'
GROUP BY date, package;
