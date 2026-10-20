-- 同一交易的Trace与Log计数
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 目标交易
-- Units: 计数与原始Gas参数
-- No remote objects created or modified.

WITH tr AS (
 SELECT tx_hash, COUNT(*) AS trace_rows FROM polygon.traces
 WHERE block_date=DATE '2026-09-10' AND tx_hash=0x1a888adf77836ee9d430c2e449ba226a99804c7e5562d89aa2956aa5b397719a GROUP BY 1
), lg AS (
 SELECT tx_hash, COUNT(*) AS log_rows FROM polygon.logs
 WHERE block_date=DATE '2026-09-10' AND tx_hash=0x1a888adf77836ee9d430c2e449ba226a99804c7e5562d89aa2956aa5b397719a GROUP BY 1
)
SELECT t.hash, t.block_number, t.success, t.gas_used, t.gas_price,
       tr.trace_rows, lg.log_rows
FROM polygon.transactions t LEFT JOIN tr ON t.hash=tr.tx_hash LEFT JOIN lg ON t.hash=lg.tx_hash
WHERE t.block_date=DATE '2026-09-10' AND t.hash=0x1a888adf77836ee9d430c2e449ba226a99804c7e5562d89aa2956aa5b397719a;
