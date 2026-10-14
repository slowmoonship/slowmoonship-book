-- DEX 成交段与独立交易数
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT project, count(*) AS trade_segments, count(DISTINCT tx_hash) AS distinct_transactions,
       count_if(amount_usd IS NULL) AS missing_valuation_segments,
       sum(amount_usd) AS priced_segment_volume_usd
FROM dex.trades
WHERE blockchain = 'avalanche_c'
  AND block_date >= DATE '2026-10-01' AND block_date < DATE '2026-10-03'
  AND block_time >= TIMESTAMP '2026-10-01 00:00:00'
  AND block_time < TIMESTAMP '2026-10-03 00:00:00'
GROUP BY 1 ORDER BY 2 DESC;
