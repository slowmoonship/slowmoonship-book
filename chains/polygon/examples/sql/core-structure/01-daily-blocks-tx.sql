-- 区块与交易分别聚合
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: UTC日
-- Units: 区块数、交易数
-- No remote objects created or modified.

WITH b AS (
  SELECT date AS day, COUNT(*) AS blocks, MIN(number) AS first_block, MAX(number) AS last_block
  FROM polygon.blocks
  WHERE date >= DATE '2026-09-10' AND date < DATE '2026-09-11' GROUP BY 1
), t AS (
  SELECT block_date AS day, COUNT(*) AS transactions, COUNT_IF(NOT success) AS failed
  FROM polygon.transactions
  WHERE block_date >= DATE '2026-09-10' AND block_date < DATE '2026-09-11' GROUP BY 1
)
SELECT b.*, COALESCE(t.transactions,0) AS transactions, COALESCE(t.failed,0) AS failed
FROM b LEFT JOIN t ON b.day=t.day ORDER BY b.day;
