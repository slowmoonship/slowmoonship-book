-- 指定完整UTC日BTC的经济成交量？
-- Grain: one output market-day
-- Unit: quote-token notional, documented as usd
-- Logic: Taker单计数；排除行政腿，保留清算/ADL，非全部Metrics口径
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_date, coin, SUM(notional_usd) AS execution_notional_quote,
 COUNT(*) AS taker_fill_legs
FROM hyperliquid.perp_trades
WHERE block_date = DATE '2026-10-12' AND coin = 'BTC'
 AND is_taker AND fill_type NOT IN ('settlement', 'vault_netting')
GROUP BY 1,2;
