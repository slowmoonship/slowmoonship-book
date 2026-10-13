WITH package_activity AS (
    SELECT
        package, -- Package ID
        SUM(move_calls) AS move_calls, -- Move Call 总次数
        SUM(transaction_blocks) AS transaction_blocks, -- 调用该 Package 的 Transaction Blocks
        COUNT(DISTINCT date) AS active_days, -- 活跃天数
        MAX(module_count) AS max_daily_module_count, -- 单日最高活跃 Module 数
        MAX(function_count) AS max_daily_function_count, -- 单日最高活跃 Function 数
        MIN(date) AS first_seen_date, -- 观察期首次出现日期
        MAX(date) AS last_seen_date -- 观察期最后出现日期
    FROM query_8348409
    WHERE date >= CURRENT_DATE - INTERVAL '30' DAY
    GROUP BY 1
)

SELECT
    CONCAT('0x', LOWER(TO_HEX(package))) AS package, -- Package 十六进制 ID
    move_calls, -- Move Call 总量
    transaction_blocks, -- 调用 Transaction Blocks 数量
    active_days, -- 活跃天数
    max_daily_module_count, -- 单日最大活跃 Module 数
    max_daily_function_count, -- 单日最大活跃 Function 数
    first_seen_date, -- 首次出现日期
    last_seen_date -- 最后出现日期
FROM package_activity
ORDER BY move_calls DESC
LIMIT 20;