-- 已明确Staked事件
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: Staked事件
-- Units: LGNS9位
-- No remote objects created or modified.

SELECT block_time, block_number, tx_hash, "index" AS log_index,
       varbinary_substring(topic1,13,20) AS recipient,
       varbinary_to_uint256(data) AS lgns_raw,
       CAST(varbinary_to_uint256(data) AS DOUBLE)/1e9 AS staked_lgns
FROM polygon.logs
WHERE block_date=DATE '2024-03-06' AND contract_address=0x1964ca90474b11ffd08af387b110ba6c96251bfc
  AND topic0=0x9e71bc8eea02a63969f509818f2dafb9254532904319f9dbda79b67bd34a5f3d AND length(data)=32
ORDER BY block_number, "index" LIMIT 100;
