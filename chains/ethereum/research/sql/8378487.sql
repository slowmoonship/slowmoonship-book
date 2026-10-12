-- Source table grain:
-- One row in gas.fees represents one modelled transaction-fee record.
-- Fee semantics:
-- tx_fee is Dune's curated total fee in the chain's native token (ETH here).
-- For Ethereum, Dune models base fee, priority fee, and blob fee where applicable.
-- total_fees_eth is total user-paid transaction fees, not validator revenue.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.

-- Aggregate transaction-fee rows into one row per UTC day.
WITH daily_gas_and_fees AS (
    SELECT
        block_date AS date,                              -- UTC date of the transaction
        SUM(CAST(gas_used AS DECIMAL(38, 0))) AS total_gas_used, -- Total gas units consumed
        AVG(CAST(gas_used AS DOUBLE)) AS avg_gas_used,   -- Mean gas units consumed per fee row
        SUM(tx_fee) AS total_fees_eth,                   -- Total curated transaction fees paid in ETH
        COUNT(*) AS transaction_fee_rows,                -- Number of transaction-fee rows
        COUNT(*) - COUNT(DISTINCT tx_hash) AS duplicate_or_null_transaction_hashes, -- QA duplicate-or-null transaction hashes
        COUNT_IF(gas_used IS NULL OR tx_fee IS NULL) AS null_fee_input_rows -- QA rows missing gas or total fee
    FROM gas.fees
    WHERE blockchain = 'ethereum'                        -- Partition filter for Ethereum only
      AND block_month >= CAST(DATE_TRUNC('month', CURRENT_DATE - INTERVAL '90' DAY) AS DATE) -- Month partition pruning
      AND block_date >= CURRENT_DATE - INTERVAL '90' DAY -- Exact lower date boundary
      AND block_date < CURRENT_DATE                      -- Exclude the current partial UTC day
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    total_gas_used AS total_gas_used,                    -- Total gas units consumed
    avg_gas_used AS avg_gas_used,                        -- Average gas used per transaction-fee row
    total_fees_eth AS total_fees_eth,                    -- Total user-paid transaction fees in ETH
    transaction_fee_rows AS transaction_fee_rows,        -- Number of curated fee rows
    duplicate_or_null_transaction_hashes AS duplicate_or_null_transaction_hashes, -- QA duplicate-or-null hash count
    null_fee_input_rows AS null_fee_input_rows           -- QA missing gas/fee input count
FROM daily_gas_and_fees
ORDER BY date;