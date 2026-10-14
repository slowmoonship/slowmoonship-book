-- 同一天第一方与HIP-3的来源指标如何比较？
-- Grain: dex-type-day
-- Unit: source quote amounts, multiple collateral units
-- Logic: 使用完整coin维度；未知注册保留；当前分类应用到历史日
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT m.block_date, COALESCE(d.perp_dex_type,'unmatched') AS market_family,
 SUM(m.volume_usd) AS source_volume_quote_proxy,
 SUM(m.open_interest_usd) AS source_eod_both_sides_oi_quote_proxy,
 COUNT_IF(d.coin IS NULL) AS unmatched_markets
FROM hyperliquid.perp_market_metrics_daily m
LEFT JOIN hyperliquid.perp_market_details d ON d.coin = m.coin
WHERE m.block_month = DATE '2026-10-01' AND m.block_date = DATE '2026-10-12'
GROUP BY 1,2;
