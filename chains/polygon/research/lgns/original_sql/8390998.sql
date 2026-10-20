-- Query 12辅助：LGNS/DAI Pair固定截止内Mint/Burn交易标记
-- 目标Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；token0=Polygon DAI，decimals=18。
-- 用途：让DAI边界Transfer按tx_hash识别Liquidity Addition/Removal；不读取303M Swap事件。
-- 唯一性：Mint与Burn topic互斥，先UNION ALL逐事件，再压缩到唯一交易哈希。

WITH liquidity_events AS (
    -- 读取目标Pair固定截止内的Mint事件。
    SELECT
        evt_tx_hash AS tx_hash,                                 -- Mint交易哈希
        evt_index AS evt_index,                                 -- Mint日志索引
        evt_block_time AS block_time,                           -- Mint区块时间
        'mint' AS event_type,                                   -- 添加流动性标记
        CAST(amount0 AS DOUBLE) / 1e18 AS dai_amount            -- Mint事件token0 DAI，按18位精度缩放
    FROM quickswap_polygon.uniswapv2pair_evt_mint
    WHERE evt_block_date >= DATE '2024-03-01'
        -- 早于Pair首笔事件，并启用日期分区裁剪。
      AND evt_block_date <= DATE '2026-08-18'
        -- 固定截止日期。
      AND evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻，与统一Burn口径一致。
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只读取LGNS/DAI Pair的Mint。
    UNION ALL
    SELECT
        evt_tx_hash AS tx_hash,                                 -- Burn交易哈希
        evt_index AS evt_index,                                 -- Burn日志索引
        evt_block_time AS block_time,                           -- Burn区块时间
        'burn' AS event_type,                                   -- 移除流动性标记
        CAST(amount0 AS DOUBLE) / 1e18 AS dai_amount            -- Burn事件token0 DAI，按18位精度缩放
    FROM quickswap_polygon.uniswapv2pair_evt_burn
    WHERE evt_block_date >= DATE '2024-03-01'
        -- 早于Pair首笔事件，并启用日期分区裁剪。
      AND evt_block_date <= DATE '2026-08-18'
        -- 固定截止日期。
      AND evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻，与Query 05/09一致。
      AND contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只读取LGNS/DAI Pair的Burn。
),
transaction_flags AS (
    -- 按交易哈希压缩事件；一笔交易可包含多条同类事件或极少数同时含Mint/Burn。
    SELECT
        tx_hash,                                                 -- 唯一交易哈希
        MAX(block_time) AS block_time,                           -- 交易内最晚流动性事件时间
        COUNT_IF(event_type = 'mint') AS mint_event_count,       -- 交易内Mint事件数
        COUNT_IF(event_type = 'burn') AS burn_event_count,       -- 交易内Burn事件数
        SUM(CASE WHEN event_type = 'mint'
            THEN dai_amount ELSE 0e0 END) AS mint_event_dai,     -- 交易内Mint事件DAI总量
        SUM(CASE WHEN event_type = 'burn'
            THEN dai_amount ELSE 0e0 END) AS burn_event_dai,     -- 交易内Burn事件DAI总量
        COUNT(*) AS raw_event_count,                             -- 交易内Mint+Burn原始事件数
        COUNT(DISTINCT CONCAT(to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)))
            AS unique_event_count                               -- 交易内唯一事件键数
    FROM liquidity_events
    GROUP BY 1
)
SELECT
    tx_hash,                                                     -- 唯一流动性交易哈希
    block_time,                                                  -- 交易内最晚流动性事件时间
    mint_event_count,                                            -- Mint事件数
    burn_event_count,                                            -- Burn事件数
    mint_event_dai,                                              -- Mint事件DAI总量
    burn_event_dai,                                              -- Burn事件DAI总量
    raw_event_count,                                             -- 原始Mint+Burn事件数
    unique_event_count,                                          -- 唯一事件键数
    raw_event_count - unique_event_count AS duplicate_event_rows -- 重复事件行数，预期为0
FROM transaction_flags
    -- 最终结果无需排序；Query 12仅按tx_hash等值连接，省去70余万行全局排序。