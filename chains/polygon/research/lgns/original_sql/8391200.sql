/*
Query 12：LGNS DAI Sources and Sinks ｜ LGNS DAI资金来源与去向

目标：在固定截止 2026-08-18 09:28:58 UTC 下，以 DAI Transfer 边界为最终底账，
把每一笔系统外部 DAI 边界事件互斥归入资金来源或资金去向，并与 Query 06、Query 07 核对。

六个系统地址：
1) LGNS      0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
2) sLGNS     0x99a57e6c8558bc6689f894e068733adf83c19725
3) Staking   0x1964ca90474b11ffd08af387b110ba6c96251bfc
4) Treasury  0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321
5) Turbine   0x07ff4e06865de4934409aa6ecea503b08cc1c78d
6) Pair       0x882df4b0fb50a229c3b4124eb18c759911485bfb

精度与限制：
- DAI 为 18 decimals；上游底账已经把原始整数除以 1e18，并沿用 Query 06/07 的 DOUBLE 口径。
- 本查询衡量链上直接边界流量，不推断最终受益人、地址控制权或链下现金价值。
- Pair 的非 Mint/Burn DAI 净流量已经由 Query 06 验证为 Swap Net Flow，历史完整月残差仅作 QA。
- 为保持精确截止，2026-08 使用固定截止底账，不直接采用 Query 06/07 在 2026-08-20 的动态尾部。
*/

WITH
/* CTE 1：把 Pair DAI边界总量与 decoded Mint/Burn精确金额结合，校正交易级模糊归类。 */
pair_monthly AS (
    SELECT
        p.month,                                                     -- 月份。
        COALESCE(x.exact_liquidity_add_dai, 0e0)
            AS liquidity_add_dai,                                    -- Source A：精确 Mint.amount0，不取同交易全部DAI流入。
        COALESCE(x.exact_liquidity_remove_dai, 0e0)
            AS liquidity_remove_dai,                                 -- Sink B：精确 Burn.amount0，与修正Query 09一致。
        p.liquidity_add_dai + p.pair_residual_in_dai
          - COALESCE(x.exact_liquidity_add_dai, 0e0)
            AS pair_residual_in_dai,                                 -- Pair外部总流入减精确Mint；保持DAI边界总额守恒。
        p.liquidity_remove_dai + p.pair_residual_out_dai
          - COALESCE(x.exact_liquidity_remove_dai, 0e0)
            AS pair_residual_out_dai,                                -- Pair外部总流出减精确Burn；其净额进入Swap Payout分类。
        p.pair_internal_dai,                                         -- Pair与其他五个系统地址之间的内部DAI流转。
        p.pair_external_event_count,                                 -- Pair外部边界DAI Transfer事件数。
        p.pair_classified_event_count,                               -- Pair已分类外部事件数。
        p.classification_event_gap,                                  -- Pair分类数量缺口。
        p.duplicate_event_rows + COALESCE(x.duplicate_event_rows, 0)
            AS duplicate_event_rows                                 -- DAI边界与精确Mint/Burn重复键QA合计。
    FROM dune.slowmoonship.result_lgns_pair_dai_boundary_monthly p   -- 固定截止Pair DAI边界总量。
    LEFT JOIN dune.slowmoonship.result_lgns_pair_exact_liquidity_monthly x
        ON p.month = x.month                                         -- JOIN：同月接入精确Mint/Burn金额；不按交易扩行。
),

/* CTE 2：读取已固化的五个非 Pair 核心地址月度 DAI 边界底账。 */
core_monthly AS (
    SELECT
        month,                                                       -- 月份。
        treasury_external_inflow_dai,                                -- 外部地址直接输入 Treasury 的 DAI。
        other_core_external_inflow_dai,                              -- 外部地址输入其他四个核心合约的 DAI。
        treasury_external_outflow_dai,                               -- Treasury 直接输出到系统外的 DAI。
        other_core_external_outflow_dai,                             -- 其他四个核心合约输出到系统外的 DAI。
        nonpair_internal_dai,                                        -- 六地址之间、至少触及非 Pair 核心地址的内部 DAI。
        unclassified_dai,                                            -- 防御性未分类金额；应为 0。
        nonpair_external_event_count,                                -- 非 Pair 核心地址外部边界事件数。
        nonpair_classified_event_count,                              -- 非 Pair 核心地址已分类外部事件数。
        classification_event_gap,                                    -- 非 Pair 分类数量缺口。
        duplicate_event_rows                                         -- 非 Pair 重复唯一键行数。
    FROM dune.slowmoonship.result_lgns_core_dai_boundary_monthly     -- 复用固定截止月度物化结果。
),

