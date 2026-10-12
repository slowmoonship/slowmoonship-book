-- Source table grain:
-- One row in ethereum.transactions represents one Ethereum transaction.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.
-- Address semantics:
-- "from" is the transaction sender and "to" is the transaction recipient.
-- They are reported separately and are not combined or labeled as active users.

-- Aggregate transaction-level rows into one row per UTC day.
WITH daily_transactions AS (
    SELECT
        block_date AS date,                              -- UTC partition date of the containing block
        COUNT(*) AS transaction_count,                   -- Number of Ethereum transaction rows
        COUNT(DISTINCT "from") AS unique_from_addresses, -- Distinct transaction senders
        COUNT(DISTINCT "to") AS unique_to_addresses,     -- Distinct non-null transaction recipients
        COUNT(*) - COUNT(DISTINCT hash) AS duplicate_or_null_transaction_hashes, -- QA: duplicate or null transaction hashes
        COUNT_IF(hash IS NULL) AS null_transaction_hashes -- QA: null transaction hashes; expected to be zero
    FROM ethereum.transactions
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    transaction_count AS transaction_count,              -- Number of Ethereum transactions
    unique_from_addresses AS unique_from_addresses,      -- Distinct transaction senders
    unique_to_addresses AS unique_to_addresses,          -- Distinct non-null transaction recipients
    duplicate_or_null_transaction_hashes AS duplicate_or_null_transaction_hashes, -- QA duplicate-or-null hash count
    null_transaction_hashes AS null_transaction_hashes   -- QA null hash count
FROM daily_transactions
ORDER BY date;