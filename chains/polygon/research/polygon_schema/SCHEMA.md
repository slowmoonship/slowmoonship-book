# 本轮Dune Schema字段快照

Catalog声明非空不代表历史数据实际无空值；本轮未新运行SQL。未返回的候选表不视为已证实不存在。

## `balances_polygon.latest`

网络：polygon；分区声明：；来源：`research/dune/schema-balances.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| updated_at | timestamp(3) with time zone | True |
| block_number | bigint | True |
| address | varbinary | True |
| token_address | varbinary | True |
| token_standard | varchar | True |
| token_symbol | varchar | True |
| balance_raw | uint256 | True |
| balance | double | True |
| balance_usd | double | True |

## `balances_polygon.updates`

网络：polygon；分区声明：；来源：`research/dune/schema-balances.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| block_date | date | True |
| block_number | bigint | True |
| timestamp | timestamp(3) with time zone | True |
| address | varbinary | True |
| token_address | varbinary | True |
| token_standard | varchar | True |
| token_symbol | varchar | True |
| balance_raw | uint256 | True |
| balance | double | True |

## `balances_polygon.daily_updates`

网络：polygon；分区声明：；来源：`research/dune/schema-balances.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| address_prefix | varchar | True |
| address | varbinary | True |
| token_address | varbinary | True |
| token_standard | varchar | True |
| token_symbol | varchar | True |
| balance_raw | uint256 | True |
| balance | double | True |
| balance_updated_at | timestamp(3) with time zone | True |
| valid_from | date | True |
| valid_to | date | True |
| balance_usd | double | True |
| _updated_at | timestamp(3) with time zone | True |

## `maker_polygon.dai_evt_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-dai.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| from | varbinary | False |
| to | varbinary | False |
| value | uint256 | False |

## `maker_polygon.dai_call_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-dai.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |
| output_0 | boolean | False |
| recipient | varbinary | False |

## `maker_polygon.dai_call_transferproxyownership`

网络：polygon；分区声明：；来源：`research/dune/schema-dai.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| newOwner | varbinary | False |

## `aave_v3_polygon.pool_call_supplywithpermit`

网络：polygon；分区声明：；来源：`research/dune/schema-decoded.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |
| asset | varbinary | False |
| deadline | uint256 | False |
| onBehalfOf | varbinary | False |
| permitR | varbinary | False |
| permitS | varbinary | False |
| permitV | integer | False |
| referralCode | integer | False |

## `aave_v3_polygon.pool_call_supply`

网络：polygon；分区声明：；来源：`research/dune/schema-decoded.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |
| asset | varbinary | False |
| onBehalfOf | varbinary | False |
| referralCode | integer | False |

## `dex_evm.trades`

网络：abstract, apechain, arbitrum, arc, avalanche_c, base, berachain, blast, bnb, boba, celo, corn, cronos, ethereum, fantom, flare, flow, gnosis, hemi, hyperevm, ink, kaia, katana, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, scroll, sei, shape, somnia, sonic, sophon, story, superseed, tac, taiko, tempo, tezos_evm, unichain, worldchain, xlayer, zkevm, zksync, zora；分区声明：block_month, blockchain, project；来源：`research/dune/schema-dex.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| project | varchar | True |
| version | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp(3) with time zone | True |
| block_number | bigint | True |
| token_bought_symbol | varchar | True |
| token_sold_symbol | varchar | True |
| token_pair | varchar | True |
| token_bought_amount | double | True |
| token_sold_amount | double | True |
| token_bought_amount_raw | uint256 | True |
| token_sold_amount_raw | uint256 | True |
| amount_usd | double | True |
| token_bought_address | varbinary | True |
| token_sold_address | varbinary | True |
| taker | varbinary | True |
| maker | varbinary | True |
| project_contract_address | varbinary | True |
| tx_hash | varbinary | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| evt_index | bigint | True |
| _updated_at | timestamp(3) with time zone | True |

## `dex.trades`

