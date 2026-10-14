-- Purpose:
-- Show recent Bitcoin output locking-script classifications and address parse gaps.
--
-- Source table grain:
-- bitcoin.outputs has one row per transaction output. Its type/address fields are
-- structured interpretations of the output locking script, not account identities.
--
-- Time range:
-- The most recent seven complete UTC calendar days ending two days before today.

-- Read script and address fields from the partition-pruned seven-day output window.
WITH filtered_outputs AS (
    SELECT
        type,
        address,
        value
    FROM bitcoin.outputs
    WHERE block_date >= CURRENT_DATE - INTERVAL '8' DAY
      AND block_date < CURRENT_DATE - INTERVAL '1' DAY
),

-- Aggregate actual Dune script-type values without hardcoding an expected enum.
script_type_summary AS (
    SELECT
        COALESCE(type, 'NULL / unclassified') AS script_type,
        COUNT(*) AS output_count,
        COUNT_IF(address IS NULL) AS null_address_output_count,
        SUM(value) AS output_value_btc
    FROM filtered_outputs
    GROUP BY 1
),

-- Add each category's share of output rows.
script_type_with_share AS (
    SELECT
        script_type,
        output_count,
        CAST(output_count AS DOUBLE) / NULLIF(SUM(output_count) OVER (), 0) AS output_count_share,
        null_address_output_count,
        output_value_btc
    FROM script_type_summary
)

SELECT
    script_type,                       -- Actual Dune locking-script/address classification
    output_count,                      -- Transaction output rows with this classification
    output_count_share,                -- Share of recent output rows in this classification
    null_address_output_count,         -- Rows where no address representation was parsed
    output_value_btc                   -- BTC assigned to these outputs; not wallet wealth
FROM script_type_with_share
ORDER BY output_count DESC