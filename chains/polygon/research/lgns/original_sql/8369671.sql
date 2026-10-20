
/*
sLGNS Rebase History ｜ sLGNS Rebase 历史

解码依据与字段口径：
1. Dune 当前按 sLGNS 合约地址检索不到 decoded event 表，因此使用 polygon.logs。
2. 目标事件为 LogRebase(uint256,uint256,uint256)：
   topic0 = 0x6012...fb2；indexed epoch 位于 topic1；
   data 第 1 个 32 字节是 rebase，第 2 个 32 字节是 index。
3. 已验证源码明确注明 rebase 字段为 18 decimals，且计算为
   profit * 1e18 / previousCirculating，因此 rebase_rate = rebase_raw / 1e18。
4. index() 返回 sLGNS 显示余额单位，按 Dune 当前 sLGNS decimals 换算。
5. LogRebase 不直接发出实际增加的 token amount；因此本 Query 不伪造
   rebase_amount，只输出确认过的 rebase_raw、rebase_rate 与 index。
6. polygon.logs 以 tx_hash + index 唯一标识日志；本 Query 不做会合并真实事件的额外去重。
7. WHERE 在底层同时限定 block_date、contract_address 和 topic0，以控制免费版扫描成本。
*/

WITH token_decimals AS (
    -- 只读取 Polygon sLGNS 的当前代币精度。
    SELECT
        MAX(decimals) AS slgns_decimals                  -- sLGNS 精度
    FROM tokens.supply_latest
    WHERE blockchain = 'polygon'                        -- 限定 Polygon 分区
      AND token_address = 0x99a57e6c8558bc6689f894e068733adf83c19725
                                                         -- 只读取 sLGNS
),

rebase_events AS (
    -- 从 Polygon 原始日志精确提取并解码 sLGNS LogRebase 事件。
    SELECT
        l.block_time,                                    -- Rebase 事件区块时间
        l.block_number,                                  -- Rebase 事件区块号
        l.tx_hash,                                       -- Rebase 交易哈希
        l."index" AS event_index,                        -- Rebase 日志索引
        varbinary_to_uint256(l.topic1) AS epoch,         -- indexed epoch
        varbinary_to_uint256(
            varbinary_substring(l.data, 1, 32)
        ) AS rebase_raw,                                 -- data 第 1 个 uint256：18 位精度 rebase rate
        varbinary_to_uint256(
            varbinary_substring(l.data, 33, 32)
        ) AS index_raw                                   -- data 第 2 个 uint256：sLGNS index 原始量
    FROM polygon.logs l
    WHERE l.block_date >= DATE '2024-03-06'              -- 合约部署日期并启用日期分区裁剪
      AND l.contract_address = 0x99a57e6c8558bc6689f894e068733adf83c19725
                                                         -- 只读取目标 sLGNS 合约
      AND l.topic0 = 0x6012dbce857565c4a40974aa5de8373a761fc429077ef0c8c8611d1e20d63fb2
                                                         -- LogRebase(uint256,uint256,uint256) 确认 topic0
),

scaled_rebases AS (
    -- 将确认过的原始字段换算为可读 rate 与 index。
    SELECT
        r.block_time,                                    -- Rebase 事件时间
        r.block_number,                                  -- Rebase 事件区块号
        r.tx_hash,                                       -- Rebase 交易哈希
        r.event_index,                                   -- Rebase 日志索引
        r.epoch,                                         -- Rebase epoch
        r.rebase_raw,                                    -- 事件原始 18 位精度 rebase 值
        CAST(r.rebase_raw AS DOUBLE) / 1e18
            AS rebase_rate,                              -- 小数形式 Rebase rate，例如 0.001 表示 0.1%
        CAST(r.rebase_raw AS DOUBLE) / 1e16
            AS rebase_percent,                           -- 百分数形式 Rebase rate
        r.index_raw,                                     -- 事件原始 sLGNS index
        CAST(r.index_raw AS DOUBLE)
            / POWER(10, d.slgns_decimals) AS index       -- 按 sLGNS 精度换算的 index
    FROM rebase_events r
    CROSS JOIN token_decimals d                          -- 将单行 sLGNS 精度应用到所有事件
    WHERE d.slgns_decimals IS NOT NULL                   -- 缺精度时不输出误缩放 index
)

SELECT
    s.block_time,                                        -- Rebase 事件时间
    s.block_number,                                      -- Rebase 事件区块号
    s.tx_hash,                                           -- Rebase 交易哈希
    s.event_index,                                       -- Rebase 日志索引
    s.epoch,                                             -- Rebase epoch
    s.rebase_raw,                                        -- 事件原始 rebase 值
    s.rebase_rate,                                       -- 小数形式 Rebase rate
    s.rebase_percent,                                    -- 百分数形式 Rebase rate
    s.index_raw,                                         -- 事件原始 index
    s.index,                                             -- 按 sLGNS 精度换算的 index
    MIN(s.block_time) OVER () AS history_start,          -- 全历史最早 Rebase 时间
    MAX(s.block_time) OVER () AS history_end,            -- 全历史最晚 Rebase 时间
    COUNT(*) OVER () AS row_count,                       -- 完整 Rebase 事件总数
    'NOT_EMITTED_BY_LOGREBASE' AS rebase_amount_status,  -- 实际 token rebase amount 未由本事件发出
    td.slgns_decimals                                    -- Dune 当前 sLGNS 精度
FROM scaled_rebases s
CROSS JOIN token_decimals td                             -- 将精度核验字段附加到最终结果
ORDER BY s.block_time ASC, s.event_index ASC             -- 按时间与日志索引升序输出