/* CTE 3：保存已核验的 Query 07 动态尾部常量；避免运行时重新触发其全历史扫描。 */
reference_constants AS (
    SELECT
        83351937.56024164e0 AS q07_published_net_dai,                -- Query 07截至2026-08-20动态尾部的累计外部DAI净额。
        DATE '2026-08-20' AS q07_published_end_date                  -- Query 07已发布结果的最后日期。
),

/* CTE 5：合并两张底账的月份全集，防止某侧无事件的月份丢失。 */
months AS (
    SELECT month FROM pair_monthly                                   -- Pair 有事件的月份。
    UNION
    SELECT month FROM core_monthly                                   -- 非 Pair 核心地址有事件的月份。
),

/* CTE 6：按月份横向合并 Pair 与其他核心地址底账；缺失金额和计数统一补 0。 */
combined AS (
    SELECT
        m.month,                                                     -- 月份。
        COALESCE(p.liquidity_add_dai, 0e0) AS liquidity_add_dai,     -- Source A：Add Liquidity DAI。
        COALESCE(p.liquidity_remove_dai, 0e0) AS liquidity_remove_dai, -- Sink B：Remove Liquidity DAI。
        COALESCE(p.pair_residual_in_dai, 0e0) AS pair_residual_in_dai, -- Pair 非流动性外部流入。
        COALESCE(p.pair_residual_out_dai, 0e0) AS pair_residual_out_dai, -- Pair 非流动性外部流出。
        COALESCE(c.treasury_external_inflow_dai, 0e0)
            AS treasury_external_inflow_dai,                         -- Source B：Treasury 外部流入。
        COALESCE(c.other_core_external_inflow_dai, 0e0)
            AS other_core_external_inflow_dai,                       -- Source C：其他核心合约外部流入。
        COALESCE(c.treasury_external_outflow_dai, 0e0)
            AS treasury_external_outflow_dai,                        -- Sink C：Treasury 外部流出。
        COALESCE(c.other_core_external_outflow_dai, 0e0)
            AS other_core_external_outflow_dai,                      -- Sink D：其他核心合约外部流出。
        COALESCE(c.unclassified_dai, 0e0) AS core_unclassified_dai,  -- 非 Pair 防御性未分类金额；应为 0。
        COALESCE(p.pair_internal_dai, 0e0)
          + COALESCE(c.nonpair_internal_dai, 0e0) AS internal_dai,   -- 六地址内部流转；不计 Sources/Sinks。
        COALESCE(p.classification_event_gap, 0)
          + COALESCE(c.classification_event_gap, 0)
            AS classification_event_gap,                             -- 两张底账分类数量缺口合计。
        COALESCE(p.duplicate_event_rows, 0)
          + COALESCE(c.duplicate_event_rows, 0)
            AS duplicate_event_rows,                                -- 两张底账重复唯一键行数合计。
        COALESCE(p.pair_external_event_count, 0)
          + COALESCE(c.nonpair_external_event_count, 0)
            AS external_event_count,                                -- 六地址去重边界的外部事件数。
        COALESCE(p.pair_classified_event_count, 0)
          + COALESCE(c.nonpair_classified_event_count, 0)
            AS classified_event_count                               -- 六地址已互斥分类的外部事件数。
    FROM months m                                                    -- 月份主表。
    LEFT JOIN pair_monthly p
        ON m.month = p.month                                         -- JOIN：按同月连接 Pair 底账。
    LEFT JOIN core_monthly c
        ON m.month = c.month                                         -- JOIN：按同月连接其他核心地址底账。
),

