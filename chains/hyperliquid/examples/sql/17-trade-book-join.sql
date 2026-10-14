-- BTC成交能连接到同分钟快照吗？
-- Grain: one fill leg with optional minute snapshot
-- Unit: UTC time and quote price
-- Logic: 精确分钟只是教学关联；稀疏簿不填充，失配显式保留，非成交前完整簿
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT t.block_time, t.coin, t.tid, t.price, t.size,
 b.interval_start, b.block_time AS book_observed_time, b.staleness_seconds,
 CASE WHEN b.coin IS NULL THEN 'NO_EXACT_MINUTE_ROW'
 ELSE 'MINUTE_SAMPLE_NOT_EXACT_PRETRADE_BOOK' END AS evidence_scope
FROM hyperliquid.perp_trades t
LEFT JOIN hyperliquid.perp_orderbook_1m b ON b.coin = t.coin
 AND CAST(b.interval_start AT TIME ZONE 'UTC' AS TIMESTAMP) = date_trunc('minute', t.block_time)
 AND b.block_date = DATE '2026-10-12'
WHERE t.block_date = DATE '2026-10-12' AND t.coin = 'BTC' AND t.is_taker
 AND t.block_time >= TIMESTAMP '2026-10-12 12:00:00'
 AND t.block_time < TIMESTAMP '2026-10-12 12:01:00'
ORDER BY t.block_time LIMIT 100;
