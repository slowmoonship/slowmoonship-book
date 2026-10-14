-- 一分钟簿快照点差多大、是否陈旧？
-- Grain: coin-minute sparse snapshot
-- Unit: quote price and bps
-- Logic: 空侧单列，不将缺失默认为零Spread
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
WITH top AS (
 SELECT interval_start, block_time, staleness_seconds,
 TRY_CAST(bids[1].px AS DOUBLE) AS bid,
 TRY_CAST(asks[1].px AS DOUBLE) AS ask
 FROM hyperliquid.perp_orderbook_1m
 WHERE block_date = DATE '2026-10-12' AND coin = 'BTC'
 AND cardinality(bids) > 0 AND cardinality(asks) > 0
)
SELECT *, ask-bid AS spread_quote,
 (ask-bid) / NULLIF((ask+bid)/2.0,0) * 10000 AS spread_bps
FROM top ORDER BY interval_start LIMIT 1440;
