-- 当前HIP-3产品按部署者和资产类别怎样组织？
-- Grain: current market registry
-- Unit: identity and parameters
-- Logic: 现行分类，不回写历史分类；不代表真实股票持有
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT perp_dex, coin, deployer, asset_class, underlying_ticker,
 max_leverage, margin_mode, is_halted, metadata_last_updated
FROM hyperliquid.perp_market_details
WHERE perp_dex_type = 'builder'
ORDER BY perp_dex, coin LIMIT 500;
