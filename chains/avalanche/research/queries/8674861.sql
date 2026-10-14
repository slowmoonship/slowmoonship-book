-- Community registry sample; no claim of complete Avalanche network coverage.
WITH sampled AS (
 SELECT blockchain_id, subnet_id, blockchain_name, name, evm_chain_id,
 chain_type, chain_created_at, data_refreshed_at, pchain_fetch_status,
 glacier_fetch_status, rpc_fetch_status
 FROM dune.suzaku.dataset_avalanche_chains
 LIMIT 10
)
SELECT blockchain_id, subnet_id, blockchain_name, name, evm_chain_id,
 chain_type, chain_created_at, data_refreshed_at, pchain_fetch_status,
 glacier_fetch_status, rpc_fetch_status FROM sampled