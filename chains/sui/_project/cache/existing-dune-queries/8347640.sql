
--## `SUI_V1_DWS_001_NETWORK_DAILY`

-- 这是整个看板的核心。

-- 它一次扫描：

-- ```text
-- sui.checkpoints
-- sui.transactions
-- ```

-- 然后按天聚合。

-- `checkpoints` 原生包含 Checkpoint sequence、epoch、timestamp，以及 Transaction Blocks、Transactions、成功数量和 Gas 等统计。([Dune Docs][4])

WITH checkpoint_raw AS (
    SELECT
        date, -- Checkpoint 所属日期
        sequence_number, -- Checkpoint 顺序号
        epoch, -- 所属 Epoch
        timestamp_ms, -- Checkpoint 链上时间戳，毫秒
        total_transaction_blocks, -- Checkpoint 内 Transaction Blocks 数量
        total_transactions, -- Checkpoint 内 transactions 数量
        total_successful_transaction_blocks, -- 成功 Transaction Blocks 数量
        LAG(sequence_number) OVER (
            ORDER BY sequence_number
        ) AS prev_sequence_number, -- 前一个 Checkpoint 顺序号
        LAG(timestamp_ms) OVER (
            ORDER BY sequence_number
        ) AS prev_timestamp_ms -- 前一个 Checkpoint 时间戳
    FROM sui.checkpoints
    WHERE date >= CURRENT_DATE - INTERVAL '366' DAY
),

checkpoint_detail AS (
    SELECT
        date, -- 日期
        sequence_number, -- 当前 Checkpoint 顺序号
        epoch, -- 当前 Epoch
        total_transaction_blocks, -- 当前 Checkpoint Transaction Blocks 数量
        total_transactions, -- 当前 Checkpoint transactions 数量
        total_successful_transaction_blocks, -- 当前 Checkpoint 成功 Transaction Blocks 数量
        sequence_number - prev_sequence_number AS sequence_step, -- 与前一条 Checkpoint 的顺序号差值
        CAST(timestamp_ms - prev_timestamp_ms AS DOUBLE) / 1000.0 AS checkpoint_gap_seconds -- 与前一个 Checkpoint 的时间间隔，秒
    FROM checkpoint_raw
),

checkpoint_daily AS (
    SELECT
        date, -- 日期
        COUNT(*) AS checkpoint_count, -- 当日 Checkpoint 数量

        AVG(checkpoint_gap_seconds)
            FILTER (WHERE sequence_step = 1)
            AS avg_checkpoint_gap_seconds, -- 连续 Checkpoint 的平均时间间隔

        approx_percentile(
            checkpoint_gap_seconds,
            0.50
        ) FILTER (WHERE sequence_step = 1)
            AS p50_checkpoint_gap_seconds, -- Checkpoint 间隔 P50

        approx_percentile(
            checkpoint_gap_seconds,
            0.95
        ) FILTER (WHERE sequence_step = 1)
            AS p95_checkpoint_gap_seconds, -- Checkpoint 间隔 P95

        approx_percentile(
            checkpoint_gap_seconds,
            0.99
        ) FILTER (WHERE sequence_step = 1)
            AS p99_checkpoint_gap_seconds, -- Checkpoint 间隔 P99

        MAX(checkpoint_gap_seconds)
            FILTER (WHERE sequence_step = 1)
            AS max_checkpoint_gap_seconds, -- 当日连续 Checkpoint 最大时间间隔

        SUM(
            CASE
                WHEN sequence_step > 1 THEN sequence_step - 1
                ELSE 0
            END
        ) AS missing_checkpoint_rows_proxy, -- Dune 数据中疑似缺失的 Checkpoint 数量代理

        SUM(total_transaction_blocks) AS network_transaction_blocks, -- 全网 Transaction Blocks 数量
        SUM(total_transactions) AS network_transactions, -- 全网 transactions 数量

        100.0 * SUM(total_successful_transaction_blocks)
            / NULLIF(SUM(total_transaction_blocks), 0)
            AS network_tx_block_success_rate_pct -- 全网 Transaction Block 成功率
    FROM checkpoint_detail
    WHERE date >= CURRENT_DATE - INTERVAL '365' DAY
    GROUP BY 1
),

