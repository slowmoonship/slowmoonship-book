-- Source table grain:
-- One row in ethereum.transactions represents one Ethereum transaction.
-- Status semantics:
-- success = true means the transaction executed successfully.
-- success = false means execution failed; there is no separate status column.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.

-- Aggregate transaction execution outcomes into one row per UTC day.
WITH daily_transaction_status AS (
    SELECT
        block_date AS date,                              -- UTC partition date of the containing block
        COUNT_IF(success = TRUE) AS success_count,       -- Successfully executed transactions
        COUNT_IF(success = FALSE) AS failed_count,       -- Failed transaction executions
        COUNT_IF(success IS NULL) AS null_status_count,  -- QA: transactions without an execution status
        CAST(COUNT_IF(success = FALSE) AS DOUBLE)
            / NULLIF(COUNT_IF(success IS NOT NULL), 0) AS failure_rate -- Failed share among rows with a known status
    FROM ethereum.transactions
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    success_count AS success_count,                      -- Successful transaction count
    failed_count AS failed_count,                        -- Failed transaction count
    failure_rate AS failure_rate,                        -- Failure share among known execution statuses
    null_status_count AS null_status_count               -- QA null-status count
FROM daily_transaction_status
ORDER BY date;