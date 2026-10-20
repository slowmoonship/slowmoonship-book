/*
LGNS Realizable Exit Value ｜ LGNS真实可兑现退出价值
检索日期：2026-08-20；统一截止：2026-08-18 09:28:58 UTC。

模型和证据：
1. 静态质押余额复用Query 08（8389804）与sLGNS index；
2. 日级储备由Q01/Q02事件净流量重建，并以Q06五个DAI Sync样本验证；最终日直接使用截止时刻前最后Sync；
3. PairCreated与1,185笔目标Pair Swap+Sync样本确认QuickSwap V2常数乘积模型；
4. 样本全部匹配amountIn*997公式，因此AMM swap fee=0.3%；
5. LGNS已验证源码初始feeRatio=5000、PRECISION=100000；
   截止日前FeeRatioChanged中卖出费率变更数为0，因此研究期卖出费可完整重建为5%；
6. AMM Only假设全部理论LGNS进入Pair；Fee Adjusted先扣5% LGNS卖出费，再进入AMM；
7. 这是同一时点一次性卖出的理论报价，不含钱包Gas、MEV、前置交易或成交失败风险。
*/

WITH constants AS (
    -- 集中定义固定截止、已确认费率和模型基准，避免散落魔法数字。
    SELECT
        DATE '2026-08-18' AS cutoff_date,                    -- 统一固定截止日期
        TIMESTAMP '2026-08-18 09:28:58' AS cutoff_time,      -- 统一固定截止时刻
        0.003e0 AS amm_fee_rate,                             -- 目标Pair实证确认AMM费率0.3%
        0.05e0 AS token_sell_fee_rate,                       -- LGNS全研究期确认卖出费5%
        1000e0 AS base_initial_capital_dai                   -- Query 08基准初始本金
),
position_inputs (initial_capital_dai) AS (
    -- 用VALUES一次构造四种初始本金，避免复制四套SQL。
    VALUES
        (1000e0),                                           -- 1,000 DAI基准仓位
        (10000e0),                                          -- 10,000 DAI仓位
        (100000e0),                                         -- 100,000 DAI仓位
        (1000000e0)                                         -- 1,000,000 DAI仓位
),
q08_history AS (
    -- 复用Query 08已经验证的历史日级价格、index与1,000 DAI理论持仓。
    SELECT
        h.date,                                             -- 历史日期
        h.lgns_price_dai,                                   -- Query 08日VWAP价格
        h.slgns_index,                                      -- 当日sLGNS index
        h.simulated_lgns_balance,                           -- 1,000 DAI模型理论LGNS数量
        h.simulated_value_dai AS mark_to_market_value_dai,  -- Query 08账面DAI价值
        h.initial_lgns_price_dai,                           -- 模型初始LGNS价格
        h.initial_lgns,                                     -- 模型初始LGNS数量
        h.initial_slgns_index                               -- 模型初始sLGNS index
    FROM query_8389804 h
    CROSS JOIN constants c
        -- constants只有一行，仅提供统一截止日期。
    WHERE h.date < c.cutoff_date
        -- 截止日前完整日直接复用；截止日由精确时刻数据重新计算。
),
initial_parameters AS (
    -- 从Query 08取唯一初始参数，作为截止日精确重算的基准。
    SELECT
        MAX(initial_lgns_price_dai) AS initial_lgns_price_dai,
                                                               -- 初始LGNS价格
        MAX(initial_lgns) AS initial_lgns,                    -- 初始LGNS数量
        MAX(initial_slgns_index) AS initial_slgns_index       -- 初始sLGNS index
    FROM q08_history
),
cutoff_price AS (
    -- 单次扫描截止日目标Pair Swap，同时计算部分日VWAP与精确双币净流量。
    SELECT
        SUM(
            CAST(w.amount0In AS DOUBLE)
            + CAST(w.amount0Out AS DOUBLE)
        ) / 1e18
        /
        NULLIF(
            SUM(
                CAST(w.amount1In AS DOUBLE)
                + CAST(w.amount1Out AS DOUBLE)
            ) / 1e9,
            0e0
        ) AS lgns_price_dai,                                  -- 截止时刻前DAI成交额/LGNS成交量
        SUM(
            CAST(w.amount0In AS DOUBLE)
            - CAST(w.amount0Out AS DOUBLE)
        ) / 1e18 AS cutoff_swap_net_dai,                      -- 截止日Pair DAI精确净流入
        SUM(
            CAST(w.amount1In AS DOUBLE)
            - CAST(w.amount1Out AS DOUBLE)
        ) / 1e9 AS cutoff_swap_net_lgns                       -- 截止日Pair LGNS精确净流入
    FROM quickswap_polygon.uniswapv2pair_evt_swap w
    CROSS JOIN constants c
        -- constants只有一行，提供精确截止时刻。
    WHERE w.evt_block_date = c.cutoff_date
        -- 单日分区裁剪，不重新扫描完整3亿Swap历史。
      AND w.evt_block_time <= c.cutoff_time
        -- 排除固定截止时刻之后的Swap。
      AND w.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只读取LGNS/DAI Pair。
),
cutoff_index AS (
    -- 复用Query 04，在固定截止时刻前选取最后一个sLGNS index。
    SELECT
        MAX_BY(r.index, r.block_time) AS slgns_index          -- 截止时刻有效sLGNS index
    FROM query_8369671 r
    CROSS JOIN constants c
        -- constants只有一行，提供截止时刻。
    WHERE r.block_time <= c.cutoff_time
        -- 排除固定截止后的Rebase。
),
cutoff_simulation AS (
    -- 用截止价格、截止index和Query 08初始参数重建固定截止日1,000 DAI模型。
    SELECT
        c.cutoff_date AS date,                               -- 固定截止日期
        p.lgns_price_dai,                                    -- 截止时刻前部分日VWAP
        i.slgns_index,                                       -- 截止时刻有效sLGNS index
        b.initial_lgns
            * i.slgns_index
            / NULLIF(b.initial_slgns_index, 0e0)
            AS simulated_lgns_balance,                       -- 1,000 DAI理论LGNS数量
        b.initial_lgns
            * i.slgns_index
            / NULLIF(b.initial_slgns_index, 0e0)
            * p.lgns_price_dai
            AS mark_to_market_value_dai,                     -- 截止时刻账面DAI价值
        b.initial_lgns_price_dai,                            -- 初始LGNS价格
        b.initial_lgns,                                      -- 初始LGNS数量
        b.initial_slgns_index                                -- 初始sLGNS index
    FROM constants c
    CROSS JOIN cutoff_price p
    CROSS JOIN cutoff_index i
    CROSS JOIN initial_parameters b
        -- 四个CTE均为单行，CROSS JOIN保持单一截止日粒度。
),
simulation_base AS (
    -- 合并截止日前完整日和精确截止日，形成1,000 DAI日级模型。
    SELECT * FROM q08_history
    UNION ALL
    SELECT * FROM cutoff_simulation
        -- 两段日期不重叠，UNION ALL不会制造重复日期。
),
liquidity_flows AS (
    -- 复用Query 01固定快照的日级Mint/Burn双币净流量，避免重扫725k事件。
    SELECT
        q.date,                                               -- 流动性事件UTC日期
        q.net_dai AS liquidity_net_dai,                       -- Add减Remove的DAI净流入
        q.net_lgns AS liquidity_net_lgns                      -- Add减Remove的LGNS净流入
    FROM query_8369227 q
    CROSS JOIN constants c
        -- constants只有一行，提供统一截止日期。
    WHERE q.date <= c.cutoff_date
        -- Query 01本身固定到09:28:58；不读取截止日之后结果。
),
swap_flows_before_cutoff AS (
    -- 复用Query 02的截止日前完整日流量；DAI净流量含全部Swap，LGNS使用已分类买卖。
    SELECT
        q.date,                                               -- Swap UTC日期
        q.net_dai_flow AS swap_net_dai,                       -- Pair DAI净流入，含other Swap
        q.sell_lgns - q.buy_lgns AS swap_net_lgns            -- Pair LGNS净流入；197条other未含双币细分
    FROM query_8369303 q
    CROSS JOIN constants c
        -- constants只有一行，提供统一截止日期。
    WHERE q.date < c.cutoff_date
        -- 截止日前完整日复用；截止日使用原始Swap精确重算。
),
daily_pair_flows AS (
    -- 合并截止日前Swap与Liquidity流量；FULL OUTER JOIN保留仅有一类事件的日期。
    SELECT
        COALESCE(s.date, l.date) AS date,                     -- 统一UTC日期
        COALESCE(s.swap_net_dai, 0e0)
            + COALESCE(l.liquidity_net_dai, 0e0)
            AS total_net_dai,                                -- Pair当日DAI总净流入
        COALESCE(s.swap_net_lgns, 0e0)
            + COALESCE(l.liquidity_net_lgns, 0e0)
            AS total_net_lgns                                -- Pair当日LGNS总净流入
    FROM swap_flows_before_cutoff s
    FULL OUTER JOIN liquidity_flows l
        ON s.date = l.date
        -- 日期是一对一日级键，不会产生多对多扩行。
    CROSS JOIN constants c
        -- constants只有一行，用于排除后续UNION的截止日。
    WHERE COALESCE(s.date, l.date) < c.cutoff_date

    UNION ALL

    -- 截止日使用Query 01固定Mint/Burn流量加原始Swap精确流量。
    SELECT
        c.cutoff_date AS date,                               -- 固定截止日期
        COALESCE(p.cutoff_swap_net_dai, 0e0)
            + COALESCE(l.liquidity_net_dai, 0e0)
            AS total_net_dai,                               -- 截止时刻前DAI总净流入
        COALESCE(p.cutoff_swap_net_lgns, 0e0)
            + COALESCE(l.liquidity_net_lgns, 0e0)
            AS total_net_lgns                               -- 截止时刻前LGNS总净流入
    FROM constants c
    CROSS JOIN cutoff_price p
        -- cutoff_price只有一行，提供截止日精确Swap净流量。
    LEFT JOIN liquidity_flows l
        ON l.date = c.cutoff_date
        -- Query 01已固定同一时刻，补入截止日Mint/Burn净流量。
),
reconstructed_reserves AS (
    -- Pair创建时储备从0开始；累计Swap+Mint-Burn净流量重建日末双币储备。
    SELECT
        date,                                                -- UTC日期
        SUM(total_net_dai) OVER (
            ORDER BY date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS reconstructed_reserve_dai,                      -- 累计流量重建DAI储备
        SUM(total_net_lgns) OVER (
            ORDER BY date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS reconstructed_reserve_lgns                     -- 累计流量重建LGNS储备
    FROM daily_pair_flows
),
cutoff_sync AS (
    -- 只读取截止日真实Sync，对最终兑现值使用直接储备并校准累计流量重建。
    SELECT
        MAX_BY(
            CAST(s.reserve0 AS DOUBLE) / 1e18,
            s.evt_block_number * 100000 + s.evt_index
        ) AS reserve_dai,                                    -- 截止时刻最后Sync的DAI储备
        MAX_BY(
            CAST(s.reserve1 AS DOUBLE) / 1e9,
            s.evt_block_number * 100000 + s.evt_index
        ) AS reserve_lgns,                                   -- 截止时刻最后Sync的LGNS储备
        MAX(s.evt_block_time) AS reserve_time                 -- 截止时刻采用的真实Sync时间
    FROM quickswap_polygon.uniswapv2pair_evt_sync s
    CROSS JOIN constants c
        -- constants只有一行，提供截止日期和时刻。
    WHERE s.evt_block_date = c.cutoff_date
        -- 只扫描一个日期分区，不再聚合全历史3亿Sync。
      AND s.evt_block_time <= c.cutoff_time
        -- 排除固定截止时刻之后的Sync。
      AND s.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只读取LGNS/DAI Pair。
),
daily_sync AS (
    -- 历史日期使用经Q06五个DAI Sync样本验证的累计流量；最终日替换为直接Sync储备。
    SELECT
        r.date,                                               -- UTC日期
        CASE WHEN r.date = c.cutoff_date
            THEN s.reserve_dai
            ELSE r.reconstructed_reserve_dai
        END AS reserve_dai,                                   -- 历史重建、最终日直接Sync的DAI储备
        CASE WHEN r.date = c.cutoff_date
            THEN s.reserve_lgns
            ELSE r.reconstructed_reserve_lgns
        END AS reserve_lgns,                                  -- 历史重建、最终日直接Sync的LGNS储备
        CASE WHEN r.date = c.cutoff_date
            THEN s.reserve_time
            ELSE CAST(NULL AS TIMESTAMP)
        END AS reserve_time                                   -- 仅最终日保留直接Sync时间
    FROM reconstructed_reserves r
    CROSS JOIN constants c
        -- constants只有一行，用于识别最终日。
    CROSS JOIN cutoff_sync s
        -- cutoff_sync只有一行，将最终真实储备应用到最终日。
),
position_days AS (
    -- 将1,000 DAI模型按初始本金线性扩展到四种仓位，并连接同日Pair储备。
    SELECT
        b.date,                                             -- 模拟日期
        p.initial_capital_dai,                              -- 初始投入DAI
        b.lgns_price_dai AS spot_price_dai,                 -- Query 08口径日VWAP现货价格
        b.slgns_index,                                      -- 当日sLGNS index
        b.simulated_lgns_balance
            * p.initial_capital_dai
            / c.base_initial_capital_dai
            AS simulated_lgns_balance,                      -- 对应本金的理论LGNS持仓
        b.mark_to_market_value_dai
            * p.initial_capital_dai
            / c.base_initial_capital_dai
            AS mark_to_market_value_dai,                    -- 对应本金的账面价值
        r.reserve_lgns,                                     -- Pair当日最后LGNS储备
        r.reserve_dai,                                      -- Pair当日最后DAI储备
        r.reserve_time,                                     -- 储备对应Sync时间
        r.reserve_dai / NULLIF(r.reserve_lgns, 0e0)
            AS reserve_spot_price_dai,                      -- Pair储备边际价格
        c.amm_fee_rate,                                     -- 已确认AMM费率
        c.token_sell_fee_rate                               -- 已确认LGNS卖出费率
    FROM simulation_base b
    CROSS JOIN position_inputs p
        -- 每个日期展开四个仓位，预期粒度=date+initial_capital_dai。
    CROSS JOIN constants c
        -- constants只有一行，提供基准本金和费率。
    JOIN daily_sync r
        ON b.date = r.date
        -- 只使用同日可验证的Pair储备；不跨日猜测储备。
),
exit_values AS (
    -- 按QuickSwap V2常数乘积公式计算AMM Only与含LGNS卖出费两套退出值。
    SELECT
        *,
        simulated_lgns_balance
            * (1e0 - token_sell_fee_rate)
            AS after_token_fee_lgns,                       -- 扣5%卖出费后实际进入Pair的LGNS
        reserve_dai
            * (
                simulated_lgns_balance
                * (1e0 - amm_fee_rate)
            )
            /
            (
                reserve_lgns
                + simulated_lgns_balance
                * (1e0 - amm_fee_rate)
            )
            AS amm_exit_value_dai,                         -- 仅AMM曲线与0.3%费后的DAI输出
        reserve_dai
            * (
                simulated_lgns_balance
                * (1e0 - token_sell_fee_rate)
                * (1e0 - amm_fee_rate)
            )
            /
            (
                reserve_lgns
                + simulated_lgns_balance
                * (1e0 - token_sell_fee_rate)
                * (1e0 - amm_fee_rate)
            )
            AS fee_adjusted_exit_value_dai                 -- 先扣LGNS 5%再扣AMM 0.3%的DAI输出
    FROM position_days
    WHERE reserve_lgns > 0e0
      AND reserve_dai > 0e0
      AND simulated_lgns_balance > 0e0
        -- 排除无储备或无持仓日期，避免不可解释的除零结果。
),
discounts AS (
    -- 计算相对账面价值的退出折价，以及仅AMM曲线导致的平均成交价冲击。
    SELECT
        *,
        1e0 - amm_exit_value_dai
            / NULLIF(mark_to_market_value_dai, 0e0)
            AS amm_exit_discount_pct,                       -- AMM Only相对账面价值折价
        1e0 - fee_adjusted_exit_value_dai
            / NULLIF(mark_to_market_value_dai, 0e0)
            AS fee_adjusted_exit_discount_pct,              -- 含5%卖出费相对账面价值折价
        1e0 - (
            amm_exit_value_dai
            / NULLIF(simulated_lgns_balance, 0e0)
        ) / NULLIF(reserve_spot_price_dai, 0e0)
            AS price_impact_pct                             -- AMM Only平均成交价相对池边际价的冲击
    FROM exit_values
),
finalized AS (
    -- 标记全模型最终日期，供最终仓位Bar和Table可视化使用。
    SELECT
        *,
        MAX(date) OVER () AS final_date                     -- 全结果固定最终日期
    FROM discounts
)
SELECT
    date,                                                   -- 日期
    initial_capital_dai,                                    -- 初始投入DAI
    simulated_lgns_balance,                                 -- 理论LGNS持仓
    spot_price_dai,                                         -- Query 08口径日VWAP现货价格
    mark_to_market_value_dai,                               -- 账面DAI价值
    reserve_lgns,                                           -- Pair LGNS储备
    reserve_dai,                                            -- Pair DAI储备
    reserve_spot_price_dai,                                 -- Pair储备边际价格
    reserve_time,                                           -- 储备对应Sync时间
    after_token_fee_lgns,                                   -- 扣LGNS卖出费后进入Pair数量
    amm_exit_value_dai,                                     -- AMM Only可兑现DAI
    fee_adjusted_exit_value_dai,                            -- 含LGNS卖出费可兑现DAI
    amm_exit_discount_pct,                                  -- AMM Only相对账面折价
    fee_adjusted_exit_discount_pct,                         -- 含卖出费相对账面折价
    price_impact_pct,                                       -- AMM Only一次性卖出价格冲击
    amm_fee_rate,                                           -- 实证确认AMM费率0.3%
    token_sell_fee_rate,                                    -- 完整重建LGNS卖出费率5%
    final_date,                                             -- 模型最终日期
    date = final_date AS is_final_date,                     -- 是否最终日期
    CASE WHEN initial_capital_dai = 1000e0
        THEN mark_to_market_value_dai END
        AS chart_1000_mark_to_market_value_dai,             -- 1,000 DAI线图账面价值
    CASE WHEN initial_capital_dai = 1000e0
        THEN amm_exit_value_dai END
        AS chart_1000_amm_exit_value_dai,                   -- 1,000 DAI线图AMM退出价值
    CASE WHEN initial_capital_dai = 1000e0
        THEN fee_adjusted_exit_value_dai END
        AS chart_1000_fee_adjusted_exit_value_dai,          -- 1,000 DAI线图含费退出价值
    CASE WHEN date = final_date
        THEN CAST(CAST(initial_capital_dai AS BIGINT) AS VARCHAR)
        END AS chart_final_position_dai,                    -- 最终仓位Bar的类别
    CASE WHEN date = final_date
        THEN fee_adjusted_exit_discount_pct END
        AS chart_final_exit_discount_pct,                   -- 最终仓位含费退出折价
    CASE WHEN date = final_date
        THEN simulated_lgns_balance END
        AS table_final_token_balance,                       -- 最终表理论LGNS余额
    CASE WHEN date = final_date
        THEN mark_to_market_value_dai END
        AS table_final_mark_to_market,                      -- 最终表账面价值
    CASE WHEN date = final_date
        THEN amm_exit_value_dai END
        AS table_final_amm_exit_value,                      -- 最终表AMM Only退出值
    CASE WHEN date = final_date
        THEN fee_adjusted_exit_value_dai END
        AS table_final_fee_adjusted_exit_value,             -- 最终表含费退出值
    CASE WHEN date = final_date
        THEN price_impact_pct END
        AS table_final_price_impact_pct                     -- 最终表AMM价格冲击
FROM finalized
ORDER BY date DESC, initial_capital_dai ASC
    -- 最终日期四个仓位排在最前，便于Final Exit Value Simulation表直接展示。
