-- Purpose:
-- Show Bitcoin's special coinbase transaction and separate its total outputs
-- into the block subsidy and transaction-fee components.
--
-- Source table grain:
-- query_8471410 has one row per date from bitcoin.transactions, including explicit
-- is_coinbase classification and coinbase output_value.
-- query_8471408 has one row per date from bitcoin.blocks with mint_reward,
-- total_fees, and total_reward fields.
--
-- Time range:
-- The 14 complete UTC days shared by Query 8471410 and Query 8471408.

-- Join daily transaction-level coinbase facts to block-level reward components.
WITH daily_coinbase AS (
    SELECT
        t.date,
        t.coinbase_transaction_count,
        t.total_coinbase_output_btc,
        b.mint_reward_btc,
        b.total_fees_btc,
        b.total_reward_btc
    FROM query_8471410 AS t
    INNER JOIN query_8471408 AS b
        ON t.date = b.date
)

SELECT
    date,                           -- Complete UTC calendar date
    coinbase_transaction_count,     -- Transactions classified as coinbase; normally one per block
    total_coinbase_output_btc,      -- BTC assigned to outputs of coinbase transactions
    mint_reward_btc,                -- Newly issued block subsidy in BTC
    total_fees_btc,                 -- Transaction fees collected by miners in BTC
    total_reward_btc                -- Block subsidy plus transaction fees in BTC
FROM daily_coinbase
ORDER BY date