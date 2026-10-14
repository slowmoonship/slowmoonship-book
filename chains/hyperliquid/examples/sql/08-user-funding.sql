-- 案例账户在各轮实际收到或支付多少？
-- Grain: user-market-funding-round
-- Unit: signed quote payment; base position
-- Logic: 地址为公开案例，prefix为首字节；不重算费用、不筛Taker
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_hour, coin, position_size, funding_rate,
 funding_amount_usd AS account_signed_funding_quote, _updated_at
FROM hyperliquid.perp_positions_hourly
WHERE block_month = DATE '2026-10-01' AND trader_prefix = '78'
 AND trader = 0x78dce96236804d6958bf3c4598cf5efbc371629c
 AND coin = 'BTC'
 AND block_hour >= TIMESTAMP '2026-10-12 00:00:00'
 AND block_hour < TIMESTAMP '2026-10-13 00:00:00'
ORDER BY block_hour;
