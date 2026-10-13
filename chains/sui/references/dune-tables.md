# Dune Sui 字段快照与表说明

抓取日期：2026-10-10。API 已验证 Schema；未完成数据唯一性、新鲜度、历史范围与 JOIN 覆盖验证。首次新增 SQL 被 402 拒绝，没有 Execution ID。

数据来源：[Dune Sui Catalog](https://docs.dune.com/data-catalog/sui/overview)，实际 API JSON：[本地快照](../_project/cache/dune-catalog-2026-10-10.json)。API 返回字段 nullable=true 不等于实际全部为空，也不能据此声明唯一约束。

## sui.checkpoints

一条 Checkpoint 记录，候选键 sequence_number。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/checkpoints)

| 字段 | API 类型 |
|---|---|
| checkpoint_digest | varchar |
| sequence_number | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| previous_checkpoint_digest | varchar |
| end_of_epoch | boolean |
| total_gas_cost | bigint |
| computation_cost | decimal(20,0) |
| storage_cost | decimal(20,0) |
| storage_rebate | decimal(20,0) |
| non_refundable_storage_fee | decimal(20,0) |
| total_transaction_blocks | decimal(20,0) |
| total_transactions | decimal(20,0) |
| total_successful_transaction_blocks | decimal(20,0) |
| total_successful_transactions | decimal(20,0) |
| network_total_transaction | decimal(20,0) |
| validator_signature | varchar |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## sui.transactions

一条事务记录，候选键 transaction_digest。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/transactions)

| 字段 | API 类型 |
|---|---|
| transaction_digest | varchar |
| checkpoint | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| sender | varbinary |
| transaction_kind | varchar |
| is_system_txn | boolean |
| is_sponsored_tx | boolean |
| transaction_count | decimal(20,0) |
| execution_success | boolean |
| input | decimal(20,0) |
| shared_input | decimal(20,0) |
| gas_coins | decimal(20,0) |
| created | decimal(20,0) |
| mutated | decimal(20,0) |
| deleted | decimal(20,0) |
| transfers | decimal(20,0) |
| split_coins | decimal(20,0) |
| merge_coins | decimal(20,0) |
| publish | decimal(20,0) |
| upgrade | decimal(20,0) |
| others | decimal(20,0) |
| move_calls | decimal(20,0) |
| packages | varchar |
| gas_owner | varbinary |
| gas_object_id | varbinary |
| gas_object_sequence | decimal(20,0) |
| gas_object_digest | varchar |
| gas_budget | decimal(20,0) |
| total_gas_cost | bigint |
| computation_cost | decimal(20,0) |
| storage_cost | decimal(20,0) |
| storage_rebate | decimal(20,0) |
| non_refundable_storage_fee | decimal(20,0) |
| gas_price | decimal(20,0) |
| raw_transaction | varchar |
| has_zklogin_sig | boolean |
| has_upgraded_multisig | boolean |
| transaction_json | varchar |
| effects_json | varchar |
| transaction_position | decimal(20,0) |
| events_digest | varchar |
| transaction_data_bcs_length | decimal(20,0) |
| effects_bcs_length | decimal(20,0) |
| events_bcs_length | decimal(20,0) |
| signatures_bcs_length | decimal(20,0) |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## sui.transaction_objects

事务与对象/版本/角色的关系；候选组合需数据验证。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/transaction_objects)

| 字段 | API 类型 |
|---|---|
| object_id | varbinary |
| version | decimal(20,0) |
| transaction_digest | varchar |
| checkpoint | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| input_kind | varchar |
| object_status | varchar |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## sui.objects

记录的对象状态或操作版本；不是单纯当前快照。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/objects)

| 字段 | API 类型 |
|---|---|
| object_id | varbinary |
| version | decimal(20,0) |
| digest | varchar |
| type_ | varchar |
| checkpoint | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| owner_type | varchar |
| owner_address | varbinary |
| object_status | varchar |
| initial_shared_version | decimal(20,0) |
| previous_transaction | varchar |
| has_public_transfer | boolean |
| is_consensus | boolean |
| storage_rebate | decimal(20,0) |
| bcs | varchar |
| coin_type | varchar |
| coin_balance | decimal(20,0) |
| struct_tag | varchar |
| object_json | varchar |
| bcs_length | decimal(20,0) |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## sui.move_call

记录的 Move 调用；候选键和 cmd_idx 精确覆盖需验证。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/move_call)

| 字段 | API 类型 |
|---|---|
| transaction_digest | varchar |
| checkpoint | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| package | varbinary |
| module | varchar |
| function | varchar |
| cmd_idx | decimal(20,0) |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## sui.events

显式 Move Event；候选键 transaction_digest + event_index。 常用窗口列 date；逻辑连接沿 transaction_digest 或 Checkpoint Sequence，Object 状态查找需 ID + Version。

[官方表说明](https://docs.dune.com/data-catalog/sui/events)

| 字段 | API 类型 |
|---|---|
| transaction_digest | varchar |
| event_index | decimal(20,0) |
| checkpoint | decimal(20,0) |
| epoch | decimal(20,0) |
| timestamp_ms | decimal(20,0) |
| date | date |
| sender | varbinary |
| package | varbinary |
| module | varchar |
| event_type | varchar |
| bcs | varchar |
| event_json | varchar |
| bcs_length | decimal(20,0) |
| _updated_at | timestamp |
| _ingested_at | timestamp |

适用问题与常见错误参见 SUI 08；未有来源确定的列含义均为待验证，尤其摘要 transaction_count、调用索引覆盖、对象状态值域和新版累加器提取。Catalog 没有返回可证明的全历史范围或实时服务 SLA。

## 扩展入口

API 同时确认 sui.move_package 与 sui.wrapped_object。前者包含 package_id、original_package_id、package_version，后者包含 object_id、root_object_id、root_object_version、json_path 等。需要时再验证记录粒度与关系。

恢复研究时复用快照，只在发现真实 Schema 冲突时刷新。下一步是获得执行条件后在有界窗口运行键、覆盖与时间检查，不能重复付费失败请求。
