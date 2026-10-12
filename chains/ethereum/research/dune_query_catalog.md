# Dune Query Catalog

读取日：2026-10-10。作者为 slowmoonship 团队。通过已有 MCP 搜索真实取得 Dashboard 218577，再读取其八个组件与对应 Query。

[原 Dashboard](https://dune.com/slowmoonship/ethereum-data-structure-v0-1)。本轮不修改 Dashboard，不创建 Query，不启动 SQL 执行。

所有原 SQL 原样保存于 sql/。已读取每条 2026-08-19 执行的前三行结果；这是历史运行证据，不能称为本轮重跑通过，也不保证八月版本与以后运行环境完全一致。

## 8378484｜Ethereum Daily Blocks ｜ 以太坊每日区块

[Query](https://dune.com/queries/8378484) · [原 SQL](sql/8378484.sql) · [本地元数据](queries/8378484.json) · [已有结果样本](result-8378484.json)

- 表：`ethereum.blocks`
- 关键字段：`date`, `number`, `time`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum block activity for the latest 90 complete UTC days. One source row is one canonical block. Includes block-number duplicate QA and an average same-day consecutive block interval.
- 输出指标：`date`, `block_count`, `first_block_number`, `last_block_number`, `avg_block_interval_seconds`, `duplicate_block_numbers`
- 复用章节：3, 30
- 原执行 ID：`01M0CPYGA62NTHRWWNRZN3E19M`；执行结束：2026-08-19T09:52:21.254464Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378485｜Ethereum Daily Transactions ｜ 以太坊每日交易

[Query](https://dune.com/queries/8378485) · [原 SQL](sql/8378485.sql) · [本地元数据](queries/8378485.json) · [已有结果样本](result-8378485.json)

- 表：`ethereum.transactions`
- 关键字段：`block_date`, `date`, `hash`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum transaction activity for the latest 90 complete UTC days. One source row is one transaction. Sender and recipient counts are separate address metrics, not active users.
- 输出指标：`date`, `transaction_count`, `unique_from_addresses`, `unique_to_addresses`, `duplicate_or_null_transaction_hashes`, `null_transaction_hashes`
- 复用章节：13, 39
- 原执行 ID：`01M0CPZTS1VY7NWFRF3JV1J13K`；执行结束：2026-08-19T09:56:34.206617Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378486｜Ethereum Transaction Status ｜ 以太坊交易执行状态

[Query](https://dune.com/queries/8378486) · [原 SQL](sql/8378486.sql) · [本地元数据](queries/8378486.json) · [已有结果样本](result-8378486.json)

- 表：`ethereum.transactions`
- 关键字段：`block_date`, `date`, `success`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily transaction execution status for the latest 90 complete UTC days using ethereum.transactions.success. Failure rate excludes null status rows and exposes nulls separately for QA.
- 输出指标：`date`, `success_count`, `failed_count`, `failure_rate`, `null_status_count`
- 复用章节：16, 27
- 原执行 ID：`01M0CQ7N4AJ76N9V64Q3J34R3F`；执行结束：2026-08-19T09:57:01.936251Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378487｜Ethereum Gas and Fees ｜ 以太坊 Gas 与手续费

[Query](https://dune.com/queries/8378487) · [原 SQL](sql/8378487.sql) · [本地元数据](queries/8378487.json) · [已有结果样本](result-8378487.json)

- 表：`gas.fees`
- 关键字段：`block_date`, `block_month`, `date`, `gas_used`, `hash`, `tx_fee`, `tx_hash`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum gas and total transaction fees for the latest 90 complete UTC days from curated gas.fees. tx_fee includes modelled Ethereum fee components, including blob fees where applicable; it is not validator revenue. QA: fee-row counts match raw transactions on 89/90 days; 2026-07-10 is short by 641 rows (0.023%), so that day's fee total has a small coverage gap.
- 输出指标：`date`, `total_gas_used`, `avg_gas_used`, `total_fees_eth`, `transaction_fee_rows`, `duplicate_or_null_transaction_hashes`, `null_fee_input_rows`
- 复用章节：25, 26
- 原执行 ID：`01M0CQ8ARGATQ4AD252ZCW8T22`；执行结束：2026-08-19T10:02:41.114033Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378488｜Ethereum Contract Execution ｜ 以太坊合约执行活动

[Query](https://dune.com/queries/8378488) · [原 SQL](sql/8378488.sql) · [本地元数据](queries/8378488.json) · [已有结果样本](result-8378488.json)

- 表：`ethereum.traces`
- 关键字段：`address`, `block_date`, `date`, `success`, `tx_hash`, `tx_success`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily transaction-linked Ethereum trace activity for the latest 90 complete UTC days. One transaction can produce many traces; destination addresses are not assumed to be verified contracts.
- 输出指标：`date`, `trace_count`, `unique_transactions`, `unique_destination_addresses`, `call_count`, `failed_trace_count`, `parent_failed_trace_count`, `avg_traces_per_transaction`
- 复用章节：9, 14
- 原执行 ID：`01M0CQKMX0A96058NPPXRGQK8P`；执行结束：2026-08-19T10:05:25.466724Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378489｜Ethereum Contract Creation ｜ 以太坊合约创建

[Query](https://dune.com/queries/8378489) · [原 SQL](sql/8378489.sql) · [本地元数据](queries/8378489.json) · [已有结果样本](result-8378489.json)

- 表：`ethereum.creation_traces`
- 关键字段：`address`, `block_date`, `block_month`, `block_time`, `date`, `tx_hash`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum contract-creation trace activity for the latest 90 complete UTC days using ethereum.creation_traces. Current schema uses address and block_month despite a conflicting catalog block_date hint. QA: created addresses are never null; repeated address rows occur on some days, peaking at 27 on 2026-06-17, so contracts_created is deployment-event rows rather than unique addresses.
- 输出指标：`date`, `contracts_created`, `unique_creators`, `unique_contract_addresses`, `creation_transactions`, `duplicate_contract_addresses`, `null_contract_addresses`, `avg_contracts_per_transaction`
- 复用章节：12, 20
- 原执行 ID：`01M0CQQPCM86KBJ85XANRNV3G8`；执行结束：2026-08-19T10:05:43.723782Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378490｜Ethereum Token Transfers ｜ 以太坊代币转账

[Query](https://dune.com/queries/8378490) · [原 SQL](sql/8378490.sql) · [本地元数据](queries/8378490.json) · [已有结果样本](result-8378490.json)

- 表：`tokens.transfers`
- 关键字段：`block_date`, `block_month`, `date`, `token_standard`, `tx_from`, `tx_hash`, `unique_key`, `value`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum fungible transfer rows for the latest 90 complete UTC days from tokens.transfers. Coverage is native ETH and ERC20 only, with Dune's documented native/WETH/ERC4626 enrichments; ERC721/ERC1155 are excluded.
- 输出指标：`date`, `transfer_count`, `unique_tokens`, `unique_senders`, `unique_receivers`, `erc20_transfer_count`, `native_transfer_count`, `null_token_standard_rows`, `duplicate_or_null_unique_keys`, `null_unique_keys`, `native_rows_missing_contract_address`
- 复用章节：19, 21, 38
- 原执行 ID：`01M0CQRK3K5VSMPRMS1K0M18Z0`；执行结束：2026-08-19T10:07:22.706741Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 8378491｜Ethereum DEX Activity ｜ 以太坊 DEX 活动

[Query](https://dune.com/queries/8378491) · [原 SQL](sql/8378491.sql) · [本地元数据](queries/8378491.json) · [已有结果样本](result-8378491.json)

- 表：`dex_evm.trades`
- 关键字段：`amount_usd`, `block_date`, `block_month`, `date`, `tx_from`, `tx_hash`, `value`
- 粒度与原结论：Schema verified with Dune MCP on 2026-08-19. Daily Ethereum DEX execution-segment activity for the latest 90 complete UTC days using the current dex_evm.trades namespace. Multi-hop or aggregator-routed swaps can produce multiple rows; unique_traders is a tx_from initiator proxy, not unique users.
- 输出指标：`date`, `trade_count`, `volume_usd`, `unique_traders`, `unique_transactions`, `avg_trade_rows_per_transaction`, `null_amount_usd_rows`, `null_amount_usd_rate`, `max_trade_row_usd`
- 复用章节：19, 36, 39
- 原执行 ID：`01M0CQVMKN502MM2G4S0B8VKZV`；执行结束：2026-08-19T10:08:03.908582Z；本轮读取 3 行。
- 更新判断：原文 90 日动态时间窗；本轮教学采用固定案例，不直接当作今日指标。字段已对照实时 Catalog；原结论按现代账户、粒度与费用边界修订。
- 状态：HISTORICAL_EXECUTION_SAMPLE_RETRIEVED；本轮未重跑。

## 样本复核

交易与状态两条 Query 的同日样本满足成功数加失败数等于交易数；前三日区块与交易样本的重复/空主键检查为零。创建 Query 在 2026-05-21 的地址差数为 4，保留原结果，不解释为已证明索引错误或四个不同合约。需要逐地址记录与当时创建规则才能进一步分类。

DEX 样本存在空 USD，且执行段多于去重交易。费用样本来自 Curated gas.fees，不冒充手工单笔收费公式覆盖所有机制。未对全部 90 日结果或十余年历史做质量验证。
