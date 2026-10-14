-- BTC买盘快照各档有多少基础数量？
-- Grain: one row per snapshot price level
-- Unit: BTC units, quote/BTC price
-- Logic: 单独展开bids；不会与asks笛卡尔积
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT b.interval_start, b.block_time, b.staleness_seconds,
 u.n AS resting_orders, TRY_CAST(u.px AS DOUBLE) AS price_quote,
 TRY_CAST(u.sz AS DOUBLE) AS size_base,
 TRY_CAST(u.px AS DOUBLE) * TRY_CAST(u.sz AS DOUBLE) AS level_notional_quote
FROM hyperliquid.perp_orderbook_1m b
CROSS JOIN UNNEST(b.bids) AS u(n, px, sz)
WHERE b.block_date = DATE '2026-10-12' AND b.coin = 'BTC'
 AND b.interval_start >= TIMESTAMP '2026-10-12 12:00:00 UTC'
 AND b.interval_start < TIMESTAMP '2026-10-12 12:05:00 UTC'
ORDER BY b.interval_start, price_quote DESC LIMIT 300;
