-- Purpose:
-- Build one reusable daily Bitcoin transaction-structure aggregate for input/output,
-- output creation/spending, fee, and coinbase visualizations.
--
-- Source table grain:
-- bitcoin.transactions has one row per Bitcoin transaction and stores precomputed
-- input/output counts, BTC values, fee, and coinbase classification.
--
-- Time range:
-- The most recent 14 complete UTC calendar days ending two days before today.

-- Read the minimum transaction-level fields needed for all structural aggregates.
WITH filtered_transactions AS (
    SELECT
        block_date,
        id,
        is_coinbase,
        input_count,
        output_count,
        input_value,
        output_value,
        fee
    FROM bitcoin.transactions
    WHERE block_date >= CURRENT_DATE - INTERVAL '15' DAY
      AND block_date < CURRENT_DATE - INTERVAL '1' DAY
),

-- Aggregate transaction rows by event date while preserving distinct UTXO semantics.
daily_structure AS (
    SELECT
        block_date AS date,
        COUNT(*) AS transaction_count,
        SUM(input_count) AS input_count,
        SUM(output_count) AS output_count,
        AVG(CAST(input_count AS DOUBLE)) AS avg_inputs_per_transaction,
        AVG(CAST(output_count AS DOUBLE)) AS avg_outputs_per_transaction,
        SUM(output_count) AS outputs_created,
        SUM(CASE WHEN NOT is_coinbase THEN input_count ELSE 0 END) AS outputs_spent,
        SUM(output_value) AS output_value_created_btc,
        SUM(CASE WHEN NOT is_coinbase THEN input_value ELSE 0.0 END) AS output_value_spent_btc,
        SUM(CASE WHEN NOT is_coinbase THEN fee ELSE 0.0 END) AS total_fees_btc,
        AVG(CASE WHEN NOT is_coinbase THEN fee END) AS avg_fee_btc,
        approx_percentile(CASE WHEN NOT is_coinbase THEN fee END, 0.5) AS median_fee_btc,
        COUNT_IF(is_coinbase) AS coinbase_transaction_count,
        SUM(CASE WHEN is_coinbase THEN output_value ELSE 0.0 END) AS total_coinbase_output_btc
    FROM filtered_transactions
    GROUP BY 1
)

SELECT
    date,                                                -- Complete UTC calendar date
    transaction_count,                                   -- Transaction rows including one coinbase transaction per block
    input_count,                                         -- Input rows declared by transactions, including coinbase inputs
    output_count,                                        -- Output rows declared by transactions
    avg_inputs_per_transaction,                          -- Mean declared inputs per transaction
    avg_outputs_per_transaction,                         -- Mean declared outputs per transaction
    outputs_created,                                     -- Outputs created on this creation-event date
    outputs_spent,                                       -- Non-coinbase inputs consuming prior outputs on this spend-event date
    output_value_created_btc,                            -- BTC assigned to outputs created on this date
    output_value_spent_btc,                              -- BTC value of prior outputs consumed on this date
    total_fees_btc,                                      -- Non-coinbase transaction fees in BTC
    avg_fee_btc,                                         -- Mean non-coinbase transaction fee in BTC
    median_fee_btc,                                      -- Approximate median non-coinbase transaction fee in BTC
    coinbase_transaction_count,                          -- Transactions explicitly classified as coinbase
    total_coinbase_output_btc                            -- BTC assigned to outputs of coinbase transactions
FROM daily_structure
ORDER BY date