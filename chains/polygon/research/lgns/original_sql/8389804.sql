-- Query 08：1,000 DAI 的 LGNS/sLGNS 静态质押持有人理论价值模拟
-- 模拟说明：这不是任何真实地址的账户历史，而是基于 sLGNS index/rebase 机制构建的静态质押理论余额路径。
-- 初始投入固定为 1,000 DAI；起点取“同时存在可靠 LGNS 日 VWAP 与可用 sLGNS index”的最早 UTC 日期。
-- 价格来源：复用 Query 02 的每日 buy/sell 已分类成交，日 VWAP = 双向 DAI 成交额 / 双向 LGNS 成交量。
-- 不使用每日最后一笔极小 Swap；197 笔 unclassified Swap 不参与价格，避免对无法严格定向的事件强行定价。
-- 数量来源：复用 Query 04 的 LogRebase index；事件没有 rebase_amount，因此不构造不存在的实际增发数量。
-- decimals：Query 02 已按 DAI/LGNS decimals 缩放，Query 04 已按 sLGNS decimals 缩放 index；本 Query 不重复缩放。
-- 去重：Query 02 每日一行，Query 04 先按日期取最后一个 tx/log 顺序的 index；最终以 date 为唯一键，一天一行。
-- 经济含义：simulated_value_dai 是理论代币余额乘 LGNS 日 VWAP，不是可保证成交的退出价值，也不含手续费、滑点、税费或 gas。

