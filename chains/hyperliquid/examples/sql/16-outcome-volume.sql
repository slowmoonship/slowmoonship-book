-- HIP-4正常成交单计数与定义？
-- Grain: market-day normal taker trade legs
-- Unit: quote stablecoin amount, contracts
-- Logic: 排除引擎腿；market_id为varchar；不按裸Ticker连接
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT t.market_id, d.title, d.quote_token,
 SUM(t.amount_usd) AS normal_execution_quote,
 SUM(t.num_contracts) AS normal_execution_contracts,
 COUNT(*) AS normal_taker_legs
FROM hip4_hyperliquid.market_trades t
LEFT JOIN hip4_hyperliquid.market_details d ON d.market_id = t.market_id
WHERE t.block_month = DATE '2026-10-01' AND t.block_date = DATE '2026-10-12'
 AND t.is_taker AND t.fill_type = 'trade'
GROUP BY 1,2,3 ORDER BY normal_execution_quote DESC LIMIT 30;
