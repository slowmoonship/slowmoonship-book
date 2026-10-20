-- 固定DAI合约的转账与价格覆盖
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: UTC日
-- Units: DAI；已有价格覆盖的USD
-- No remote objects created or modified.

SELECT block_date, COUNT(*) AS transfer_rows, SUM(amount) AS transferred_dai,
       COUNT_IF(amount_usd IS NULL) AS missing_usd_rows,
       SUM(amount_usd) AS covered_usd_value
FROM tokens.transfers
WHERE blockchain='polygon' AND block_month=DATE '2026-09-01'
  AND block_date=DATE '2026-09-10' AND contract_address=0x8f3cf7ad23cd3cadbd9735aff958023239c6a063
GROUP BY 1;
