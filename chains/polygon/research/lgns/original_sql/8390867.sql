-- Query 11辅助：Top 20 Burn.to直接接收地址的DAI第一跳时间关联底表
-- 固定截止：2026-08-18 09:28:58 UTC；Burn事件复用query_8390794。
-- DAI：Polygon DAI 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063，decimals=18。
-- 关联规则：每笔DAI转出只关联同地址此前7天内时间最近的一笔Burn，避免同一转出重复归属。
-- 局限：ERC20余额可替代，24小时/7天只是时间邻近，不是UTXO级资金来源证明。

WITH burn_base AS (
    -- 读取Top 20逐笔Burn的最小关联字段。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        block_time,                                              -- Burn时间
        tx_hash,                                                 -- Burn交易哈希
        evt_index                                                -- Burn日志索引
    FROM query_8390794
        -- Saved Query Result避免重扫Mint/Burn底表。
),
top20_addresses AS (
    -- 提取唯一Top 20发送端，限制DAI底表扫描结果。
    SELECT DISTINCT
        beneficiary_address                                     -- 唯一Top remover地址
    FROM burn_base
),
outbound_raw AS (
    -- 只读取Top 20地址在固定截止前发出的Polygon DAI Transfer。
    SELECT
        a.beneficiary_address AS source_remover,                 -- DAI发送端Top remover
        d.evt_block_time AS transfer_time,                       -- DAI转出时间
        d.evt_tx_hash AS transfer_tx_hash,                       -- DAI转出交易哈希
        d.evt_index AS transfer_evt_index,                       -- DAI转出日志索引
        d."to" AS destination_address,                            -- 第一跳接收地址
        CAST(d.value AS DOUBLE) / 1e18 AS dai_sent               -- DAI uint256按18位精度缩放
    FROM maker_polygon.dai_evt_transfer d
    INNER JOIN top20_addresses a
        ON d."from" = a.beneficiary_address
        -- 发送端严格限定Top 20，普通DAI转账不进入结果。
    WHERE d.evt_block_date >= DATE '2024-03-01'
        -- 早于Pair首笔事件，并启用日期分区裁剪。
      AND d.evt_block_date <= DATE '2026-08-18'
        -- 固定截止日期。
      AND d.evt_block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻，与Burn口径一致。
      AND d.contract_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
        -- 显式限定Polygon DAI合约。
      AND d."to" <> d."from"
        -- 自转账不构成有效第一跳。
      AND d.value > UINT256 '0'
        -- 零金额事件不计入资金去向。
),
assigned_outbound AS (
    -- 每笔DAI转出按事件键聚合候选Burn，只保留此前7天内时间最近者。
    SELECT
        o.source_remover,                                       -- DAI发送端Top remover
        o.transfer_time,                                        -- DAI转出时间
        o.transfer_tx_hash,                                     -- DAI转出交易哈希
        o.transfer_evt_index,                                   -- DAI转出日志索引
        o.destination_address,                                  -- 第一跳接收地址
        o.dai_sent,                                              -- 第一跳DAI数量
        MAX(b.block_time) AS nearest_burn_time,                  -- 此前7天内最近Burn时间
        DATE_DIFF('second', MAX(b.block_time), o.transfer_time) / 3600e0
            AS hours_after_burn                                  -- 转出距最近Burn的小时数
    FROM outbound_raw o
    INNER JOIN burn_base b
        ON o.source_remover = b.beneficiary_address
       AND o.transfer_time >= b.block_time
       AND o.transfer_time <= b.block_time + INTERVAL '7' DAY
        -- 同一remover且Burn后7天内才建立时间关联。
       AND (
            o.transfer_tx_hash <> b.tx_hash
            OR o.transfer_evt_index > b.evt_index
       )
        -- 同交易仅接受Burn日志之后的转出，保持日志顺序。
    GROUP BY 1, 2, 3, 4, 5, 6
        -- 唯一DAI事件键分组，使每笔转出最终只出现一次。
),
source_destination_stats AS (
    -- 在remover+目的地址粒度同时计算24小时和7天窗口，避免重复扫描。
    SELECT
        source_remover,                                         -- DAI发送端Top remover
        destination_address,                                    -- 第一跳接收地址
        COUNT_IF(hours_after_burn <= 24e0) AS transfer_count_24h, -- 24小时转账事件数
        SUM(CASE WHEN hours_after_burn <= 24e0
            THEN dai_sent ELSE 0e0 END) AS dai_sent_24h,         -- 24小时时间关联DAI
        COUNT(*) AS transfer_count_7d,                           -- 7天转账事件数
        SUM(dai_sent) AS dai_sent_7d,                            -- 7天时间关联DAI
        MIN(transfer_time) AS first_transfer_time,               -- 首笔关联转出时间
        MAX(transfer_time) AS last_transfer_time                 -- 末笔关联转出时间
    FROM assigned_outbound
    GROUP BY 1, 2
)
SELECT
    source_remover,                                              -- DAI发送端Top remover
    destination_address,                                         -- 第一跳接收地址
    transfer_count_24h,                                          -- 24小时转账事件数
    dai_sent_24h,                                                 -- 24小时时间关联DAI
    transfer_count_7d,                                           -- 7天转账事件数
    dai_sent_7d,                                                  -- 7天时间关联DAI
    first_transfer_time,                                         -- 首笔关联转出时间
    last_transfer_time                                            -- 末笔关联转出时间
FROM source_destination_stats
ORDER BY source_remover, dai_sent_7d DESC, destination_address
    -- 每个remover内按7天关联DAI降序，便于主Query确定主要第一跳。