/* CTE 7：把 Pair 非 Mint/Burn 的净流量映射到互斥 Source/Sink 类别。 */
economic_classes AS (
    SELECT
        c.*,                                                         -- 继承所有基础分类与 QA 字段。
        c.pair_residual_in_dai - c.pair_residual_out_dai
            AS pair_swap_net_dai,                                   -- Query 06语义：正值为Pair净吸收DAI，负值为Pair净支付DAI。
        GREATEST(c.pair_residual_in_dai - c.pair_residual_out_dai, 0e0)
            AS other_unclassified_inflow_dai,                        -- Source D：Pair Swap净流量为正时的外部净输入。
        GREATEST(c.pair_residual_out_dai - c.pair_residual_in_dai, 0e0)
            AS swap_payout_dai,                                      -- Sink A：Pair Swap净流量为负时的DAI净支付，不用gross卖出量。
        0e0 AS other_unclassified_outflow_dai                        -- Sink E：独立未分类流出；当前底账未发现需从Swap净支付中拆出的金额。
    FROM combined c                                                  -- 每个外部边界事件已在上游互斥归类。
),

/* CTE 8：计算每月来源、去向、净留存与底账守恒差异。 */
monthly_math AS (
    SELECT
        e.month,                                                     -- 月份。
        e.liquidity_add_dai,                                         -- Source A：流动性添加。
        e.treasury_external_inflow_dai,                              -- Source B：Treasury外部流入。
        e.other_core_external_inflow_dai,                            -- Source C：其他核心外部流入。
        e.other_unclassified_inflow_dai,                             -- Source D：其他/未分类净流入。
        e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          + e.other_unclassified_inflow_dai
            AS other_external_inflow_dai,                           -- 图表合并口径：除流动性添加外的全部外部来源。
        e.liquidity_add_dai
          + e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          + e.other_unclassified_inflow_dai
            AS total_sources_dai,                                   -- 月度 Sources 总额。
        e.swap_payout_dai,                                           -- Sink A：Swap DAI净支付。
        e.liquidity_remove_dai,                                      -- Sink B：流动性移除。
        e.treasury_external_outflow_dai,                             -- Sink C：Treasury外部流出。
        e.other_core_external_outflow_dai,                           -- Sink D：其他核心外部流出。
        e.other_unclassified_outflow_dai,                            -- Sink E：其他/未分类流出。
        e.treasury_external_outflow_dai
          + e.other_core_external_outflow_dai
          + e.other_unclassified_outflow_dai
            AS other_external_outflow_dai,                          -- 图表合并口径：除Swap和撤池外的全部外部去向。
        e.swap_payout_dai
          + e.liquidity_remove_dai
          + e.treasury_external_outflow_dai
          + e.other_core_external_outflow_dai
          + e.other_unclassified_outflow_dai
            AS total_sinks_dai,                                     -- 月度 Sinks 总额。
        e.liquidity_add_dai
          + e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          + e.other_unclassified_inflow_dai
          - e.swap_payout_dai
          - e.liquidity_remove_dai
          - e.treasury_external_outflow_dai
          - e.other_core_external_outflow_dai
          - e.other_unclassified_outflow_dai
            AS net_dai_retained,                                    -- 月度净留存：Sources - Sinks。
        e.liquidity_add_dai
          + e.pair_residual_in_dai
          + e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          - e.liquidity_remove_dai
          - e.pair_residual_out_dai
          - e.treasury_external_outflow_dai
          - e.other_core_external_outflow_dai
            AS ledger_net_external_dai,                             -- DAI Transfer边界底账净额，等价Query 07定义。
        (
            e.liquidity_add_dai
          + e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          + e.other_unclassified_inflow_dai
          - e.swap_payout_dai
          - e.liquidity_remove_dai
          - e.treasury_external_outflow_dai
          - e.other_core_external_outflow_dai
          - e.other_unclassified_outflow_dai
        ) - (
            e.liquidity_add_dai
          + e.pair_residual_in_dai
          + e.treasury_external_inflow_dai
          + e.other_core_external_inflow_dai
          - e.liquidity_remove_dai
          - e.pair_residual_out_dai
          - e.treasury_external_outflow_dai
          - e.other_core_external_outflow_dai
        ) AS reconciliation_gap,                                    -- 分类净额减底账净额；浮点误差外应为0。
        e.pair_swap_net_dai,                                         -- Pair非流动性净流量。
        e.internal_dai,                                              -- 系统内部DAI流转，不计外部净额。
        e.classification_event_gap,                                  -- 分类事件数量缺口。
        e.duplicate_event_rows,                                      -- 重复唯一键行数。
        e.external_event_count,                                      -- 外部边界事件总数。
        e.classified_event_count                                     -- 已分类外部事件总数。
    FROM economic_classes e                                          -- 复用互斥经济类别。
),

