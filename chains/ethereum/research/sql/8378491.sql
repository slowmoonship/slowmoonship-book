-- Source table grain:
-- One row in dex_evm.trades represents one DEX liquidity-pool execution segment.
-- A multi-hop swap can produce multiple rows under the same tx_hash.
-- Aggregator-routed swaps can also contribute multiple underlying execution rows.
-- Therefore trade_count is execution-segment count, not end-user swap count.
-- Trader proxy:
-- tx_from is the transaction-originating EOA in the catalog, but can be a keeper or arbitrage bot.
-- unique_traders is therefore a distinct initiator proxy, not a unique-user metric.
-- USD semantics:
-- amount_usd is the row-level execution value and can be null when valuation data is unavailable.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.

-- Aggregate curated DEX execution rows into one row per UTC day.
WITH daily_dex_activity AS (
    SELECT
        block_date AS date,                              -- UTC event date
        COUNT(*) AS trade_count,                         -- Number of DEX execution-segment rows
        SUM(amount_usd) AS volume_usd,                   -- Sum of non-null row-level USD execution values
        COUNT(DISTINCT tx_from) AS unique_traders,       -- Distinct transaction initiators; proxy, not users
        COUNT(DISTINCT tx_hash) AS unique_transactions,  -- Distinct transactions containing DEX rows
        CAST(COUNT(*) AS DOUBLE)
            / NULLIF(COUNT(DISTINCT tx_hash), 0) AS avg_trade_rows_per_transaction, -- Mean execution rows per represented transaction
        COUNT_IF(amount_usd IS NULL) AS null_amount_usd_rows, -- QA rows without USD valuation
        CAST(COUNT_IF(amount_usd IS NULL) AS DOUBLE)
            / NULLIF(COUNT(*), 0) AS null_amount_usd_rate, -- QA share of rows without USD valuation
        MAX(amount_usd) AS max_trade_row_usd             -- QA largest single execution-row USD value
    FROM dex_evm.trades
    WHERE blockchain = 'ethereum'                        -- Blockchain partition filter
      AND block_month >= CAST(DATE_TRUNC('month', CURRENT_DATE - INTERVAL '90' DAY) AS DATE) -- Month partition pruning
      AND block_date >= CURRENT_DATE - INTERVAL '90' DAY -- Exact lower date boundary
      AND block_date < CURRENT_DATE                      -- Exclude the current partial UTC day
      -- project is intentionally unfiltered because this chart covers all Ethereum DEX protocols.
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    trade_count AS trade_count,                          -- DEX execution-segment row count
    volume_usd AS volume_usd,                            -- Sum of non-null row-level USD execution values
    unique_traders AS unique_traders,                    -- Distinct transaction-initiator proxy
    unique_transactions AS unique_transactions,          -- Distinct transactions containing DEX activity
    avg_trade_rows_per_transaction AS avg_trade_rows_per_transaction, -- Mean execution rows per transaction
    null_amount_usd_rows AS null_amount_usd_rows,        -- QA rows lacking USD valuation
    null_amount_usd_rate AS null_amount_usd_rate,        -- QA share lacking USD valuation
    max_trade_row_usd AS max_trade_row_usd               -- QA maximum row-level USD value
FROM daily_dex_activity
ORDER BY date;