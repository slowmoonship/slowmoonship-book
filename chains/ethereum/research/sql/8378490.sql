-- Source table grain:
-- One row in tokens.transfers represents one curated fungible asset-movement row.
-- unique_key is the surrogate key for that transfer row; tx_hash is not unique.
-- Coverage:
-- The EVM dataset covers native-token and ERC20 transfers, not ERC721 or ERC1155.
-- Native rows include documented transaction-value, trace-value, and gas-used transfers.
-- "from" and "to" are transfer parties; tx_from and tx_to are parent-transaction parties.
-- Time scope:
-- The latest 90 complete UTC calendar days; the current partial UTC day is excluded.

-- Aggregate curated Ethereum transfer rows into one row per UTC day.
WITH daily_token_transfers AS (
    SELECT
        block_date AS date,                              -- UTC date of the asset movement
        COUNT(*) AS transfer_count,                      -- Number of curated fungible transfer rows
        COUNT(DISTINCT contract_address) AS unique_tokens, -- Distinct non-null token identifiers in contract_address
        COUNT(DISTINCT "from") AS unique_senders,        -- Distinct transfer-level senders
        COUNT(DISTINCT "to") AS unique_receivers,        -- Distinct transfer-level receivers
        COUNT_IF(LOWER(token_standard) = 'erc20') AS erc20_transfer_count, -- ERC20 rows, case-normalized
        COUNT_IF(LOWER(token_standard) = 'native') AS native_transfer_count, -- Native ETH rows, case-normalized
        COUNT_IF(token_standard IS NULL) AS null_token_standard_rows, -- QA rows without a token standard
        COUNT(*) - COUNT(DISTINCT unique_key) AS duplicate_or_null_unique_keys, -- QA duplicate-or-null surrogate keys
        COUNT_IF(unique_key IS NULL) AS null_unique_keys, -- QA null surrogate keys
        COUNT_IF(LOWER(token_standard) = 'native' AND contract_address IS NULL) AS native_rows_missing_contract_address -- QA whether unique_tokens can omit native ETH
    FROM tokens.transfers
    WHERE blockchain = 'ethereum'                        -- Blockchain partition filter
      AND block_month >= CAST(DATE_TRUNC('month', CURRENT_DATE - INTERVAL '90' DAY) AS DATE) -- Month partition pruning
      AND block_date >= CURRENT_DATE - INTERVAL '90' DAY -- Exact lower date boundary
      AND block_date < CURRENT_DATE                      -- Exclude the current partial UTC day
    GROUP BY block_date
)

SELECT
    date AS date,                                        -- UTC calendar date
    transfer_count AS transfer_count,                    -- Curated fungible transfer row count
    unique_tokens AS unique_tokens,                      -- Distinct non-null token identifiers
    unique_senders AS unique_senders,                    -- Distinct transfer-level senders
    unique_receivers AS unique_receivers,                -- Distinct transfer-level receivers
    erc20_transfer_count AS erc20_transfer_count,        -- ERC20 transfer rows
    native_transfer_count AS native_transfer_count,      -- Native ETH movement rows
    null_token_standard_rows AS null_token_standard_rows, -- QA null-standard row count
    duplicate_or_null_unique_keys AS duplicate_or_null_unique_keys, -- QA duplicate-or-null key count
    null_unique_keys AS null_unique_keys,                -- QA null surrogate-key count
    native_rows_missing_contract_address AS native_rows_missing_contract_address -- QA native rows omitted by unique_tokens
FROM daily_token_transfers
ORDER BY date;