transaction_daily AS (
    SELECT
        date, -- 日期

        COUNT_IF(NOT is_system_txn)
            AS user_transaction_blocks, -- 非系统 Transaction Blocks 数量

        COUNT(
            DISTINCT CASE
                WHEN NOT is_system_txn THEN sender
            END
        ) AS active_senders, -- 非系统交易的独立发送地址数

        SUM(
            CASE
                WHEN NOT is_system_txn THEN transaction_count
                ELSE 0
            END
        ) AS batch_transactions, -- 用户 PTB 内 transaction_count 总和

        AVG(
            CASE
                WHEN NOT is_system_txn
                    THEN CAST(transaction_count AS DOUBLE)
            END
        ) AS avg_transactions_per_ptb, -- 每个用户 PTB 平均 transaction_count

        approx_percentile(
            CASE
                WHEN NOT is_system_txn
                    THEN CAST(transaction_count AS DOUBLE)
            END,
            0.95
        ) AS p95_transactions_per_ptb, -- 每个用户 PTB transaction_count 的 P95

        SUM(
            CASE
                WHEN NOT is_system_txn THEN move_calls
                ELSE 0
            END
        ) AS move_calls, -- Move Call 总量

        COUNT_IF(
            NOT is_system_txn
            AND shared_input > 0
        ) AS shared_transaction_blocks, -- 至少包含一个 Shared Input 的用户 Transaction Blocks

        100.0 * COUNT_IF(
            NOT is_system_txn
            AND shared_input > 0
        ) / NULLIF(
            COUNT_IF(NOT is_system_txn),
            0
        ) AS shared_tx_share_pct, -- Shared Object 交易占用户 Transaction Blocks 比例

        SUM(
            CASE
                WHEN NOT is_system_txn THEN shared_input
                ELSE 0
            END
        ) AS shared_inputs, -- Shared Input 总数量

        COUNT_IF(
            NOT is_system_txn
            AND is_sponsored_tx
        ) AS sponsored_transaction_blocks, -- Sponsored Transaction Blocks 数量

        100.0 * COUNT_IF(
            NOT is_system_txn
            AND is_sponsored_tx
        ) / NULLIF(
            COUNT_IF(NOT is_system_txn),
            0
        ) AS sponsored_tx_share_pct, -- Sponsored Transaction 占比

        COUNT_IF(
            NOT is_system_txn
            AND has_zklogin_sig
        ) AS zklogin_transaction_blocks, -- 使用 zkLogin 的 Transaction Blocks

        100.0 * COUNT_IF(
            NOT is_system_txn
            AND has_zklogin_sig
        ) / NULLIF(
            COUNT_IF(NOT is_system_txn),
            0
        ) AS zklogin_tx_share_pct, -- zkLogin Transaction 占比

        100.0 * COUNT_IF(
            NOT is_system_txn
            AND execution_success
        ) / NULLIF(
            COUNT_IF(NOT is_system_txn),
            0
        ) AS user_execution_success_rate_pct, -- 用户 Transaction Block 执行成功率

        SUM(
            CASE
                WHEN NOT is_system_txn THEN created
                ELSE 0
            END
        ) AS created, -- 用户交易创建对象数量

        SUM(
            CASE
                WHEN NOT is_system_txn THEN mutated
                ELSE 0
            END
        ) AS mutated, -- 用户交易修改对象数量

        SUM(
            CASE
                WHEN NOT is_system_txn THEN deleted
                ELSE 0
            END
        ) AS deleted, -- 用户交易删除对象数量

        SUM(
            CASE
                WHEN NOT is_system_txn THEN publish
                ELSE 0
            END
        ) AS publish, -- Package Publish 操作数量

        SUM(
            CASE
                WHEN NOT is_system_txn THEN upgrade
                ELSE 0
            END
        ) AS upgrade, -- Package Upgrade 操作数量

        SUM(
            CASE
                WHEN NOT is_system_txn THEN total_gas_cost
                ELSE 0
            END
        ) AS total_gas_cost, -- 用户交易总 Gas Cost

        SUM(
            CASE
                WHEN NOT is_system_txn THEN computation_cost
                ELSE 0
            END
        ) AS computation_cost, -- 用户交易 Computation Cost

        SUM(
            CASE
                WHEN NOT is_system_txn THEN storage_cost
                ELSE 0
            END
        ) AS storage_cost, -- 用户交易 Storage Cost

        SUM(
            CASE
                WHEN NOT is_system_txn THEN storage_rebate
                ELSE 0
            END
        ) AS storage_rebate, -- 用户交易 Storage Rebate

        SUM(
            CASE
                WHEN NOT is_system_txn THEN non_refundable_storage_fee
                ELSE 0
            END
        ) AS non_refundable_storage_fee -- 不可返还 Storage Fee
    FROM sui.transactions
    WHERE date >= CURRENT_DATE - INTERVAL '365' DAY
    GROUP BY 1
)

