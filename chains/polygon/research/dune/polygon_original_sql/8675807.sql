-- Query:
-- Polygon PoS Creation Trace Sample ｜ Polygon PoS 合约创建记录样例
--
-- Purpose:
-- Return a small deterministic sample using only the verified creation-trace
-- fields and expose the catalog/schema partition mismatch as an output diagnostic.
--
-- Source table: polygon.creation_traces
-- Grain: One row represents one materialized contract-deployment record; one
-- transaction may create multiple contracts.
-- Time range: Latest complete UTC day, bounded by exposed block_month and block_time;
-- maximum 25 rows returned.
--
-- Important caveats:
-- Verified fields are only block_time, block_number, tx_hash, address, from,
-- code, and block_month. Catalog metadata reports absent block_date as the
-- partition. type, success, and trace_address must not be referenced or inferred.

WITH sampled_creation_traces AS (
    SELECT
        ct.block_time,
        ct.block_number,
        ct.tx_hash,
        ct.address,
        ct."from" AS creator_address,
        ct.code,
        ct.block_month
    FROM polygon.creation_traces AS ct
    WHERE ct.block_month = CAST(date_trunc('month', date_add('day', -1, CURRENT_DATE)) AS DATE)
      AND CAST(ct.block_time AS DATE) = date_add('day', -1, CURRENT_DATE)
    ORDER BY ct.block_number DESC, ct.tx_hash DESC, ct.address DESC
    LIMIT 25
)

SELECT
    block_time AS block_time,
    block_number AS block_number,
    tx_hash AS tx_hash,
    address AS contract_address,
    creator_address AS creator_address,
    code AS deployed_code,
    block_month AS block_month,
    'block_date' AS catalog_reported_partition,
    'block_month' AS schema_exposed_partition,
    'UNRESOLVED: catalog block_date is absent from the verified schema' AS partition_metadata_diagnostic,
    'UNAVAILABLE: type, success, and trace_address are not exposed' AS unsupported_field_diagnostic
FROM sampled_creation_traces
ORDER BY block_number DESC, tx_hash DESC, contract_address DESC;