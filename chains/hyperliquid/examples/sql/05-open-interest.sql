-- BTC小时站立敞口？
-- Grain: coin-hour stock
-- Unit: base units and source quote valuation
-- Logic: 来源双边OI与经典单边换算分列，不跨小时加总
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_hour, coin, open_interest_units AS source_both_sides_units,
 open_interest_units / 2.0 AS classical_one_side_units,
 open_interest_usd AS source_oi_quote,
 open_interest_usd / 2.0 AS classical_one_side_quote, _updated_at
FROM hyperliquid.perp_market_metrics_hourly
WHERE block_month = DATE '2026-10-01' AND coin = 'BTC'
 AND block_hour >= TIMESTAMP '2026-10-12 00:00:00'
 AND block_hour < TIMESTAMP '2026-10-13 00:00:00'
ORDER BY block_hour;