网络：abstract, apechain, arbitrum, arc, avalanche_c, base, berachain, blast, bnb, boba, celo, corn, cronos, ethereum, fantom, flare, flow, gnosis, hemi, hyperevm, ink, kaia, katana, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, scroll, sei, shape, somnia, sonic, sophon, story, superseed, tac, taiko, tempo, tezos_evm, unichain, worldchain, xlayer, zkevm, zksync, zora；分区声明：blockchain, project, block_month；来源：`research/dune/schema-dex.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| project | varchar | True |
| version | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp | True |
| block_number | bigint | True |
| token_bought_symbol | varchar | True |
| token_sold_symbol | varchar | True |
| token_pair | varchar | True |
| token_bought_amount | double | True |
| token_sold_amount | double | True |
| token_bought_amount_raw | uint256 | True |
| token_sold_amount_raw | uint256 | True |
| amount_usd | double | True |
| token_bought_address | varbinary | True |
| token_sold_address | varbinary | True |
| taker | varbinary | True |
| maker | varbinary | True |
| project_contract_address | varbinary | True |
| tx_hash | varbinary | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| evt_index | bigint | True |
| _updated_at | timestamp | True |

## `tokens.erc20`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hedera, hemi, henesys, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sophon, sonic, story, superseed, tac, taiko, tempo, tezos_evm, tron, unichain, viction, worldchain, xlayer, zkevm, zksync, zora；分区声明：blockchain；来源：`research/dune/schema-transfers.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| name | varchar | True |
| decimals | integer | True |
| _updated_at | timestamp(3) with time zone | True |

## `tokens.transfers`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, gnosis, hemi, henesys, hyperevm, ink, kaia, katana, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sonic, sophon, story, superseed, tac, taiko, tempo, tezos_evm, tron, unichain, viction, worldchain, xlayer, zkevm, zksync, zora, lens；分区声明：block_month, blockchain；来源：`research/dune/schema-transfers.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| unique_key | varchar | True |
| blockchain | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp(3) with time zone | True |
| block_number | bigint | True |
| tx_hash | varbinary | True |
| evt_index | bigint | True |
| trace_address | array(bigint) | True |
| token_standard | varchar | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| tx_index | bigint | True |
| from | varbinary | True |
| to | varbinary | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| amount_raw | uint256 | True |
| amount | double | True |
| price_usd | double | True |
| amount_usd | double | True |
| _updated_at | timestamp(3) with time zone | True |

## `ethereum.logs`

网络：ethereum；分区声明：block_date；来源：`research/dune/schema-ethereum-logs.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| block_hash | varbinary | False |
| contract_address | varbinary | False |
| topic0 | varbinary | False |
| topic1 | varbinary | False |
| topic2 | varbinary | False |
| topic3 | varbinary | False |
| data | varbinary | False |
| tx_hash | varbinary | False |
| index | integer | False |
| tx_index | integer | False |
| block_date | date | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |
| blob_gas_price | bigint | False |
| blob_gas_used | bigint | False |

## `gas.fees`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hemi, henesys, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sonic, sophon, story, superseed, tac, taiko, tempo, tezos_evm, unichain, worldchain, xlayer, zkevm, zksync, zora, tron；分区声明：block_month, blockchain；来源：`research/dune/schema-fees.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp(3) with time zone | True |
| block_number | bigint | True |
| tx_hash | varbinary | True |
| tx_index | bigint | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| gas_price | uint256 | True |
| gas_used | bigint | True |
| currency_symbol | varchar | True |
| tx_fee | double | True |
| tx_fee_usd | double | True |
| tx_fee_raw | uint256 | True |
| tx_fee_breakdown | map(varchar,double) | True |
| tx_fee_breakdown_usd | map(varchar,double) | True |
| tx_fee_breakdown_raw | map(varchar,uint256) | True |
| tx_fee_currency | varbinary | True |
| block_proposer | varbinary | True |
| gas_limit | uint256 | True |
| gas_limit_usage | double | True |

## `nft.transfers`

