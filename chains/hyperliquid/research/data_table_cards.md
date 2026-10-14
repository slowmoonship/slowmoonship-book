# Dune实时表说明卡

API验证状态：**已用Dune MCP验证Catalog**。元数据visibility=public不证明entitlement。当前数据结果与最新业务时点API未验证；本轮未运行新SQL。类型保留Catalog原值，官方文档个别时间列为带时区类型，需运行前复核。

## hip4_hyperliquid.open_interest_hourly

来源：[实时Catalog](../research/dune/catalog-hip4.json)；基准2026-10-13。层级：spell / spell。Grain：Outcome market × hour。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| hour | timestamp | 待验证，见对应官方表页 |
| market_id | varchar | 待验证，见对应官方表页 |
| event_id | varchar | 待验证，见对应官方表页 |
| market_oi_yes_contracts | double | 待验证，见对应官方表页 |
| market_oi_no_contracts | double | 待验证，见对应官方表页 |
| event_oi_contracts | double | 待验证，见对应官方表页 |
| volume_contracts | double | 待验证，见对应官方表页 |
| volume_usd | double | 待验证，见对应官方表页 |
| trade_count | bigint | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hip4_hyperliquid.positions_daily

来源：[实时Catalog](../research/dune/catalog-hip4.json)；基准2026-10-13。层级：spell / spell。Grain：account × outcome token × day。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| day | date | 待验证，见对应官方表页 |
| trader | varbinary | 交易账户，不等于现实个人 |
| market_id | varchar | 待验证，见对应官方表页 |
| outcome_id | varchar | 待验证，见对应官方表页 |
| outcome_index | integer | 待验证，见对应官方表页 |
| balance | double | 待验证，见对应官方表页 |
| price | double | 待验证，见对应官方表页 |
| balance_usd | double | 待验证，见对应官方表页 |
| _position_updated_at | timestamp | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hip4_hyperliquid.ohlcv_hourly

来源：[实时Catalog](../research/dune/catalog-hip4.json)；基准2026-10-13。层级：spell / spell。Grain：Outcome token × hour。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| hour | timestamp | 待验证，见对应官方表页 |
| market_id | varchar | 待验证，见对应官方表页 |
| outcome_id | varchar | 待验证，见对应官方表页 |
| outcome_index | integer | 待验证，见对应官方表页 |
| outcome_name | varchar | 待验证，见对应官方表页 |
| market_name | varchar | 待验证，见对应官方表页 |
| event_market_name | varchar | 待验证，见对应官方表页 |
| category | varchar | 待验证，见对应官方表页 |
| open | double | 待验证，见对应官方表页 |
| high | double | 待验证，见对应官方表页 |
| low | double | 待验证，见对应官方表页 |
| close | double | 待验证，见对应官方表页 |
| vwap | double | 待验证，见对应官方表页 |
| volume_contracts | double | 待验证，见对应官方表页 |
| volume_usd | double | 待验证，见对应官方表页 |
| trade_count | bigint | 待验证，见对应官方表页 |
| market_end_time | timestamp | 待验证，见对应官方表页 |
| expected_expiration_time | timestamp | 待验证，见对应官方表页 |
| market_outcome | varchar | 待验证，见对应官方表页 |
| is_forward_filled | boolean | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hip4_hyperliquid.market_details

