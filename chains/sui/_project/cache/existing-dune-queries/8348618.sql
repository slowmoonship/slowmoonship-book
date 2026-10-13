SELECT
    date, -- 日期
    checkpoint_count, -- Checkpoint 数量
    p95_checkpoint_gap_seconds, -- Checkpoint Gap P95
    p99_checkpoint_gap_seconds, -- Checkpoint Gap P99
    max_checkpoint_gap_seconds, -- Checkpoint 最大 Gap
    network_transaction_blocks, -- 全网 Transaction Blocks
    network_transactions, -- 全网 transactions
    user_transaction_blocks, -- 用户 Transaction Blocks
    active_senders, -- 活跃发送地址
    batch_transactions, -- PTB 中 transaction_count 总量
    avg_transactions_per_ptb, -- PTB 平均 transaction_count
    p95_transactions_per_ptb, -- PTB transaction_count P95
    move_calls, -- Move Calls
    shared_tx_share_pct, -- Shared Object 交易占比
    sponsored_tx_share_pct, -- Sponsored Transaction 占比
    zklogin_tx_share_pct, -- zkLogin Transaction 占比
    user_execution_success_rate_pct, -- 用户交易执行成功率
    created, -- 创建对象数量
    mutated, -- 修改对象数量
    deleted, -- 删除对象数量
    net_object_change_proxy, -- 对象操作净增代理
    publish, -- Package Publish
    upgrade, -- Package Upgrade
    total_gas_cost / 1000000000.0 AS total_gas_cost_sui, -- 总 Gas Cost 换算为 SUI
    computation_cost / 1000000000.0 AS computation_cost_sui, -- Computation Cost 换算为 SUI
    storage_cost / 1000000000.0 AS storage_cost_sui, -- Storage Cost 换算为 SUI
    storage_rebate / 1000000000.0 AS storage_rebate_sui -- Storage Rebate 换算为 SUI
FROM query_8347640
WHERE date >= CURRENT_DATE - INTERVAL '365' DAY
ORDER BY date;