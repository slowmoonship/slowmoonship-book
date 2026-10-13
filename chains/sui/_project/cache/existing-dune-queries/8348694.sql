WITH checkpoint_raw AS (
    SELECT
        date, -- Checkpoint 日期
        epoch, -- Epoch
        sequence_number, -- 当前 Checkpoint 顺序号
        timestamp_ms, -- 当前 Checkpoint 时间戳
        end_of_epoch, -- 是否为 Epoch 最后一个 Checkpoint
        LAG(sequence_number) OVER (
            ORDER BY sequence_number
        ) AS prev_sequence_number, -- 前一个 Checkpoint 顺序号
        LAG(timestamp_ms) OVER (
            ORDER BY sequence_number
        ) AS prev_timestamp_ms -- 前一个 Checkpoint 时间戳
    FROM sui.checkpoints
    WHERE date >= CURRENT_DATE - INTERVAL '366' DAY
),

checkpoint_gap AS (
    SELECT
        date, -- 日期
        epoch, -- Epoch
        sequence_number, -- Checkpoint 顺序号
        end_of_epoch, -- 是否 Epoch 结束
        sequence_number - prev_sequence_number AS sequence_step, -- Sequence 步长
        CAST(timestamp_ms - prev_timestamp_ms AS DOUBLE) / 1000.0 AS checkpoint_gap_seconds -- Checkpoint Gap，秒
    FROM checkpoint_raw
)

SELECT
    date, -- 日期
    epoch, -- Epoch
    sequence_number, -- Checkpoint 顺序号
    checkpoint_gap_seconds, -- Checkpoint 时间间隔，秒
    sequence_step, -- Sequence 是否连续
    end_of_epoch -- 是否位于 Epoch 结束 Checkpoint
FROM checkpoint_gap
WHERE date >= CURRENT_DATE - INTERVAL '365' DAY
  AND sequence_step = 1
  AND checkpoint_gap_seconds >= 10
ORDER BY checkpoint_gap_seconds DESC;