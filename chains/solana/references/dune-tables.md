# Dune 数据表与字段

状态：DOCS_SCHEMA。来源为 2026-10-09 读取的官方文档 Schema；本轮未执行 SQL、未调用目录 API。查询定义提供额外字段证据，但不证明最新引擎类型。

## `solana.blocks`

- 粒度：一行一个被索引区块。
- 候选键：slot；hash。候选语义键，未声明数据库约束。
- 关联：slot = transactions.block_slot。
- 边界：网络块级计数，不能单凭缺行判断 skipped slot。
- 官方字段：`slot` (BIGINT), `height` (BIGINT), `time` (TIMESTAMP), `date` (DATE), `hash` (VARCHAR), `total_transactions` (INTEGER), `successful_transactions` (INTEGER), `failed_transactions` (INTEGER), `total_vote_transactions` (INTEGER), `total_non_vote_transactions` (INTEGER), `successful_vote_transactions` (INTEGER), `successful_non_vote_transactions` (INTEGER), `failed_vote_transactions` (INTEGER), `failed_non_vote_transactions` (INTEGER), `parent_slot` (BIGINT), `previous_block_hash` (VARCHAR), `num_reward_partitions` (BIGINT).

## `solana.transactions`

- 粒度：一行一笔非投票交易。
- 候选键：id / signature；位置候选 (block_slot, index)。
- 关联：id = instruction_calls.tx_id = account_activity.tx_id。
- 边界：投票另表；version 文档未确认 v1 加工支持。
- 官方字段：`block_slot` (BIGINT), `block_height` (BIGINT), `block_time` (TIMESTAMP), `block_date` (DATE), `index` (INTEGER), `fee` (BIGINT), `compute_units_consumed` (BIGINT), `cost_units` (BIGINT), `version` (VARCHAR), `required_signatures` (INTEGER), `readonly_signed_accounts` (INTEGER), `readonly_unsigned_accounts` (INTEGER), `block_hash` (VARCHAR), `id` (VARCHAR), `signature` (VARCHAR), `success` (BOOLEAN), `error` (VARCHAR), `recent_block_hash` (VARCHAR), `instructions` (ARRAY(ROW(data VARCHAR, executing_account VARCHAR, account_arguments ARRAY(VARCHAR), inner_instructions ARRAY(ROW(data VARCHAR, executing_account VARCHAR, account_arguments ARRAY(VARCHAR), stack_height BIGINT))))), `account_keys` (ARRAY(VARCHAR)), `log_messages` (ARRAY(VARCHAR)), `pre_balances` (ARRAY(BIGINT)), `post_balances` (ARRAY(BIGINT)), `pre_token_balances` (ARRAY(ROW(account VARCHAR, mint VARCHAR, owner VARCHAR, amount DECIMAL(38,18)))), `post_token_balances` (ARRAY(ROW(account VARCHAR, mint VARCHAR, owner VARCHAR, amount DECIMAL(38,18)))), `signatures` (ARRAY(VARCHAR)), `signer` (VARCHAR), `signers` (ARRAY(VARCHAR)), `return_data_program_id` (VARCHAR), `return_data` (ARRAY(VARCHAR)), `address_table_lookups` (ARRAY(ROW(accountKey VARCHAR, readonlyIndexes ARRAY(BIGINT), writableIndexes ARRAY(BIGINT)))), `loaded_addresses` (ROW(readonly ARRAY(VARCHAR), writable ARRAY(VARCHAR))).

## `solana.vote_transactions`