来源：[实时Catalog](../research/dune/catalog-hip4.json)；基准2026-10-13。层级：spell / spell。Grain：Outcome market_id一行，Question为event维度。分区：未返回分区。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| market_id | varchar | 待验证，见对应官方表页 |
| event_id | varchar | 待验证，见对应官方表页 |
| yes_outcome_id | varchar | 待验证，见对应官方表页 |
| no_outcome_id | varchar | 待验证，见对应官方表页 |
| title | varchar | 待验证，见对应官方表页 |
| yes_outcome_name | varchar | 待验证，见对应官方表页 |
| no_outcome_name | varchar | 待验证，见对应官方表页 |
| event_title | varchar | 待验证，见对应官方表页 |
| template_id | varchar | 待验证，见对应官方表页 |
| is_fallback | boolean | 待验证，见对应官方表页 |
| market_type | varchar | 待验证，见对应官方表页 |
| is_mutually_exclusive_event | boolean | 待验证，见对应官方表页 |
| event_outcome_count | integer | 待验证，见对应官方表页 |
| outcome_position | integer | 待验证，见对应官方表页 |
| quote_token | varchar | 待验证，见对应官方表页 |
| deployer | varbinary | 待验证，见对应官方表页 |
| deployer_venue | varchar | 待验证，见对应官方表页 |
| frequency | varchar | 待验证，见对应官方表页 |
| underlying | varchar | 待验证，见对应官方表页 |
| underlying_dex | varchar | 待验证，见对应官方表页 |
| strike_type | varchar | 待验证，见对应官方表页 |
| floor_strike | double | 待验证，见对应官方表页 |
| cap_strike | double | 待验证，见对应官方表页 |
| observation_seconds | integer | 待验证，见对应官方表页 |
| listed_at | timestamp | 待验证，见对应官方表页 |
| scheduled_start_time | timestamp | 待验证，见对应官方表页 |
| expected_expiration_time | timestamp | 待验证，见对应官方表页 |
| status | varchar | 待验证，见对应官方表页 |
| result | varchar | 待验证，见对应官方表页 |
| settlement_value_usd | double | 待验证，见对应官方表页 |
| settlement_details | varchar | 待验证，见对应官方表页 |
| settlement_ts | timestamp | 待验证，见对应官方表页 |
| settlement_block_number | bigint | 待验证，见对应官方表页 |
| category | varchar | 待验证，见对应官方表页 |
| category_native | array(varchar) | 待验证，见对应官方表页 |
| template | varchar | 待验证，见对应官方表页 |
| description | varchar | 待验证，见对应官方表页 |
| event_description | varchar | 待验证，见对应官方表页 |
| template_fields | map(varchar, varchar) | 待验证，见对应官方表页 |
| event_template_fields | map(varchar, varchar) | 待验证，见对应官方表页 |
| source_updated_at | timestamp | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hip4_hyperliquid.market_trades

来源：[实时Catalog](../research/dune/catalog-hip4.json)；基准2026-10-13。层级：spell / spell。Grain：全量Outcome腿，含引擎操作。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| event_index | integer | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| trade_id | bigint | 待验证，见对应官方表页 |
| order_id | bigint | 待验证，见对应官方表页 |
| client_order_id | varchar | 待验证，见对应官方表页 |
| twap_id | bigint | 待验证，见对应官方表页 |
| market_id | varchar | 待验证，见对应官方表页 |
| outcome_id | varchar | 待验证，见对应官方表页 |
| outcome_index | integer | 待验证，见对应官方表页 |
| trader | varbinary | 交易账户，不等于现实个人 |
| is_system_account | boolean | 待验证，见对应官方表页 |
| is_taker | boolean | 此腿的主动角色 |
| side | varchar | 待验证，见对应官方表页 |
| dir | varchar | 待验证，见对应官方表页 |
| fill_type | varchar | 规范化金融角色，非原生简单买卖 |
| start_position | double | 待验证，见对应官方表页 |
| price | double | 待验证，见对应官方表页 |
| num_contracts | double | 待验证，见对应官方表页 |
| amount_usd | double | 待验证，见对应官方表页 |
| closed_pnl_usd | double | 待验证，见对应官方表页 |
| fee_usd | double | 待验证，见对应官方表页 |
| builder_fee_usd | double | 待验证，见对应官方表页 |
| deployer_fee_usd | double | 待验证，见对应官方表页 |
| fee_token | varchar | 待验证，见对应官方表页 |
| builder | varbinary | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_trades

