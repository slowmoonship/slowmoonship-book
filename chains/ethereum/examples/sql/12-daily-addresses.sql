-- Status: STATIC_CHECKED; NOT EXECUTED in Dune.
-- Schema: Dune Catalog, observed 2026-10-10.
-- Fixed UTC partitions; no all-history scan.
-- Grain: one fixed UTC day. Includes failed included transactions; addresses are not people.
SELECT block_date,COUNT(*) AS transaction_rows,COUNT(DISTINCT hash) AS transaction_hashes,
       COUNT(DISTINCT "from") AS active_sender_addresses,
       COUNT(DISTINCT "to") AS recipient_addresses,
       COUNT_IF(hash IS NULL) AS null_hash_rows,
       COUNT_IF(success IS NULL) AS null_status_rows
FROM ethereum.transactions
WHERE block_date=DATE '2026-06-29'
GROUP BY block_date;
