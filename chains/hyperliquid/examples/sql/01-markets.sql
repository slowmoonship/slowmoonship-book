-- 当前市场有哪些、采用哪些风险参数？
-- Grain: one row per current coin
-- Unit: identity and parameters
-- Logic: 当前注册维度，不是历史参数版本
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT coin, perp_dex, asset_id, perp_dex_type, deployer,
 max_leverage, margin_mode, funding_multiplier, open_interest_cap_usd,
 asset_class, is_halted, _updated_at
FROM hyperliquid.perp_market_details
ORDER BY coin LIMIT 500;
