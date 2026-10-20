-- Query 11辅助底表：复用Query 09结果，为Top 20 Burn事件附加Dune合约和标签元数据
-- 该辅助Query不扫描Swap、Staked或全部Mint/Burn底表，只读取已保存的query_8389881结果。
-- 固定范围：beneficiary_rank 1至20；地址仍为Burn.to直接接收地址，不等于最终控制人。
-- 地址元数据：contracts.contract_mapping和labels.owner_addresses仅作EOA/Contract及名称辅助证据。

WITH top20_events AS (
    -- 从已修正Query 09筛选Top 20地址的逐笔Burn事件。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        beneficiary_rank,                                       -- 累计Remove DAI排名
        block_time,                                              -- Burn区块时间
        tx_hash,                                                 -- Burn交易哈希
        evt_index,                                               -- Burn日志索引
        tx_from,                                                 -- 外层交易发起地址
        sender,                                                  -- Pair.burn sender，可能是Router
        dai_removed,                                             -- 单笔移出DAI
        lgns_removed,                                            -- 单笔移出LGNS
        remove_count,                                            -- 地址累计Burn接收次数
        total_dai_removed,                                       -- 地址累计直接接收DAI
        total_lgns_removed,                                      -- 地址累计直接接收LGNS
        first_remove_time,                                       -- 地址首次Remove时间
        last_remove_time                                         -- 地址最后Remove时间
    FROM query_8389881
        -- Saved Query Result复用Query 09，避免链上Burn重扫。
    WHERE beneficiary_rank BETWEEN 1 AND 20
        -- 严格限制Top 20，禁止扩展为全地址图谱。
      AND beneficiary_address IS NOT NULL
        -- 缺失直接接收地址不做身份猜测。
      AND block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止，与Query 05/09统一口径一致。
),
top20_addresses AS (
    -- 从逐事件底表提取唯一Top 20地址，限制后续元数据连接。
    SELECT DISTINCT
        beneficiary_address                                     -- 唯一Burn.to直接接收地址
    FROM top20_events
),
contract_metadata_ranked AS (
    -- 从Dune合约映射提取Top 20地址的创建者、名称和运行时代码。
    SELECT
        cm.contract_address,                                    -- 合约地址
        cm.contract_project,                                    -- Dune项目名，仅辅助
        cm.contract_name,                                       -- Dune合约名，仅辅助
        COALESCE(cm.creator_address, cm.trace_creator_address, cm.created_tx_from)
            AS creator_address,                                 -- 可用创建者字段按优先级合并
        cm.created_time,                                         -- 合约创建时间
        cm.created_tx_hash,                                      -- 合约创建交易
        LOWER(to_hex(cm.code)) AS code_hex,                      -- 运行时代码十六进制
        cm.is_self_destruct,                                     -- Dune自毁标记
        ROW_NUMBER() OVER (
            PARTITION BY cm.contract_address
            ORDER BY cm.is_self_destruct ASC, cm.created_time DESC
        ) AS metadata_rank                                      -- 同地址优先最新非自毁记录
    FROM contracts.contract_mapping cm
    INNER JOIN top20_addresses t
        ON cm.contract_address = t.beneficiary_address
        -- 元数据查询只连接Top 20地址。
    WHERE cm.blockchain = 'polygon'
        -- 限定Polygon，避免跨链同地址混淆。
),
contract_metadata AS (
    -- 每个地址只保留一条确定性合约元数据，避免JOIN扩行。
    SELECT
        contract_address,                                       -- 合约地址
        contract_project,                                       -- Dune项目名
        contract_name,                                          -- Dune合约名
        creator_address,                                        -- 合约创建者
        created_time,                                           -- 合约创建时间
        created_tx_hash,                                        -- 合约创建交易
        code_hex,                                                -- 运行时代码
        is_self_destruct                                         -- 自毁标记
    FROM contract_metadata_ranked
    WHERE metadata_rank = 1
        -- 每地址只保留一条元数据。
),
label_metadata_ranked AS (
    -- 读取Top 20地址的Dune owner label；标签不能单独证明最终控制人。
    SELECT
        l.address,                                               -- 标签地址
        NULLIF(
            CONCAT_WS(
                ' | ',
                NULLIF(l.owner_key, ''),
                NULLIF(l.custody_owner, ''),
                NULLIF(l.account_owner, ''),
                NULLIF(l.contract_name, '')
            ),
            ''
        ) AS dune_owner_label,                                   -- 非空Dune命名字段拼接
        l.eoa AS dune_eoa_hint,                                  -- Dune EOA提示
        l.source AS dune_label_source,                            -- 标签来源
        ROW_NUMBER() OVER (
            PARTITION BY l.address
            ORDER BY
                CASE WHEN l.account_owner IS NOT NULL THEN 0 ELSE 1 END,
                l.updated_at DESC,
                l.created_at DESC
        ) AS label_rank                                          -- 有owner且最新标签优先
    FROM labels.owner_addresses l
    INNER JOIN top20_addresses t
        ON l.address = t.beneficiary_address
        -- 标签查询严格限制Top 20。
    WHERE l.blockchain = 'polygon'
        -- 限定Polygon标签。
),
label_metadata AS (
    -- 每个地址只保留一条Dune辅助标签。
    SELECT
        address,                                                 -- 标签地址
        dune_owner_label,                                        -- Dune辅助标签
        dune_eoa_hint,                                           -- Dune EOA提示
        dune_label_source                                        -- Dune标签来源
    FROM label_metadata_ranked
    WHERE label_rank = 1
        -- 每地址一条，避免标签JOIN扩行。
)
SELECT
    e.beneficiary_address,                                       -- Burn.to直接接收地址
    e.beneficiary_rank,                                          -- 累计Remove DAI排名
    e.block_time,                                                 -- Burn区块时间
    e.tx_hash,                                                    -- Burn交易哈希
    e.evt_index,                                                  -- Burn日志索引
    e.tx_from,                                                    -- 外层交易发起地址
    e.sender,                                                     -- Pair.burn sender
    e.dai_removed,                                                -- 单笔移出DAI
    e.lgns_removed,                                               -- 单笔移出LGNS
    e.remove_count,                                               -- 地址累计Burn接收次数
    e.total_dai_removed,                                          -- 地址累计直接接收DAI
    e.total_lgns_removed,                                         -- 地址累计直接接收LGNS
    e.first_remove_time,                                          -- 地址首次Remove时间
    e.last_remove_time,                                           -- 地址最后Remove时间
    c.contract_address IS NOT NULL AS has_contract_creation,      -- 是否有Dune合约创建记录
    c.contract_project,                                           -- Dune合约项目名
    c.contract_name,                                              -- Dune合约名
    c.creator_address,                                            -- 合约创建者
    c.created_time,                                               -- 合约创建时间
    c.created_tx_hash,                                            -- 合约创建交易
    c.code_hex,                                                   -- 运行时代码十六进制
    c.is_self_destruct,                                           -- Dune自毁标记
    l.dune_owner_label,                                           -- Dune辅助owner label
    l.dune_eoa_hint,                                              -- Dune辅助EOA提示
    l.dune_label_source                                           -- Dune标签来源
FROM top20_events e
LEFT JOIN contract_metadata c
    ON e.beneficiary_address = c.contract_address
    -- 一对一附加合约元数据，不改变Burn事件粒度。
LEFT JOIN label_metadata l
    ON e.beneficiary_address = l.address
    -- 一对一附加Dune标签，不把标签解释为控制关系。
ORDER BY e.beneficiary_rank, e.block_time, e.evt_index
    -- 先地址排名，再事件时间和日志索引，便于审计复核。