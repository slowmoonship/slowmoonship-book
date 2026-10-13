# 06.99 一条能解释自己的查询

一份可解释的 SQL 应带着四个信息进入结果：对象粒度、范围边界、单位和验证状态。RPC 的嵌套结构经过展开、解码与业务加工，才能成为多张仓库表；表名友好不代表它就是原生状态或用户意图。

交易连接调用与账户活动时，先确认 1 对多关系。交易级金额不能在多份明细同时展开后随意求和，正确方法通常是先聚合到交易或用存在性筛选。数组内部也有关系：地址与前后余额要按位置对齐；RPC 与 SQL 的索引起点要明确；不同来源的 NULL 要按含义处理。

核验不能只看 SQL 是否运行。精确候选键、匹配次数、更新覆盖、USD 缺值和极端金额都影响结论。已有粒度 QA 为全书提供了研究起点，但历史样本与当前教学改写是两种证据；本篇保留静态查询标签，避免把研究基础写成未经发生的实测结果。

你可以先用一笔真实交易建立小范围闭环：RPC 固定身份，仓库按该身份检索，再核对调用与账户变化。下一模块按这个顺序拆三个主网案例，同时给出确实已经核验的金额和未完成的仓库映射边界。

![一条能解释自己的查询](./assets/data-lineage.svg)

[编辑原图（draw.io）](./assets/data-lineage.drawio)

参考来源（核验日期：2026-10-09）：

- [RPC JSON 结构](https://solana.com/docs/rpc/json-structures)
- [Dune Transactions](https://docs.dune.com/data-catalog/solana/transactions)
- [Dune Instruction Calls](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [Dune Account Activity](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune DEX 数据模型](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)

<!-- NAV -->

[总目录](../README.md) · [上一章：时间窗口与质量核验](04-quality.md) · [下一章：用三个案例贯穿数据地图](../07-cases/index.md)