- 粒度：一行一笔投票交易。
- 候选键：id / signature；未查数据库约束。
- 关联：block_slot = blocks.slot。
- 边界：不能将 vote 当成应用用户操作。
- 官方字段：`block_slot` (BIGINT), `block_height` (BIGINT), `block_time` (TIMESTAMP), `block_date` (DATE), `index` (INTEGER), `fee` (BIGINT), `compute_units_consumed` (BIGINT), `cost_units` (BIGINT), `version` (VARCHAR), `required_signatures` (INTEGER), `readonly_signed_accounts` (INTEGER), `readonly_unsigned_accounts` (INTEGER), `block_hash` (VARCHAR), `id` (VARCHAR), `signature` (VARCHAR), `success` (BOOLEAN), `error` (VARCHAR), `recent_block_hash` (VARCHAR), `instructions` (ARRAY(ROW(data VARCHAR, executing_account VARCHAR, account_arguments ARRAY(VARCHAR), inner_instructions ARRAY(ROW(data VARCHAR, executing_account VARCHAR, account_arguments ARRAY(VARCHAR), stack_height BIGINT))))), `account_keys` (ARRAY(VARCHAR)), `log_messages` (ARRAY(VARCHAR)), `pre_balances` (ARRAY(BIGINT)), `post_balances` (ARRAY(BIGINT)), `pre_token_balances` (ARRAY(ROW(account VARCHAR, mint VARCHAR, owner VARCHAR, amount DECIMAL(38,18)))), `post_token_balances` (ARRAY(ROW(account VARCHAR, mint VARCHAR, owner VARCHAR, amount DECIMAL(38,18)))), `signatures` (ARRAY(VARCHAR)), `signer` (VARCHAR), `signers` (ARRAY(VARCHAR)), `return_data_program_id` (VARCHAR), `return_data` (ARRAY(VARCHAR)), `address_table_lookups` (ARRAY(ROW(accountKey VARCHAR, readonlyIndexes ARRAY(BIGINT), writableIndexes ARRAY(BIGINT)))), `loaded_addresses` (ROW(readonly ARRAY(VARCHAR), writable ARRAY(VARCHAR))).

## `solana.instruction_calls`

- 粒度：一行一条顶层或内层指令调用。
- 候选键：(tx_id, outer_instruction_index, inner_instruction_index)，顶层 inner index 可为 NULL。
- 关联：tx_id = transactions.id。
- 边界：展平调用不是完整父节点指针；日志与深度可能缺失。
- 官方字段：`block_slot` (BIGINT), `block_date` (DATE), `block_time` (TIMESTAMP), `block_hash` (VARCHAR), `tx_index` (INTEGER), `inner_instruction_index` (INTEGER), `outer_instruction_index` (INTEGER), `inner_executing_account` (VARCHAR), `outer_executing_account` (VARCHAR), `executing_account` (VARCHAR), `is_inner` (BOOLEAN), `stack_height` (BIGINT), `data` (VARBINARY), `account_arguments` (ARRAY(VARCHAR)), `inner_instructions` (ARRAY(ROW(data VARCHAR, executing_account VARCHAR, account_arguments ARRAY(VARCHAR), stack_height BIGINT))), `tx_id` (VARCHAR), `tx_signer` (VARCHAR), `tx_success` (BOOLEAN), `log_messages` (ARRAY(VARCHAR)).

## `solana.account_activity`

- 粒度：一行一笔交易中一个账户的活动。
- 候选键：(tx_id,address)；历史 10,000 行样本报告唯一，非全表约束。
- 关联：tx_id = transactions.id。
- 边界：余额字段不是完整任意 data 状态；地址不是用户。
- 官方字段：`block_date` (DATE), `block_slot` (BIGINT), `block_time` (TIMESTAMP), `address` (VARCHAR), `tx_index` (INTEGER), `token_mint_address` (VARCHAR), `tx_id` (VARCHAR), `block_hash` (VARCHAR), `tx_success` (BOOLEAN), `signed` (BOOLEAN), `writable` (BOOLEAN), `pre_balance` (BIGINT), `post_balance` (BIGINT), `balance_change` (BIGINT), `pre_token_balance` (DECIMAL(38,18)), `post_token_balance` (DECIMAL(38,18)), `token_balance_change` (DECIMAL(38,17)), `token_balance_owner` (VARCHAR).

## `solana.rewards`

- 粒度：一行一条奖励分配记录。
- 候选键：未确认唯一键；不把 candidate 当约束。
- 关联：block_slot = blocks.slot。
- 边界：奖励记录不一定等于普通交易里的转账指令。
- 官方字段：`block_slot` (BIGINT), `block_time` (TIMESTAMP), `block_hash` (VARCHAR), `reward_type` (VARCHAR), `lamports` (BIGINT), `pre_balance` (BIGINT), `post_balance` (BIGINT), `commission` (BIGINT), `commission_bps` (BIGINT), `recipient` (VARCHAR), `block_date` (DATE).

## `tokens_solana.transfers`