网络：ethereum, bnb, avalanche_c, gnosis, optimism, arbitrum, polygon, fantom, base, zksync, zora, celo, scroll, linea, blast, mantle, sei, ronin, worldchain, kaia；分区声明：block_month, blockchain；来源：`research/dune/schema-nft.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| block_time | timestamp(3) with time zone | True |
| block_month | date | True |
| block_date | date | True |
| block_number | bigint | True |
| token_standard | varchar | True |
| transfer_type | varchar | True |
| evt_index | integer | True |
| contract_address | varbinary | True |
| token_id | uint256 | True |
| amount | uint256 | True |
| from | varbinary | True |
| to | varbinary | True |
| executed_by | varbinary | True |
| tx_hash | varbinary | True |
| unique_transfer_id | varchar | True |

## `nft.trades`

网络：abstract, apechain, arbitrum, avalanche_c, base, blast, bnb, celo, ethereum, fantom, linea, nova, optimism, polygon, ronin, scroll, zksync, zora；分区声明：blockchain, project, block_month；来源：`research/dune/schema-nft.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| project | varchar | True |
| version | varchar | True |
| block_date | date | True |
| block_month | date | True |
| block_time | timestamp(3) with time zone | True |
| token_id | uint256 | True |
| collection | varchar | True |
| amount_usd | double | True |
| token_standard | varchar | True |
| trade_type | varchar | True |
| number_of_items | uint256 | True |
| trade_category | varchar | True |
| evt_type | varchar(5) | True |
| seller | varbinary | True |
| buyer | varbinary | True |
| amount_original | double | True |
| amount_raw | uint256 | True |
| currency_symbol | varchar | True |
| currency_contract | varbinary | True |
| nft_contract_address | varbinary | True |
| project_contract_address | varbinary | True |
| aggregator_name | varchar | True |
| aggregator_address | varbinary | True |
| tx_hash | varbinary | True |
| block_number | bigint | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| platform_fee_amount_raw | uint256 | True |
| platform_fee_amount | double | True |
| platform_fee_amount_usd | double | True |
| platform_fee_percentage | double | True |
| royalty_fee_receive_address | varbinary | True |
| royalty_fee_currency_symbol | varchar | True |
| royalty_fee_amount_raw | uint256 | True |
| royalty_fee_amount | double | True |
| royalty_fee_amount_usd | double | True |
| royalty_fee_percentage | double | True |
| unique_trade_id | varchar | True |

## `polygon.logs`

网络：polygon；分区声明：block_date；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| block_hash | varbinary | False |
| contract_address | varbinary | False |
| topic0 | varbinary | False |
| topic1 | varbinary | False |
| topic2 | varbinary | False |
| topic3 | varbinary | False |
| data | varbinary | False |
| tx_hash | varbinary | False |
| index | integer | False |
| tx_index | integer | False |
| block_date | date | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |

## `polygon.transactions`

网络：polygon；分区声明：block_date；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| value | decimal(38,0) | False |
| gas_limit | bigint | False |
| gas_price | bigint | False |
| gas_used | bigint | False |
| max_fee_per_gas | bigint | False |
| max_priority_fee_per_gas | bigint | False |
| priority_fee_per_gas | bigint | False |
| nonce | bigint | False |
| index | bigint | False |
| success | boolean | False |
| from | varbinary | False |
| to | varbinary | False |
| block_hash | varbinary | False |
| data | varbinary | False |
| hash | varbinary | False |
| type | varchar | False |
| access_list | array(row(address varbinary,storageKeys array(varbinary))) | False |
| block_date | date | False |
| authorization_list | array(row(chainId bigint,address varbinary,nonce bigint,r varchar,s varchar,yParity varchar)) | False |

## `polygon.creation_traces`

网络：polygon；分区声明：block_date；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| tx_hash | varbinary | False |
| address | varbinary | False |
| from | varbinary | False |
| code | varbinary | False |
| block_month | date | False |

## `polygon.traces`

网络：polygon；分区声明：block_date；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| value | uint256 | False |
| gas | bigint | False |
| gas_used | bigint | False |
| block_hash | varbinary | False |
| success | boolean | False |
| tx_index | integer | False |
| sub_traces | bigint | False |
| error | varchar | False |
| tx_success | boolean | False |
| tx_hash | varbinary | False |
| from | varbinary | False |
| to | varbinary | False |
| trace_address | array(bigint) | False |
| type | varchar | False |
| address | varbinary | False |
| code | varbinary | False |
| call_type | varchar | False |
| input | varbinary | False |
| output | varbinary | False |
| refund_address | varbinary | False |
| block_date | date | False |

## `polygon.contracts`

网络：polygon；分区声明：；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| abi_id | varchar | False |
| abi | array(varchar) | False |
| address | varbinary | False |
| from | varbinary | False |
| code | varbinary | False |
| name | varchar | False |
| namespace | varchar | False |
| dynamic | boolean | False |
| base | boolean | False |
| factory | boolean | False |
| detection_source | varchar | False |
| created_at | timestamp | False |

## `polygon.blocks`

