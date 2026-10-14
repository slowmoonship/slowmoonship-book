-- BTC被清算角色有多少腿与账户？
-- Grain: liquidation-role legs grouped by method
-- Unit: quote notional; distinct accounts
-- Logic: 不是完整清算事件数；method可能标两侧，选被清算角色
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT liquidation_method, COUNT(*) AS liquidated_account_fill_legs,
 COUNT(DISTINCT trader) AS liquidated_accounts,
 SUM(notional_usd) AS liquidated_role_notional_quote
FROM hyperliquid.perp_trades
WHERE block_date = DATE '2026-10-12' AND coin = 'BTC'
 AND fill_type = 'liquidation'
GROUP BY 1;