- 粒度：指令级资产移动 action；一笔交易多行。
- 候选键：unique_instruction_key：官方文档写 DECIMAL，精度待目录 API 核验。
- 关联：tx_id = transactions.id；mint 连 fungible。
- 边界：覆盖 SPL、Token-2022 和部分 native SOL；含 mint/burn 等动作；不是全资产移动保证。
- 官方字段：`block_time` (TIMESTAMP), `action` (VARCHAR), `amount` (UINT256), `from_token_account` (VARCHAR), `to_token_account` (VARCHAR), `token_mint_address` (VARCHAR), `symbol` (VARCHAR), `amount_display` (DOUBLE), `amount_usd` (DOUBLE), `from_owner` (VARCHAR), `to_owner` (VARCHAR), `token_version` (VARCHAR), `tx_id` (VARCHAR), `tx_signer` (VARCHAR), `outer_executing_account` (VARCHAR), `block_date` (DATE), `block_slot` (BIGINT), `tx_index` (INTEGER), `outer_instruction_index` (INTEGER), `inner_instruction_index` (INTEGER), `unique_instruction_key` (DECIMAL).

## `tokens_solana.fungible`

- 粒度：一个 mint 的整理元数据。
- 候选键：token_mint_address 为候选键；JOIN 前检查重复。
- 关联：token_mint_address = transfers.token_mint_address。
- 边界：symbol 不唯一；元数据不代表可信资产认证。
- 官方字段：`token_mint_address` (VARCHAR), `address_prefix` (VARCHAR), `decimals` (BIGINT), `name` (VARCHAR), `symbol` (VARCHAR), `token_uri` (VARCHAR), `metadata_program` (VARCHAR), `token_version` (VARCHAR), `init_tx` (VARCHAR), `created_at` (TIMESTAMP).

## `solana_utils.token_accounts`

- 粒度：Token Account 关系记录。
- 候选键：address 候选键；历史执行报告一行探针可访问。
- 关联：address = transfer token-account 字段。
- 边界：文档 account_type 示例不能代替实测枚举；不是历史完整账户快照。
- 官方字段：`address` (VARCHAR), `address_prefix` (VARCHAR), `token_mint_address` (VARCHAR), `token_balance_owner` (VARCHAR), `account_type` (VARCHAR).

## `dex_solana.trades`

- 粒度：一个池执行段；一次换币可多段。
- 候选键：不得仅用 tx_id 唯一；按当前模型检查组合身份。
- 关联：tx_id = transactions.id。
- 边界：SUM(amount_usd) 是池段成交量；USD 可为空；不等于用户投入额。
- 官方字段：`blockchain` (VARCHAR), `project` (VARCHAR), `version` (INTEGER), `version_name` (VARCHAR), `block_month` (DATE), `block_date` (DATE), `block_time` (TIMESTAMP), `block_slot` (BIGINT), `trade_source` (VARCHAR), `token_bought_symbol` (VARCHAR), `token_sold_symbol` (VARCHAR), `token_pair` (VARCHAR), `token_bought_amount` (DOUBLE), `token_sold_amount` (DOUBLE), `token_bought_amount_raw` (UINT256), `token_sold_amount_raw` (UINT256), `amount_usd` (DOUBLE), `fee_tier` (DOUBLE), `fee_usd` (DOUBLE), `token_bought_mint_address` (VARCHAR), `token_sold_mint_address` (VARCHAR), `token_bought_vault` (VARCHAR), `token_sold_vault` (VARCHAR), `project_program_id` (VARCHAR), `project_main_id` (VARCHAR), `trader_id` (VARCHAR), `tx_id` (VARCHAR), `outer_instruction_index` (INTEGER), `inner_instruction_index` (INTEGER), `tx_index` (INTEGER).

## 解码表的特殊边界

`system_program_solana.system_program_call_transfer` 的 `call_tx_id`、`call_outer_instruction_index`、`call_inner_instruction_index`、`call_executing_account`、`account_from`、`account_to`、`lamports` 来自当前读取的 Query 8435196 和历史原材料报告。本轮未执行引擎验证类型；不得用无前缀旧目录字段替换当前 SQL。

`address_prefix` 出现在已有 account_activity 查询中，但不在此次官方文档 Schema 中。保留为 CURRENT_SQL_READ 证据，未推断最新引擎类型。
