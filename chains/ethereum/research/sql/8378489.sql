-- Source table grain:
-- One row in ethereum.creation_traces represents one contract-creation trace.
-- This dedicated table is documented as a create-trace subset of ethereum.traces.
-- address is the newly created contract; "from" is the direct trace-level creator.
-- A factory contract can therefore be the creator, and one transaction can create multiple contracts.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.
-- Partition note:
-- The current real schema contains block_month but not block_date, despite a conflicting catalog hint.

-- Aggregate contract-creation trace rows into one row per UTC day.
WITH daily_contract_creation AS (
    SELECT
        CAST(block_time AS DATE) AS date,                -- UTC calendar date derived from the creation timestamp
        COUNT(*) AS contracts_created,                   -- Number of contract-creation trace rows
        COUNT(DISTINCT "from") AS unique_creators,       -- Distinct direct trace-level creators
        COUNT(DISTINCT address) AS unique_contract_addresses, -- Distinct non-null created contract addresses
        COUNT(DISTINCT tx_hash) AS creation_transactions, -- Distinct transactions containing creations
        COUNT(*) - COUNT_IF(address IS NULL) - COUNT(DISTINCT address) AS duplicate_contract_addresses, -- QA duplicate non-null created addresses
        COUNT_IF(address IS NULL) AS null_contract_addresses, -- QA creation rows without a created address
        CAST(COUNT(*) AS DOUBLE)
            / NULLIF(COUNT(DISTINCT tx_hash), 0) AS avg_contracts_per_transaction -- Mean creation rows per creation transaction
    FROM ethereum.creation_traces
    WHERE block_month >= CAST(DATE_TRUNC('month', CURRENT_DATE - INTERVAL '90' DAY) AS DATE) -- Real month partition field
      AND block_time >= CAST(CURRENT_DATE - INTERVAL '90' DAY AS TIMESTAMP) -- Exact lower timestamp boundary
      AND block_time < CAST(CURRENT_DATE AS TIMESTAMP)      -- Exclude current partial UTC day
    GROUP BY CAST(block_time AS DATE)
)

SELECT
    date AS date,                                        -- UTC calendar date
    contracts_created AS contracts_created,              -- Contract-creation trace count
    unique_creators AS unique_creators,                  -- Distinct direct creators
    unique_contract_addresses AS unique_contract_addresses, -- Distinct created contract addresses
    creation_transactions AS creation_transactions,      -- Distinct transactions containing creations
    duplicate_contract_addresses AS duplicate_contract_addresses, -- QA duplicate non-null address count
    null_contract_addresses AS null_contract_addresses,  -- QA null created-address count
    avg_contracts_per_transaction AS avg_contracts_per_transaction -- Mean created contracts per creation transaction
FROM daily_contract_creation
ORDER BY date;