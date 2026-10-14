-- Case 01 交易定位
-- Status: STATIC_CHECKED; execution: BLOCKED_READ_ONLY_ACCOUNT
-- UTC window; finite scope; no claimed query result.
SELECT hash, block_hash, block_number, block_time, "from", "to", value,
       success, gas_limit, gas_used, gas_price
FROM avalanche_c.transactions
WHERE block_date = DATE '2026-10-12'
  AND hash = 0x566b431b5c10e7c52022943dce0a4aa724cad760eb18de696665ae869fc852d7;
