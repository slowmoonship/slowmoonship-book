-- SMS HYPE 12: HyperEVM active sender addresses over 30D and 90D windows.
-- Source: hyperevm.transactions.from. An address is NOT a user; an address can be
-- an EOA, a contract, or a multisig. We compute COUNT(DISTINCT from) for both
-- windows in one Query to keep the panel comparable.

WITH
win30 AS (
    SELECT COUNT(DISTINCT "from") AS active_senders_30d
    FROM hyperevm.transactions
    WHERE block_date >= CAST(CURRENT_DATE - INTERVAL '30' DAY AS DATE)
      AND block_date < CURRENT_DATE
),
win90 AS (
    SELECT COUNT(DISTINCT "from") AS active_senders_90d
    FROM hyperevm.transactions
    WHERE block_date >= CAST(CURRENT_DATE - INTERVAL '90' DAY AS DATE)
      AND block_date < CURRENT_DATE
)

SELECT
    (SELECT active_senders_30d FROM win30) AS active_senders_30d,
    (SELECT active_senders_90d FROM win90) AS active_senders_90d,
    CAST(CURRENT_DATE - INTERVAL '1' DAY AS DATE) AS reference_day;
