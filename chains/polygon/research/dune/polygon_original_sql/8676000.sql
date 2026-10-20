WITH filtered_decoded_supply_events AS (
    SELECT
        evt_block_date,
        evt_block_time,
        evt_block_number,
        evt_tx_hash,
        evt_index,
        contract_address,
        reserve,
        "user" AS user_address,
        "onBehalfOf" AS on_behalf_of_address,
        amount AS amount_raw,
        "referralCode" AS referral_code
    FROM aave_v3_polygon.pool_evt_supply
    WHERE evt_block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '7' DAY
            AS date
        )
      AND evt_block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
      AND evt_block_time >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '7' DAY
            AS timestamp
        )
      AND evt_block_time < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS timestamp
        )
),
filtered_raw_logs AS (
    SELECT
        block_date,
        block_time,
        block_number,
        tx_hash,
        "index" AS log_index,
        contract_address,
        topic0,
        data
    FROM polygon.logs
    WHERE block_date >= CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '7' DAY
            AS date
        )
      AND block_date < CAST(
            date_trunc('day', current_timestamp AT TIME ZONE 'UTC')
            AS date
        )
),
decoded_supply_with_raw_log AS (
    SELECT
        d.evt_block_time AS block_time,
        d.evt_block_number AS block_number,
        d.evt_tx_hash AS tx_hash,
        d.evt_index AS log_index,
        d.contract_address,
        d.reserve AS reserve_address,
        d.user_address,
        d.on_behalf_of_address,
        d.amount_raw,
        d.referral_code,
        r.contract_address AS raw_contract_address,
        r.topic0 AS raw_topic0,
        r.data AS raw_data
    FROM filtered_decoded_supply_events AS d
    INNER JOIN filtered_raw_logs AS r
        ON r.tx_hash = d.evt_tx_hash
       AND r.log_index = d.evt_index
)
SELECT
    block_time,
    block_number,
    tx_hash,
    contract_address,
    'Supply' AS event_name,
    log_index,
    reserve_address,
    user_address,
    on_behalf_of_address,
    amount_raw,
    referral_code,
    contract_address = raw_contract_address AS contract_address_matches_raw_log,
    raw_topic0,
    raw_data
FROM decoded_supply_with_raw_log
ORDER BY block_time DESC, tx_hash, log_index
LIMIT 200;