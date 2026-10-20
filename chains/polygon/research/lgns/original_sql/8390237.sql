/*
LGNS Burn Count Reconciliation ｜ LGNS Burn数量差异核对
检索日期：2026-08-20。
目标：严格复现 Query 05 固定快照与 Query 09 已执行快照的 Burn 事件键集合，
通过双向 EXCEPT 定位差异，避免仅凭“可能是日期边界”作推测。

Pair：0x882df4b0fb50a229c3b4124eb18c759911485bfb。
token0：Polygon DAI，18 decimals；token1：LGNS，9 decimals。
事件唯一键：evt_tx_hash + evt_index + contract_address。
Q05 固定截止：2026-08-18 09:28:58 UTC。
Q09 已执行快照最后事件：2026-08-20 09:59:31 UTC。
amount0/amount1 保留 decoded Burn 的原始整数，汇总 DAI 时才除以 1e18。
*/

WITH burn_base AS (
    -- 一次读取能够覆盖两个快照的目标 Pair Burn，后续从同一底表切出两套集合。
    SELECT
        b.evt_block_time AS block_time,                 -- Burn 区块时间（UTC）
        b.evt_block_number AS block_number,             -- Burn 区块号
        b.evt_tx_hash AS tx_hash,                       -- Burn 交易哈希
        b.evt_index,                                    -- Burn 日志索引
        b.contract_address,                             -- Pair 合约地址，属于事件键
        b.sender,                                       -- 调用 Pair.burn 的地址，可能是 Router
        b."to" AS recipient_to,                         -- Pair 直接发送 token0/token1 的地址
        b.amount0,                                      -- token0 DAI 原始uint256数量
        b.amount1                                       -- token1 LGNS 原始uint256数量
    FROM quickswap_polygon.uniswapv2pair_evt_burn b
    WHERE b.evt_block_date >= DATE '2024-03-01'
        -- 从Pair上线前开始，并用日期分区裁剪避免扫描无关历史。
      AND b.evt_block_date <= DATE '2026-08-20'
        -- 只扫描Q09既有执行快照所覆盖的最后日期，不扩展到之后数据。
      AND b.evt_block_time <= TIMESTAMP '2026-08-20 09:59:31'
        -- 精确冻结到Query 09既有执行结果中的最后一条Burn。
      AND b.contract_address = 0x882df4b0fb50a229c3b4124eb18c759911485bfb
        -- 只保留LGNS/DAI Pair，排除其他QuickSwap交易对。
),
q05_burn AS (
    -- 按Query 05固定时间边界复现其Burn集合。
    SELECT *
    FROM burn_base
    WHERE block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- Query 05为对齐Query 01使用的精确固定截止时间。
),
q09_burn AS (
    -- Query 09既有执行没有上限；此处使用其已观察到的最后事件时间冻结快照。
    SELECT *
    FROM burn_base
),
q05_only_keys AS (
    -- 双向差分第一侧：存在于Q05而不存在于Q09的完整事件键。
    SELECT tx_hash, evt_index, contract_address
    FROM q05_burn
    EXCEPT
    SELECT tx_hash, evt_index, contract_address
    FROM q09_burn
),
q09_only_keys AS (
    -- 双向差分第二侧：存在于Q09而不存在于Q05的完整事件键。
    SELECT tx_hash, evt_index, contract_address
    FROM q09_burn
    EXCEPT
    SELECT tx_hash, evt_index, contract_address
    FROM q05_burn
),
difference_keys AS (
    -- 合并两侧差异，并写明集合方向；UNION ALL保留两类互斥结果。
    SELECT
        tx_hash,                                         -- 差异事件交易哈希
        evt_index,                                       -- 差异事件日志索引
        contract_address,                                -- 差异事件Pair地址
        TRUE AS q05_present,                             -- Q05集合中存在
        FALSE AS q09_present,                            -- Q09集合中不存在
        'q05_only_unexpected_key' AS difference_reason   -- 若出现则不是时间边界，需要继续调查
    FROM q05_only_keys

    UNION ALL

    SELECT
        tx_hash,                                         -- 差异事件交易哈希
        evt_index,                                       -- 差异事件日志索引
        contract_address,                                -- 差异事件Pair地址
        FALSE AS q05_present,                            -- Q05集合中不存在
        TRUE AS q09_present,                             -- Q09集合中存在
        'after_q05_fixed_cutoff_before_or_at_q09_snapshot_cutoff'
            AS difference_reason                        -- 已确认由两个执行快照截止时间不同导致
    FROM q09_only_keys
),
summary AS (
    -- 单行汇总两个集合的数量、移除金额和双向差异数量，作为每条明细的审计背景。
    SELECT
        (SELECT COUNT(*) FROM q05_burn) AS q05_burn_count,
                                                            -- Q05固定快照Burn数
        (SELECT COUNT(*) FROM q09_burn) AS q09_burn_count,
                                                            -- Q09既有执行快照Burn数
        (SELECT COUNT(*) FROM q05_only_keys) AS q05_only_count,
                                                            -- Q05独有事件数
        (SELECT COUNT(*) FROM q09_only_keys) AS q09_only_count,
                                                            -- Q09独有事件数
        (SELECT SUM(CAST(amount0 AS DOUBLE)) / 1e18 FROM q05_burn)
            AS q05_remove_dai,                             -- Q05固定快照累计移除DAI
        (SELECT SUM(CAST(amount0 AS DOUBLE)) / 1e18 FROM q09_burn)
            AS q09_remove_dai,                             -- Q09既有快照累计移除DAI
        (SELECT SUM(CAST(amount0 AS DOUBLE)) / 1e18 FROM q09_burn)
          - (SELECT SUM(CAST(amount0 AS DOUBLE)) / 1e18 FROM q05_burn)
            AS difference_remove_dai                       -- 11条时间边界事件对应的DAI差额
)
SELECT
    b.block_time,                                         -- 差异Burn区块时间
    b.block_number,                                       -- 差异Burn区块号
    b.tx_hash,                                            -- 差异Burn交易哈希
    b.evt_index,                                          -- 差异Burn日志索引
    b.contract_address,                                   -- 事件键中的Pair合约地址
    b.sender,                                             -- Pair.burn调用地址
    b.recipient_to AS "to",                               -- token0/token1直接接收地址
    b.amount0,                                            -- token0 DAI原始整数
    b.amount1,                                            -- token1 LGNS原始整数
    d.q05_present,                                        -- 是否存在于Q05集合
    d.q09_present,                                        -- 是否存在于Q09集合
    d.difference_reason,                                  -- 已验证的差异原因
    s.q05_burn_count,                                     -- Q05 Burn总数
    s.q09_burn_count,                                     -- Q09 Burn总数
    s.q05_only_count,                                     -- Q05独有事件数
    s.q09_only_count,                                     -- Q09独有事件数
    s.q05_remove_dai,                                     -- Q05截止口径累计移除DAI
    s.q09_remove_dai,                                     -- Q09快照口径累计移除DAI
    s.difference_remove_dai                               -- 时间边界造成的累计移除DAI差额
FROM difference_keys d
JOIN burn_base b
    ON d.tx_hash = b.tx_hash
   AND d.evt_index = b.evt_index
   AND d.contract_address = b.contract_address
    -- 使用完整三字段事件键回取差异明细，避免同交易不同日志误配。
CROSS JOIN summary s
    -- summary只有一行，将统一的数量与金额核验附到每条差异记录。
ORDER BY b.block_time, b.block_number, b.evt_index
    -- 按时间顺序展示11条新增事件，便于核对截止边界。