来源：[实时Catalog](../research/dune/catalog-outcome.json)；基准2026-10-13。层级：spell / spell。Grain：账户成交腿；非经济撮合一行。分区：block_date。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| event_index | integer | 待验证，见对应官方表页 |
| perp_dex | varchar | 待验证，见对应官方表页 |
| coin | varchar | 完整市场键，保留DEX前缀 |
| market_symbol | varchar | 显示符号，会跨DEX重复 |
| asset_id | bigint | 待验证，见对应官方表页 |
| trader | varbinary | 交易账户，不等于现实个人 |
| is_taker | boolean | 此腿的主动角色 |
| side | varchar | 待验证，见对应官方表页 |
| dir | varchar | 待验证，见对应官方表页 |
| fill_type | varchar | 规范化金融角色，非原生简单买卖 |
| start_position | double | 待验证，见对应官方表页 |
| price | double | 待验证，见对应官方表页 |
| size | double | 待验证，见对应官方表页 |
| notional_usd | double | 待验证，见对应官方表页 |
| closed_pnl_usd | double | 待验证，见对应官方表页 |
| fee_usd | double | 待验证，见对应官方表页 |
| builder_fee_usd | double | 待验证，见对应官方表页 |
| deployer_fee_usd | double | 待验证，见对应官方表页 |
| fee_token | varchar | 待验证，见对应官方表页 |
| priority_gas | double | 待验证，见对应官方表页 |
| tid | bigint | 待验证，见对应官方表页 |
| oid | bigint | 待验证，见对应官方表页 |
| cloid | varchar | 待验证，见对应官方表页 |
| builder | varbinary | 待验证，见对应官方表页 |
| twap_id | bigint | 待验证，见对应官方表页 |
| liquidation_method | varchar | 待验证，见对应官方表页 |
| liquidated_trader | varbinary | 待验证，见对应官方表页 |
| liquidation_mark_price | double | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_market_details

来源：[实时Catalog](../research/dune/catalog-outcome.json)；基准2026-10-13。层级：spell / spell。Grain：当前注册市场coin一行。分区：未返回分区。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| coin | varchar | 完整市场键，保留DEX前缀 |
| perp_dex | varchar | 待验证，见对应官方表页 |
| market_symbol | varchar | 显示符号，会跨DEX重复 |
| asset_id | bigint | 待验证，见对应官方表页 |
| asset_index | integer | 待验证，见对应官方表页 |
| dex_index | integer | 待验证，见对应官方表页 |
| perp_dex_type | varchar(11) | 待验证，见对应官方表页 |
| builder_name | varchar | 待验证，见对应官方表页 |
| deployer | varbinary | 待验证，见对应官方表页 |
| oracle_updater | varbinary | 待验证，见对应官方表页 |
| fee_recipient | varbinary | 待验证，见对应官方表页 |
| size_decimals | integer | 待验证，见对应官方表页 |
| max_leverage | integer | 待验证，见对应官方表页 |
| margin_table_id | integer | 待验证，见对应官方表页 |
| margin_tiers | varchar | 待验证，见对应官方表页 |
| is_tiered_margin | boolean | 待验证，见对应官方表页 |
| margin_mode | varchar | 待验证，见对应官方表页 |
| only_isolated | boolean | 待验证，见对应官方表页 |
| funding_multiplier | double | 待验证，见对应官方表页 |
| open_interest_cap_usd | double | 待验证，见对应官方表页 |
| growth_mode | varchar | 待验证，见对应官方表页 |
| growth_mode_changed_at | timestamp(3) with time zone | 待验证，见对应官方表页 |
| is_delisted | boolean | 待验证，见对应官方表页 |
| is_halted | boolean | 待验证，见对应官方表页 |
| listed_at | timestamp(3) with time zone | 待验证，见对应官方表页 |
| delisted_at | timestamp(3) with time zone | 待验证，见对应官方表页 |
| market_category | varchar | 待验证，见对应官方表页 |
| asset_class | varchar | 待验证，见对应官方表页 |
| asset_type | varchar | 待验证，见对应官方表页 |
| underlying_ticker | varchar | 待验证，见对应官方表页 |
| description | varchar | 待验证，见对应官方表页 |
| metadata_last_updated | date | 待验证，见对应官方表页 |
| _updated_at | timestamp(3) with time zone | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_positions_hourly

来源：[实时Catalog](../research/dune/catalog-outcome.json)；基准2026-10-13。层级：spell / spell。Grain：trader × coin × funding hour。分区：block_month, trader_prefix。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| block_hour | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| perp_dex | varchar | 待验证，见对应官方表页 |
| coin | varchar | 完整市场键，保留DEX前缀 |
| market_symbol | varchar | 显示符号，会跨DEX重复 |
| asset_id | bigint | 待验证，见对应官方表页 |
| trader | varbinary | 交易账户，不等于现实个人 |
| trader_prefix | varchar | 待验证，见对应官方表页 |
| position_size | double | 待验证，见对应官方表页 |
| position_side | varchar | 待验证，见对应官方表页 |
| valuation_price | double | 待验证，见对应官方表页 |
| position_notional_usd | double | 待验证，见对应官方表页 |
| funding_amount_usd | double | 账户已结算金额，负支付；quote单位 |
| funding_rate | double | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_accounts_daily

