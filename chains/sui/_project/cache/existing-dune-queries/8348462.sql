WITH daily AS (
    SELECT
        * -- 读取 DWS 每日网络指标
    FROM query_8347640
    WHERE date < CURRENT_DATE
),

latest_date AS (
    SELECT
        MAX(date) AS date -- 最近一个完整自然日
    FROM daily
)

SELECT
    d.date, -- 指标所属日期
    d.max_checkpoint_gap_seconds, -- 当日最大 Checkpoint Gap
    d.user_transaction_blocks, -- 用户 Transaction Blocks
    d.active_senders, -- 活跃发送地址
    d.user_execution_success_rate_pct, -- 用户交易执行成功率
    d.shared_tx_share_pct, -- Shared Object 交易占比
    d.move_calls, -- Move Call 总量
    d.avg_transactions_per_ptb -- PTB 平均 transaction_count
FROM daily d
INNER JOIN latest_date l
    ON d.date = l.date;