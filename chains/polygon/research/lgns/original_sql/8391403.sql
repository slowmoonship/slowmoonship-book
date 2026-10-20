-- Query 12辅助：LGNS/DAI Pair与外部地址之间的DAI边界月度互斥分类
-- Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；固定截止2026-08-18 09:28:58 UTC。
-- 只保留Pair与六地址系统之外地址之间的DAI Transfer；Pair与其余五个核心地址互转属于内部流，不计外部sources/sinks。
-- 入Pair且交易含Mint=Liquidity Addition；出Pair且交易含Burn=Liquidity Removal；其余分别为residual in/out。
-- Mint/Burn标记来自已核验物化表；不读取303M Swap，residual在Query 12按月净额处理。

WITH pair_transfers AS (
    -- 单次扫描Polygon DAI，只读取至少一个端点为目标Pair的固定截止事件。
    SELECT
        CAST(DATE_TRUNC('month', d.evt_block_time) AS DATE)
            AS month,                                           -- UTC月份
        d.evt_tx_hash AS tx_hash,                               -- DAI Transfer交易哈希
        d.evt_index AS evt_index,                               -- DAI Transfer日志索引
        d."from" AS from_address,                                -- DAI发送地址
        d."to" AS to_address,                                    -- DAI接收地址
        CAST(d.value AS DOUBLE) / 1e18 AS dai_amount            -- DAI uint256按18位精度缩放
    FROM maker_polygon.dai_evt_transfer d
    WHERE d.evt_block_date >= DATE '2024-03-01'
        -- 早于Pair生命周期起点，并启用日期分区裁剪。
      AND d.evt_block_date <= DATE '2026-08-18'
        -- 固定截止日期。
      AND d.evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻。
      AND d.contract_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
        -- 显式限定Polygon DAI。
      AND (
          d."from" = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
          OR d."to" = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
      )
        -- 只读取Pair作为发送端或接收端的DAI事件。
),
classified_pair AS (
    -- 接入唯一tx_hash流动性标记，并区分外部边界与系统内部Pair互转。
    SELECT
        p.month,                                                -- UTC月份
        p.tx_hash,                                              -- DAI交易哈希
        p.evt_index,                                            -- DAI日志索引
        p.dai_amount,                                           -- DAI数量
        CASE
            WHEN p.to_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
             AND p.from_address NOT IN (
                0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
                0x99a57e6c8558bc6689f894e068733adf83c19725,
                0x1964ca90474b11ffd08af387b110ba6c96251bfc,
                0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
                0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
                0x882df4b0fb50a229c3b4124eb18c759911485bfb
             )
             AND COALESCE(f.mint_event_count, 0) > 0
                THEN 'liquidity_add'
            WHEN p.from_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
             AND p.to_address NOT IN (
                0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
                0x99a57e6c8558bc6689f894e068733adf83c19725,
                0x1964ca90474b11ffd08af387b110ba6c96251bfc,
                0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
                0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
                0x882df4b0fb50a229c3b4124eb18c759911485bfb
             )
             AND COALESCE(f.burn_event_count, 0) > 0
                THEN 'liquidity_remove'
            WHEN p.to_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
             AND p.from_address NOT IN (
                0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
                0x99a57e6c8558bc6689f894e068733adf83c19725,
                0x1964ca90474b11ffd08af387b110ba6c96251bfc,
                0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
                0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
                0x882df4b0fb50a229c3b4124eb18c759911485bfb
             )
                THEN 'pair_residual_in'
            WHEN p.from_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
             AND p.to_address NOT IN (
                0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01,
                0x99a57e6c8558bc6689f894e068733adf83c19725,
                0x1964ca90474b11ffd08af387b110ba6c96251bfc,
                0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321,
                0x07ff4e06865de4934409aa6ecea503b08cc1c78d,
                0x882df4b0fb50a229c3b4124eb18c759911485bfb
             )
                THEN 'pair_residual_out'
            ELSE 'pair_internal'
        END AS economic_category                                -- Pair事件的唯一互斥分类
    FROM pair_transfers p
    LEFT JOIN dune.slowmoonship.result_lgns_pair_liquidity_tx_flags f
        ON p.tx_hash = f.tx_hash
        -- 物化表每个tx_hash一行，不扩展DAI事件。
),
monthly_pair AS (
    -- 在月度粒度汇总四类外部Pair流和内部互转，保留事件键质量检查。
    SELECT
        month,                                                   -- UTC月份
        SUM(CASE WHEN economic_category = 'liquidity_add'
            THEN dai_amount ELSE 0e0 END) AS liquidity_add_dai, -- 外部入Pair且含Mint
        SUM(CASE WHEN economic_category = 'liquidity_remove'
            THEN dai_amount ELSE 0e0 END) AS liquidity_remove_dai, -- Pair出向外部且含Burn
        SUM(CASE WHEN economic_category = 'pair_residual_in'
            THEN dai_amount ELSE 0e0 END) AS pair_residual_in_dai, -- 非Mint外部入Pair
        SUM(CASE WHEN economic_category = 'pair_residual_out'
            THEN dai_amount ELSE 0e0 END) AS pair_residual_out_dai, -- 非Burn Pair外部流出
        SUM(CASE WHEN economic_category = 'pair_internal'
            THEN dai_amount ELSE 0e0 END) AS pair_internal_dai, -- Pair与其他核心地址内部互转
        COUNT_IF(economic_category <> 'pair_internal')
            AS pair_external_event_count,                       -- Pair外部边界事件数
        COUNT_IF(economic_category IN (
            'liquidity_add',
            'liquidity_remove',
            'pair_residual_in',
            'pair_residual_out'
        )) AS pair_classified_event_count,                      -- 已分到四类的Pair外部事件数
        COUNT(*) - COUNT(DISTINCT CONCAT(
            to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
        )) AS duplicate_event_rows                             -- 重复DAI事件键数，预期为0
    FROM classified_pair
    GROUP BY 1
)
SELECT
    month,                                                       -- UTC月份
    liquidity_add_dai,                                          -- Liquidity Addition DAI
    liquidity_remove_dai,                                       -- Liquidity Removal DAI
    pair_residual_in_dai,                                       -- Pair residual gross流入
    pair_residual_out_dai,                                      -- Pair residual gross流出
    pair_residual_in_dai - pair_residual_out_dai
        AS pair_residual_net_dai,                               -- Pair视角residual净流入
    pair_internal_dai,                                          -- Pair与其他核心地址内部互转
    pair_external_event_count,                                  -- Pair外部边界事件数
    pair_classified_event_count,                                -- 已分类Pair外部事件数
    pair_external_event_count - pair_classified_event_count
        AS classification_event_gap,                            -- Pair外部事件分类缺口，必须为0
    duplicate_event_rows                                        -- 重复DAI事件键数
FROM monthly_pair
    -- 不做最终排序，降低物化成本；Query 12按month等值连接。