-- Query 11：Top 20 LGNS/DAI流动性移除直接接收地址的类型、Burn调用来源与DAI第一跳时间关联
-- 固定截止：2026-08-18 09:28:58 UTC；Burn与第一跳底表使用无定时刷新的已核验Dune物化结果。
-- Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；QuickSwap V2 Router：0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff。
-- DAI：Polygon DAI 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063，decimals=18；decoded value除以1e18。
-- 地址归因：beneficiary_address只是Burn.to直接接收地址；Dune label、创建者和调用者均不等于最终控制人。
-- 第一跳口径：每笔DAI转出只关联到同地址此前7天内时间最近的一笔Burn，防止同一转出重复匹配多笔Burn。
-- 局限：ERC20余额可替代，24小时/7天是时间关联而非UTXO级追踪；截止前不足完整窗口的晚近Burn会标记右删失。
-- proxy口径：只确认EIP-1167最小代理字节码或Dune名称中的proxy线索；“未确认”不等于证明不存在代理。

WITH burn_base AS (
    -- 读取Query 11辅助底表的Top 20逐笔Burn和地址元数据，避免主Query重复做复杂元数据扫描。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        beneficiary_rank,                                       -- 累计Remove DAI排名
        block_time,                                              -- Burn区块时间
        tx_hash,                                                 -- Burn交易哈希
        evt_index,                                               -- Burn日志索引
        tx_from,                                                 -- 外层交易发起地址
        sender,                                                  -- Pair.burn sender
        dai_removed,                                             -- 单笔移出DAI
        lgns_removed,                                            -- 单笔移出LGNS
        remove_count,                                            -- 地址累计Burn接收次数
        total_dai_removed,                                       -- 地址累计直接接收DAI
        total_lgns_removed,                                      -- 地址累计直接接收LGNS
        first_remove_time,                                       -- 地址首次Remove时间
        last_remove_time,                                        -- 地址最后Remove时间
        has_contract_creation,                                   -- 是否有Dune合约创建记录
        contract_project,                                        -- Dune项目名
        contract_name,                                           -- Dune合约名
        creator_address,                                         -- 合约创建者
        code_hex,                                                 -- 合约运行时代码
        dune_owner_label,                                        -- Dune辅助owner label
        dune_eoa_hint,                                           -- Dune辅助EOA提示
        dune_label_source                                        -- Dune标签来源
    FROM dune.slowmoonship.result_lgns_top20_burn_attribution_base
        -- Saved Query Result共8,568条Top 20 Burn，不扫描底层Mint/Burn。
),
address_base AS (
    -- 按地址压缩逐事件字段，每个Top remover只保留一行确定性元数据。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        MIN(beneficiary_rank) AS beneficiary_rank,              -- 地址排名
        MAX(remove_count) AS remove_count,                       -- Burn接收次数
        MAX(total_dai_removed) AS total_dai_removed,             -- 累计直接接收DAI
        MAX(total_lgns_removed) AS total_lgns_removed,           -- 累计直接接收LGNS
        MIN(first_remove_time) AS first_remove_time,             -- 首次Remove时间
        MAX(last_remove_time) AS last_remove_time,               -- 最后Remove时间
        MAX(has_contract_creation) AS has_contract_creation,     -- 是否存在合约创建记录
        MAX_BY(contract_project, block_time) AS contract_project, -- Dune项目名
        MAX_BY(contract_name, block_time) AS contract_name,      -- Dune合约名
        MAX_BY(creator_address, block_time) AS creator_address,  -- 合约创建者
        MAX_BY(code_hex, block_time) AS code_hex,                -- 合约运行时代码
        MAX_BY(dune_owner_label, block_time) AS dune_owner_label, -- Dune辅助label
        MAX_BY(dune_eoa_hint, block_time) AS dune_eoa_hint,      -- Dune EOA提示
        MAX_BY(dune_label_source, block_time) AS dune_label_source -- Dune标签来源
    FROM burn_base
    GROUP BY 1
),
tx_from_stats AS (
    -- 按remover和Burn tx_from聚合，主要tx_from按关联Remove DAI确定。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        tx_from,                                                 -- Burn外层交易发起地址
        COUNT(*) AS burn_count,                                  -- 该tx_from关联Burn次数
        SUM(dai_removed) AS dai_removed                          -- 该tx_from关联Remove DAI
    FROM burn_base
    WHERE tx_from IS NOT NULL
        -- tx_from缺失时不补猜地址。
    GROUP BY 1, 2
),
tx_from_summary AS (
    -- 每个remover提取唯一tx_from数和按累计DAI最大的主要tx_from。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        COUNT(*) AS distinct_tx_from,                            -- 不同Burn tx_from数量
        MAX_BY(tx_from, dai_removed) AS top_tx_from,             -- 关联DAI最大的主要tx_from
        MAX(dai_removed) AS top_tx_from_dai,                     -- 主要tx_from关联DAI
        MAX_BY(burn_count, dai_removed) AS top_tx_from_burn_count -- 主要tx_from关联Burn次数
    FROM tx_from_stats
    GROUP BY 1
),
sender_stats AS (
    -- 按remover和Pair.burn sender聚合；sender可能是Router，不能替代受益地址。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        sender,                                                  -- Pair.burn sender
        COUNT(*) AS burn_count,                                  -- 该sender关联Burn次数
        SUM(dai_removed) AS dai_removed                          -- 该sender关联Remove DAI
    FROM burn_base
    WHERE sender IS NOT NULL
        -- sender缺失时不补猜。
    GROUP BY 1, 2
),
sender_summary AS (
    -- 每个remover提取按累计DAI最大的主要Pair.burn sender。
    SELECT
        beneficiary_address,                                    -- Burn.to直接接收地址
        MAX_BY(sender, dai_removed) AS top_sender,               -- 关联DAI最大的主要sender
        MAX_BY(burn_count, dai_removed) AS top_sender_burn_count -- 主要sender关联Burn次数
    FROM sender_stats
    GROUP BY 1
),
top1_caller(caller_address, call_count, first_call_time, last_call_time) AS (
    -- 复用Query 8390841已完成的固定截止核验结果，避免主Query重扫Polygon transactions。
    VALUES (
        '0x9DA64DF74565861708781B9AD2E559B7328B97C4', -- Top 1合约唯一已观察到的成功顶层调用者
        BIGINT '1262',                                           -- 固定截止前成功顶层调用次数
        TIMESTAMP '2025-08-07 17:12:47',                         -- 首次成功调用时间
        TIMESTAMP '2026-03-19 15:14:25'                          -- 最后成功调用时间
    )
),
first_hop_base AS (
    -- 读取已完成的Top 20 remover+目的地址第一跳底表；主Query不再扫描DAI Transfer。
    SELECT
        source_remover,                                         -- DAI发送端Top remover
        destination_address,                                    -- 第一跳接收地址
        transfer_count_24h,                                     -- 24小时转账事件数
        dai_sent_24h,                                            -- 24小时时间关联DAI
        transfer_count_7d,                                      -- 7天转账事件数
        dai_sent_7d                                              -- 7天时间关联DAI
    FROM dune.slowmoonship.result_lgns_top20_dai_first_hop_base
        -- Saved Query Result保证每笔DAI转出只归属此前7天内最近的一笔Burn。
),
source_first_hop AS (
    -- 每个remover确定24小时/7天金额第一目的地址，并汇总各窗口全部关联转出。
    SELECT
        source_remover,                                         -- DAI发送端Top remover
        MAX_BY(destination_address, dai_sent_24h)
            FILTER (WHERE dai_sent_24h > 0e0)
            AS top_24h_destination,                              -- 24小时主要第一跳地址
        MAX(dai_sent_24h) AS top_24h_destination_dai,            -- 24小时主要第一跳DAI
        SUM(dai_sent_24h) AS outbound_24h_dai,                   -- 24小时全部关联转出DAI
        MAX_BY(destination_address, dai_sent_7d)
            AS top_7d_destination,                               -- 7天主要第一跳地址
        MAX(dai_sent_7d) AS top_7d_destination_dai,              -- 7天主要第一跳DAI
        SUM(dai_sent_7d) AS outbound_7d_dai                      -- 7天全部关联转出DAI
    FROM first_hop_base
    GROUP BY 1
),
destination_ranked AS (
    -- 跨Top removers聚合相同目的地址，并按7天关联DAI排序；共同去向不等于共同控制。
    SELECT
        destination_address,                                    -- 第一跳目的地址
        COUNT_IF(dai_sent_24h > 0e0) AS source_remover_count_24h, -- 24小时不同来源remover数
        COUNT(*) AS source_remover_count_7d,                     -- 7天不同来源remover数
        SUM(transfer_count_24h) AS transfer_count_24h,           -- 24小时转账事件数
        SUM(transfer_count_7d) AS transfer_count_7d,             -- 7天转账事件数
        SUM(dai_sent_24h) AS dai_received_24h,                   -- 24小时关联DAI
        SUM(dai_sent_7d) AS dai_received_7d,                     -- 7天关联DAI
        ROW_NUMBER() OVER (
            ORDER BY SUM(dai_sent_7d) DESC, COUNT(*) DESC, destination_address
        ) AS destination_rank_7d                                -- 7天目的地址金额排名
    FROM first_hop_base
    GROUP BY 1
),
remover_enriched AS (
    -- 合并地址类型、Burn调用来源、Top 1全部调用者和两个第一跳窗口。
    SELECT
        a.beneficiary_address,                                  -- Burn.to直接接收地址
        a.beneficiary_rank,                                     -- 累计Remove DAI排名
        a.remove_count,                                         -- Burn接收次数
        a.total_dai_removed,                                    -- 累计直接接收DAI
        a.total_lgns_removed,                                   -- 累计直接接收LGNS
        a.first_remove_time,                                    -- 首次Remove时间
        a.last_remove_time,                                     -- 最后Remove时间
        t.distinct_tx_from,                                     -- 不同Burn tx_from数
        t.top_tx_from,                                          -- 主要Burn tx_from
        s.top_sender,                                           -- 主要Pair.burn sender
        a.has_contract_creation,                                -- 是否有合约创建记录
        a.contract_project,                                     -- Dune项目名
        a.contract_name,                                        -- Dune合约名
        a.creator_address,                                      -- 合约创建者
        a.code_hex,                                             -- 合约运行时代码
        a.dune_owner_label,                                     -- Dune辅助owner label
        a.dune_eoa_hint,                                        -- Dune EOA提示
        a.dune_label_source,                                    -- Dune标签来源
        CASE WHEN a.beneficiary_rank = 1
            THEN c.caller_address END AS top1_main_caller,      -- Top 1合约全部成功顶层调用中的主要调用者
        CASE WHEN a.beneficiary_rank = 1
            THEN c.call_count END AS top1_main_caller_count,    -- Top 1主要调用者成功调用次数
        f.top_24h_destination,                                  -- 24小时主要第一跳地址
        f.top_24h_destination_dai,                              -- 24小时主要第一跳DAI
        COALESCE(f.outbound_24h_dai, 0e0) AS outbound_24h_dai, -- 24小时全部关联转出DAI
        f.top_7d_destination,                                   -- 7天主要第一跳地址
        f.top_7d_destination_dai,                               -- 7天主要第一跳DAI
        COALESCE(f.outbound_7d_dai, 0e0) AS outbound_7d_dai    -- 7天全部关联转出DAI
    FROM address_base a
    LEFT JOIN tx_from_summary t
        ON a.beneficiary_address = t.beneficiary_address
        -- 一对一接入主要Burn tx_from统计。
    LEFT JOIN sender_summary s
        ON a.beneficiary_address = s.beneficiary_address
        -- 一对一接入主要Pair.burn sender统计。
    LEFT JOIN source_first_hop f
        ON a.beneficiary_address = f.source_remover
        -- 一对一接入24小时/7天主要第一跳和总额。
    LEFT JOIN top1_caller c
        ON a.beneficiary_rank = 1
        -- 只有Top 1地址接入其全部成功顶层调用者结果。
),
remover_classified AS (
    -- 依据已知协议地址、合约创建记录和Dune命名线索进行有限地址类型与proxy分类。
    SELECT
        r.*,
        CASE
            WHEN r.beneficiary_address = 0xa5e0829caced8ffdd4de3c43696c57f7d7a678ff
                THEN 'router'
            WHEN r.beneficiary_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
                THEN 'pair'
            WHEN r.beneficiary_address = 0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321
                THEN 'treasury'
            WHEN r.beneficiary_address = 0x1964ca90474b11ffd08af387b110ba6c96251bfc
                THEN 'staking'
            WHEN r.has_contract_creation
             AND REGEXP_LIKE(
                    LOWER(CONCAT_WS(' ', r.contract_project, r.contract_name, r.dune_owner_label)),
                    '(^|[^a-z])(safe|multisig)([^a-z]|$)'
                 )
                THEN 'multisig'
            WHEN r.has_contract_creation THEN 'contract'
            WHEN NOT r.has_contract_creation THEN 'EOA'
            ELSE 'unknown'
        END AS address_type,                                    -- 允许的地址类型分类
        CASE WHEN r.has_contract_creation THEN 'Contract'
             WHEN NOT r.has_contract_creation THEN 'EOA'
             ELSE 'Unknown' END AS contract_or_eoa,             -- 独立EOA/Contract判断
        COALESCE(
            r.dune_owner_label,
            NULLIF(CONCAT_WS(' | ', r.contract_project, r.contract_name), '')
        ) AS dune_label,                                        -- Dune辅助命名证据
        CASE
            WHEN NOT r.has_contract_creation THEN 'not_applicable_eoa'
            WHEN REGEXP_LIKE(
                    COALESCE(r.code_hex, ''),
                    '^363d3d373d3d3d363d73[0-9a-f]{40}5af43d82803e903d91602b57fd5bf3$'
                 )
                THEN 'confirmed_eip1167_minimal_proxy'
            WHEN REGEXP_LIKE(
                    LOWER(CONCAT_WS(' ', r.contract_project, r.contract_name, r.dune_owner_label)),
                    'proxy'
                 )
                THEN 'possible_proxy_by_dune_name'
            ELSE 'not_confirmed_from_available_dune_metadata'
        END AS proxy_status,                                    -- proxy核验结论与限制
        CASE
            WHEN REGEXP_LIKE(
                    COALESCE(r.code_hex, ''),
                    '^363d3d373d3d3d363d73[0-9a-f]{40}5af43d82803e903d91602b57fd5bf3$'
                 )
                THEN CONCAT('0x', SUBSTR(r.code_hex, 21, 40))
            ELSE NULL
        END AS proxy_implementation                              -- EIP-1167可直接提取的实现地址
    FROM remover_enriched r
),
quality_summary AS (
    -- 汇总Top 20中无Dune命名标签和未知类型的地址数。
    SELECT
        SUM(CASE WHEN dune_label IS NULL THEN 1 ELSE 0 END)
            AS unlabeled_address_count,                          -- 无Dune命名标签地址数
        SUM(CASE WHEN address_type = 'unknown' THEN 1 ELSE 0 END)
            AS unknown_type_count                               -- 未知类型地址数
    FROM remover_classified
),
remover_rows AS (
    -- 生成Top 20地址行及Visualization A/B所需字段。
    SELECT
        'remover' AS row_type,                                  -- 行类型：Top remover
        r.beneficiary_rank AS rank_number,                       -- Top remover排名
        CONCAT('0x', to_hex(r.beneficiary_address)) AS address, -- Burn.to直接接收地址
        r.address_type,                                         -- 地址类型
        r.dune_label,                                           -- Dune辅助label
        r.contract_or_eoa,                                      -- EOA或Contract
        CASE WHEN r.creator_address IS NOT NULL
            THEN CONCAT('0x', to_hex(r.creator_address)) END AS creator_address, -- Contract创建者
        r.proxy_status,                                         -- proxy核验状态
        r.proxy_implementation,                                 -- 最小代理实现地址
        r.remove_count,                                         -- Burn接收次数
        r.total_dai_removed,                                    -- 累计Remove DAI
        r.total_lgns_removed,                                   -- 累计Remove LGNS
        r.first_remove_time,                                    -- 首次Remove时间
        r.last_remove_time,                                     -- 最后Remove时间
        r.distinct_tx_from,                                     -- 不同Burn tx_from数
        CASE WHEN r.top_tx_from IS NOT NULL
            THEN CONCAT('0x', to_hex(r.top_tx_from)) END AS top_tx_from, -- 主要Burn tx_from
        CASE WHEN r.top_sender IS NOT NULL
            THEN CONCAT('0x', to_hex(r.top_sender)) END AS top_sender, -- 主要Pair.burn sender
        r.top1_main_caller AS main_caller,                       -- Top 1全部成功顶层交易的主要调用者
        r.top1_main_caller_count AS main_caller_call_count,      -- Top 1主要调用者调用次数
        CASE WHEN r.top_24h_destination IS NOT NULL
            THEN CONCAT('0x', to_hex(r.top_24h_destination)) END
            AS first_hop_24h_destination,                        -- 24小时主要第一跳地址
        r.top_24h_destination_dai AS first_hop_24h_destination_dai, -- 24小时主要第一跳DAI
        r.outbound_24h_dai,                                     -- 24小时全部时间关联DAI
        CASE WHEN r.top_7d_destination IS NOT NULL
            THEN CONCAT('0x', to_hex(r.top_7d_destination)) END
            AS first_hop_7d_destination,                         -- 7天主要第一跳地址
        r.top_7d_destination_dai AS first_hop_7d_destination_dai, -- 7天主要第一跳DAI
        r.outbound_7d_dai,                                      -- 7天全部时间关联DAI
        CASE WHEN r.last_remove_time <= TIMESTAMP '2026-08-17 09:28:58'
            THEN 'complete_for_latest_burn'
            ELSE 'right_censored_at_fixed_cutoff' END AS window_24h_status, -- 最新Burn的24小时窗状态
        CASE WHEN r.last_remove_time <= TIMESTAMP '2026-08-11 09:28:58'
            THEN 'complete_for_latest_burn'
            ELSE 'right_censored_at_fixed_cutoff' END AS window_7d_status, -- 最新Burn的7天窗状态
        CAST(NULL AS BIGINT) AS source_remover_count_24h,        -- remover行不适用汇聚来源数
        CAST(NULL AS BIGINT) AS source_remover_count_7d,         -- remover行不适用汇聚来源数
        CAST(NULL AS BIGINT) AS destination_transfer_count_24h,  -- remover行不适用目的地址转账数
        CAST(NULL AS BIGINT) AS destination_transfer_count_7d,   -- remover行不适用目的地址转账数
        CAST(NULL AS DOUBLE) AS destination_dai_received_24h,    -- remover行不适用目的地址DAI
        CAST(NULL AS DOUBLE) AS destination_dai_received_7d,     -- remover行不适用目的地址DAI
        CAST(NULL AS BIGINT) AS destination_rank_7d,             -- remover行不适用目的地址排名
        q.unlabeled_address_count,                               -- Top 20无Dune命名标签数
        q.unknown_type_count,                                    -- Top 20未知类型数
        CONCAT(
            'Rank ', CAST(r.beneficiary_rank AS VARCHAR), ' | ',
            SUBSTR(CONCAT('0x', to_hex(r.beneficiary_address)), 1, 10), '… | ',
            r.address_type,
            CASE WHEN r.dune_label IS NOT NULL
                THEN CONCAT(' | ', r.dune_label) ELSE '' END
        ) AS chart_remover_label,                                -- Visualization A类别，含类型/label
        r.total_dai_removed AS chart_remover_dai,                -- Visualization A累计Remove DAI
        CAST(NULL AS VARCHAR) AS chart_destination_label,        -- remover行不适用目的地址图类别
        CAST(NULL AS DOUBLE) AS chart_destination_dai            -- remover行不适用目的地址图金额
    FROM remover_classified r
    CROSS JOIN quality_summary q
        -- 单行质量汇总附到每个地址行。
),
destination_rows AS (
    -- 生成7天关联DAI前20目的地址行，包含24小时/7天共享来源数和金额。
    SELECT
        'destination' AS row_type,                               -- 行类型：第一跳目的地址
        CAST(NULL AS BIGINT) AS rank_number,                     -- destination行无remover排名
        CONCAT('0x', to_hex(d.destination_address)) AS address, -- 第一跳目的地址
        CAST(NULL AS VARCHAR) AS address_type,                    -- 本轮不扩展目的地址身份图谱
        CAST(NULL AS VARCHAR) AS dune_label,                      -- 本轮不扩展目的地址label
        CAST(NULL AS VARCHAR) AS contract_or_eoa,                 -- 本轮不扩展目的地址类型
        CAST(NULL AS VARCHAR) AS creator_address,                 -- destination行无创建者
        CAST(NULL AS VARCHAR) AS proxy_status,                    -- destination行无proxy核验
        CAST(NULL AS VARCHAR) AS proxy_implementation,            -- destination行无实现地址
        CAST(NULL AS BIGINT) AS remove_count,                     -- destination行无Burn次数
        CAST(NULL AS DOUBLE) AS total_dai_removed,                -- destination行无Remove DAI
        CAST(NULL AS DOUBLE) AS total_lgns_removed,               -- destination行无Remove LGNS
        CAST(NULL AS TIMESTAMP) AS first_remove_time,             -- destination行无首次Remove
        CAST(NULL AS TIMESTAMP) AS last_remove_time,              -- destination行无最后Remove
        CAST(NULL AS BIGINT) AS distinct_tx_from,                 -- destination行无tx_from数
        CAST(NULL AS VARCHAR) AS top_tx_from,                     -- destination行无主要tx_from
        CAST(NULL AS VARCHAR) AS top_sender,                      -- destination行无主要sender
        CAST(NULL AS VARCHAR) AS main_caller,                     -- destination行无主要调用者
        CAST(NULL AS BIGINT) AS main_caller_call_count,           -- destination行无调用次数
        CAST(NULL AS VARCHAR) AS first_hop_24h_destination,       -- destination行无地址级24h主要去向
        CAST(NULL AS DOUBLE) AS first_hop_24h_destination_dai,    -- destination行无地址级24h金额
        CAST(NULL AS DOUBLE) AS outbound_24h_dai,                 -- destination行无地址级24h总额
        CAST(NULL AS VARCHAR) AS first_hop_7d_destination,        -- destination行无地址级7d主要去向
        CAST(NULL AS DOUBLE) AS first_hop_7d_destination_dai,     -- destination行无地址级7d金额
        CAST(NULL AS DOUBLE) AS outbound_7d_dai,                  -- destination行无地址级7d总额
        CAST(NULL AS VARCHAR) AS window_24h_status,               -- destination行无24h状态
        CAST(NULL AS VARCHAR) AS window_7d_status,                -- destination行无7d状态
        d.source_remover_count_24h,                              -- 24小时不同来源remover数
        d.source_remover_count_7d,                               -- 7天不同来源remover数
        d.transfer_count_24h AS destination_transfer_count_24h,  -- 24小时第一跳转账数
        d.transfer_count_7d AS destination_transfer_count_7d,    -- 7天第一跳转账数
        d.dai_received_24h AS destination_dai_received_24h,      -- 24小时关联DAI
        d.dai_received_7d AS destination_dai_received_7d,        -- 7天关联DAI
        d.destination_rank_7d,                                  -- 7天目的地址金额排名
        q.unlabeled_address_count,                               -- Top 20无Dune命名标签数
        q.unknown_type_count,                                    -- Top 20未知类型数
        CAST(NULL AS VARCHAR) AS chart_remover_label,             -- destination行无remover图类别
        CAST(NULL AS DOUBLE) AS chart_remover_dai,                -- destination行无remover图金额
        CONCAT(
            SUBSTR(CONCAT('0x', to_hex(d.destination_address)), 1, 12), '… | ',
            CAST(d.source_remover_count_7d AS VARCHAR), ' removers'
        ) AS chart_destination_label,                            -- Visualization C类别，含7天来源数
        d.dai_received_7d AS chart_destination_dai               -- Visualization C的7天关联DAI
    FROM destination_ranked d
    CROSS JOIN quality_summary q
        -- 单行质量汇总附到目的地址行。
    WHERE d.destination_rank_7d <= 20
        -- 只输出7天金额前20目的地址，避免构建全链图谱。
)
SELECT
    row_type,                                                    -- remover或destination
    rank_number,                                                 -- Top remover排名
    address,                                                     -- remover或第一跳目的地址
    address_type,                                                -- Top remover地址类型
    dune_label,                                                  -- Dune辅助标签
    contract_or_eoa,                                             -- EOA或Contract
    creator_address,                                             -- Contract创建者
    proxy_status,                                                -- proxy核验状态
    proxy_implementation,                                       -- 可确认的最小代理实现地址
    remove_count,                                                -- Burn接收次数
    total_dai_removed,                                           -- 累计直接接收DAI
    total_lgns_removed,                                          -- 累计直接接收LGNS
    first_remove_time,                                           -- 首次Remove时间
    last_remove_time,                                            -- 最后Remove时间
    distinct_tx_from,                                            -- 不同Burn tx_from数
    top_tx_from,                                                 -- 主要Burn tx_from
    top_sender,                                                  -- 主要Pair.burn sender
    main_caller,                                                 -- Top 1合约主要直接调用者
    main_caller_call_count,                                      -- Top 1主要调用者成功调用次数
    first_hop_24h_destination,                                   -- 24小时主要第一跳地址
    first_hop_24h_destination_dai,                               -- 24小时主要第一跳DAI
    outbound_24h_dai,                                           -- 24小时全部时间关联DAI
    first_hop_7d_destination,                                    -- 7天主要第一跳地址
    first_hop_7d_destination_dai,                                -- 7天主要第一跳DAI
    outbound_7d_dai,                                            -- 7天全部时间关联DAI
    window_24h_status,                                           -- 最新Burn的24小时观察窗状态
    window_7d_status,                                            -- 最新Burn的7天观察窗状态
    source_remover_count_24h,                                   -- 24小时共同去向来源remover数
    source_remover_count_7d,                                    -- 7天共同去向来源remover数
    destination_transfer_count_24h,                             -- 24小时目的地址转账数
    destination_transfer_count_7d,                              -- 7天目的地址转账数
    destination_dai_received_24h,                               -- 24小时目的地址收到关联DAI
    destination_dai_received_7d,                                -- 7天目的地址收到关联DAI
    destination_rank_7d,                                       -- 7天目的地址金额排名
    unlabeled_address_count,                                    -- Top 20无Dune命名标签数
    unknown_type_count,                                         -- Top 20未知类型数
    chart_remover_label,                                        -- Visualization A类别
    chart_remover_dai,                                          -- Visualization A金额
    chart_destination_label,                                    -- Visualization C类别
    chart_destination_dai                                       -- Visualization C金额
