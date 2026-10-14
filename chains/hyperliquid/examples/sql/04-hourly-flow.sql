-- BTC成交的小时分布？
-- Grain: market-hour
-- Unit: UTC hour, quote amount
-- Logic: 先在成交侧聚合；不是站立仓位
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT date_trunc('hour', block_time) AS event_hour,
 SUM(notional_usd) AS taker_execution_notional_quote
FROM hyperliquid.perp_trades
WHERE block_date = DATE '2026-10-12' AND coin = 'BTC'
 AND is_taker AND fill_type NOT IN ('settlement','vault_netting')
GROUP BY 1 ORDER BY 1;