网络：polygon；分区声明：date；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| time | timestamp | False |
| number | bigint | False |
| gas_limit | decimal(38,0) | False |
| gas_used | decimal(38,0) | False |
| difficulty | bigint | False |
| total_difficulty | decimal(38,0) | False |
| size | bigint | False |
| base_fee_per_gas | bigint | False |
| hash | varbinary | False |
| parent_hash | varbinary | False |
| miner | varbinary | False |
| nonce | varbinary | False |
| date | date | False |

## `polygon.logs_decoded`

网络：polygon；分区声明：contract_name, namespace；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_date | date | False |
| block_time | timestamp | False |
| block_number | bigint | False |
| namespace | varchar | False |
| contract_name | varchar | False |
| contract_address | varbinary | False |
| tx_hash | varbinary | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |
| index | integer | False |
| signature | varbinary | False |
| event_name | varchar | False |
| created_at | timestamp | False |

## `polygon.traces_decoded`

网络：polygon；分区声明：contract_name, namespace；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| block_date | date | False |
| block_time | timestamp | False |
| block_number | bigint | False |
| namespace | varchar | False |
| contract_name | varchar | False |
| to | varbinary | False |
| trace_address | array(bigint) | False |
| tx_hash | varbinary | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |
| success | boolean | False |
| signature | varbinary | False |
| function_name | varchar | False |
| created_at | timestamp | False |

## `polygon.signatures`

网络：polygon；分区声明：；来源：`research/dune/schema-polygon-raw.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| id | varbinary | False |
| signature | varchar | False |
| abi | varchar | False |
| type | varchar | False |
| namespace | varchar | False |
| name | varchar | False |
| created_at | timestamp | False |

## `prices.day`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hedera, hemi, henesys, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sophon, sonic, story, superseed, tac, taiko, tempo, tezos_evm, tron, unichain, viction, worldchain, xlayer, zkevm, zksync, zora；分区声明：blockchain；来源：`research/dune/schema-prices.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| timestamp | timestamp(3) with time zone | True |
| blockchain | varchar | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| price | double | True |
| decimals | integer | True |
| volume | double | True |
| source | varchar | True |
| contract_address_varchar | varchar | True |

## `prices.minute`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hedera, hemi, henesys, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sophon, sonic, story, superseed, tac, taiko, tempo, tezos_evm, tron, unichain, viction, worldchain, xlayer, zkevm, zksync, zora；分区声明：blockchain；来源：`research/dune/schema-prices.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| timestamp | timestamp(3) with time zone | True |
| blockchain | varchar | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| price | double | True |
| decimals | integer | True |
| volume | double | True |
| source | varchar | True |
| contract_address_varchar | varchar | True |

## `prices.hour`

网络：abstract, apechain, arbitrum, arc, avalanche_c, b3, base, berachain, blast, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hedera, hemi, henesys, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sophon, sonic, story, superseed, tac, taiko, tempo, tezos_evm, tron, unichain, viction, worldchain, xlayer, zkevm, zksync, zora；分区声明：blockchain；来源：`research/dune/schema-prices.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| timestamp | timestamp(3) with time zone | True |
| blockchain | varchar | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| price | double | True |
| decimals | integer | True |
| volume | double | True |
| source | varchar | True |
| contract_address_varchar | varchar | True |

## `quickswap_polygon.uniswapv2pair_evt_burn`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount0 | uint256 | False |
| amount1 | uint256 | False |
| sender | varbinary | False |
| to | varbinary | False |

## `quickswap_polygon.uniswapv2pair_evt_swap`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount0In | uint256 | False |
| amount0Out | uint256 | False |
| amount1In | uint256 | False |
| amount1Out | uint256 | False |
| sender | varbinary | False |
| to | varbinary | False |

## `quickswap_polygon.quick_evt_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount | uint256 | False |
| from | varbinary | False |
| to | varbinary | False |

## `quickswap_polygon.uniswapv2pair_evt_mint`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount0 | uint256 | False |
| amount1 | uint256 | False |
| sender | varbinary | False |

## `quickswap_polygon.uniswapv2factory_evt_paircreated`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| _0 | uint256 | False |
| pair | varbinary | False |
| token0 | varbinary | False |
| token1 | varbinary | False |

## `quickswap_polygon.uniswapv2pair_evt_sync`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| reserve0 | uint256 | False |
| reserve1 | uint256 | False |

