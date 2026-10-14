-- 已经结算的BTC资金费率？
-- Grain: market funding-hour
-- Unit: decimal hourly rate
-- Logic: 不把下一轮预测当历史支付；简单年化仅展示
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_hour, funding_rate AS settled_hourly_rate,
 funding_rate * 24 * 365 AS simple_annualized_rate,
 funding_paid_usd AS paying_side_gross_quote, _updated_at
FROM hyperliquid.perp_market_metrics_hourly
WHERE block_month = DATE '2026-10-01' AND coin = 'BTC'
 AND block_hour >= TIMESTAMP '2026-10-12 00:00:00'
 AND block_hour < TIMESTAMP '2026-10-13 00:00:00'
ORDER BY block_hour;
