-- Purpose:
-- Compare output creation events with prior-output spending events without
-- mislabeling their difference as daily UTXO-set growth.
--
-- Source table grain:
-- query_8471410 has one row per complete UTC date, derived from transaction rows.
-- outputs_created uses output creation date; outputs_spent uses the spending input date.
--
-- Time range:
-- The most recent 14 complete UTC calendar days inherited from Query 8471410.

-- Preserve the two different event-time semantics from the reusable structure query.
WITH daily_utxo_events AS (
    SELECT
        date,
        outputs_created,
        outputs_spent,
        output_value_created_btc,
        output_value_spent_btc
    FROM query_8471410
)

SELECT
    date,                            -- Complete UTC event date
    outputs_created,                 -- Transaction outputs created on the date
    outputs_spent,                   -- Historical outputs consumed by non-coinbase inputs on the date
    output_value_created_btc,        -- BTC assigned to newly created outputs on the date
    output_value_spent_btc           -- BTC value of historical outputs consumed on the date
FROM daily_utxo_events
ORDER BY date