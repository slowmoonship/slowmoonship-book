-- SQL 01: 定位单笔真实交易
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- Source: live Dune Catalog retrieved 2026-10-13; see research/bitcoin_schema.md
-- Scope: 一行确认交易；Case01；BTC DOUBLE
-- Evidence: INDEXED_DERIVED; DOUBLE BTC is approximate, not integer audit proof.
SELECT id, block_height, block_hash, block_time, input_count, output_count,
       input_value, output_value, fee, size, virtual_size, is_coinbase
FROM bitcoin.transactions WHERE block_date = DATE '2009-01-12' AND block_height = 170 AND id = 0xf4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16;