/* CTE 9：加入 Query 06 完整月份参考值并计算累计 Sources/Sinks/Net。 */
monthly_cumulative AS (
    SELECT
        m.*,                                                         -- 继承月度金额和 QA。
        SUM(m.total_sources_dai) OVER (
            ORDER BY m.month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_sources,                                    -- 截至当月累计 Sources。
        SUM(m.total_sinks_dai) OVER (
            ORDER BY m.month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_sinks,                                      -- 截至当月累计 Sinks。
        SUM(m.net_dai_retained) OVER (
            ORDER BY m.month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_net_retained                                -- 截至当月累计净留存。
    FROM monthly_math m                                              -- 最终月度经济分类；Query 06语义核验已在独立查询完成。
),

/* CTE 10：计算固定截止全历史总额与全局 QA，供每行重复展示和 Counter 使用。 */
global_totals AS (
    SELECT
        SUM(total_sources_dai) AS total_sources_all_dai,             -- 固定截止全历史 Sources。
        SUM(total_sinks_dai) AS total_sinks_all_dai,                 -- 固定截止全历史 Sinks。
        SUM(net_dai_retained) AS net_retained_all_dai,               -- 固定截止全历史净留存。
        SUM(liquidity_add_dai) AS liquidity_add_all_dai,             -- 固定截止全部 Add Liquidity。
        SUM(other_external_inflow_dai) AS other_external_inflow_all_dai, -- 固定截止其他外部流入。
        SUM(swap_payout_dai) AS swap_payout_all_dai,                 -- 固定截止全部 Swap净支付。
        SUM(liquidity_remove_dai) AS liquidity_remove_all_dai,       -- 固定截止全部 Remove Liquidity。
        SUM(other_external_outflow_dai) AS other_external_outflow_all_dai, -- 固定截止其他外部流出。
        SUM(treasury_external_inflow_dai) AS treasury_external_inflow_all_dai, -- Treasury外部流入总额。
        SUM(other_core_external_inflow_dai) AS other_core_external_inflow_all_dai, -- 其他核心外部流入总额。
        SUM(other_unclassified_inflow_dai) AS other_unclassified_inflow_all_dai, -- 其他/未分类流入总额。
        SUM(treasury_external_outflow_dai) AS treasury_external_outflow_all_dai, -- Treasury外部流出总额。
        SUM(other_core_external_outflow_dai) AS other_core_external_outflow_all_dai, -- 其他核心外部流出总额。
        SUM(other_unclassified_outflow_dai) AS other_unclassified_outflow_all_dai, -- 其他/未分类流出总额。
        SUM(ledger_net_external_dai) AS query07_same_cutoff_net_dai, -- 固定截止、与Query 07同定义的外部净额。
        SUM(reconciliation_gap) AS reconciliation_gap_all_dai,       -- 全历史分类守恒差异。
        SUM(classification_event_gap) AS classification_event_gap_all, -- 全历史分类事件缺口。
        SUM(duplicate_event_rows) AS duplicate_event_rows_all        -- 全历史重复事件行数。
    FROM monthly_cumulative                                          -- 30个月的最终结果。
)

/* 最终 SELECT：30个月月度结果、累计值、全局核对值与可视化专用字段。 */
SELECT
    m.month,                                                         -- 月份。
    m.liquidity_add_dai,                                             -- 月度 Liquidity Addition。
    m.treasury_external_inflow_dai,                                  -- 月度 External Transfer to Treasury。
    m.other_core_external_inflow_dai,                                -- 月度 External Transfer to Other Core Contracts。
    m.other_unclassified_inflow_dai,                                 -- 月度 Other / Unclassified Inflow。
    m.other_external_inflow_dai,                                    -- 月度其他外部流入合计。
    m.total_sources_dai,                                             -- 月度 Sources 合计。
    m.swap_payout_dai,                                               -- 月度 Swap Payout净额。
    m.liquidity_remove_dai,                                          -- 月度 Liquidity Removal。
    m.treasury_external_outflow_dai,                                 -- 月度 Treasury External Outflow。
    m.other_core_external_outflow_dai,                               -- 月度 Other Core Contract External Outflow。
    m.other_unclassified_outflow_dai,                                -- 月度 Other / Unclassified Outflow。
    m.other_external_outflow_dai,                                   -- 月度其他外部流出合计。
    m.total_sinks_dai,                                               -- 月度 Sinks 合计。
    m.net_dai_retained,                                              -- 月度净留存。
    m.cumulative_sources,                                            -- 累计 Sources。
    m.cumulative_sinks,                                              -- 累计 Sinks。
    m.cumulative_net_retained,                                       -- 累计净留存。
    m.ledger_net_external_dai,                                       -- 月度Query 07同定义边界净额。
    m.reconciliation_gap,                                            -- 月度分类守恒差异。
    m.pair_swap_net_dai,                                             -- 月度Pair Swap Net口径。
    m.internal_dai,                                                  -- 月度系统内部转账。
    m.classification_event_gap,                                      -- 月度分类事件缺口。
    m.duplicate_event_rows,                                          -- 月度重复事件行数。
    m.external_event_count,                                          -- 月度外部边界事件数。
    m.classified_event_count,                                        -- 月度已分类事件数。
    g.total_sources_all_dai,                                         -- 固定截止全历史 Sources。
    g.total_sinks_all_dai,                                           -- 固定截止全历史 Sinks。
    g.net_retained_all_dai,                                          -- 固定截止全历史净留存。
    g.liquidity_add_all_dai,                                         -- 固定截止全部流动性添加。
    g.other_external_inflow_all_dai,                                 -- 固定截止全部其他外部流入。
    g.swap_payout_all_dai,                                           -- 固定截止全部Swap净支付。
    g.liquidity_remove_all_dai,                                      -- 固定截止全部流动性移除。
    g.other_external_outflow_all_dai,                                -- 固定截止全部其他外部流出。
    g.treasury_external_inflow_all_dai,                              -- Treasury外部流入总额。
    g.other_core_external_inflow_all_dai,                            -- 其他核心外部流入总额。
    g.other_unclassified_inflow_all_dai,                             -- 其他/未分类流入总额。
    g.treasury_external_outflow_all_dai,                             -- Treasury外部流出总额。
    g.other_core_external_outflow_all_dai,                           -- 其他核心外部流出总额。
    g.other_unclassified_outflow_all_dai,                            -- 其他/未分类流出总额。
    g.query07_same_cutoff_net_dai,                                   -- 固定截止Query 07同定义净额。
    r.q07_published_net_dai,                                        -- Query 07动态截止已发布净额。
    r.q07_published_end_date,                                       -- Query 07已发布尾部日期。
    g.query07_same_cutoff_net_dai - r.q07_published_net_dai
        AS difference_vs_query07_published_dai,                      -- 固定截止与已发布动态截止差异。
    g.reconciliation_gap_all_dai,                                    -- 全历史分类守恒差异。
    g.classification_event_gap_all,                                  -- 全历史分类事件缺口。
    g.duplicate_event_rows_all,                                      -- 全历史重复事件行数。
    m.liquidity_add_dai AS chart_liquidity_add_dai,                  -- 图表正值系列：Liquidity Addition。
    m.other_external_inflow_dai AS chart_other_external_inflow_dai,  -- 图表正值系列：Other External Inflow。
    -m.swap_payout_dai AS chart_swap_payout_dai,                     -- 图表负值系列：Swap Payout。
    -m.liquidity_remove_dai AS chart_liquidity_remove_dai,           -- 图表负值系列：Liquidity Removal。
    -m.other_external_outflow_dai AS chart_other_external_outflow_dai, -- 图表负值系列：Other External Outflow。
    g.net_retained_all_dai AS chart_final_net_retained               -- Counter字段：固定截止外部DAI净留存。
FROM monthly_cumulative m                                            -- 月度主结果。
CROSS JOIN global_totals g                                           -- JOIN：全局总额重复到每月，便于视觉组件与核验。
CROSS JOIN reference_constants r                                    -- JOIN：附加已核验Query 07动态截止常量。
ORDER BY m.month ASC                                                 -- 时间升序，保证累计图和柱图顺序稳定。