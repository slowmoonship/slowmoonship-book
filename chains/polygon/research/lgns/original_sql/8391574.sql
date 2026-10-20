/*
Query 12辅助：LGNS/DAI Pair 精确 Mint/Burn 月度金额。
固定截止：2026-08-18 09:28:58 UTC。
经济口径：Mint.amount0 是添加到 Pair 的 token0 DAI；Burn.amount0 是从 Pair 移出的 token0 DAI。
精度口径：该 Pair 的 token0 已由 Query 09 和 token 元数据确认是 18 decimals 的 Polygon DAI。
归因限制：金额来自 decoded Pair 事件本身，不把同交易中的其他 DAI Transfer 误归为流动性金额。
唯一键：event_type + evt_tx_hash + evt_index；Mint/Burn topic 互斥。
*/

WITH
/* CTE 1：合并固定截止内的 Mint 与 Burn 真实事件，不使用交易级模糊标记。 */
liquidity_events AS (
    SELECT
        CAST(DATE_TRUNC('month', m.evt_block_time) AS DATE) AS month, -- Mint月份。
        m.evt_tx_hash AS tx_hash,                                    -- Mint交易哈希。
        m.evt_index AS evt_index,                                    -- Mint日志索引。
        'mint' AS event_type,                                        -- Mint代表添加流动性。
        CAST(m.amount0 AS DOUBLE) / 1e18 AS dai_amount               -- token0 DAI原始整数除以1e18。
    FROM quickswap_polygon.uniswapv2pair_evt_mint m
    WHERE m.evt_block_date >= DATE '2024-03-01'                      -- 分区下界：早于Pair首个事件。
      AND m.evt_block_date <= DATE '2026-08-18'                      -- 分区上界：固定截止日期。
      AND m.evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'        -- 精确截止时间。
      AND m.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                                                                       -- 仅目标LGNS/DAI Pair。
    UNION ALL                                                        -- Mint/Burn topic互斥，保留全部真实日志。
    SELECT
        CAST(DATE_TRUNC('month', b.evt_block_time) AS DATE) AS month, -- Burn月份。
        b.evt_tx_hash AS tx_hash,                                    -- Burn交易哈希。
        b.evt_index AS evt_index,                                    -- Burn日志索引。
        'burn' AS event_type,                                        -- Burn代表移除流动性。
        CAST(b.amount0 AS DOUBLE) / 1e18 AS dai_amount               -- token0 DAI原始整数除以1e18。
    FROM quickswap_polygon.uniswapv2pair_evt_burn b
    WHERE b.evt_block_date >= DATE '2024-03-01'                      -- 分区下界：早于Pair首个事件。
      AND b.evt_block_date <= DATE '2026-08-18'                      -- 分区上界：固定截止日期。
      AND b.evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'        -- 精确截止时间；排除已确认的后续11条Burn。
      AND b.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                                                                       -- 仅目标LGNS/DAI Pair。
)

/* 最终SELECT：每月精确流动性金额、事件数和重复键QA。 */
SELECT
    month,                                                           -- 月份。
    SUM(CASE WHEN event_type = 'mint'
             THEN dai_amount ELSE 0e0 END) AS exact_liquidity_add_dai, -- Mint.amount0累计DAI。
    SUM(CASE WHEN event_type = 'burn'
             THEN dai_amount ELSE 0e0 END) AS exact_liquidity_remove_dai, -- Burn.amount0累计DAI。
    SUM(CASE WHEN event_type = 'mint'
             THEN 1 ELSE 0 END) AS mint_event_count,                 -- Mint事件数。
    SUM(CASE WHEN event_type = 'burn'
             THEN 1 ELSE 0 END) AS burn_event_count,                 -- Burn事件数。
    COUNT(*) - COUNT(DISTINCT CONCAT(
        event_type, ':', to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
    )) AS duplicate_event_rows                                      -- 重复事件键行数；强制目标为0。
FROM liquidity_events                                                -- 仅固定截止目标Pair Mint/Burn。
GROUP BY month                                                       -- 每月一行，供Query 12校正交易级模糊分类。