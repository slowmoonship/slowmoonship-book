-- Last complete UTC day; deterministic bounded sample. No assumption of send/receive pairing on C-Chain.
SELECT
    evt_block_time,
    evt_tx_hash,
    evt_index,
    contract_address,
    "messageID",
    "destinationBlockchainID",
    message
FROM avalanche_teleporter_avalanche_c.teleportermessenger_evt_sendcrosschainmessage
WHERE evt_block_date = current_date - interval '1' day
  AND evt_block_time >= current_date - interval '1' day
  AND evt_block_time < current_date
ORDER BY evt_block_time DESC, evt_tx_hash DESC, evt_index DESC
LIMIT 5