FROM remover_rows
UNION ALL
SELECT
    row_type,                                                    -- destination行类型
    rank_number,                                                 -- destination行无remover排名
    address,                                                     -- 第一跳目的地址
    address_type,                                                -- destination行不扩展类型
    dune_label,                                                  -- destination行不扩展label
    contract_or_eoa,                                             -- destination行不扩展EOA/Contract
    creator_address,                                             -- destination行无创建者
    proxy_status,                                                -- destination行无proxy
    proxy_implementation,                                       -- destination行无实现地址
    remove_count,                                                -- destination行无Burn次数
    total_dai_removed,                                           -- destination行无Remove DAI
    total_lgns_removed,                                          -- destination行无Remove LGNS
    first_remove_time,                                           -- destination行无首次Remove
    last_remove_time,                                            -- destination行无最后Remove
    distinct_tx_from,                                            -- destination行无tx_from数
    top_tx_from,                                                 -- destination行无主要tx_from
    top_sender,                                                  -- destination行无主要sender
    main_caller,                                                 -- destination行无主要调用者
    main_caller_call_count,                                      -- destination行无调用次数
    first_hop_24h_destination,                                   -- destination行无地址级24h去向
    first_hop_24h_destination_dai,                               -- destination行无地址级24h金额
    outbound_24h_dai,                                           -- destination行无地址级24h总额
    first_hop_7d_destination,                                    -- destination行无地址级7d去向
    first_hop_7d_destination_dai,                                -- destination行无地址级7d金额
    outbound_7d_dai,                                            -- destination行无地址级7d总额
    window_24h_status,                                           -- destination行无24h状态
    window_7d_status,                                            -- destination行无7d状态
    source_remover_count_24h,                                   -- 24小时来源remover数
    source_remover_count_7d,                                    -- 7天来源remover数
    destination_transfer_count_24h,                             -- 24小时转账数
    destination_transfer_count_7d,                              -- 7天转账数
    destination_dai_received_24h,                               -- 24小时关联DAI
    destination_dai_received_7d,                                -- 7天关联DAI
    destination_rank_7d,                                       -- 7天目的地址排名
    unlabeled_address_count,                                    -- Top 20无Dune命名标签数
    unknown_type_count,                                         -- Top 20未知类型数
    chart_remover_label,                                        -- destination行无remover图类别
    chart_remover_dai,                                          -- destination行无remover图金额
    chart_destination_label,                                    -- Visualization C类别
    chart_destination_dai                                       -- Visualization C金额
FROM destination_rows
ORDER BY
    CASE WHEN row_type = 'remover' THEN 0 ELSE 1 END,
    COALESCE(rank_number, destination_rank_7d)
    -- 先Top remover排名，再7天目的地址排名。