## `quickswap_polygon.uniswapv2pair_evt_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| from | varbinary | False |
| to | varbinary | False |
| value | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_swap`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount0Out | uint256 | False |
| amount1Out | uint256 | False |
| data | varbinary | False |
| to | varbinary | False |

## `quickswap_polygon.uniswapv2pair_call_initialize`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _token0 | varbinary | False |
| _token1 | varbinary | False |

## `quickswap_polygon.quick_call_allowance`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| account | varbinary | False |
| output_0 | uint256 | False |
| spender | varbinary | False |

## `quickswap_polygon.uniswapv2pair_call_factory`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varbinary | False |

## `quickswap_polygon.uniswapv2factory_call_allpairslength`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | uint256 | False |

## `quickswap_polygon.newquickdragonlair_call_enter`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _quickAmount | uint256 | False |

## `quickswap_polygon.stakingdualrewards_evt_ownerchanged`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| newOwner | varbinary | False |
| oldOwner | varbinary | False |

## `quickswap_polygon.uniswapv2pair_call_getreserves`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output__blockTimestampLast | bigint | False |
| output__reserve0 | uint256 | False |
| output__reserve1 | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_transferfrom`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| from | varbinary | False |
| output_0 | boolean | False |
| to | varbinary | False |
| value | uint256 | False |

## `quickswap_polygon.uniswapv2router02_call_swapexactethfortokens`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountOutMin | uint256 | False |
| deadline | uint256 | False |
| output_amounts | array(uint256) | False |
| path | array(varbinary) | False |
| to | varbinary | False |

## `quickswap_polygon.uniswapv2pair_call_burn`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_amount0 | uint256 | False |
| output_amount1 | uint256 | False |
| to | varbinary | False |

## `quickswap_polygon.stakingdualrewards_call_earnedb`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| account | varbinary | False |
| output_0 | uint256 | False |

## `quickswap_polygon.uniswapv2router02_call_removeliquidityeth`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountETHMin | uint256 | False |
| amountTokenMin | uint256 | False |
| deadline | uint256 | False |
| liquidity | uint256 | False |
| output_amountETH | uint256 | False |
| output_amountToken | uint256 | False |
| to | varbinary | False |
| token | varbinary | False |

## `quickswap_polygon.newquickdragonlair_call_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |
| output_0 | boolean | False |
| recipient | varbinary | False |

## `quickswap_polygon.stakingdualrewards_call_balanceof`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| account | varbinary | False |
| output_0 | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_balanceof`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _0 | varbinary | False |
| output_0 | uint256 | False |

## `quickswap_polygon.stakingdualrewards_evt_rewardadded`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| periodFinish | uint256 | False |
| rewardA | uint256 | False |
| rewardB | uint256 | False |

## `quickswap_polygon.newquickdragonlair_evt_transfer`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| from | varbinary | False |
| to | varbinary | False |
| value | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_token0`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varbinary | False |

## `quickswap_polygon.uniswapv2router02_call_removeliquidityethwithpermit`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountETHMin | uint256 | False |
| amountTokenMin | uint256 | False |
| approveMax | boolean | False |
| deadline | uint256 | False |
| liquidity | uint256 | False |
| output_amountETH | uint256 | False |
| output_amountToken | uint256 | False |
| r | varbinary | False |
| s | varbinary | False |
| to | varbinary | False |
| token | varbinary | False |
| v | integer | False |

## `quickswap_polygon.uniswapv2pair_call_symbol`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varchar | False |

## `quickswap_polygon.uniswapv2router02_call_removeliquiditywithpermit`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountAMin | uint256 | False |
| amountBMin | uint256 | False |
| approveMax | boolean | False |
| deadline | uint256 | False |
| liquidity | uint256 | False |
| output_amountA | uint256 | False |
| output_amountB | uint256 | False |
| r | varbinary | False |
| s | varbinary | False |
| to | varbinary | False |
| tokenA | varbinary | False |
| tokenB | varbinary | False |
| v | integer | False |

## `quickswap_polygon.stakingdualrewards_call_notifyrewardamount`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| rewardA | uint256 | False |
| rewardB | uint256 | False |
| rewardsDuration | uint256 | False |

## `quickswap_polygon.uniswapv2factory_call_setfeeto`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _feeTo | varbinary | False |

## `quickswap_polygon.uniswapv2pair_call_token1`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varbinary | False |

## `quickswap_polygon.uniswapv2router02_call_swapexacttokensforethsupportingfeeontransfertokens`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountIn | uint256 | False |
| amountOutMin | uint256 | False |
| deadline | uint256 | False |
| path | array(varbinary) | False |
| to | varbinary | False |