来源：[实时Catalog](../research/dune/catalog-outcome.json)；基准2026-10-13。层级：spell / spell。Grain：trader × UTC day，无市场维度。分区：block_date。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| trader | varbinary | 交易账户，不等于现实个人 |
| fills_count | bigint | 待验证，见对应官方表页 |
| taker_fills_count | bigint | 待验证，见对应官方表页 |
| maker_fills_count | bigint | 待验证，见对应官方表页 |
| volume_usd | double | 待验证，见对应官方表页 |
| taker_volume_usd | double | 待验证，见对应官方表页 |
| maker_volume_usd | double | 待验证，见对应官方表页 |
| buy_volume_usd | double | 待验证，见对应官方表页 |
| sell_volume_usd | double | 待验证，见对应官方表页 |
| markets_traded | bigint | 待验证，见对应官方表页 |
| dexes_traded | bigint | 待验证，见对应官方表页 |
| realized_pnl_usd | double | 待验证，见对应官方表页 |
| fee_usd | double | 待验证，见对应官方表页 |
| builder_fee_usd | double | 待验证，见对应官方表页 |
| deployer_fee_usd | double | 待验证，见对应官方表页 |
| liquidation_count | bigint | 待验证，见对应官方表页 |
| liquidation_volume_usd | double | 待验证，见对应官方表页 |
| adl_count | bigint | 待验证，见对应官方表页 |
| adl_volume_usd | double | 待验证，见对应官方表页 |
| funding_paid_usd | double | 待验证，见对应官方表页 |
| funding_received_usd | double | 待验证，见对应官方表页 |
| net_pnl_usd | double | 待验证，见对应官方表页 |
| open_positions_eod | bigint | 待验证，见对应官方表页 |
| position_notional_usd_eod | double | 待验证，见对应官方表页 |
| deposit_usd | double | 待验证，见对应官方表页 |
| withdraw_usd | double | 待验证，见对应官方表页 |
| transfer_in_usd | double | 待验证，见对应官方表页 |
| transfer_out_usd | double | 待验证，见对应官方表页 |
| spot_to_perp_usd | double | 待验证，见对应官方表页 |
| perp_to_spot_usd | double | 待验证，见对应官方表页 |
| vault_deposit_usd | double | 待验证，见对应官方表页 |
| vault_withdraw_usd | double | 待验证，见对应官方表页 |
| net_collateral_flow_usd | double | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_market_metrics_daily

来源：[实时Catalog](../research/dune/catalog-hypercore.json)；基准2026-10-13。层级：spell / spell。Grain：coin × UTC day，OI为日末。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| perp_dex | varchar | 待验证，见对应官方表页 |
| coin | varchar | 完整市场键，保留DEX前缀 |
| market_symbol | varchar | 显示符号，会跨DEX重复 |
| asset_id | bigint | 待验证，见对应官方表页 |
| open_price | double | 待验证，见对应官方表页 |
| high_price | double | 待验证，见对应官方表页 |
| low_price | double | 待验证，见对应官方表页 |
| close_price | double | 待验证，见对应官方表页 |
| vwap | double | 待验证，见对应官方表页 |
| volume_usd | double | 待验证，见对应官方表页 |
| volume_units | double | 待验证，见对应官方表页 |
| buy_volume_usd | double | 待验证，见对应官方表页 |
| sell_volume_usd | double | 待验证，见对应官方表页 |
| trades_count | bigint | 待验证，见对应官方表页 |
| unique_traders | bigint | 待验证，见对应官方表页 |
| unique_takers | bigint | 待验证，见对应官方表页 |
| unique_makers | bigint | 待验证，见对应官方表页 |
| fee_usd | double | 待验证，见对应官方表页 |
| taker_fee_usd | double | 待验证，见对应官方表页 |
| maker_fee_usd | double | 待验证，见对应官方表页 |
| builder_fee_usd | double | 待验证，见对应官方表页 |
| deployer_fee_usd | double | 待验证，见对应官方表页 |
| forced_count | bigint | 待验证，见对应官方表页 |
| forced_volume_usd | double | 待验证，见对应官方表页 |
| open_interest_units | double | 待验证，见对应官方表页 |
| open_interest_usd | double | 文档来源双边OI，按最近成交估值 |
| open_positions | bigint | 待验证，见对应官方表页 |
| funding_rate | double | 待验证，见对应官方表页 |
| funding_rate_annualized | double | 待验证，见对应官方表页 |
| funding_paid_usd | double | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_orderbook_1m

