-- Query:
-- Polygon PoS Transaction Sample ｜ Polygon PoS 交易样例
--
-- Purpose:
-- Return a small deterministic transaction sample covering keys, addresses,
-- value, calldata, status, type, nonce, gas, and EIP-1559-related fields.
--
-- Source table: polygon.transactions
-- Grain: One row represents one Polygon PoS transaction; key uniqueness remains a QA question.
-- Time range: Latest complete UTC calendar day; one block_date partition only; maximum 25 rows returned.
--
-- Important caveats:
-- Calldata is data, not input. to IS NULL is diagnostic and does not by itself
-- define contract creation. Address does not equal user.

WITH sampled_transactions AS (
    SELECT
        t.block_date,
        t.block_time,
        t.block_number,
        t.block_hash,
        t.hash AS tx_hash,
        t."index" AS transaction_index,
        t."from" AS tx_from,
        t."to" AS tx_to,
        t.value,
        t.data,
        t.success,
        t.type AS transaction_type,
        t.nonce,
        t.gas_limit,
        t.gas_price,
        t.gas_used,
        t.max_fee_per_gas,
        t.max_priority_fee_per_gas,
        t.priority_fee_per_gas
    FROM polygon.transactions AS t
    WHERE t.block_date = date_add('day', -1, CURRENT_DATE)
    ORDER BY t.block_number DESC, t."index" DESC
    LIMIT 25
)

SELECT
    block_date AS block_date,
    block_time AS block_time,
    block_number AS block_number,
    block_hash AS block_hash,
    tx_hash AS tx_hash,
    transaction_index AS transaction_index,
    tx_from AS tx_from,
    tx_to AS tx_to,
    value AS value_raw,
    data AS calldata,
    success AS transaction_success,
    transaction_type AS transaction_type,
    nonce AS nonce,
    gas_limit AS gas_limit,
    gas_price AS gas_price,
    gas_used AS gas_used,
    max_fee_per_gas AS max_fee_per_gas,
    max_priority_fee_per_gas AS max_priority_fee_per_gas,
    priority_fee_per_gas AS priority_fee_per_gas
FROM sampled_transactions
ORDER BY block_number DESC, transaction_index DESC;