## `quickswap_polygon.quick_call_approve`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | boolean | False |
| rawAmount | uint256 | False |
| spender | varbinary | False |

## `quickswap_polygon.stakingdualrewards_call_withdraw`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_minimum_liquidity`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | uint256 | False |

## `quickswap_polygon.uniswapv2router02_call_weth`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varbinary | False |

## `quickswap_polygon.quick_call_permit`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| deadline | uint256 | False |
| owner | varbinary | False |
| r | varbinary | False |
| rawAmount | uint256 | False |
| s | varbinary | False |
| spender | varbinary | False |
| v | integer | False |

## `quickswap_polygon.newquickdragonlair_call_quickfordquick`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _quickAmount | uint256 | False |
| output_dQuickAmount_ | uint256 | False |

## `quickswap_polygon.uniswapv2router02_call_swaptokensforexacteth`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountInMax | uint256 | False |
| amountOut | uint256 | False |
| deadline | uint256 | False |
| output_amounts | array(uint256) | False |
| path | array(varbinary) | False |
| to | varbinary | False |

## `quickswap_polygon.uniswapv2factory_call_allpairs`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _0 | uint256 | False |
| output_0 | varbinary | False |

## `quickswap_polygon.newquickdragonlair_call_leave`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _dQuickAmount | uint256 | False |

## `quickswap_polygon.quick_call_name`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varchar | False |

## `quickswap_polygon.quick_evt_delegatevoteschanged`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| delegate | varbinary | False |
| newBalance | uint256 | False |
| previousBalance | uint256 | False |

## `quickswap_polygon.uniswapv2pair_call_klast`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | uint256 | False |

## `quickswap_polygon.uniswapv2router02_call_getamountin`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amountOut | uint256 | False |
| output_amountIn | uint256 | False |
| reserveIn | uint256 | False |
| reserveOut | uint256 | False |

## `quickswap_polygon.newquickdragonlair_call_transferfrom`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | False |
| output_0 | boolean | False |
| recipient | varbinary | False |
| sender | varbinary | False |

## `quickswap_polygon.uniswapv2router02_call_factory`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varbinary | False |

## `quickswap_polygon.quick_evt_delegatechanged`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| delegator | varbinary | False |
| fromDelegate | varbinary | False |
| toDelegate | varbinary | False |

## `quickswap_polygon.quick_call_symbol`

网络：polygon；分区声明：；来源：`research/dune/schema-quickswap.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| output_0 | varchar | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_call_receivemessage`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| inputData | varbinary | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_call_maptoken`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| rootToken | varbinary | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxwithdrawerc20`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount | uint256 | False |
| childToken | varbinary | False |
| rootToken | varbinary | False |
| userAddress | varbinary | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_call_deposit`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| amount | uint256 | True |
| data | varbinary | True |
| output_0 | varbinary | True |
| rootToken | varbinary | True |
| user | varbinary | True |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| amount | uint256 | False |
| depositor | varbinary | False |
| rootToken | varbinary | False |
| userAddress | varbinary | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_call_setfxchildtunnel`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| _fxChildTunnel | varbinary | False |

## `polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_tokenmappederc20`

网络：ethereum；分区声明：；来源：`research/dune/schema-root-tunnel.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| childToken | varbinary | False |
| rootToken | varbinary | False |

## `tokens.supply_latest`

网络：abstract, apechain, arbitrum, arc, avalanche_c, base, berachain, bnb, bob, boba, celo, corn, cronos, degen, ethereum, fantom, flare, flow, gnosis, hedera, hyperevm, ink, kaia, katana, lens, linea, mantle, megaeth, mezo, monad, morph, nova, opbnb, optimism, peaq, plasma, plume, polygon, robinhood, ronin, rise, scroll, sei, shape, somnia, sophon, sonic, story, superseed, tac, taiko, tempo, tezos_evm, unichain, worldchain, xlayer, zksync, zora；分区声明：blockchain；来源：`research/dune/schema-transfers.json`。

| 字段 | 类型 | Nullable |
|---|---|---|
| blockchain | varchar | True |
| token_address | varbinary | True |
| symbol | varchar | True |
| decimals | integer | True |
| supply_raw | uint256 | True |
| supply | double | True |
| _updated_at | timestamp(3) with time zone | True |
