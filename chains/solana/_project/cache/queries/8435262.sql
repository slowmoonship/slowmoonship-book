-- Purpose:
-- Verify whether the officially documented solana_utils.token_accounts dataset is
-- query-engine accessible even though Dune MCP catalog search did not return it.
--
-- Source table grain:
-- Expected one token-account row with separate mint and owner fields; this probe validates access.
--
-- Time range:
-- Not applicable because the documented table has no event timestamp; one row only.

SELECT
    address,                 -- Token-account address, not a wallet owner
    token_mint_address,      -- Mint represented by the token account
    token_balance_owner,     -- Owner authority/wallet recorded for the token account
    account_type             -- Associated or regular token-account classification
FROM solana_utils.token_accounts
LIMIT 1