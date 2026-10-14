-- Purpose:
-- Measure Bitcoin transaction fees from the verified precomputed transaction fee field.
--
-- Source table grain:
-- query_8471410 has one row per complete UTC date, derived from non-coinbase
-- bitcoin.transactions fee values. Fee is input_value minus output_value in BTC.
--
-- Time range:
-- The most recent 14 complete UTC calendar days inherited from Query 8471410.

-- Select fee metrics without joining prices or mixing fees with block subsidy.
WITH daily_fees AS (
    SELECT
        date,
        total_fees_btc,
        avg_fee_btc,
        median_fee_btc
    FROM query_8471410
)

SELECT
    date,                 -- Complete UTC calendar date
    total_fees_btc,       -- Sum of non-coinbase transaction fees in BTC
    avg_fee_btc,          -- Mean non-coinbase transaction fee in BTC
    median_fee_btc        -- Approximate median non-coinbase transaction fee in BTC
FROM daily_fees
ORDER BY date