SELECT
    c.date, -- 日期
    c.checkpoint_count, -- Checkpoint 数量
    c.avg_checkpoint_gap_seconds, -- Checkpoint 平均间隔
    c.p50_checkpoint_gap_seconds, -- Checkpoint 间隔 P50
    c.p95_checkpoint_gap_seconds, -- Checkpoint 间隔 P95
    c.p99_checkpoint_gap_seconds, -- Checkpoint 间隔 P99
    c.max_checkpoint_gap_seconds, -- Checkpoint 最大间隔
    c.missing_checkpoint_rows_proxy, -- 疑似缺失 Checkpoint 记录数量
    c.network_transaction_blocks, -- 全网 Transaction Blocks
    c.network_transactions, -- 全网 transactions
    c.network_tx_block_success_rate_pct, -- 全网 Transaction Block 成功率
    t.user_transaction_blocks, -- 用户 Transaction Blocks
    t.active_senders, -- 活跃发送地址
    t.batch_transactions, -- PTB 内 transaction_count 总量
    t.avg_transactions_per_ptb, -- 平均每个 PTB transaction_count
    t.p95_transactions_per_ptb, -- PTB transaction_count P95
    t.move_calls, -- Move Call 总量
    t.shared_transaction_blocks, -- Shared Object Transaction Blocks
    t.shared_tx_share_pct, -- Shared Object Transaction Blocks 占比
    t.shared_inputs, -- Shared Input 数量
    t.sponsored_transaction_blocks, -- Sponsored Transaction Blocks
    t.sponsored_tx_share_pct, -- Sponsored Transaction 占比
    t.zklogin_transaction_blocks, -- zkLogin Transaction Blocks
    t.zklogin_tx_share_pct, -- zkLogin Transaction 占比
    t.user_execution_success_rate_pct, -- 用户 Transaction Block 成功率
    t.created, -- 创建对象数量
    t.mutated, -- 修改对象数量
    t.deleted, -- 删除对象数量
    t.created - t.deleted AS net_object_change_proxy, -- 创建减删除，仅作为对象操作净增代理
    t.publish, -- Package Publish 操作
    t.upgrade, -- Package Upgrade 操作
    t.total_gas_cost, -- 总 Gas Cost
    t.computation_cost, -- Computation Cost
    t.storage_cost, -- Storage Cost
    t.storage_rebate, -- Storage Rebate
    t.non_refundable_storage_fee -- Non-refundable Storage Fee
FROM checkpoint_daily c
LEFT JOIN transaction_daily t
    ON c.date = t.date
ORDER BY c.date;