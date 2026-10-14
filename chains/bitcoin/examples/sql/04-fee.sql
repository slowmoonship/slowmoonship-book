-- SQL 04: 普通交易手续费
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 交易层金额合计DOUBLE舍入，仅近似；精确费用用JSON整数复核
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
SELECT id, fee AS indexed_fee_btc, input_value - output_value AS computed_fee_btc,
       CAST(round(input_value * 100000000) AS BIGINT)
         - CAST(round(output_value * 100000000) AS BIGINT) AS approximate_fee_sat,
       CAST(round(fee * 100000000) AS BIGINT) / CAST(virtual_size AS DOUBLE) AS sat_per_vb
FROM bitcoin.transactions WHERE block_date = DATE '2009-01-12' AND block_height = 170 AND id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16 AND NOT is_coinbase AND virtual_size > 0;
