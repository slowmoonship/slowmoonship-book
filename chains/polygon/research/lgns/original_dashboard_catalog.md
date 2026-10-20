# LGNS原看板Query目录

2026-10-19只读获取；原SQL为权限0444的研究副本。旧执行费用属于旧运行，不计作本轮执行消耗。每个JSON保存完整原始工具响应。当前保存SQL与latest执行版本未能独立绑定，不自动声称两者字节相同。

## 8369671｜sLGNS Rebase History ｜ sLGNS Rebase 历史

[Query](https://dune.com/queries/8369671)；SQL副本：`research/lgns/original_sql/8369671.sql`；保存版本：2；结果：5/2632行；旧执行ID：`01M0A6A30NMR688RY029MSGRH5`；标识时间UTC：2026-08-18T10:22:41.685000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`polygon.logs`, `tokens.supply_latest`。

结果字段：`block_time timestamp(3) with time zone`, `block_number bigint`, `tx_hash varbinary`, `event_index integer`, `epoch uint256`, `rebase_raw uint256`, `rebase_rate double`, `rebase_percent double`, `index_raw uint256`, `index double`, `history_start timestamp(3) with time zone`, `history_end timestamp(3) with time zone`, `row_count bigint`, `rebase_amount_status varchar(24)`, `slgns_decimals integer`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：sLGNS Rebase History ｜ sLGNS Rebase 历史 / 解码依据与字段口径： / 1. Dune 当前按 sLGNS 合约地址检索不到 decoded event 表，因此使用 polygon.logs。 / 2. 目标事件为 LogRebase(uint256,uint256,uint256)： / topic0 = 0x6012...fb2；indexed epoch 位于 topic1； / data 第 1 个 32 字节是 rebase，第 2 个 32 字节是 index。 / 3. 已验证源码明确注明 rebase 字段为 18 decimals，且计算为

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389592｜LGNS/DAI DAI Flow Reconciliation ｜ LGNS/DAI DAI资金守恒

[Query](https://dune.com/queries/8389592)；SQL副本：`research/lgns/original_sql/8389592.sql`；保存版本：3；结果：5/898行；旧执行ID：`01M0FRYB87WXB3FJVC7N10X956`；标识时间UTC：2026-08-20T14:24:32.007000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`query_8369227`, `query_8369303`, `quickswap_polygon.uniswapv2pair_evt_sync`, `tokens.supply_latest`。

结果字段：`date date`, `swap_dai_in double`, `swap_dai_out double`, `swap_net_dai double`, `liquidity_add_dai double`, `liquidity_remove_dai double`, `liquidity_net_dai double`, `total_pair_net_dai_flow double`, `cumulative_swap_net_dai double`, `cumulative_liquidity_net_dai double`, `cumulative_total_pair_net_dai double`, `decoded_swap_net_dai double`, `unclassified_net_dai_gap double`, `cumulative_decoded_total_pair_net_dai double`, `pair_dai_balance double`, `opening_dai_balance_offset double`, `flow_reconciliation_gap double`, `reconciliation_status varchar(31)`, `swap_history_start timestamp(3) with time zone`, `swap_history_end timestamp(3) with time zone`, `liquidity_history_start timestamp(3) with time zone`, `liquidity_history_end timestamp(3) with time zone`, `raw_swap_count bigint`, `unclassified_swap_count bigint`, `liquidity_raw_event_count bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 06：LGNS/DAI Pair 的 DAI 资金流守恒 / 视角：全部净流量均从 LGNS/DAI Pair 地址 0x882d...5bfb 的视角计算；正数表示 DAI 进入 Pair，负数表示 DAI 离开 Pair。 / token0/token1：该 Pair 已确认 token0=Polygon DAI（0x8f3c...a063，18位精度），token1=LGNS（0xeb51...0f01，9位精度）。 / 数据复用：Swap 日结果来自 query_8369303，Mint/Burn 日结果来自 query_8369227，避免重新扫描约 3.04 亿条 Swap。 / decimals：两个被复用 Query 已从 tokens.supply_latest 动态读取 decimals 后换算；储备抽样使用 decoded Sync.reserve0，并从 tokens.supply_latest 动态读取 DAI decimals 后缩放。 / 去重：本 Query 不再改变上游事件粒度；Query 05 已证明上游 evt_tx_hash+evt_index 唯一，日结果按 date 各一行。 / 经济含义：Swap 净流量反映交易者与 Pair 的 DAI 交换，Liquidity 净流量反映 LP 添加/移除 DAI；两者之和才是 Pair 的事件口径 DAI 净变化。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8389804｜LGNS Holder Value Simulation ｜ LGNS持有人价值模拟

[Query](https://dune.com/queries/8389804)；SQL副本：`research/lgns/original_sql/8389804.sql`；保存版本：2；结果：5/898行；旧执行ID：`01M0FTAP5B4K55PXCYBJ4EZHJ8`；标识时间UTC：2026-08-20T14:48:44.971000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`query_8369303`, `query_8369671`。

结果字段：`date date`, `lgns_price_dai double`, `slgns_index double`, `balance_multiplier double`, `simulated_lgns_balance double`, `simulated_value_dai double`, `token_balance_return_pct double`, `dai_value_return_pct double`, `token_balance_index double`, `dai_value_index double`, `price_index double`, `simulation_start date`, `initial_investment_dai double`, `initial_lgns_price_dai double`, `initial_lgns double`, `initial_slgns_index double`, `pricing_dai_volume double`, `pricing_lgns_volume double`, `day_last_rebase_time timestamp(3) with time zone`, `day_rebase_count bigint`, `raw_swap_count bigint`, `unclassified_swap_count bigint`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 08：1,000 DAI 的 LGNS/sLGNS 静态质押持有人理论价值模拟 / 模拟说明：这不是任何真实地址的账户历史，而是基于 sLGNS index/rebase 机制构建的静态质押理论余额路径。 / 初始投入固定为 1,000 DAI；起点取“同时存在可靠 LGNS 日 VWAP 与可用 sLGNS index”的最早 UTC 日期。 / 价格来源：复用 Query 02 的每日 buy/sell 已分类成交，日 VWAP = 双向 DAI 成交额 / 双向 LGNS 成交量。 / 不使用每日最后一笔极小 Swap；197 笔 unclassified Swap 不参与价格，避免对无法严格定向的事件强行定价。 / 数量来源：复用 Query 04 的 LogRebase index；事件没有 rebase_amount，因此不构造不存在的实际增发数量。 / decimals：Query 02 已按 DAI/LGNS decimals 缩放，Query 04 已按 sLGNS decimals 缩放 index；本 Query 不重复缩放。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390372｜LGNS Realizable Exit Value ｜ LGNS真实可兑现退出价值

[Query](https://dune.com/queries/8390372)；SQL副本：`research/lgns/original_sql/8390372.sql`；保存版本：3；结果：5/3584行；旧执行ID：`01M0G0AV770V3FWAFQR7N3M2BZ`；标识时间UTC：2026-08-20T16:33:41.607000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`query_8369227`, `query_8369303`, `query_8369671`, `query_8389804`, `quickswap_polygon.uniswapv2pair_evt_swap`, `quickswap_polygon.uniswapv2pair_evt_sync`。

结果字段：`date date`, `initial_capital_dai double`, `simulated_lgns_balance double`, `spot_price_dai double`, `mark_to_market_value_dai double`, `reserve_lgns double`, `reserve_dai double`, `reserve_spot_price_dai double`, `reserve_time timestamp(3) with time zone`, `after_token_fee_lgns double`, `amm_exit_value_dai double`, `fee_adjusted_exit_value_dai double`, `amm_exit_discount_pct double`, `fee_adjusted_exit_discount_pct double`, `price_impact_pct double`, `amm_fee_rate double`, `token_sell_fee_rate double`, `final_date date`, `is_final_date boolean`, `chart_1000_mark_to_market_value_dai double`, `chart_1000_amm_exit_value_dai double`, `chart_1000_fee_adjusted_exit_value_dai double`, `chart_final_position_dai varchar`, `chart_final_exit_discount_pct double`, `table_final_token_balance double`, `table_final_mark_to_market double`, `table_final_amm_exit_value double`, `table_final_fee_adjusted_exit_value double`, `table_final_price_impact_pct double`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：LGNS Realizable Exit Value ｜ LGNS真实可兑现退出价值 / 检索日期：2026-08-20；统一截止：2026-08-18 09:28:58 UTC。 / 模型和证据： / 1. 静态质押余额复用Query 08（8389804）与sLGNS index； / 2. 日级储备由Q01/Q02事件净流量重建，并以Q06五个DAI Sync样本验证；最终日直接使用截止时刻前最后Sync； / 3. PairCreated与1,185笔目标Pair Swap+Sync样本确认QuickSwap V2常数乘积模型； / 4. 样本全部匹配amountIn*997公式，因此AMM swap fee=0.3%；

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8390785｜LGNS Liquidity Remover Attribution ｜ LGNS流动性移除地址归因

[Query](https://dune.com/queries/8390785)；SQL副本：`research/lgns/original_sql/8390785.sql`；保存版本：5；结果：5/40行；旧执行ID：`01M0G2A9EYQS2THNMV5CFYB57C`；标识时间UTC：2026-08-20T17:08:20.574000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`dune.slowmoonship`。

结果字段：`row_type varchar(11)`, `rank_number bigint`, `address varchar`, `address_type varchar`, `dune_label varchar`, `contract_or_eoa varchar`, `creator_address varchar`, `proxy_status varchar`, `proxy_implementation varchar`, `remove_count bigint`, `total_dai_removed double`, `total_lgns_removed double`, `first_remove_time timestamp(3) with time zone`, `last_remove_time timestamp(3) with time zone`, `distinct_tx_from bigint`, `top_tx_from varchar`, `top_sender varchar`, `main_caller varchar`, `main_caller_call_count bigint`, `first_hop_24h_destination varchar`, `first_hop_24h_destination_dai double`, `outbound_24h_dai double`, `first_hop_7d_destination varchar`, `first_hop_7d_destination_dai double`, `outbound_7d_dai double`, `window_24h_status varchar`, `window_7d_status varchar`, `source_remover_count_24h bigint`, `source_remover_count_7d bigint`, `destination_transfer_count_24h bigint`, `destination_transfer_count_7d bigint`, `destination_dai_received_24h double`, `destination_dai_received_7d double`, `destination_rank_7d bigint`, `unlabeled_address_count bigint`, `unknown_type_count bigint`, `chart_remover_label varchar`, `chart_remover_dai double`, `chart_destination_label varchar`, `chart_destination_dai double`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 11：Top 20 LGNS/DAI流动性移除直接接收地址的类型、Burn调用来源与DAI第一跳时间关联 / 固定截止：2026-08-18 09:28:58 UTC；Burn与第一跳底表使用无定时刷新的已核验Dune物化结果。 / Pair：0x882df4B0fB50a229C3B4124EB18c759911485bFb；QuickSwap V2 Router：0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff。 / DAI：Polygon DAI 0x8f3cf7ad23cd3cadbd9735aff958023239c6a063，decimals=18；decoded value除以1e18。 / 地址归因：beneficiary_address只是Burn.to直接接收地址；Dune label、创建者和调用者均不等于最终控制人。 / 第一跳口径：每笔DAI转出只关联到同地址此前7天内时间最近的一笔Burn，防止同一转出重复匹配多笔Burn。 / 局限：ERC20余额可替代，24小时/7天是时间关联而非UTXO级追踪；截止前不足完整窗口的晚近Burn会标记右删失。

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。

## 8391200｜LGNS DAI Sources and Sinks ｜ LGNS DAI资金来源与去向

[Query](https://dune.com/queries/8391200)；SQL副本：`research/lgns/original_sql/8391200.sql`；保存版本：5；结果：5/30行；旧执行ID：`01M0G73S318XXEXF7298ECE1Z0`；标识时间UTC：2026-08-20T18:32:10.081000+00:00（由ULID推导，非独立取得起止时间）；状态：HISTORICAL_RESULT_RETRIEVED_NOT_RERUN。

使用表：`dune.slowmoonship`。

结果字段：`month date`, `liquidity_add_dai double`, `treasury_external_inflow_dai double`, `other_core_external_inflow_dai double`, `other_unclassified_inflow_dai double`, `other_external_inflow_dai double`, `total_sources_dai double`, `swap_payout_dai double`, `liquidity_remove_dai double`, `treasury_external_outflow_dai double`, `other_core_external_outflow_dai double`, `other_unclassified_outflow_dai double`, `other_external_outflow_dai double`, `total_sinks_dai double`, `net_dai_retained double`, `cumulative_sources double`, `cumulative_sinks double`, `cumulative_net_retained double`, `ledger_net_external_dai double`, `reconciliation_gap double`, `pair_swap_net_dai double`, `internal_dai double`, `classification_event_gap bigint`, `duplicate_event_rows bigint`, `external_event_count bigint`, `classified_event_count bigint`, `total_sources_all_dai double`, `total_sinks_all_dai double`, `net_retained_all_dai double`, `liquidity_add_all_dai double`, `other_external_inflow_all_dai double`, `swap_payout_all_dai double`, `liquidity_remove_all_dai double`, `other_external_outflow_all_dai double`, `treasury_external_inflow_all_dai double`, `other_core_external_inflow_all_dai double`, `other_unclassified_inflow_all_dai double`, `treasury_external_outflow_all_dai double`, `other_core_external_outflow_all_dai double`, `other_unclassified_outflow_all_dai double`, `query07_same_cutoff_net_dai double`, `q07_published_net_dai double`, `q07_published_end_date date`, `difference_vs_query07_published_dai double`, `reconciliation_gap_all_dai double`, `classification_event_gap_all bigint`, `duplicate_event_rows_all bigint`, `chart_liquidity_add_dai double`, `chart_other_external_inflow_dai double`, `chart_swap_payout_dai double`, `chart_liquidity_remove_dai double`, `chart_other_external_outflow_dai double`, `chart_final_net_retained double`。原始列另以SQL与Schema核对，结果别名不冒充Raw字段。

原作者口径摘要：Query 12：LGNS DAI Sources and Sinks ｜ LGNS DAI资金来源与去向 / 目标：在固定截止 2026-08-18 09:28:58 UTC 下，以 DAI Transfer 边界为最终底账， / 把每一笔系统外部 DAI 边界事件互斥归入资金来源或资金去向，并与 Query 06、Query 07 核对。 / 六个系统地址： / 1) LGNS      0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01 / 2) sLGNS     0x99a57e6c8558bc6689f894e068733adf83c19725 / 3) Staking   0x1964ca90474b11ffd08af387b110ba6c96251bfc

本轮适用：第37—40章及独立LGNS专题；地址标签和历史行为须与源码/交易交叉核验。


Dashboard ID：218654；14图/6条不同Query。另存16条辅助Query。本轮不继承标题中的诈骗结论。