来源：[实时Catalog](../research/dune/catalog-outcome.json)；基准2026-10-13。层级：spell / spell。Grain：coin × minute，稀疏L2聚合快照。分区：block_date。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| coin | varchar | 完整市场键，保留DEX前缀 |
| interval_start | timestamp(3) with time zone | 待验证，见对应官方表页 |
| interval | varchar | 待验证，见对应官方表页 |
| block_time | timestamp(3) with time zone | 待验证，见对应官方表页 |
| height | bigint | 待验证，见对应官方表页 |
| bids | array(row("n" integer,"px" varchar,"sz" varchar)) | 待验证，见对应官方表页 |
| asks | array(row("n" integer,"px" varchar,"sz" varchar)) | 待验证，见对应官方表页 |
| staleness_seconds | bigint | 待验证，见对应官方表页 |
| derived_at | timestamp(3) with time zone | 待验证，见对应官方表页 |
| block_date | date | UTC日期；分区作用按表检查 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_market_metrics_hourly

来源：[实时Catalog](../research/dune/catalog-oracle.json)；基准2026-10-13。层级：spell / spell。Grain：coin × hour，流量与结算存量并列。分区：block_month。

适用：指定业务粒度的金融数据；不证明完整原始Action或现实用户归属。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_month | date | 月份字段；是否分区按表检查 |
| block_date | date | UTC日期；分区作用按表检查 |
| block_hour | timestamp | 待验证，见对应官方表页 |
| perp_dex | varchar | 待验证，见对应官方表页 |
| coin | varchar | 完整市场键，保留DEX前缀 |
| market_symbol | varchar | 显示符号，会跨DEX重复 |
| asset_id | bigint | 待验证，见对应官方表页 |
| open_price | double | 待验证，见对应官方表页 |
| high_price | double | 待验证，见对应官方表页 |
| low_price | double | 待验证，见对应官方表页 |
| close_price | double | 待验证，见对应官方表页 |
| vwap | double | 待验证，见对应官方表页 |
| volume_usd | double | 待验证，见对应官方表页 |
| volume_units | double | 待验证，见对应官方表页 |
| buy_volume_usd | double | 待验证，见对应官方表页 |
| sell_volume_usd | double | 待验证，见对应官方表页 |
| trades_count | bigint | 待验证，见对应官方表页 |
| unique_traders | bigint | 待验证，见对应官方表页 |
| unique_takers | bigint | 待验证，见对应官方表页 |
| unique_makers | bigint | 待验证，见对应官方表页 |
| fee_usd | double | 待验证，见对应官方表页 |
| taker_fee_usd | double | 待验证，见对应官方表页 |
| maker_fee_usd | double | 待验证，见对应官方表页 |
| builder_fee_usd | double | 待验证，见对应官方表页 |
| deployer_fee_usd | double | 待验证，见对应官方表页 |
| forced_count | bigint | 待验证，见对应官方表页 |
| forced_volume_usd | double | 待验证，见对应官方表页 |
| open_interest_units | double | 待验证，见对应官方表页 |
| open_interest_usd | double | 文档来源双边OI，按最近成交估值 |
| open_positions | bigint | 待验证，见对应官方表页 |
| funding_rate | double | 待验证，见对应官方表页 |
| funding_rate_annualized | double | 待验证，见对应官方表页 |
| funding_paid_usd | double | 待验证，见对应官方表页 |
| _updated_at | timestamp | 模型构建时点，非业务事件时间 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.logs

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：EVM transaction log。分区：block_date。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| block_hash | varbinary | 待验证，见对应官方表页 |
| contract_address | varbinary | 待验证，见对应官方表页 |
| topic0 | varbinary | 待验证，见对应官方表页 |
| topic1 | varbinary | 待验证，见对应官方表页 |
| topic2 | varbinary | 待验证，见对应官方表页 |
| topic3 | varbinary | 待验证，见对应官方表页 |
| data | varbinary | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| index | integer | 待验证，见对应官方表页 |
| tx_index | integer | 待验证，见对应官方表页 |
| block_date | date | UTC日期；分区作用按表检查 |
| tx_from | varbinary | 待验证，见对应官方表页 |
| tx_to | varbinary | 待验证，见对应官方表页 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.transactions

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：EVM user transaction。分区：block_date。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| value | uint256 | 待验证，见对应官方表页 |
| gas_limit | bigint | 待验证，见对应官方表页 |
| gas_price | uint256 | 待验证，见对应官方表页 |
| gas_used | bigint | 待验证，见对应官方表页 |
| max_fee_per_gas | bigint | 待验证，见对应官方表页 |
| max_priority_fee_per_gas | bigint | 待验证，见对应官方表页 |
| priority_fee_per_gas | bigint | 待验证，见对应官方表页 |
| nonce | bigint | 待验证，见对应官方表页 |
| index | bigint | 待验证，见对应官方表页 |
| success | boolean | 待验证，见对应官方表页 |
| from | varbinary | 待验证，见对应官方表页 |
| to | varbinary | 待验证，见对应官方表页 |
| block_hash | varbinary | 待验证，见对应官方表页 |
| data | varbinary | 待验证，见对应官方表页 |
| hash | varbinary | 待验证，见对应官方表页 |
| type | varchar | 待验证，见对应官方表页 |
| access_list | array(row(address varbinary,storageKeys array(varbinary))) | 待验证，见对应官方表页 |
| chain_id | varchar | 待验证，见对应官方表页 |
| block_date | date | UTC日期；分区作用按表检查 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.traces

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：EVM call frame。分区：block_date。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| value | uint256 | 待验证，见对应官方表页 |
| gas | bigint | 待验证，见对应官方表页 |
| gas_used | bigint | 待验证，见对应官方表页 |
| block_hash | varbinary | 待验证，见对应官方表页 |
| success | boolean | 待验证，见对应官方表页 |
| tx_index | integer | 待验证，见对应官方表页 |
| tx_from | varbinary | 待验证，见对应官方表页 |
| tx_to | varbinary | 待验证，见对应官方表页 |
| sub_traces | bigint | 待验证，见对应官方表页 |
| error | varchar | 待验证，见对应官方表页 |
| tx_success | boolean | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| from | varbinary | 待验证，见对应官方表页 |
| to | varbinary | 待验证，见对应官方表页 |
| trace_address | array(bigint) | 待验证，见对应官方表页 |
| type | varchar | 待验证，见对应官方表页 |
| address | varbinary | 待验证，见对应官方表页 |
| code | varbinary | 待验证，见对应官方表页 |
| call_type | varchar | 待验证，见对应官方表页 |
| input | varbinary | 待验证，见对应官方表页 |
| output | varbinary | 待验证，见对应官方表页 |
| refund_address | varbinary | 待验证，见对应官方表页 |
| revert_reason | varchar | 待验证，见对应官方表页 |
| block_date | date | UTC日期；分区作用按表检查 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.creation_traces

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：EVM creation frame。分区：block_date。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| address | varbinary | 待验证，见对应官方表页 |
| from | varbinary | 待验证，见对应官方表页 |
| code | varbinary | 待验证，见对应官方表页 |
| block_month | date | 月份字段；是否分区按表检查 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.blocks

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：EVM block。分区：date。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| time | timestamp | 待验证，见对应官方表页 |
| number | bigint | 待验证，见对应官方表页 |
| gas_limit | decimal(38,0) | 待验证，见对应官方表页 |
| gas_used | decimal(38,0) | 待验证，见对应官方表页 |
| difficulty | bigint | 待验证，见对应官方表页 |
| total_difficulty | decimal(38,0) | 待验证，见对应官方表页 |
| size | bigint | 待验证，见对应官方表页 |
| base_fee_per_gas | bigint | 待验证，见对应官方表页 |
| hash | varbinary | 待验证，见对应官方表页 |
| parent_hash | varbinary | 待验证，见对应官方表页 |
| miner | varbinary | 待验证，见对应官方表页 |
| nonce | varbinary | 待验证，见对应官方表页 |
| state_root | varbinary | 待验证，见对应官方表页 |
| transactions_root | varbinary | 待验证，见对应官方表页 |
| receipts_root | varbinary | 待验证，见对应官方表页 |
| date | date | 待验证，见对应官方表页 |
| blob_gas_used | bigint | 待验证，见对应官方表页 |
| excess_blob_gas | bigint | 待验证，见对应官方表页 |
| parent_beacon_block_root | varbinary | 待验证，见对应官方表页 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.contracts

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：indexed contract metadata。分区：未返回分区。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| abi_id | varchar | 待验证，见对应官方表页 |
| abi | array(varchar) | 待验证，见对应官方表页 |
| address | varbinary | 待验证，见对应官方表页 |
| from | varbinary | 待验证，见对应官方表页 |
| code | varbinary | 待验证，见对应官方表页 |
| name | varchar | 待验证，见对应官方表页 |
| namespace | varchar | 待验证，见对应官方表页 |
| dynamic | boolean | 待验证，见对应官方表页 |
| base | boolean | 待验证，见对应官方表页 |
| factory | boolean | 待验证，见对应官方表页 |
| detection_source | varchar | 待验证，见对应官方表页 |
| created_at | timestamp | 待验证，见对应官方表页 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.logs_decoded

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：ABI decoded log。分区：contract_name, namespace。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_date | date | UTC日期；分区作用按表检查 |
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| namespace | varchar | 待验证，见对应官方表页 |
| contract_name | varchar | 待验证，见对应官方表页 |
| contract_address | varbinary | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| tx_from | varbinary | 待验证，见对应官方表页 |
| tx_to | varbinary | 待验证，见对应官方表页 |
| tx_index | integer | 待验证，见对应官方表页 |
| index | integer | 待验证，见对应官方表页 |
| signature | varbinary | 待验证，见对应官方表页 |
| event_name | varchar | 待验证，见对应官方表页 |
| decoded_json | varchar | 待验证，见对应官方表页 |
| created_at | timestamp | 待验证，见对应官方表页 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperevm.traces_decoded

