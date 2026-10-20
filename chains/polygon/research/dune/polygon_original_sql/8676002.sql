WITH daily_fx_deposit_events AS (
    SELECT
        evt_block_date AS date,
        COUNT(*) AS event_count
    FROM polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20
    WHERE evt_block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS date
        )
      AND evt_block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
      AND evt_block_time >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS timestamp
        )
      AND evt_block_time < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS timestamp
        )
    GROUP BY 1
),
daily_fx_withdraw_events AS (
    SELECT
        evt_block_date AS date,
        COUNT(*) AS event_count
    FROM polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxwithdrawerc20
    WHERE evt_block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS date
        )
      AND evt_block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
      AND evt_block_time >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY
            AS timestamp
        )
      AND evt_block_time < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS timestamp
        )
    GROUP BY 1
),
daily_boundary_events AS (
    SELECT
        date,
        'fx_deposit_erc20_event' AS interaction_type,
        event_count
    FROM daily_fx_deposit_events
    UNION ALL
    SELECT
        date,
        'fx_withdraw_erc20_event' AS interaction_type,
        event_count
    FROM daily_fx_withdraw_events
)
SELECT
    date,
    interaction_type,
    event_count
FROM daily_boundary_events
ORDER BY date, interaction_type;