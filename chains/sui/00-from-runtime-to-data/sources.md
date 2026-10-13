# SUI 00 来源与核验边界

核验日期：2026-10-10。

- [Life of a Transaction](https://docs.sui.io/develop/transactions/transaction-lifecycle)：当前共同共识排序、执行、Effects 确认与 Checkpoint inclusion。
- [Object Model](https://docs.sui.io/develop/sui-architecture/object-model)、[Ownership](https://docs.sui.io/develop/objects/object-ownership)、[Versioning](https://docs.sui.io/develop/objects/versioning)：所有权与版本路径；当前所有交易排序与对象 Fastpath versioning 并非同一问题。
- [PTB](https://docs.sui.io/develop/transactions/ptbs/)、[Transaction](https://docs.sui.io/develop/transactions/txn-overview)：请求、Inputs、Commands 与返回值。
- [Checkpoint Verification](https://docs.sui.io/develop/sui-architecture/checkpoint-verification)、[Epoch](https://docs.sui.io/develop/sui-architecture/epochs)：历史证明、周期背景。
- [Dune Sui Catalog](https://docs.dune.com/data-catalog/sui/overview)：表的官方说明；字段类型实际以本地 `../_project/cache/dune-catalog-2026-10-10.json` 的 API 结果为准。

Runtime 图来自历史可编辑源文件的副本，修改位置见项目图形审计。图中的 5 SUI、Alice、USDC 输出和 Event 是教学示例；没有声称它是已验证交易。Data Map 的连接是分析路径，候选唯一键及匹配覆盖尚不能仅凭 Catalog 证明。

Dune API Catalog 已验证；SQL 首次轻量提交被 402 数据点限额拒绝，没有本轮新增 SQL 的成功执行结果。该限制不影响核心表名和字段的 API 核验。
