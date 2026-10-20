-- sLGNS比率与Index分开缩放
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: LogRebase事件
-- Units: 无量纲比率；sLGNS Index
-- No remote objects created or modified.

SELECT block_time, block_number, tx_hash, "index" AS log_index,
       varbinary_to_uint256(topic1) AS epoch,
       varbinary_to_uint256(varbinary_substring(data,1,32)) AS rebase_raw,
       CAST(varbinary_to_uint256(varbinary_substring(data,1,32)) AS DOUBLE)/1e18 AS rebase_rate,
       varbinary_to_uint256(varbinary_substring(data,33,32)) AS index_raw,
       CAST(varbinary_to_uint256(varbinary_substring(data,33,32)) AS DOUBLE)/1e9 AS slgns_index
FROM polygon.logs
WHERE block_date=DATE '2024-03-06' AND contract_address=0x99a57e6c8558bc6689f894e068733adf83c19725
  AND topic0=0x6012dbce857565c4a40974aa5de8373a761fc429077ef0c8c8611d1e20d63fb2 AND length(data)=64 ORDER BY block_number, "index";
