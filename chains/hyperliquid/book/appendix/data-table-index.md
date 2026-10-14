# 附录C｜数据表索引

[逐表字段与限制](../../research/data_table_cards.md) · [当前Catalog JSON](../../research/dune/verified-schema.json)。

| 表 | 粒度 | 适用范围 |
|---|---|---|
| `hip4_hyperliquid.open_interest_hourly` | Outcome market × hour | Outcome |
| `hip4_hyperliquid.positions_daily` | account × outcome token × day | Outcome |
| `hip4_hyperliquid.ohlcv_hourly` | Outcome token × hour | Outcome |
| `hip4_hyperliquid.market_details` | Outcome market_id一行，Question为event维度 | Outcome |
| `hip4_hyperliquid.market_trades` | 全量Outcome腿，含引擎操作 | Outcome |
| `hyperliquid.perp_trades` | 账户成交腿；非经济撮合一行 | Perps |
| `hyperliquid.perp_market_details` | 当前注册市场coin一行 | Perps |
| `hyperliquid.perp_positions_hourly` | trader × coin × funding hour | Perps |
| `hyperliquid.perp_accounts_daily` | trader × UTC day，无市场维度 | Perps |
| `hyperliquid.perp_market_metrics_daily` | coin × UTC day，OI为日末 | Perps |
| `hyperliquid.perp_orderbook_1m` | coin × minute，稀疏L2聚合快照 | Perps |
| `hyperliquid.perp_market_metrics_hourly` | coin × hour，流量与结算存量并列 | Perps |
| `hyperevm.logs` | EVM transaction log | EVM |
| `hyperevm.transactions` | EVM user transaction | EVM |
| `hyperevm.traces` | EVM call frame | EVM |
| `hyperevm.creation_traces` | EVM creation frame | EVM |
| `hyperevm.blocks` | EVM block | EVM |
| `hyperevm.contracts` | indexed contract metadata | EVM |
| `hyperevm.logs_decoded` | ABI decoded log | EVM |
| `hyperevm.traces_decoded` | ABI decoded call | EVM |

Oracle表为文档核验，未由本轮Catalog返回。Perp官方覆盖：成交2025-07-27；OI/Funding2025-09-27；Book2026-06-29；HIP-4文档覆盖2026-05-02。实际首尾行、缺失和权限尚未运行验证。


[目录](../../SUMMARY.md) · [上一章](market-identifiers.md) · [下一章](hip-standards.md)
