-- 工厂创建候选
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 物化创建记录
-- Units: 地址、字节码
-- No remote objects created or modified.

SELECT block_time, block_number, tx_hash, address AS created_address, "from" AS creator, code
FROM polygon.creation_traces
WHERE block_month=DATE '2026-09-01'
  AND block_time>=TIMESTAMP '2026-09-10 00:00:00'
  AND block_time<TIMESTAMP '2026-09-11 00:00:00'
ORDER BY block_number DESC LIMIT 50;
