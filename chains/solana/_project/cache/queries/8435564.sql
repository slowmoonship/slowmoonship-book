-- Purpose:
-- Show the curated Solana DEX execution layer while preserving pool-segment grain
-- and measuring USD-value coverage.
--
-- Source table grain:
-- dex_solana.trades has one liquidity-pool execution / route-segment row.
-- One user swap or aggregator route can create multiple rows, so row count is not swap intent count.
--
-- Time range:
-- Thirty complete UTC calendar days ending two days before today. Both block_month
-- and block_date are filtered to prune the curated DEX table.

-- Read only DEX segment identity, trader, project, and USD-value fields.
WITH filtered_dex_segments AS (
    SELECT
        block_date,
        tx_id,
        trader_id,
        project,
        trade_source,
        amount_usd
    FROM dex_solana.trades
    WHERE block_month >= CAST(date_trunc('month', current_date - INTERVAL '32' DAY) AS date)
      AND block_month <= CAST(date_trunc('month', current_date - INTERVAL '2' DAY) AS date)
      AND block_date >= current_date - INTERVAL '32' DAY
      AND block_date < current_date - INTERVAL '2' DAY
),

-- Aggregate pool-segment activity by complete UTC date.
daily_dex_activity AS (
    SELECT
        block_date AS date,
        COUNT(*) AS trade_segment_count,
        approx_distinct(tx_id) AS approximate_unique_transactions,
        approx_distinct(trader_id) AS approximate_unique_traders,
        approx_distinct(project) AS unique_projects,
        approx_distinct(trade_source) AS observed_trade_sources,
        SUM(amount_usd) AS segment_volume_usd,
        COUNT_IF(amount_usd IS NOT NULL) AS usd_covered_segments,
        COUNT_IF(amount_usd IS NULL) AS null_amount_usd_segments,
        MAX(amount_usd) AS max_segment_amount_usd
    FROM filtered_dex_segments
    GROUP BY 1
)

SELECT
    date,                               -- Complete UTC calendar date
    trade_segment_count,                -- Curated pool execution / route-segment rows
    approximate_unique_transactions,    -- Approximate transactions containing DEX segments
    approximate_unique_traders,         -- Approximate trader_id values; not necessarily unique people
    unique_projects,                    -- Approximate curated DEX project labels
    observed_trade_sources,             -- Distinct direct/aggregator source labels observed
    segment_volume_usd,                  -- Sum of USD value at segment grain, not user swap-intent volume
    usd_covered_segments,                -- Segments with non-null amount_usd
    null_amount_usd_segments,            -- Segments without USD valuation
    CAST(null_amount_usd_segments AS double)
        / NULLIF(trade_segment_count, 0) AS null_amount_usd_rate, -- USD-null share of segments
    max_segment_amount_usd               -- Largest single segment value for outlier QA
FROM daily_dex_activity
ORDER BY date