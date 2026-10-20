-- DEX成交段与交易数
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 项目
-- Units: 段数、交易数、USD
-- No remote objects created or modified.

SELECT project, COUNT(*) AS trade_segments, COUNT(DISTINCT tx_hash) AS transactions,
       COUNT_IF(amount_usd IS NULL) AS missing_price_segments,
       SUM(amount_usd) AS pool_segment_volume_usd
FROM dex.trades
WHERE blockchain='polygon' AND block_month=DATE '2026-09-01'
  AND block_date=DATE '2026-09-10' GROUP BY 1 ORDER BY trade_segments DESC;
