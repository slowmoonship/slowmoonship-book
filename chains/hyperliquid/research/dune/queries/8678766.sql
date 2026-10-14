-- SMS HYPE 10: Hyperliquid Overview Metrics — 24H KPIs across 4 HyperEVM tables
-- Single Query that produces 6 KPI rows for the latest complete UTC day.
-- Each row: metric_name, metric_value, source_table, scope.

WITH
latest_day AS (
    SELECT CAST(CURRENT_DATE - INTERVAL '1' DAY AS DATE) AS kpi_date
),

blocks_kpi AS (
    SELECT
        'hyperevm_blocks_24h' AS metric_name,
        CAST(COUNT(*) AS DOUBLE) AS metric_value,
        'hyperevm.blocks' AS source_table,
        'HyperEVM block headers in the latest complete UTC day' AS metric_scope
    FROM hyperevm.blocks b, latest_day ld
    WHERE b.date = ld.kpi_date
),

transactions_kpi AS (
    SELECT
        'hyperevm_transactions_24h' AS metric_name,
        CAST(COUNT(*) AS DOUBLE) AS metric_value,
        'hyperevm.transactions' AS source_table,
        'HyperEVM transaction rows in the latest complete UTC day' AS metric_scope
    FROM hyperevm.transactions t, latest_day ld
    WHERE t.block_date = ld.kpi_date
),

failure_rate_kpi AS (
    SELECT
        'hyperevm_transaction_failure_rate_24h' AS metric_name,
        CAST(COUNT_IF(NOT success) AS DOUBLE) / NULLIF(CAST(COUNT(*) AS DOUBLE), 0e0) AS metric_value,
        'hyperevm.transactions' AS source_table,
        'share of transactions with success=false in the latest complete UTC day' AS metric_scope
    FROM hyperevm.transactions t, latest_day ld
    WHERE t.block_date = ld.kpi_date
),

logs_kpi AS (
    SELECT
        'hyperevm_event_logs_24h' AS metric_name,
        CAST(COUNT(*) AS DOUBLE) AS metric_value,
        'hyperevm.logs' AS source_table,
        'HyperEVM raw event-log rows in the latest complete UTC day' AS metric_scope
    FROM hyperevm.logs l, latest_day ld
    WHERE l.block_date = ld.kpi_date
),

corewriter_kpi AS (
    SELECT
        'hyperevm_corewriter_calls_24h' AS metric_name,
        CAST(COUNT(*) AS DOUBLE) AS metric_value,
        'hyperevm.traces' AS source_table,
        'HyperEVM traces with to=0x3333...3333 (CoreWriter) in the latest complete UTC day' AS metric_scope
    FROM hyperevm.traces t, latest_day ld
    WHERE t.block_date = ld.kpi_date
      AND t."to" = 0x3333333333333333333333333333333333333333
),

read_precompile_kpi AS (
    SELECT
        'hyperevm_hypercore_read_precompile_calls_24h' AS metric_name,
        CAST(COUNT(*) AS DOUBLE) AS metric_value,
        'hyperevm.traces' AS source_table,
        'HyperEVM traces targeting documented HyperCore read precompiles 0x0800-0x0814 in the latest complete UTC day' AS metric_scope
    FROM hyperevm.traces t, latest_day ld
    WHERE t.block_date = ld.kpi_date
      AND t."to" IN (
          0x0000000000000000000000000000000000000800,
          0x0000000000000000000000000000000000000801,
          0x0000000000000000000000000000000000000802,
          0x0000000000000000000000000000000000000803,
          0x0000000000000000000000000000000000000804,
          0x0000000000000000000000000000000000000805,
          0x0000000000000000000000000000000000000806,
          0x0000000000000000000000000000000807,
          0x0000000000000000000000000000000808,
          0x0000000000000000000000000000000809,
          0x000000000000000000000000000000080a,
          0x000000000000000000000000000000080b,
          0x000000000000000000000000000000080c,
          0x000000000000000000000000000000080d,
          0x000000000000000000000000000000080e,
          0x000000000000000000000000000000080f,
          0x0000000000000000000000000000000810,
          0x0000000000000000000000000000000811,
          0x0000000000000000000000000000000812,
          0x0000000000000000000000000000000813,
          0x0000000000000000000000000000000814
      )
)

SELECT
    (SELECT kpi_date FROM latest_day) AS date,
    metric_name,
    metric_value,
    source_table,
    metric_scope
FROM (
    SELECT * FROM blocks_kpi
    UNION ALL SELECT * FROM transactions_kpi
    UNION ALL SELECT * FROM failure_rate_kpi
    UNION ALL SELECT * FROM logs_kpi
    UNION ALL SELECT * FROM corewriter_kpi
    UNION ALL SELECT * FROM read_precompile_kpi
) all_kpis
ORDER BY metric_name;