来源：[实时Catalog](../research/dune/catalog-hyperevm.json)；基准2026-10-13。层级：canonical / dune_table。Grain：ABI decoded call。分区：contract_name, namespace。

适用：EVM结构与接口调用；不覆盖全部Core活动。

| 字段 | Catalog类型 | 业务说明依据 |
|---|---|---|
| block_date | date | UTC日期；分区作用按表检查 |
| block_time | timestamp | 待验证，见对应官方表页 |
| block_number | bigint | 待验证，见对应官方表页 |
| namespace | varchar | 待验证，见对应官方表页 |
| contract_name | varchar | 待验证，见对应官方表页 |
| to | varbinary | 待验证，见对应官方表页 |
| trace_address | array(bigint) | 待验证，见对应官方表页 |
| tx_hash | varbinary | 待验证，见对应官方表页 |
| tx_from | varbinary | 待验证，见对应官方表页 |
| tx_to | varbinary | 待验证，见对应官方表页 |
| tx_index | integer | 待验证，见对应官方表页 |
| success | boolean | 待验证，见对应官方表页 |
| signature | varbinary | 待验证，见对应官方表页 |
| function_name | varchar | 待验证，见对应官方表页 |
| decoded_input_json | varchar | 待验证，见对应官方表页 |
| decoded_output_json | varchar | 待验证，见对应官方表页 |
| created_at | timestamp | 待验证，见对应官方表页 |

缺口：Catalog不能验证行唯一性、缺失率、最大业务时间或运行权限；未解释字段保持待验证，不猜业务含义。

## hyperliquid.perp_oracle_prices

只取得[官方字段与来源说明](https://docs.dune.com/data-catalog/curated/perpetuals/hyperliquid/perp-oracle-prices.md)，当前限定Catalog未返回该表。状态：DOC_SCHEMA_ONLY / API未验证；没有据此虚构可执行字段。分钟取最后更新，第一方与HIP-3上游不同，刷新可能相差数周。
