-- LGNS池Mint与Burn事件
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: Mint或Burn事件
-- Units: 原始整数；token0/token1顺序来自旧Query，需历史状态再核
-- No remote objects created or modified.

SELECT 'mint' AS event_type, evt_block_time, evt_tx_hash, evt_index, amount0 AS dai_raw, amount1 AS lgns_raw
FROM quickswap_polygon.uniswapv2pair_evt_mint
WHERE evt_block_date=DATE '2024-03-06' AND contract_address=0x882df4b0fb50a229c3b4124eb18c759911485bfb
UNION ALL
SELECT 'burn', evt_block_time, evt_tx_hash, evt_index, amount0, amount1
FROM quickswap_polygon.uniswapv2pair_evt_burn
WHERE evt_block_date=DATE '2024-03-06' AND contract_address=0x882df4b0fb50a229c3b4124eb18c759911485bfb;
