-- C-Chain 每日交易和成功发送地址
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT date_trunc('day', block_time) AS day,
       count(*) AS transactions,
       count_if(success) AS successful_transactions,
       count(DISTINCT CASE WHEN success THEN "from" END) AS successful_sender_addresses
FROM avalanche_c.transactions
WHERE block_date >= DATE '2026-10-01' AND block_date < DATE '2026-10-03'
  AND block_time >= TIMESTAMP '2026-10-01 00:00:00'
  AND block_time < TIMESTAMP '2026-10-03 00:00:00'
GROUP BY 1 ORDER BY 1;
