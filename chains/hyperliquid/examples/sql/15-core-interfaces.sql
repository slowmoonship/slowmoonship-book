-- 观察到多少CoreWriter或BTC Oracle接口调用？
-- Grain: one interface-address-day
-- Unit: trace count, transactions, caller addresses
-- Logic: 只证明接口调用；只选择已核对0807与CoreWriter，不推断Core成功
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT "to" AS interface_address, COUNT(*) AS calls,
 COUNT(DISTINCT tx_hash) AS transactions, COUNT(DISTINCT "from") AS callers,
 COUNT_IF(success) AS successful_evm_call_frames
FROM hyperevm.traces
WHERE block_date = DATE '2026-10-12'
 AND "to" IN (0x3333333333333333333333333333333333333333,
 0x0000000000000000000000000000000000000807)
GROUP BY 1;
