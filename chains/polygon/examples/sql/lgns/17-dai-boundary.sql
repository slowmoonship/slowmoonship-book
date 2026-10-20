-- 六合约DAI边界与内部流量
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 指定日、指定集合
-- Units: DAI18位
-- No remote objects created or modified.

WITH system(address) AS (VALUES (0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01),(0x99a57e6c8558bc6689f894e068733adf83c19725),(0x1964ca90474b11ffd08af387b110ba6c96251bfc),
 (0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321),(0x07ff4e06865de4934409aa6ecea503b08cc1c78d),(0x882df4b0fb50a229c3b4124eb18c759911485bfb)),
events AS (
SELECT d.evt_tx_hash, d.evt_index, CAST(d.value AS DOUBLE)/1e18 AS dai,
       s1.address IS NOT NULL AS from_system, s2.address IS NOT NULL AS to_system
FROM maker_polygon.dai_evt_transfer d
LEFT JOIN system s1 ON d."from"=s1.address LEFT JOIN system s2 ON d."to"=s2.address
WHERE d.evt_block_date=DATE '2024-03-06' AND d.contract_address=0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
)
SELECT SUM(CASE WHEN NOT from_system AND to_system THEN dai ELSE 0 END) AS external_in_dai,
       SUM(CASE WHEN from_system AND NOT to_system THEN dai ELSE 0 END) AS external_out_dai,
       SUM(CASE WHEN from_system AND to_system THEN dai ELSE 0 END) AS internal_dai,
       COUNT(*) AS included_events
FROM events WHERE from_system OR to_system;
