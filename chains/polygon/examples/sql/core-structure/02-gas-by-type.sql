-- 按交易类型观察费用
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 交易类型
-- Units: Gas；POL近似值
-- No remote objects created or modified.

SELECT type, COUNT(*) AS rows, COUNT_IF(success) AS succeeded,
       SUM(CAST(gas_used AS DOUBLE)) AS gas_used,
       SUM(CAST(gas_used AS DOUBLE)*CAST(gas_price AS DOUBLE)/1e18) AS fee_pol_approx,
       approx_percentile(CAST(gas_used AS DOUBLE)*CAST(gas_price AS DOUBLE)/1e18,0.5) AS median_fee_pol_approx
FROM polygon.transactions
WHERE block_date=DATE '2026-09-10' GROUP BY 1 ORDER BY rows DESC;
