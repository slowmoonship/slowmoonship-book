# Polygon原看板Query目录

2026-10-19只读获取；原SQL为权限0444的研究副本。旧执行费用属于旧运行，不计作本轮执行消耗。每个JSON保存完整原始工具响应。当前保存SQL与latest执行版本未能独立绑定，不自动声称两者字节相同。

## 8675965｜Dashboard 01: Polygon PoS Daily Blocks (90d)

[Query](https://dune.com/queries/8675965)；SQL副本：`research/dune/polygon_original_sql/8675965.sql`；保存版本：1；结果：5/90行；旧执行ID：`01M27GNJ1YCEVG6TV67VSZYPFC`；标识时间UTC：2026-09-11T05:57:23.646000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.blocks`。

结果字段：`date date`, `block_count bigint`, `first_block_number bigint`, `last_block_number bigint`, `avg_block_interval_seconds decimal(26, 6)`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：date, / time, / number / FROM polygon.blocks / WHERE date >= CAST( / date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY / AS date

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675966｜Dashboard 03: Polygon PoS Gas and Fees (90d)

[Query](https://dune.com/queries/8675966)；SQL副本：`research/dune/polygon_original_sql/8675966.sql`；保存版本：1；结果：5/90行；旧执行ID：`01M27GNJFD5YA49481PQMANSEG`；标识时间UTC：2026-09-11T05:57:24.077000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`gas.fees`。

结果字段：`date date`, `currency_symbol varchar`, `transaction_count bigint`, `total_gas_used bigint`, `total_fees_native double`, `avg_fee_native double`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / gas_used, / currency_symbol, / tx_fee / FROM gas.fees / WHERE blockchain = 'polygon' / AND block_month >= CAST(

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675967｜Dashboard 02: Polygon PoS Daily Transactions (90d)

[Query](https://dune.com/queries/8675967)；SQL副本：`research/dune/polygon_original_sql/8675967.sql`；保存版本：1；结果：5/90行；旧执行ID：`01M27GNJFSJ1D798D1YB2839AC`；标识时间UTC：2026-09-11T05:57:24.089000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.transactions`。

结果字段：`date date`, `transaction_count bigint`, `successful_transactions bigint`, `failed_transactions bigint`, `failure_rate double`, `unique_from_addresses bigint`, `unique_to_addresses bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / success, / "from" AS from_address, / "to" AS to_address / FROM polygon.transactions / WHERE block_date >= CAST( / date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '90' DAY

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675980｜Dashboard 04: Polygon PoS Contract Execution (30d)

[Query](https://dune.com/queries/8675980)；SQL副本：`research/dune/polygon_original_sql/8675980.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GRMBG3YVR6DC6RE2FFV3K`；标识时间UTC：2026-09-11T05:59:04.304000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.traces`。

结果字段：`date date`, `trace_count bigint`, `unique_transactions bigint`, `call_count bigint`, `unique_destination_addresses bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / tx_hash, / type, / "to" AS destination_address / FROM polygon.traces / WHERE block_date >= CAST( / date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675981｜Dashboard 05: Polygon PoS Contract Creation (30d)

[Query](https://dune.com/queries/8675981)；SQL副本：`research/dune/polygon_original_sql/8675981.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GRMB8E525CNKKB2XRAC28`；标识时间UTC：2026-09-11T05:59:04.296000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.creation_traces`。

结果字段：`date date`, `contract_creation_count bigint`, `unique_contract_addresses bigint`, `unique_creators bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_time, / address AS contract_address, / "from" AS creator_address / FROM polygon.creation_traces / WHERE block_month >= CAST( / date_trunc( / 'month',

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675982｜Dashboard 06: Polygon PoS Event Logs (30d)

[Query](https://dune.com/queries/8675982)；SQL副本：`research/dune/polygon_original_sql/8675982.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GRMBBTDD43KED2TGKPP5Z`；标识时间UTC：2026-09-11T05:59:04.299000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.logs`。

结果字段：`date date`, `log_count bigint`, `unique_transactions bigint`, `unique_contracts bigint`, `unique_topic0 bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / tx_hash, / contract_address, / topic0 / FROM polygon.logs / WHERE block_date >= CAST( / date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675998｜Dashboard 08: Polygon PoS DEX Activity (30d)

[Query](https://dune.com/queries/8675998)；SQL副本：`research/dune/polygon_original_sql/8675998.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GV5QMY4DVQXV0ZCZGK91H`；标识时间UTC：2026-09-11T06:00:27.636000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`dex_evm.trades`。

结果字段：`date date`, `trade_segment_count bigint`, `dex_volume_usd double`, `unique_traders bigint`, `unique_projects bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / amount_usd, / taker, / project / FROM dex_evm.trades / WHERE blockchain = 'polygon' / AND block_month >= CAST(

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8675999｜Dashboard 07: Polygon PoS Token Transfers (30d)

[Query](https://dune.com/queries/8675999)；SQL副本：`research/dune/polygon_original_sql/8675999.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GV5R6VRK235DA333XQ2QM`；标识时间UTC：2026-09-11T06:00:27.654000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`tokens.transfers`。

结果字段：`date date`, `transfer_count bigint`, `unique_tokens bigint`, `unique_senders bigint`, `unique_receivers bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：block_date, / contract_address, / "from" AS from_address, / "to" AS to_address / FROM tokens.transfers / WHERE blockchain = 'polygon' / AND block_month >= CAST(

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8676000｜Dashboard 09: Polygon PoS Decoded Event Example (Aave V3 Supply)

[Query](https://dune.com/queries/8676000)；SQL副本：`research/dune/polygon_original_sql/8676000.sql`；保存版本：1；结果：5/200行；旧执行ID：`01M27GV5R8PE0RHRV2M1MX4T0J`；标识时间UTC：2026-09-11T06:00:27.656000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`aave_v3_polygon.pool_evt_supply`, `polygon.logs`。

结果字段：`block_time timestamp(3) with time zone`, `block_number bigint`, `tx_hash varbinary`, `contract_address varbinary`, `event_name varchar(6)`, `log_index integer`, `reserve_address varbinary`, `user_address varbinary`, `on_behalf_of_address varbinary`, `amount_raw uint256`, `referral_code integer`, `contract_address_matches_raw_log boolean`, `raw_topic0 varbinary`, `raw_data varbinary`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：evt_block_date, / evt_block_time, / evt_block_number, / evt_tx_hash, / evt_index, / contract_address, / reserve,

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。

## 8676002｜Dashboard 10: Polygon PoS Ethereum Boundary (30d)

[Query](https://dune.com/queries/8676002)；SQL副本：`research/dune/polygon_original_sql/8676002.sql`；保存版本：1；结果：5/30行；旧执行ID：`01M27GV65QDG8PA320T28EGSQB`；标识时间UTC：2026-09-11T06:00:28.087000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20`, `polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxwithdrawerc20`。

结果字段：`date date`, `interaction_type varchar(23)`, `event_count bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：evt_block_date AS date, / COUNT(*) AS event_count / FROM polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20 / WHERE evt_block_date >= CAST( / date_trunc('day', current_timestamp AT TIME ZONE 'UTC') - INTERVAL '30' DAY / AS date / )

本轮适用：区块、执行、数据仓库与SQL教学；主要映射第21—24、29—32章。


Dashboard ID：220013；10图/10条Query。旧看板文字把零地址miner叫作proposer，不能由字段观察推出，正文已经纠正。
