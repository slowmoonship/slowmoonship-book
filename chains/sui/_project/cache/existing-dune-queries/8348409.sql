SELECT
    date, -- 日期
    package, -- Move Package ID

    COUNT(*) AS move_calls, -- Move Call 总次数

    COUNT(
        DISTINCT transaction_digest
    ) AS transaction_blocks, -- 调用该 Package 的独立 Transaction Blocks

    COUNT(
        DISTINCT module
    ) AS module_count, -- 当天被调用的独立 Module 数量

    COUNT(
        DISTINCT CONCAT(module, '::', function)
    ) AS function_count, -- 当天被调用的独立 Function 数量

    MIN(checkpoint) AS first_checkpoint, -- 当天第一次调用所在 Checkpoint

    MAX(checkpoint) AS last_checkpoint -- 当天最后一次调用所在 Checkpoint
FROM sui.move_call
WHERE date >= CURRENT_DATE - INTERVAL '180' DAY
GROUP BY 1, 2;
