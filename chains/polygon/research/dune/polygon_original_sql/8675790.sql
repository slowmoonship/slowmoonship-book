-- Query:
-- Polygon PoS Log Sample ｜ Polygon PoS 日志样例
--
-- Purpose:
-- Return a small deterministic raw-log sample showing transaction identity,
-- emitting contract, indexed topics, data payload, and parent-transaction fields.
--
-- Source table: polygon.logs
-- Grain: One row represents one raw EVM log emitted during execution.
-- Time range: Latest complete UTC day; one block_date partition only; maximum 50 rows returned.

WITH sampled_logs AS (
    SELECT
        l.block_date,
        l.block_time,
        l.block_number,
        l.block_hash,
        l.tx_hash,
        l.tx_index,
        l."index" AS log_index,
        l.contract_address,
        l.topic0,
        l.topic1,
        l.topic2,
        l.topic3,
        l.data,
        l.tx_from,
        l.tx_to
    FROM polygon.logs AS l
    WHERE l.block_date = date_add('day', -1, CURRENT_DATE)
    ORDER BY l.block_number DESC, l.tx_index DESC, l."index" DESC
    LIMIT 50
)

SELECT
    block_date AS block_date,
    block_time AS block_time,
    block_number AS block_number,
    block_hash AS block_hash,
    tx_hash AS tx_hash,
    tx_index AS transaction_index,
    log_index AS log_index,
    contract_address AS contract_address,
    topic0 AS topic0,
    topic1 AS topic1,
    topic2 AS topic2,
    topic3 AS topic3,
    data AS data,
    tx_from AS tx_from,
    tx_to AS tx_to
FROM sampled_logs
ORDER BY block_number DESC, transaction_index DESC, log_index DESC;