-- Ethereum侧Fxwithdraw候选
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: Ethereum侧特定FxTunnel事件
-- Units: rootToken原始整数，未缩放
-- No remote objects created or modified.

SELECT contract_address, evt_block_time, evt_block_number, evt_tx_hash, evt_index,
       rootToken, userAddress, childToken, amount AS amount_raw
FROM polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxwithdrawerc20
WHERE evt_block_date >= DATE '2026-08-01' AND evt_block_date < DATE '2026-08-02'
ORDER BY evt_block_number, evt_index LIMIT 100;
