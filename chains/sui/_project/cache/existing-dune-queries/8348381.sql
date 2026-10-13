SELECT
    date, -- 日期
    object_id, -- Shared Object ID

    COUNT(
        DISTINCT transaction_digest
    ) AS transaction_blocks, -- 当天涉及该 Shared Object 的独立 Transaction Blocks

    COUNT(*) AS interaction_rows, -- 该 Shared Object 在 transaction_objects 中的关系记录数

    MIN(checkpoint) AS first_checkpoint, -- 当天第一次出现的 Checkpoint

    MAX(checkpoint) AS last_checkpoint -- 当天最后一次出现的 Checkpoint
FROM sui.transaction_objects
WHERE date >= CURRENT_DATE - INTERVAL '180' DAY
  AND input_kind = 'SharedInput'
GROUP BY 1, 2;