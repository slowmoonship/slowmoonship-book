-- 一日市场活动与数据质量怎样一起报告？
-- Grain: coin-day
-- Unit: source quote flow/stock, freshness
-- Logic: 财务单位未经FX独立验证，按市场保留，不合并协议总收入
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT m.block_date, m.coin, d.perp_dex, d.asset_class,
 m.volume_usd AS source_volume_quote,
 m.open_interest_usd AS source_eod_both_sides_oi_quote,
 m.funding_paid_usd AS paying_side_funding_quote,
 m.fee_usd AS source_net_fee_quote,
 m.forced_volume_usd AS forced_flow_quote,
 m._updated_at, d.metadata_last_updated,
 CASE WHEN m.open_interest_usd IS NULL THEN 'MISSING_STOCK'
 WHEN d.coin IS NULL THEN 'UNMATCHED_REGISTRY' ELSE 'REVIEW_FRESHNESS' END AS quality_status
FROM hyperliquid.perp_market_metrics_daily m
LEFT JOIN hyperliquid.perp_market_details d ON d.coin = m.coin
WHERE m.block_month = DATE '2026-10-01' AND m.block_date = DATE '2026-10-12'
ORDER BY source_volume_quote DESC LIMIT 100;
