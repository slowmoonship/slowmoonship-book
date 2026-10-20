-- Query 11辅助：Top 1 Burn.to合约的全部成功顶层调用者统计
-- 目标合约：0x1D6A7F2CB262AFBB1204BBFCBB3DB642662B15C3；已由Dune合约创建记录确认是Contract。
-- 固定截止：2026-08-18 09:28:58 UTC；只统计to为目标合约的顶层交易，不扩展内部调用图谱。
-- 经济含义：caller仅表示直接调用该合约的交易from，不证明该地址控制合约或控制资金。

WITH caller_stats AS (
    -- 在Polygon顶层交易表按from聚合目标合约的成功调用。
    SELECT
        t."from" AS caller_address,                              -- 直接调用目标合约的顶层交易from
        COUNT(*) AS call_count,                                  -- 成功顶层调用次数
        MIN(t.block_time) AS first_call_time,                    -- 首次成功调用时间
        MAX(t.block_time) AS last_call_time,                     -- 最后成功调用时间
        MIN_BY(SUBSTR(to_hex(t.data), 1, 8), t.block_time)
            AS first_method_id,                                  -- 首次调用的4字节方法选择器
        MAX_BY(SUBSTR(to_hex(t.data), 1, 8), t.block_time)
            AS last_method_id                                    -- 最后调用的4字节方法选择器
    FROM polygon.transactions t
    WHERE t.block_date >= DATE '2024-12-01'
        -- 早于目标合约2024-12-28创建日并启用日期分区裁剪。
      AND t.block_date <= DATE '2026-08-18'
        -- 固定截止日期，不扫描后续交易。
      AND t.block_time <= TIMESTAMP '2026-08-18 09:28:58'
        -- 固定截止时刻，与Burn统一口径一致。
      AND t."to" = 0x1d6a7f2cb262afbb1204bbfcbb3db642662b15c3
        -- 只统计直接调用Top 1合约的顶层交易。
      AND t.success
        -- 失败交易不作为有效调用者证据。
    GROUP BY 1
)
SELECT
    CONCAT('0x', to_hex(caller_address)) AS caller_address,      -- 直接调用者地址文本
    call_count,                                                   -- 成功调用次数
    first_call_time,                                              -- 首次成功调用时间
    last_call_time,                                               -- 最后成功调用时间
    first_method_id,                                              -- 首次调用方法选择器
    last_method_id,                                               -- 最后调用方法选择器
    ROW_NUMBER() OVER (
        ORDER BY call_count DESC, caller_address
    ) AS caller_rank                                              -- 按调用次数确定主要调用者排名
FROM caller_stats
ORDER BY caller_rank
    -- 主要调用者优先输出，供Query 11复用。