WITH daily_price AS (
    -- 复用 Query 02 日结果计算双向成交量加权的 LGNS/DAI 日均价格。
    SELECT
        date,                                                    -- UTC 日期
        (
            COALESCE(buy_volume_dai, 0e0)
            + COALESCE(sell_volume_dai, 0e0)
        ) / NULLIF(
            COALESCE(buy_lgns, 0e0)
            + COALESCE(sell_lgns, 0e0),
            0e0
        ) AS lgns_price_dai,                                     -- 日 VWAP：每 1 LGNS 对应 DAI
        COALESCE(buy_volume_dai, 0e0)
            + COALESCE(sell_volume_dai, 0e0) AS pricing_dai_volume, -- 用于定价的双向 DAI 成交额
        COALESCE(buy_lgns, 0e0)
            + COALESCE(sell_lgns, 0e0) AS pricing_lgns_volume,   -- 用于定价的双向 LGNS 成交量
        raw_swap_count,                                         -- Query 02 全历史 Swap 数
        unclassified_swap_count                                 -- 未纳入 VWAP 的 unclassified Swap 数
    FROM query_8369303
        -- Saved Query Result 引用避免重新扫描约 3.04 亿条 Swap。
    WHERE (
        COALESCE(buy_volume_dai, 0e0)
        + COALESCE(sell_volume_dai, 0e0)
    ) > 0e0
      AND (
        COALESCE(buy_lgns, 0e0)
        + COALESCE(sell_lgns, 0e0)
      ) > 0e0
        -- DAI 或 LGNS 成交量为零时无法形成可解释价格，故不进入模拟。
),
daily_rebase AS (
    -- Query 04 可能一天有多个 LogRebase；按区块时间与日志索引取当日最后一个有效 index。
    SELECT
        CAST(date_trunc('day', block_time) AS DATE) AS date,     -- Rebase UTC 日期
        MAX_BY(
            index,
            CAST(to_unixtime(block_time) AS BIGINT) * 1000000
                + event_index
        ) AS slgns_index,                                       -- 当日最后一个 sLGNS index
        MAX(block_time) AS day_last_rebase_time,                 -- 当日最后 Rebase 时间
        COUNT(*) AS day_rebase_count                             -- 当日 LogRebase 数
    FROM query_8369671
        -- Saved Query Result 引用避免重新扫描 polygon.logs。
    WHERE index IS NOT NULL
      AND index > 0e0
        -- index 必须为正，才能计算余额倍率。
    GROUP BY 1
),
price_with_index_event AS (
    -- 以每日价格为完整日期骨架，LEFT JOIN 同日最后一个 Rebase index。
    SELECT
        p.date,                                                  -- UTC 日期
        p.lgns_price_dai,                                        -- LGNS 日 VWAP
        p.pricing_dai_volume,                                    -- 日定价 DAI 成交额
        p.pricing_lgns_volume,                                   -- 日定价 LGNS 成交量
        r.slgns_index AS event_day_slgns_index,                  -- 当日有 Rebase 时的最后 index
        r.day_last_rebase_time,                                  -- 当日最后 Rebase 时间
        COALESCE(r.day_rebase_count, 0) AS day_rebase_count,     -- 当日 Rebase 数；无事件为 0
        p.raw_swap_count,                                        -- 全历史 Swap 数
        p.unclassified_swap_count                                -- 未分类 Swap 数
    FROM daily_price p
    LEFT JOIN daily_rebase r
        ON p.date = r.date
        -- 一日价格对一日末 index；daily_rebase 已保证 date 唯一，不会放大价格行。
),
daily_aligned AS (
    -- 对无 Rebase 的日期以前一可用 index 前向填充；价格仍使用该日自身 VWAP。
    SELECT
        date,                                                    -- UTC 日期
        lgns_price_dai,                                          -- 当日 LGNS/DAI VWAP
        pricing_dai_volume,                                      -- 当日定价 DAI 成交额
        pricing_lgns_volume,                                     -- 当日定价 LGNS 成交量
        LAST_VALUE(event_day_slgns_index) IGNORE NULLS OVER (
            ORDER BY date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS slgns_index,                                       -- 截至当日最新可用 sLGNS index
        day_last_rebase_time,                                    -- 当日最后 Rebase 时间；无事件为空
        day_rebase_count,                                        -- 当日 Rebase 数
        raw_swap_count,                                          -- 全历史 Swap 数
        unclassified_swap_count                                  -- 未分类 Swap 数
    FROM price_with_index_event
),
initial_values AS (
    -- 找到价格与 index 同时可用的最早日期，并固定 1,000 DAI 模拟初值。
    SELECT
        MIN(date) AS simulation_start,                           -- 实际模拟起点
        MIN_BY(lgns_price_dai, date) AS initial_lgns_price_dai,  -- 起点 LGNS 日 VWAP
        MIN_BY(slgns_index, date) AS initial_slgns_index,        -- 起点可用 sLGNS index
        1000e0 AS initial_investment_dai                         -- 固定初始投入
    FROM daily_aligned
    WHERE lgns_price_dai > 0e0
      AND slgns_index > 0e0
        -- 只有价格和 index 同时为正才具备模拟定义。
),
simulation_base AS (
    -- 按 index 比率计算理论余额，并按当日 VWAP 计算 DAI 价值。
    SELECT
        d.date,                                                  -- UTC 日期
        d.lgns_price_dai,                                        -- 当日 LGNS 日 VWAP
        d.slgns_index,                                           -- 截至当日最新 sLGNS index
        d.slgns_index / i.initial_slgns_index
            AS balance_multiplier,                              -- 数量倍率=current index / initial index
        i.initial_investment_dai / i.initial_lgns_price_dai
            AS initial_lgns,                                    -- 起点 1,000 DAI 可买入的理论 LGNS 数量
        (
            i.initial_investment_dai / i.initial_lgns_price_dai
        ) * (
            d.slgns_index / i.initial_slgns_index
        ) AS simulated_lgns_balance,                            -- 静态质押理论 LGNS 等值余额
        (
            i.initial_investment_dai / i.initial_lgns_price_dai
        ) * (
            d.slgns_index / i.initial_slgns_index
        ) * d.lgns_price_dai AS simulated_value_dai,            -- 理论余额按当日 VWAP 计价的 DAI 价值
        d.pricing_dai_volume,                                    -- 当日用于定价的 DAI 成交额
        d.pricing_lgns_volume,                                   -- 当日用于定价的 LGNS 成交量
        d.day_last_rebase_time,                                  -- 当日最后 Rebase 时间
        d.day_rebase_count,                                      -- 当日 Rebase 数
        i.simulation_start,                                      -- 模拟起点
        i.initial_investment_dai,                                -- 初始投入 DAI
        i.initial_lgns_price_dai,                                -- 初始 LGNS 价格
        i.initial_slgns_index,                                   -- 初始 sLGNS index
        d.raw_swap_count,                                        -- 全历史 Swap 数
        d.unclassified_swap_count                                -- 未参与价格的 Swap 数
    FROM daily_aligned d
    CROSS JOIN initial_values i
        -- initial_values 只有一行，将同一模拟基准应用到所有日期。
    WHERE d.date >= i.simulation_start
      AND d.lgns_price_dai > 0e0
      AND d.slgns_index > 0e0
        -- 起点后仍要求价格和 index 可用，防止空值被误当收益。
)
SELECT
    date,                                                        -- UTC 日期
    lgns_price_dai,                                              -- LGNS 日 VWAP（DAI/LGNS）
    slgns_index,                                                 -- 截至当日最新 sLGNS index
    balance_multiplier,                                         -- 理论余额倍率
    simulated_lgns_balance,                                      -- 理论 LGNS 等值余额
    simulated_value_dai,                                         -- 理论 DAI 价值
    (balance_multiplier - 1e0) * 100e0
        AS token_balance_return_pct,                             -- 相对起点的代币数量增长率（%）
    (simulated_value_dai / initial_investment_dai - 1e0) * 100e0
        AS dai_value_return_pct,                                 -- 相对 1,000 DAI 的价值收益率（%）
    balance_multiplier * 100e0 AS token_balance_index,           -- 起点=100 的代币数量指数
    simulated_value_dai / initial_investment_dai * 100e0
        AS dai_value_index,                                      -- 起点=100 的 DAI 价值指数
    lgns_price_dai / initial_lgns_price_dai * 100e0
        AS price_index,                                          -- 起点=100 的 LGNS 价格指数
    simulation_start,                                            -- 实际模拟起始日期
    initial_investment_dai,                                      -- 固定初始投入 1,000 DAI
    initial_lgns_price_dai,                                      -- 起点 LGNS 日 VWAP
    initial_lgns,                                                -- 起点理论 LGNS 数量
    initial_slgns_index,                                         -- 起点 sLGNS index
    pricing_dai_volume,                                          -- 当日定价 DAI 成交额
    pricing_lgns_volume,                                         -- 当日定价 LGNS 成交量
    day_last_rebase_time,                                        -- 当日最后 Rebase 时间
    day_rebase_count,                                            -- 当日 Rebase 条数
    raw_swap_count,                                              -- Query 02 全历史 Swap 数
    unclassified_swap_count                                      -- 未参与 VWAP 的 unclassified Swap 数
FROM simulation_base
ORDER BY date ASC
    -- 日期升序，用于数量/价值标准化折线图和价格指数图。