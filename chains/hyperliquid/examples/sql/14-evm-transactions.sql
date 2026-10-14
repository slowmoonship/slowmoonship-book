-- HyperEVM一天的交易执行活动？
-- Grain: UTC day
-- Unit: count and approximate native HYPE fee
-- Logic: to不是自动合约；浮点Gas费用为近似且不含全部系统业务
-- STATIC_CHECKED; NOT_EXECUTED. No runtime rows supplied.
SELECT block_date, COUNT(*) AS user_transactions,
 COUNT_IF(NOT success) AS failed_transactions,
 COUNT(DISTINCT "from") AS sender_addresses,
 SUM(CAST(gas_used AS DOUBLE) * CAST(gas_price AS DOUBLE) / 1e18) AS approximate_gas_fee_hype
FROM hyperevm.transactions
WHERE block_date = DATE '2026-10-12'
GROUP BY 1;
