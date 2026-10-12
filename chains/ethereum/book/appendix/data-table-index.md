# 数据表索引

来源：2026-10-10 Dune Catalog 实读快照。类型与可用字段已核实，不证明完整历史覆盖与候选键唯一性。

- [dex.trades](../../research/schema-notes/dex.trades.md)：DEX 兼容命名空间，非额外无重叠数据源。
- [dex_evm.trades](../../research/schema-notes/dex_evm.trades.md)：池级成交执行段。
- [ethereum.blocks](../../research/schema-notes/ethereum.blocks.md)：执行层区块。
- [ethereum.creation_traces](../../research/schema-notes/ethereum.creation_traces.md)：创建记录。
- [ethereum.logs](../../research/schema-notes/ethereum.logs.md)：保留日志。
- [ethereum.traces](../../research/schema-notes/ethereum.traces.md)：执行调用／系统轨迹记录。
- [ethereum.transactions](../../research/schema-notes/ethereum.transactions.md)：顶层交易及整理执行字段。
- [ethereum.withdrawals](../../research/schema-notes/ethereum.withdrawals.md)：载荷提款操作。
- [gas.fees](../../research/schema-notes/gas.fees.md)：加工后的交易费用行。
- [tokens.transfers](../../research/schema-notes/tokens.transfers.md)：规范化可替代资产移动。

Withdrawals Amount：Catalog 为 bigint，文档为 uint256，单位均按 Gwei；Creation Traces 当前分区为 block_month、没有 trace_address。Raw 的时间类型与部分 Curated 的带时区类型不同。完整 [快照](../../research/schema-notes/target-schemas.json) 与 [事实台账](../../research/fact-ledger.md) 可追溯差异。

[目录](../../SUMMARY.md)
