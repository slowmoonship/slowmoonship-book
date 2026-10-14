-- 市场两种参与角色各有多少Fill与费用？
-- Grain: coin-role-day, participation legs
-- Unit: quote amount, counts
-- Logic: 双侧参与统计不可直接相加当市场成交；Maker负费保留
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT coin, is_taker, COUNT(*) AS participation_legs,
 SUM(notional_usd) AS participation_notional_quote,
 SUM(fee_usd) AS signed_fee_quote
FROM hyperliquid.perp_trades
WHERE block_date = DATE '2026-10-12' AND coin = 'BTC'
 AND fill_type NOT IN ('settlement', 'vault_netting')
GROUP BY 1,2;
