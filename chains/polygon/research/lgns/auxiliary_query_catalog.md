# LGNS辅助研究Query目录

2026-10-19只读获取；原SQL为权限0444的研究副本。旧执行费用属于旧运行，不计作本轮执行消耗。每个JSON保存完整原始工具响应。当前保存SQL与latest执行版本未能独立绑定，不自动声称两者字节相同。

## 8369227｜LGNS/DAI Daily Liquidity Events ｜ LGNS/DAI 每日流动性变化

[Query](https://dune.com/queries/8369227)；SQL副本：`research/lgns/original_sql/8369227.sql`；保存版本：3；结果：5/896行；旧执行ID：`01M0A3P9ANFK5JETN7M01GRTCF`；标识时间UTC：2026-08-18T09:36:55.637000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`, `quickswap_polygon.uniswapv2pair_evt_mint`, `tokens.supply_latest`。

结果字段：`date date`, `add_liquidity_count bigint`, `remove_liquidity_count bigint`, `add_dai double`, `add_lgns double`, `remove_dai double`, `remove_lgns double`, `net_dai double`, `net_lgns double`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `raw_event_count bigint`, `duplicate_event_rows bigint`, `sample_event_1 varchar`, `sample_event_2 varchar`, `sample_event_3 varchar`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 01：LGNS/DAI 每日添加与移除流动性 / 数据来源：Dune 当前 Polygon QuickSwap V2 decoded Mint/Burn 事件表。 / Pair 已确认 token0=Polygon DAI、token1=LGNS；精度从 tokens.supply_latest 动态读取。 / Mint 是 Uniswap V2 Pair 在收到 token0/token1 后铸造 LP 的事件，因此代表 Add Liquidity。 / Burn 是 Pair 销毁 LP 并转出 token0/token1 的事件，因此代表 Remove Liquidity。 / decoded 事件表以交易哈希和日志索引标识原始日志；本 Query 不做会改变数量的额外去重， / 并在 validation 中核对重复事件键，预期 duplicate_event_rows=0。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8369303｜LGNS/DAI Daily Swap Flow ｜ LGNS/DAI 累计每日买卖成交

[Query](https://dune.com/queries/8369303)；SQL副本：`research/lgns/original_sql/8369303.sql`；保存版本：9；结果：5/898行；旧执行ID：`01M0FMD36T1B5TZ3SG0YN54ZDV`；标识时间UTC：2026-08-20T13:05:12.410000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_swap`, `tokens.supply_latest`。

结果字段：`date date`, `buy_count bigint`, `sell_count bigint`, `swap_count bigint`, `buy_lgns double`, `sell_lgns double`, `buy_volume_dai double`, `sell_volume_dai double`, `result_volume_dai double`, `result_volume_byday double`, `net_dai_flow double`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `raw_swap_count bigint`, `unclassified_swap_count bigint`, `sample_event_1 varchar`, `sample_event_2 varchar`, `sample_event_3 varchar`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 02：LGNS/DAI 每日 Swap 买卖成交 / 数据来源：Dune 当前 Polygon QuickSwap V2 decoded Swap 事件表。 / Pair 已确认 token0=Polygon DAI、token1=LGNS；精度从 tokens.supply_latest 动态读取。 / 买入 LGNS：amount0In(DAI)>0 且 amount1Out(LGNS)>0，即用 DAI 换出 LGNS。 / 卖出 LGNS：amount1In(LGNS)>0 且 amount0Out(DAI)>0，即用 LGNS 换出 DAI。 / other 表示不符合上述单向交换结构的事件，保留计数但不伪装成买入或卖出。 / decoded 表按交易哈希和日志索引对应原始日志；本 Query 不额外去重。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8369505｜LGNS Staking Activity ｜ LGNS 质押活动

[Query](https://dune.com/queries/8369505)；SQL副本：`research/lgns/original_sql/8369505.sql`；保存版本：7；结果：5/896行；旧执行ID：`01M0A63HY5KEF70DF2C7E1MCT8`；标识时间UTC：2026-08-18T10:19:07.589000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.logs`, `tokens.supply_latest`。

结果字段：`date date`, `stake_count bigint`, `stake_lgns double`, `unique_stakers bigint`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `row_count bigint`, `raw_stake_event_count bigint`, `sample_tx_hash varbinary`, `sample_block_number bigint`, `sample_event_index integer`, `sample_stake_lgns double`, `unstake_coverage_status varchar(58)`, `lgns_decimals integer`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Staking Activity ｜ LGNS 质押活动 / 可执行口径： / 1. Stake 使用 Staking 合约明确的 Staked(address,uint256) 事件。 / topic0 = keccak256('Staked(address,uint256)')；topic1 是 indexed recipient； / data 是未索引的 LGNS amount。 / 2. 合约 ABI 没有 Unstaked 事件。完整 ERC20 配对与顶层调用历史在当前免费引擎 / 两分钟限制内未完成，因此不把未验证代理伪装成 Unstake。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389462｜LGNS Core Event Sanity Check ｜ LGNS核心事件数据质量核验

[Query](https://dune.com/queries/8389462)；SQL副本：`research/lgns/original_sql/8389462.sql`；保存版本：3；结果：1/1行；旧执行ID：`01M0FQYVK9NT2JJHD359YDZ4R8`；标识时间UTC：2026-08-20T14:07:20.169000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_swap`。

结果字段：`raw_event_count bigint`, `distinct_event_key_count bigint`, `distinct_tx_count bigint`, `distinct_block_count bigint`, `max_events_per_tx bigint`, `max_events_per_block bigint`, `avg_events_per_block double`, `max_daily_events bigint`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `raw_equals_unique boolean`, `duplicate_event_rows bigint`, `top_20_transactions array(varchar)`, `top_20_blocks array(varchar)`, `top_20_days array(varchar)`, `query_02_snapshot_raw_count integer`, `matches_query_02_snapshot boolean`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Core Event Sanity Check ｜ LGNS核心事件数据质量核验 / 05A：LGNS/DAI Pair Swap 唯一性与集中度核验（固定快照） / 固定快照截止： / 2026-08-18 09:44:54 UTC，与 Query 02（ID 8369303）的已知结果截止一致。 / 口径： / 1. 当前 Dune Catalog 确认数据源为 / quickswap_polygon.uniswapv2pair_evt_swap。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389527｜LGNS Liquidity Event Sanity Check ｜ LGNS流动性事件数据质量核验

[Query](https://dune.com/queries/8389527)；SQL副本：`research/lgns/original_sql/8389527.sql`；保存版本：2；结果：1/1行；旧执行ID：`01M0FR2S8GMTYSSG3Y6XDYQGHT`；标识时间UTC：2026-08-20T14:09:28.848000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`, `quickswap_polygon.uniswapv2pair_evt_mint`。

结果字段：`raw_event_count bigint`, `distinct_event_key_count bigint`, `mint_count bigint`, `unique_mint_count bigint`, `burn_count bigint`, `unique_burn_count bigint`, `distinct_tx_count bigint`, `distinct_block_count bigint`, `max_events_per_tx bigint`, `max_events_per_block bigint`, `max_daily_events bigint`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `raw_equals_unique boolean`, `duplicate_event_rows bigint`, `top_20_transactions array(varchar)`, `top_20_blocks array(varchar)`, `top_20_days array(varchar)`, `query_01_snapshot_raw_count integer`, `matches_query_01_snapshot boolean`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Liquidity Event Sanity Check ｜ LGNS流动性事件数据质量核验 / 05B：LGNS/DAI Pair Mint/Burn 唯一性与集中度核验（固定快照） / 固定快照截止： / 2026-08-18 09:28:58 UTC，与 Query 01（ID 8369227）截止一致。 / 口径： / 1. Mint/Burn 分别来自当前 Dune Catalog 确认的 QuickSwap decoded 事件表。 / 2. Pair = 0x882d...5bFb；token0=Polygon DAI，token1=LGNS。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389535｜LGNS Staked Event Sanity Check ｜ LGNS质押事件数据质量核验

[Query](https://dune.com/queries/8389535)；SQL副本：`research/lgns/original_sql/8389535.sql`；保存版本：3；结果：1/1行；旧执行ID：`01M0FRBNKF551AQ4EF92GJQQ2E`；标识时间UTC：2026-08-20T14:14:20.015000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.logs`。

结果字段：`raw_staked_count bigint`, `distinct_event_key_count bigint`, `distinct_tx_count bigint`, `distinct_staker_count bigint`, `distinct_block_count bigint`, `max_events_per_tx bigint`, `max_events_per_block bigint`, `avg_events_per_block double`, `max_daily_events bigint`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `raw_equals_unique boolean`, `duplicate_event_rows bigint`, `top_20_transactions array(varchar)`, `top_20_blocks array(varchar)`, `top_20_days array(varchar)`, `query_03_snapshot_raw_count integer`, `matches_query_03_snapshot boolean`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Staked Event Sanity Check ｜ LGNS质押事件数据质量核验 / 05C：Staked(address,uint256) 单次扫描质量核验（固定快照） / 截止：2026-08-18 10:13:12 UTC，与 Query 03（ID 8369505）一致。 / 口径： / 1. Staking = 0x1964...1Bfc；Dune无decoded表，使用polygon.logs。 / 2. topic0 = Staked(address,uint256)；topic1 = indexed staker/recipient。 / 3. 唯一键 = tx_hash + log index。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389682｜LGNS System External DAI Cash Flow ｜ LGNS体系外部DAI现金流

[Query](https://dune.com/queries/8389682)；SQL副本：`research/lgns/original_sql/8389682.sql`；保存版本：2；结果：5/898行；旧执行ID：`01M0FS808GY0KZ0N8MDD4TN57V`；标识时间UTC：2026-08-20T14:29:48.432000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`maker_polygon.dai_evt_transfer`, `tokens.supply_latest`。

结果字段：`date date`, `external_dai_in double`, `external_dai_out double`, `net_external_dai double`, `internal_dai_transfer double`, `external_in_tx_count bigint`, `external_out_tx_count bigint`, `unique_external_in_addresses bigint`, `unique_external_out_addresses bigint`, `cumulative_external_dai_in double`, `cumulative_external_dai_out double`, `cumulative_net_external_dai double`, `internal_transfer_event_count bigint`, `raw_boundary_event_count bigint`, `unique_boundary_event_count bigint`, `duplicate_event_rows bigint`, `core_system_address_count integer`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 07：LGNS 已确认核心协议地址集合与外部世界之间的 Polygon DAI 边界现金流 / 口径视角：正向流入是“外部地址 -> 系统地址”，流出是“系统地址 -> 外部地址”；系统内部互转不计入外部现金流。 / 地址集合只含此前已确认的六个核心合约，不把任何未知钱包、Router 或交易对手自动归为项目方。 / 系统地址及角色： / 1) LGNS     0xeB51D9A39AD5EEF215dC0Bf39a8821ff804A0F01 / 2) sLGNS    0x99a57e6c8558bc6689f894e068733adf83c19725 / 3) Staking  0x1964Ca90474b11FFD08af387b110ba6C96251Bfc

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389881｜LGNS/DAI Largest Liquidity Removers ｜ LGNS/DAI最大流动性移除者

[Query](https://dune.com/queries/8389881)；SQL副本：`research/lgns/original_sql/8389881.sql`；保存版本：3；结果：5/11687行；旧执行ID：`01M0FXP1MAEZXT850JK1H4V3AP`；标识时间UTC：2026-08-20T15:47:22.890000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`, `tokens.supply_latest`。

结果字段：`block_time timestamp(3) with time zone`, `block_number bigint`, `tx_hash varbinary`, `evt_index integer`, `sender varbinary`, `to varbinary`, `tx_from varbinary`, `dai_removed double`, `lgns_removed double`, `beneficiary_address varbinary`, `beneficiary_method varchar(30)`, `address_pattern varchar(40)`, `remove_count bigint`, `total_dai_removed double`, `total_lgns_removed double`, `first_remove_time timestamp(3) with time zone`, `last_remove_time timestamp(3) with time zone`, `share_of_total_removed_dai double`, `beneficiary_rank bigint`, `largest_event_rank bigint`, `chart_beneficiary_address varchar`, `chart_total_dai_removed double`, `burn_event_count bigint`, `unique_burn_event_count bigint`, `duplicate_event_rows bigint`, `total_dai_removed_all double`, `total_lgns_removed_all double`, `top1_beneficiary_address varchar`, `top1_total_dai_removed double`, `top10_share_of_total_removed_dai double`, `top20_share_of_total_removed_dai double`, `unresolved_event_count bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 09：LGNS/DAI Pair 固定截止Burn明细、直接接收地址聚合与大额事件 / 统一截止：2026-08-18 09:28:58 UTC，与Query 01/05固定快照完全一致；不包含之后新增事件。 / Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；token0=Polygon DAI，token1=LGNS。 / 事件语义：Uniswap V2 Pair 的 Burn(sender, amount0, amount1, to) 表示销毁 LP 后把 token0/token1 转给事件字段 to。 / 地址归因：sender 是调用 Pair.burn 的地址，可能是 Router；evt_tx_from 是发起交易的钱包；to 是 Burn 明确记录的代币直接接收地址。 / 因此 beneficiary_address 仅表示“本次 Burn 的直接接收地址”，不声称它是资金后续最终控制人或项目方地址。 / to 为零地址或缺失时不强行归因，beneficiary_address=NULL 且 beneficiary_method='unresolved'。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390237｜LGNS Burn Count Reconciliation ｜ LGNS Burn数量差异核对

[Query](https://dune.com/queries/8390237)；SQL副本：`research/lgns/original_sql/8390237.sql`；保存版本：2；结果：5/11行；旧执行ID：`01M0FXJH2MZ68QFMZGQTV5QWFJ`；标识时间UTC：2026-08-20T15:45:27.636000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`。

结果字段：`block_time timestamp(3) with time zone`, `block_number bigint`, `tx_hash varbinary`, `evt_index integer`, `contract_address varbinary`, `sender varbinary`, `to varbinary`, `amount0 uint256`, `amount1 uint256`, `q05_present boolean`, `q09_present boolean`, `difference_reason varchar(55)`, `q05_burn_count bigint`, `q09_burn_count bigint`, `q05_only_count bigint`, `q09_only_count bigint`, `q05_remove_dai double`, `q09_remove_dai double`, `difference_remove_dai double`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Burn Count Reconciliation ｜ LGNS Burn数量差异核对 / 检索日期：2026-08-20。 / 目标：严格复现 Query 05 固定快照与 Query 09 已执行快照的 Burn 事件键集合， / 通过双向 EXCEPT 定位差异，避免仅凭“可能是日期边界”作推测。 / Pair：0x882df4b0fb50a229c3b4124eb18c759911485bfb。 / token0：Polygon DAI，18 decimals；token1：LGNS，9 decimals。 / 事件唯一键：evt_tx_hash + evt_index + contract_address。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390794｜LGNS Top20 Burn Attribution Base ｜ LGNS Top20撤池归因底表

[Query](https://dune.com/queries/8390794)；SQL副本：`research/lgns/original_sql/8390794.sql`；保存版本：2；结果：5/8568行；旧执行ID：`01M0G1CEH3W1WSQM3GVKP3PHZB`；标识时间UTC：2026-08-20T16:52:02.723000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`contracts.contract_mapping`, `labels.owner_addresses`, `query_8389881`。

结果字段：`beneficiary_address varbinary`, `beneficiary_rank bigint`, `block_time timestamp(3) with time zone`, `tx_hash varbinary`, `evt_index integer`, `tx_from varbinary`, `sender varbinary`, `dai_removed double`, `lgns_removed double`, `remove_count bigint`, `total_dai_removed double`, `total_lgns_removed double`, `first_remove_time timestamp(3) with time zone`, `last_remove_time timestamp(3) with time zone`, `has_contract_creation boolean`, `contract_project varchar`, `contract_name varchar`, `creator_address varbinary`, `created_time timestamp(3) with time zone`, `created_tx_hash varbinary`, `code_hex varchar`, `is_self_destruct boolean`, `dune_owner_label varchar`, `dune_eoa_hint varchar`, `dune_label_source varchar`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 11辅助底表：复用Query 09结果，为Top 20 Burn事件附加Dune合约和标签元数据 / 该辅助Query不扫描Swap、Staked或全部Mint/Burn底表，只读取已保存的query_8389881结果。 / 固定范围：beneficiary_rank 1至20；地址仍为Burn.to直接接收地址，不等于最终控制人。 / 地址元数据：contracts.contract_mapping和labels.owner_addresses仅作EOA/Contract及名称辅助证据。 / 从已修正Query 09筛选Top 20地址的逐笔Burn事件。 / beneficiary_address,                                    -- Burn.to直接接收地址 / beneficiary_rank,                                       -- 累计Remove DAI排名

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390841｜LGNS Top1 Contract Callers ｜ LGNS Top1合约调用者核验

[Query](https://dune.com/queries/8390841)；SQL副本：`research/lgns/original_sql/8390841.sql`；保存版本：2；结果：1/1行；旧执行ID：`01M0G1G584AKZZPBCQAKDDJH2N`；标识时间UTC：2026-08-20T16:54:04.292000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.transactions`。

结果字段：`caller_address varchar`, `call_count bigint`, `first_call_time timestamp(3) with time zone`, `last_call_time timestamp(3) with time zone`, `first_method_id varchar`, `last_method_id varchar`, `caller_rank bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 11辅助：Top 1 Burn.to合约的全部成功顶层调用者统计 / 目标合约：0x1D6A7F2CB262AFBB1204BBFCBB3DB642662B15C3；已由Dune合约创建记录确认是Contract。 / 固定截止：2026-08-18 09:28:58 UTC；只统计to为目标合约的顶层交易，不扩展内部调用图谱。 / 经济含义：caller仅表示直接调用该合约的交易from，不证明该地址控制合约或控制资金。 / 在Polygon顶层交易表按from聚合目标合约的成功调用。 / t."from" AS caller_address,                              -- 直接调用目标合约的顶层交易from / COUNT(*) AS call_count,                                  -- 成功顶层调用次数

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390867｜LGNS Top20 DAI First Hop Base ｜ LGNS Top20 DAI第一跳底表

[Query](https://dune.com/queries/8390867)；SQL副本：`research/lgns/original_sql/8390867.sql`；保存版本：2；结果：5/66行；旧执行ID：`01M0G1RBADJF14QYVZE2RFC7DN`；标识时间UTC：2026-08-20T16:58:32.653000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`maker_polygon.dai_evt_transfer`, `query_8390794`。

结果字段：`source_remover varbinary`, `destination_address varbinary`, `transfer_count_24h bigint`, `dai_sent_24h double`, `transfer_count_7d bigint`, `dai_sent_7d double`, `first_transfer_time timestamp(3) with time zone`, `last_transfer_time timestamp(3) with time zone`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 11辅助：Top 20 Burn.to直接接收地址的DAI第一跳时间关联底表 / 固定截止：2026-08-18 09:28:58 UTC；Burn事件复用query_8390794。 / DAI：Polygon DAI 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063，decimals=18。 / 关联规则：每笔DAI转出只关联同地址此前7天内时间最近的一笔Burn，避免同一转出重复归属。 / 局限：ERC20余额可替代，24小时/7天只是时间邻近，不是UTXO级资金来源证明。 / 读取Top 20逐笔Burn的最小关联字段。 / beneficiary_address,                                    -- Burn.to直接接收地址

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390998｜LGNS Pair Liquidity Transaction Flags ｜ LGNS交易对流动性交易标记

[Query](https://dune.com/queries/8390998)；SQL副本：`research/lgns/original_sql/8390998.sql`；保存版本：3；结果：5/725139行；旧执行ID：`01M0G2H68E3R2NN1QY1MREY8DV`；标识时间UTC：2026-08-20T17:12:06.670000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`, `quickswap_polygon.uniswapv2pair_evt_mint`。

结果字段：`tx_hash varbinary`, `block_time timestamp(3) with time zone`, `mint_event_count bigint`, `burn_event_count bigint`, `mint_event_dai double`, `burn_event_dai double`, `raw_event_count bigint`, `unique_event_count bigint`, `duplicate_event_rows bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 12辅助：LGNS/DAI Pair固定截止内Mint/Burn交易标记 / 目标Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；token0=Polygon DAI，decimals=18。 / 用途：让DAI边界Transfer按tx_hash识别Liquidity Addition/Removal；不读取303M Swap事件。 / 唯一性：Mint与Burn topic互斥，先UNION ALL逐事件，再压缩到唯一交易哈希。 / 读取目标Pair固定截止内的Mint事件。 / evt_tx_hash AS tx_hash,                                 -- Mint交易哈希 / evt_index AS evt_index,                                 -- Mint日志索引

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8391403｜LGNS Pair DAI Boundary Monthly ｜ LGNS交易对DAI边界月度底账

[Query](https://dune.com/queries/8391403)；SQL副本：`research/lgns/original_sql/8391403.sql`；保存版本：2；结果：5/30行；旧执行ID：`01M0G62ACSV86632659CXFJ0D6`；标识时间UTC：2026-08-20T18:13:53.689000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`dune.slowmoonship`, `maker_polygon.dai_evt_transfer`。

结果字段：`month date`, `liquidity_add_dai double`, `liquidity_remove_dai double`, `pair_residual_in_dai double`, `pair_residual_out_dai double`, `pair_residual_net_dai double`, `pair_internal_dai double`, `pair_external_event_count bigint`, `pair_classified_event_count bigint`, `classification_event_gap bigint`, `duplicate_event_rows bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 12辅助：LGNS/DAI Pair与外部地址之间的DAI边界月度互斥分类 / Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；固定截止2026-08-18 09:28:58 UTC。 / 只保留Pair与六地址系统之外地址之间的DAI Transfer；Pair与其余五个核心地址互转属于内部流，不计外部sources/sinks。 / 入Pair且交易含Mint=Liquidity Addition；出Pair且交易含Burn=Liquidity Removal；其余分别为residual in/out。 / Mint/Burn标记来自已核验物化表；不读取303M Swap，residual在Query 12按月净额处理。 / 单次扫描Polygon DAI，只读取至少一个端点为目标Pair的固定截止事件。 / CAST(DATE_TRUNC('month', d.evt_block_time) AS DATE)

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8391491｜LGNS Core DAI Boundary Monthly ｜ LGNS核心合约DAI边界月度底账

[Query](https://dune.com/queries/8391491)；SQL副本：`research/lgns/original_sql/8391491.sql`；保存版本：2；结果：5/30行；旧执行ID：`01M0G6HN8JPP99B2DSSZR1508G`；标识时间UTC：2026-08-20T18:22:16.338000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`maker_polygon.dai_evt_transfer`。

结果字段：`month date`, `treasury_external_inflow_dai double`, `other_core_external_inflow_dai double`, `treasury_external_outflow_dai double`, `other_core_external_outflow_dai double`, `nonpair_internal_dai double`, `unclassified_dai double`, `nonpair_external_event_count bigint`, `nonpair_classified_event_count bigint`, `classification_event_gap bigint`, `duplicate_event_rows bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Query 12 恢复底账 B：五个非 Pair 核心合约的 DAI 外部边界月度汇总。 / 固定截止：2026-08-18 09:28:58 UTC，与 Query 05、修正后的 Query 09、Query 10/11/12 统一。 / 精度口径：Maker Polygon DAI 的 value 为原始 18 位整数；仅在汇总前转换为 DOUBLE / 1e18。 / 归因限制：本查询只按 DAI Transfer 的直接边界地址归类，不推断地址控制权、最终受益人或链下身份。 / 去重口径：唯一键为 evt_tx_hash + evt_index；解码事件表正常情况下每个日志只出现一次。 / raw_core_dai AS ( / CAST(DATE_TRUNC('month', d.evt_block_time) AS DATE) AS month, -- 月份：用于 Query 12 月度资金结构。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8391574｜LGNS Pair Exact Liquidity Monthly ｜ LGNS交易对精确流动性月度底账

[Query](https://dune.com/queries/8391574)；SQL副本：`research/lgns/original_sql/8391574.sql`；保存版本：2；结果：5/30行；旧执行ID：`01M0G72A0H9GSW28X6YVAQBQVZ`；标识时间UTC：2026-08-20T18:31:21.873000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`quickswap_polygon.uniswapv2pair_evt_burn`, `quickswap_polygon.uniswapv2pair_evt_mint`。

结果字段：`month date`, `exact_liquidity_add_dai double`, `exact_liquidity_remove_dai double`, `mint_event_count bigint`, `burn_event_count bigint`, `duplicate_event_rows bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 12辅助：LGNS/DAI Pair 精确 Mint/Burn 月度金额。 / 固定截止：2026-08-18 09:28:58 UTC。 / 经济口径：Mint.amount0 是添加到 Pair 的 token0 DAI；Burn.amount0 是从 Pair 移出的 token0 DAI。 / 精度口径：该 Pair 的 token0 已由 Query 09 和 token 元数据确认是 18 decimals 的 Polygon DAI。 / 归因限制：金额来自 decoded Pair 事件本身，不把同交易中的其他 DAI Transfer 误归为流动性金额。 / 唯一键：event_type + evt_tx_hash + evt_index；Mint/Burn topic 互斥。 / liquidity_events AS (

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。
