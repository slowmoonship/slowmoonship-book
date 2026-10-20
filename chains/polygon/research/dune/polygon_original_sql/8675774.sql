-- Query:
-- Polygon PoS Trace Sample ｜ Polygon PoS 执行轨迹样例
--
-- Purpose:
-- Return a small deterministic execution-trace sample for transaction linkage,
-- trace path, call classification, gas, value, and two-level status inspection.
--
-- Source table: polygon.traces
-- Grain: One row represents one execution trace/call frame, not one transaction.
-- Time range: Latest complete UTC day; one block_date partition only; maximum 50 rows returned.
--
-- Important caveats:
-- Several rows may share tx_hash. trace success and tx_success are distinct;
-- null-hash, reward, or system patterns require QA output before interpretation.

WITH sampled_traces AS (
    SELECT
        tr.block_date,
        tr.block_time,
        tr.block_number,
        tr.block_hash,
        tr.tx_hash,
        tr.tx_index,
        tr.trace_address,
        tr.type AS trace_type,
        tr.call_type,
        tr."from" AS trace_from,
        tr."to" AS trace_to,
        tr.address,
        tr.value,
        tr.gas,
        tr.gas_used,
        tr.success AS trace_success,
        tr.tx_success,
        tr.error,
        tr.sub_traces,
        tr.input,
        tr.output
    FROM polygon.traces AS tr
    WHERE tr.block_date = date_add('day', -1, CURRENT_DATE)
    ORDER BY tr.block_number DESC, tr.tx_index DESC, tr.trace_address DESC
    LIMIT 50
)

SELECT
    block_date AS block_date,
    block_time AS block_time,
    block_number AS block_number,
    block_hash AS block_hash,
    tx_hash AS tx_hash,
    tx_index AS transaction_index,
    trace_address AS trace_address,
    trace_type AS trace_type,
    call_type AS call_type,
    trace_from AS trace_from,
    trace_to AS trace_to,
    address AS trace_address_field,
    value AS value_raw,
    gas AS gas,
    gas_used AS gas_used,
    trace_success AS trace_success,
    tx_success AS transaction_success,
    error AS error,
    sub_traces AS sub_trace_count,
    input AS input_data,
    output AS output_data
FROM sampled_traces
ORDER BY block_number DESC, transaction_index DESC, trace_address DESC;