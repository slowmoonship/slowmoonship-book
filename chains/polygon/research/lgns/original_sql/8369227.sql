-- Query 01：LGNS/DAI 每日添加与移除流动性
-- 数据来源：Dune 当前 Polygon QuickSwap V2 decoded Mint/Burn 事件表。
-- Pair 已确认 token0=Polygon DAI、token1=LGNS；精度从 tokens.supply_latest 动态读取。
-- Mint 是 Uniswap V2 Pair 在收到 token0/token1 后铸造 LP 的事件，因此代表 Add Liquidity。
-- Burn 是 Pair 销毁 LP 并转出 token0/token1 的事件，因此代表 Remove Liquidity。
-- decoded 事件表以交易哈希和日志索引标识原始日志；本 Query 不做会改变数量的额外去重，
-- 并在 validation 中核对重复事件键，预期 duplicate_event_rows=0。

WITH token_decimals AS (
    -- 只读取 Polygon 上 DAI 与 LGNS 两个 token 的当前元数据，避免扫描全部代币目录。
    SELECT
        MAX(CASE
            WHEN token_address = 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
            THEN decimals
        END) AS dai_decimals,       -- Polygon DAI 的精度，预期为 18
        MAX(CASE
            WHEN token_address = 0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
            THEN decimals
        END) AS lgns_decimals       -- Origin LGNS 的精度，预期为 9
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'    -- blockchain 是该表的分区字段，先限定 Polygon 以节省额度
      AND token_address IN (         -- 只保留本 Pair 的 token0 DAI 与 token1 LGNS
          0x8f3cf7ad23cd3cadbd9735aff958023239c6a063,
          0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
      )
),
pair_mint AS (
    -- 提取目标 Pair 的 Mint 事件；amount0 是 DAI 原始量，amount1 是 LGNS 原始量。
    SELECT
        evt_block_time AS block_time,       -- Mint 事件区块时间
        evt_block_number AS block_number,   -- Mint 事件区块号
        evt_tx_hash AS tx_hash,             -- Mint 事件交易哈希
        evt_index AS evt_index,             -- Mint 事件日志索引
        'add' AS liquidity_action,           -- Mint 对应添加流动性
        CAST(amount0 AS DOUBLE) AS dai_raw,  -- token0 DAI 的链上原始数量
        CAST(amount1 AS DOUBLE) AS lgns_raw  -- token1 LGNS 的链上原始数量
    FROM quickswap_polygon.uniswapv2pair_evt_mint
    WHERE contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 在底层 decoded 事件表即限定 Pair，避免读取其他 QuickSwap V2 Pair。
),
pair_burn AS (
    -- 提取目标 Pair 的 Burn 事件；amount0 是 DAI 原始量，amount1 是 LGNS 原始量。
    SELECT
        evt_block_time AS block_time,       -- Burn 事件区块时间
        evt_block_number AS block_number,   -- Burn 事件区块号
        evt_tx_hash AS tx_hash,             -- Burn 事件交易哈希
        evt_index AS evt_index,             -- Burn 事件日志索引
        'remove' AS liquidity_action,        -- Burn 对应移除流动性
        CAST(amount0 AS DOUBLE) AS dai_raw,  -- token0 DAI 的链上原始数量
        CAST(amount1 AS DOUBLE) AS lgns_raw  -- token1 LGNS 的链上原始数量
    FROM quickswap_polygon.uniswapv2pair_evt_burn
    WHERE contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 与 Mint 使用同一 Pair 地址，保证 Add/Remove 口径一致。
),
pair_events AS (
    -- 合并 Mint 与 Burn；两类事件来自互斥 topic，使用 UNION ALL 保留每一笔真实日志。
    SELECT
        block_time,          -- 事件区块时间
        block_number,        -- 事件区块号
        tx_hash,             -- 事件交易哈希
        evt_index,           -- 事件日志索引
        liquidity_action,    -- add 或 remove
        dai_raw,             -- DAI 原始数量
        lgns_raw             -- LGNS 原始数量
    FROM pair_mint
    UNION ALL
    SELECT
        block_time,          -- 事件区块时间
        block_number,        -- 事件区块号
        tx_hash,             -- 事件交易哈希
        evt_index,           -- 事件日志索引
        liquidity_action,    -- add 或 remove
        dai_raw,             -- DAI 原始数量
        lgns_raw             -- LGNS 原始数量
    FROM pair_burn
),
scaled_events AS (
    -- 按 Dune 元数据中的 decimals 将 uint256 原始量换算为可读 DAI/LGNS 数量。
    SELECT
        e.block_time,                                        -- 事件区块时间
        e.block_number,                                      -- 事件区块号
        e.tx_hash,                                           -- 事件交易哈希
        e.evt_index,                                         -- 事件日志索引
        e.liquidity_action,                                  -- 添加或移除流动性
        e.dai_raw / POWER(10, d.dai_decimals) AS dai_amount, -- DAI 显示数量
        e.lgns_raw / POWER(10, d.lgns_decimals) AS lgns_amount -- LGNS 显示数量
    FROM pair_events e
    CROSS JOIN token_decimals d
        -- token_decimals 只有一行，CROSS JOIN 仅把两个精度参数应用到全部目标事件。
    WHERE d.dai_decimals IS NOT NULL
      AND d.lgns_decimals IS NOT NULL
        -- 缺少任一精度时不输出误缩放金额；空结果应触发人工调查而非猜测精度。
),
daily AS (
    -- 按 UTC 日期汇总 Add/Remove 次数、金额和净变化。
    SELECT
        CAST(date_trunc('day', block_time) AS DATE) AS date, -- UTC 日期
        SUM(CASE
            WHEN liquidity_action = 'add' THEN 1 ELSE 0
        END) AS add_liquidity_count,                         -- 当日添加流动性次数
        SUM(CASE
            WHEN liquidity_action = 'remove' THEN 1 ELSE 0
        END) AS remove_liquidity_count,                      -- 当日移除流动性次数
        SUM(CASE
            WHEN liquidity_action = 'add' THEN dai_amount ELSE 0
        END) AS add_dai,                                     -- 当日添加的 DAI
        SUM(CASE
            WHEN liquidity_action = 'add' THEN lgns_amount ELSE 0
        END) AS add_lgns,                                    -- 当日添加的 LGNS
        SUM(CASE
            WHEN liquidity_action = 'remove' THEN dai_amount ELSE 0
        END) AS remove_dai,                                  -- 当日移除的 DAI
        SUM(CASE
            WHEN liquidity_action = 'remove' THEN lgns_amount ELSE 0
        END) AS remove_lgns                                  -- 当日移除的 LGNS
    FROM scaled_events
    GROUP BY 1
),
sample_ranked AS (
    -- 用事件键哈希形成稳定的伪随机顺序，一次执行内抽取 3 笔原始事件供方向和金额检查。
    SELECT
        block_time,                                          -- 抽样事件区块时间
        block_number,                                        -- 抽样事件区块号
        tx_hash,                                             -- 抽样事件交易哈希
        evt_index,                                           -- 抽样事件日志索引
        liquidity_action,                                    -- 抽样事件 Add/Remove 类型
        dai_amount,                                          -- 抽样事件 DAI 数量
        lgns_amount,                                         -- 抽样事件 LGNS 数量
        ROW_NUMBER() OVER (
            ORDER BY xxhash64(tx_hash), evt_index
        ) AS sample_rank                                     -- 稳定伪随机样本序号
    FROM scaled_events
),
validation AS (
    -- 汇总历史边界、原始事件数和重复键数，用于确认完整结果不是 LIMIT 样本。
    SELECT
        MIN(block_time) AS history_start,                    -- 全部 Mint/Burn 的最早时间
        MAX(block_time) AS history_end,                      -- 全部 Mint/Burn 的最晚时间
        COUNT(*) AS raw_event_count,                         -- 全部 Mint/Burn 事件行数
        COUNT(*) - COUNT(DISTINCT CONCAT(
            to_hex(tx_hash), ':', CAST(evt_index AS VARCHAR)
        )) AS duplicate_event_rows                           -- 重复交易哈希+日志索引数量，预期为 0
    FROM scaled_events
),
sample_events AS (
    -- 将 3 笔样本压成审计字符串；保留 tx、block、事件方向和两种代币金额。
    SELECT
        MAX(CASE WHEN sample_rank = 1 THEN CONCAT(
            'tx=0x', to_hex(tx_hash), ',block=', CAST(block_number AS VARCHAR),
            ',action=', liquidity_action, ',dai=', CAST(dai_amount AS VARCHAR),
            ',lgns=', CAST(lgns_amount AS VARCHAR)
        ) END) AS sample_event_1,                            -- 第 1 笔伪随机样本
        MAX(CASE WHEN sample_rank = 2 THEN CONCAT(
            'tx=0x', to_hex(tx_hash), ',block=', CAST(block_number AS VARCHAR),
            ',action=', liquidity_action, ',dai=', CAST(dai_amount AS VARCHAR),
            ',lgns=', CAST(lgns_amount AS VARCHAR)
        ) END) AS sample_event_2,                            -- 第 2 笔伪随机样本
        MAX(CASE WHEN sample_rank = 3 THEN CONCAT(
            'tx=0x', to_hex(tx_hash), ',block=', CAST(block_number AS VARCHAR),
            ',action=', liquidity_action, ',dai=', CAST(dai_amount AS VARCHAR),
            ',lgns=', CAST(lgns_amount AS VARCHAR)
        ) END) AS sample_event_3                             -- 第 3 笔伪随机样本
    FROM sample_ranked
    WHERE sample_rank <= 3
        -- 只聚合前三个伪随机事件，避免把全部事件拼入结果。
)
SELECT
    d.date,                                                  -- 日期
    d.add_liquidity_count,                                   -- 添加流动性次数
    d.remove_liquidity_count,                                -- 移除流动性次数
    d.add_dai,                                               -- 添加 DAI 数量
    d.add_lgns,                                              -- 添加 LGNS 数量
    d.remove_dai,                                            -- 移除 DAI 数量
    d.remove_lgns,                                           -- 移除 LGNS 数量
    d.add_dai - d.remove_dai AS net_dai,                     -- DAI 净流动性变化
    d.add_lgns - d.remove_lgns AS net_lgns,                  -- LGNS 净流动性变化
    v.history_start,                                         -- 事件历史起点
    v.history_end,                                           -- 事件历史终点
    v.raw_event_count,                                       -- 原始 Mint/Burn 事件总数
    v.duplicate_event_rows,                                  -- 重复事件键数量
    s.sample_event_1,                                        -- 抽查样本 1
    s.sample_event_2,                                        -- 抽查样本 2
    s.sample_event_3                                         -- 抽查样本 3
FROM daily d
CROSS JOIN validation v
    -- validation 只有一行，将全局质量指标附在每日结果上。
CROSS JOIN sample_events s
    -- sample_events 只有一行，将 3 笔抽样附在每日结果上。
ORDER BY d.date ASC
    -- 按日期升序，便于时间序列图直接使用。