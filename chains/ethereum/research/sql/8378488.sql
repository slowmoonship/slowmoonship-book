-- Source table grain:
-- One row in ethereum.traces represents one top-level or internal execution trace.
-- Relationship:
-- One Ethereum transaction can produce multiple trace rows.
-- Therefore trace_count is not transaction_count.
-- Scope:
-- Transaction-linked traces only (tx_hash IS NOT NULL), over the latest 90 complete UTC days.
-- The "to" field is reported as a destination address, not automatically as a verified contract.

-- Aggregate transaction-linked trace rows into one row per UTC day.
WITH daily_contract_execution AS (
    SELECT
        block_date AS date,                              -- UTC partition date of the trace
        COUNT(*) AS trace_count,                         -- Number of transaction-linked trace rows
        COUNT(DISTINCT tx_hash) AS unique_transactions,  -- Distinct parent transactions represented
        COUNT(DISTINCT "to") AS unique_destination_addresses, -- Distinct non-null trace destinations
        COUNT_IF(type = 'call') AS call_count,           -- Trace rows whose documented type is call
        COUNT_IF(success = FALSE) AS failed_trace_count, -- Trace-level execution failures
        COUNT_IF(tx_success = FALSE) AS parent_failed_trace_count, -- Trace rows whose parent transaction failed
        CAST(COUNT(*) AS DOUBLE)
            / NULLIF(COUNT(DISTINCT tx_hash), 0) AS avg_traces_per_transaction -- Mean trace rows per represented transaction
    FROM ethereum.traces
    WHERE block_date >= CURRENT_DATE - INTERVAL '90' DAY
      AND block_date < CURRENT_DATE
      AND tx_hash IS NOT NULL
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    trace_count AS trace_count,                          -- Transaction-linked trace row count
    unique_transactions AS unique_transactions,          -- Distinct parent transaction count
    unique_destination_addresses AS unique_destination_addresses, -- Distinct trace destinations
    call_count AS call_count,                            -- Call-type trace count
    failed_trace_count AS failed_trace_count,            -- Failed trace count
    parent_failed_trace_count AS parent_failed_trace_count, -- Traces belonging to failed parent transactions
    avg_traces_per_transaction AS avg_traces_per_transaction -- Mean traces per represented transaction
FROM daily_contract_execution
ORDER BY date;