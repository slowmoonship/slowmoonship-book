-- Purpose:
-- Describe recent Bitcoin transaction-output value buckets as output rows,
-- not wallet wealth, users, transfers, or economic transaction volume.
--
-- Source table grain:
-- bitcoin.outputs has one row per transaction output.
--
-- Time range:
-- The most recent seven complete UTC calendar days ending two days before today.

-- Read only output values from the partition-pruned seven-day window.
WITH filtered_outputs AS (
    SELECT
        value
    FROM bitcoin.outputs
    WHERE block_date >= CURRENT_DATE - INTERVAL '8' DAY
      AND block_date < CURRENT_DATE - INTERVAL '1' DAY
),

-- Assign each output row to a BTC-denominated value bucket.
bucketed_outputs AS (
    SELECT
        CASE
            WHEN value < 0.001 THEN '< 0.001 BTC'
            WHEN value < 0.01 THEN '0.001 - 0.01 BTC'
            WHEN value < 0.1 THEN '0.01 - 0.1 BTC'
            WHEN value < 1 THEN '0.1 - 1 BTC'
            WHEN value < 10 THEN '1 - 10 BTC'
            WHEN value < 100 THEN '10 - 100 BTC'
            ELSE '>= 100 BTC'
        END AS value_bucket,
        CASE
            WHEN value < 0.001 THEN 1
            WHEN value < 0.01 THEN 2
            WHEN value < 0.1 THEN 3
            WHEN value < 1 THEN 4
            WHEN value < 10 THEN 5
            WHEN value < 100 THEN 6
            ELSE 7
        END AS bucket_order,
        value
    FROM filtered_outputs
),

-- Aggregate output rows and assigned BTC by bucket.
bucket_summary AS (
    SELECT
        value_bucket,
        bucket_order,
        COUNT(*) AS output_count,
        SUM(value) AS output_value_btc
    FROM bucketed_outputs
    GROUP BY 1, 2
)

SELECT
    value_bucket,           -- BTC value range assigned to each transaction output
    output_count,           -- Number of output rows in the bucket
    output_value_btc        -- BTC assigned to output rows in the bucket; not wallet wealth
FROM bucket_summary
ORDER BY bucket_order