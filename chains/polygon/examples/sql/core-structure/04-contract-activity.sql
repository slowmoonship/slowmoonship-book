-- 入口调用活跃度
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 顶层入口地址
-- Units: 交易数、地址数
-- No remote objects created or modified.

SELECT "to" AS entry_address, COUNT(*) AS tx_count,
       COUNT(DISTINCT "from") AS distinct_senders, COUNT_IF(success) AS succeeded
FROM polygon.transactions
WHERE block_date=DATE '2026-09-10' AND "to" IS NOT NULL AND length(data)>=4
GROUP BY 1 ORDER BY tx_count DESC LIMIT 50;
