-- 标准Upgraded事件候选
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 标准事件签名匹配日志
-- Units: 地址/事件
-- No remote objects created or modified.

SELECT contract_address, block_number, block_time, tx_hash, "index" AS log_index,
       varbinary_substring(topic1,13,20) AS candidate_implementation
FROM polygon.logs
WHERE block_date=DATE '2026-09-10'
  AND topic0=keccak(to_utf8('Upgraded(address)'))
ORDER BY block_number, "index" LIMIT 100;
