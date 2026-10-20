-- Query:
-- Polygon PoS Block Sample ｜ Polygon PoS 区块样例
--
-- Purpose:
-- Return a small deterministic sample of block-header rows for grain and field inspection.
-- 返回少量确定性的区块头样例，用于检查表粒度与字段。
--
-- Source table: polygon.blocks
-- Grain: One row represents one Polygon PoS block header; uniqueness remains a QA question.
-- Time range: Latest complete UTC calendar day; one date partition only; maximum 25 rows returned.
--
-- Important caveats:
-- This sample is not a completeness, uniqueness, or performance result.

WITH sampled_blocks AS (
    SELECT
        b.date AS block_date,
        b.time AS block_time,
        b.number AS block_number,
        b.hash AS block_hash,
        b.parent_hash,
        b.gas_limit,
        b.gas_used,
        b.base_fee_per_gas,
        b.miner,
        b.size
    FROM polygon.blocks AS b
    WHERE b.date = date_add('day', -1, CURRENT_DATE)
    ORDER BY b.number DESC
    LIMIT 25
)

SELECT
    block_date AS block_date,
    block_time AS block_time,
    block_number AS block_number,
    block_hash AS block_hash,
    parent_hash AS parent_hash,
    gas_limit AS gas_limit,
    gas_used AS gas_used,
    base_fee_per_gas AS base_fee_per_gas,
    miner AS miner,
    size AS block_size_bytes
FROM sampled_blocks
ORDER BY block_number DESC;