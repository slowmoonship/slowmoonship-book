-- Purpose:
-- Present daily Bitcoin transaction activity and transactions per block using the
-- validated block-level transaction counts from Query 8471408.
--
-- Source table grain:
-- query_8471408 has one row per complete UTC date, derived from bitcoin.blocks.
-- Its transaction_count includes coinbase transactions, as separately verified
-- against bitcoin.transactions in the Core Grain QA query.
--
-- Time range:
-- The most recent 90 complete UTC calendar days inherited from Query 8471408.

-- Select and derive transaction-layer metrics from the validated block aggregate.
WITH daily_transactions AS (
    SELECT
        date,
        transaction_count,
        block_count,
        CAST(transaction_count AS DOUBLE) / NULLIF(block_count, 0) AS avg_transactions_per_block
    FROM query_8471408
)

SELECT
    date,                           -- Complete UTC calendar date
    transaction_count,              -- Transactions declared by block rows, including coinbase
    avg_transactions_per_block      -- Mean transactions per canonical block on the date
FROM daily_transactions
ORDER BY date