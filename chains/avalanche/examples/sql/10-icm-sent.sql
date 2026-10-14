-- C-Chain 发送事件与窗口内消息身份
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT contract_address, destinationBlockchainID,
       count(*) AS send_events, count(DISTINCT messageID) AS window_distinct_message_ids
FROM avalanche_teleporter_avalanche_c.teleportermessenger_evt_sendcrosschainmessage
WHERE evt_block_date = DATE '2026-09-10'
  AND evt_block_time >= TIMESTAMP '2026-09-10 00:00:00'
  AND evt_block_time < TIMESTAMP '2026-09-11 00:00:00'
GROUP BY 1, 2 ORDER BY 3 DESC;
