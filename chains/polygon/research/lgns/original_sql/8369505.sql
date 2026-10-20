
/*
LGNS Staking Activity ｜ LGNS 质押活动

可执行口径：
1. Stake 使用 Staking 合约明确的 Staked(address,uint256) 事件。
   topic0 = keccak256('Staked(address,uint256)')；topic1 是 indexed recipient；
   data 是未索引的 LGNS amount。
2. 合约 ABI 没有 Unstaked 事件。完整 ERC20 配对与顶层调用历史在当前免费引擎
   两分钟限制内未完成，因此不把未验证代理伪装成 Unstake。
3. 本 Query 只输出完整历史的已确认 Stake；不输出 unstake_count、unstake_lgns、
   net_staked_lgns。结果中的 unstake_coverage_status 明确记录缺口。
4. polygon.logs 的 tx_hash + index 是事件唯一键；底层日志本身不额外去重，
   避免错误合并同一交易内多个真实 Staked 事件。
5. LGNS decimals 从 tokens.supply_latest 动态读取，不硬编码。
6. 为控制免费版成本，直接按日聚合；不对全部事件做全局排序。
*/

WITH token_decimals AS (
    -- 只读取 Polygon LGNS 的当前精度。
    SELECT
        MAX(decimals) AS lgns_decimals                   -- LGNS 精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'                        -- 限定 Polygon 分区
      AND token_address = 0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
                                                         -- 只读取 LGNS
),

stake_events AS (
    -- 在最底层按日期、合约地址和 topic0 精确筛选 Staked 事件。
    SELECT
        l.block_time,                                    -- Stake 区块时间
        l.block_number,                                  -- Stake 区块号
        l.tx_hash,                                       -- Stake 交易哈希
        l."index" AS event_index,                        -- Stake 日志索引
        varbinary_substring(l.topic1, 13, 20) AS staker,-- indexed recipient 地址
        CAST(varbinary_to_uint256(l.data) AS DOUBLE)
            / POWER(10, d.lgns_decimals) AS stake_lgns   -- 按动态精度换算的 LGNS 数量
    FROM polygon.logs l
    CROSS JOIN token_decimals d                          -- 将单行精度应用到目标日志
    WHERE l.block_date >= DATE '2024-03-06'              -- 合约部署日期并启用分区裁剪
      AND l.contract_address = 0x1964ca90474b11ffd08af387b110ba6c96251bfc
                                                         -- 只读取目标 Staking 合约
      AND l.topic0 = 0x9e71bc8eea02a63969f509818f2dafb9254532904319f9dbda79b67bd34a5f3d
                                                         -- Staked(address,uint256) 确认 topic0
      AND d.lgns_decimals IS NOT NULL                    -- 缺精度时不输出误缩放金额
),

daily AS (
    -- 直接按 UTC 日期聚合，避免对完整事件集做全局排序。
    SELECT
        CAST(block_time AS DATE) AS date,                -- UTC 日期
        COUNT(*) AS stake_count,                         -- 当日 Staked 事件数
        SUM(stake_lgns) AS stake_lgns,                   -- 当日 Stake LGNS 数量
        COUNT(DISTINCT staker) AS unique_stakers,        -- 当日去重 recipient 数
        MIN(block_time) AS day_first_event_time,         -- 当日最早 Stake 时间
        MAX(block_time) AS day_last_event_time,          -- 当日最晚 Stake 时间
        MIN_BY(tx_hash, block_time) AS sample_tx_hash,   -- 当日首笔样本交易哈希
        MIN_BY(block_number, block_time) AS sample_block_number, -- 当日首笔样本区块号
        MIN_BY(event_index, block_time) AS sample_event_index,   -- 当日首笔样本日志索引
        MIN_BY(stake_lgns, block_time) AS sample_stake_lgns      -- 当日首笔样本金额
    FROM stake_events
    GROUP BY CAST(block_time AS DATE)                    -- 每个 UTC 日期一行
)

SELECT
    d.date,                                              -- UTC 日期
    d.stake_count,                                       -- 当日已确认 Stake 次数
    d.stake_lgns,                                        -- 当日已确认 Stake LGNS 数量
    d.unique_stakers,                                    -- 当日去重 Stake recipient 数
    MIN(d.day_first_event_time) OVER () AS history_start,-- 全历史最早 Stake 时间
    MAX(d.day_last_event_time) OVER () AS history_end,   -- 全历史最晚 Stake 时间
    COUNT(*) OVER () AS row_count,                       -- 最终每日结果总行数
    SUM(d.stake_count) OVER () AS raw_stake_event_count, -- 全历史 Staked 事件总数
    d.sample_tx_hash,                                    -- 当日复核样本交易哈希
    d.sample_block_number,                               -- 当日复核样本区块号
    d.sample_event_index,                                -- 当日复核样本日志索引
    d.sample_stake_lgns,                                 -- 当日复核样本金额
    'UNSTAKE_NOT_INCLUDED_NO_EXPLICIT_EVENT_FREE_ENGINE_TIMEOUT'
        AS unstake_coverage_status,                      -- Unstake 未纳入的机器可读说明
    td.lgns_decimals                                     -- Dune 当前 LGNS 精度
FROM daily d
CROSS JOIN token_decimals td                             -- 将精度核验字段附加到最终结果
ORDER BY d.date ASC                                      -- 按日期升序输出完整 Stake 历史
