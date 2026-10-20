-- 从Raw日志读取LGNS转账
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: Transfer事件
-- Units: LGNS原始整数/1e9
-- No remote objects created or modified.

SELECT block_time, block_number, tx_hash, "index" AS log_index,
       varbinary_substring(topic1,13,20) AS sender,
       varbinary_substring(topic2,13,20) AS recipient,
       varbinary_to_uint256(data) AS amount_raw,
       CAST(varbinary_to_uint256(data) AS DOUBLE)/1e9 AS amount_lgns
FROM polygon.logs
WHERE block_date=DATE '2024-03-06' AND contract_address=0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01
  AND topic0=0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef AND length(data)=32
ORDER BY block_number, "index" LIMIT 100;
