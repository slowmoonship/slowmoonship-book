-- Purpose:
-- Present daily non-vote Solana transaction activity and failure rate using the
-- validated block-level transaction aggregates from Query 8435308.
--
-- Source table grain:
-- query_8435308 has one row per complete UTC date, derived from produced solana.blocks rows.
-- The underlying solana.transactions table itself is one non-vote transaction per row,
-- as separately validated by the bounded Core Grain QA query.
--
-- Time range:
-- The most recent 90 complete UTC calendar days inherited from Query 8435308.

-- Select only transaction-layer fields from the validated daily block aggregate.
WITH daily_transactions AS (
    SELECT
        date,
        transaction_count,
        successful_transactions,
        failed_transactions,
        failure_rate,
        vote_transaction_count
    FROM query_8435308
)

SELECT
    date,                       -- Complete UTC calendar date
    transaction_count,          -- Non-vote transactions aggregated from produced blocks
    successful_transactions,    -- Successful non-vote transactions
    failed_transactions,        -- Failed non-vote transactions
    failure_rate,               -- Failed non-vote transactions divided by all non-vote transactions
    vote_transaction_count      -- Vote transactions shown separately, not mixed into the primary count
FROM daily_transactions
ORDER BY date