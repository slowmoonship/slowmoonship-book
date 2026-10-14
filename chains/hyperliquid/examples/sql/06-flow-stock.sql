-- 同一小时成交与OI有何不同？
-- Grain: one market-hour
-- Unit: quote flow and quote stock
-- Logic: 同表避免Fill与OI一对多复制；Metrics volume含文档所述行政Fill
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_hour, volume_usd AS source_total_volume_quote,
 open_interest_usd AS source_both_sides_oi_quote,
 volume_usd / NULLIF(open_interest_usd / 2.0, 0) AS turnover_vs_one_side_stock,
 forced_volume_usd, _updated_at
FROM hyperliquid.perp_market_metrics_hourly
WHERE block_month = DATE '2026-10-01' AND coin = 'BTC'
 AND block_hour >= TIMESTAMP '2026-10-12 00:00:00'
 AND block_hour < TIMESTAMP '2026-10-13 00:00:00'
ORDER BY block_hour;
