-- SQL 16: 确认费率与区块时间分布
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 两UTC日；无首次广播字段，不计算确认等待或因果关系
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
SELECT date_trunc('day',block_time) AS utc_block_day, COUNT(*) AS normal_transactions,
       approx_percentile(fee*100000000/CAST(virtual_size AS DOUBLE),0.5) AS median_sat_per_vb,
       SUM(fee)*100000000 / SUM(virtual_size) AS size_weighted_sat_per_vb
FROM bitcoin.transactions WHERE block_date BETWEEN DATE '2024-04-20' AND DATE '2024-04-21'
 AND NOT is_coinbase AND virtual_size>0
GROUP BY 1 ORDER BY 1;
