-- Query:
-- Polygon PoS Decoded Supply Event Sample ｜ Polygon PoS 已解码 Supply 事件样例
--
-- Purpose:
-- Demonstrate a bounded raw-log-to-decoded-event mapping with the verified
-- aave_v3_polygon.pool_evt_supply table and human-readable event parameters.
--
-- Source tables: aave_v3_polygon.pool_evt_supply and polygon.logs
-- Time range: Latest complete UTC calendar day; decoded and raw-log scans limited to that date.
-- Maximum 25 decoded rows returned.

WITH sampled_decoded_supply_events AS (
    SELECT
        d.evt_block_date,
        d.evt_block_time,
        d.evt_block_number,
        d.evt_tx_hash,
        d.evt_tx_from,
        d.evt_tx_to,
        d.evt_tx_index,
        d.evt_index,
        d.contract_address,
        d.reserve,
        d.user,
        d."onBehalfOf" AS on_behalf_of,
        d.amount,
        d."referralCode" AS referral_code
    FROM aave_v3_polygon.pool_evt_supply AS d
    WHERE d.evt_block_date = date_add('day', -1, CURRENT_DATE)
    ORDER BY d.evt_block_time DESC, d.evt_tx_hash DESC, d.evt_index DESC
    LIMIT 25
),

filtered_raw_logs AS (
    SELECT
        l.block_date,
        l.tx_hash,
        l."index" AS log_index,
        l.contract_address,
        l.topic0,
        l.data
    FROM polygon.logs AS l
    WHERE l.block_date = date_add('day', -1, CURRENT_DATE)
),

decoded_with_raw_log AS (
    SELECT
        d.evt_block_date,
        d.evt_block_time,
        d.evt_block_number,
        d.evt_tx_hash,
        d.evt_tx_from,
        d.evt_tx_to,
        d.evt_tx_index,
        d.evt_index,
        d.contract_address,
        d.reserve,
        d.user,
        d.on_behalf_of,
        d.amount,
        d.referral_code,
        r.topic0,
        r.data AS raw_log_data,
        r.tx_hash IS NOT NULL AS raw_log_match_found
    FROM sampled_decoded_supply_events AS d
    LEFT JOIN filtered_raw_logs AS r
        ON r.block_date = d.evt_block_date
       AND r.tx_hash = d.evt_tx_hash
       AND r.log_index = d.evt_index
       AND r.contract_address = d.contract_address
)

SELECT
    evt_block_date AS block_date,
    evt_block_time AS block_time,
    evt_block_number AS block_number,
    evt_tx_hash AS tx_hash,
    evt_tx_from AS tx_from,
    evt_tx_to AS tx_to,
    evt_tx_index AS transaction_index,
    evt_index AS event_index,
    contract_address AS contract_address,
    'Supply' AS event_name,
    reserve AS reserve,
    user AS user_address,
    on_behalf_of AS on_behalf_of_address,
    amount AS amount_raw,
    referral_code AS referral_code,
    topic0 AS raw_topic0,
    raw_log_data AS raw_log_data,
    raw_log_match_found AS raw_log_match_found
FROM decoded_with_raw_log
ORDER BY block_time DESC, tx_hash DESC, event_index DESC
LIMIT 25;