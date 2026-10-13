# 慢月船：链上数据之路 · Solana 篇

slowmoonship: Gateway to Onchain Data

沿阅读顺序理解：链上状态 → 执行 → RPC → Dune → SQL。技术与 Schema 核验日期：2026-10-09。

本书 SQL 均明确标示验证状态；当前新增执行次数为 0。真实案例来自官方主网 RPC，尚未在 Dune 按 signature 交叉核对。

## Solana 总章

- [00.00 先拥有一张数据地图](./00-overview/index.md) — COMPLETE

## 时间与账本

- [01.00 把一笔行为放回账本](./01-ledger/index.md) — COMPLETE
- [01.01 Slot 为什么不等于 Block](./01-ledger/01-slot-block.md) — COMPLETE
- [01.02 时间与确认程度](./01-ledger/02-time-finality.md) — COMPLETE
- [01.03 用区块表观察网络](./01-ledger/03-block-table.md) — COMPLETE
- [01.99 先固定坐标，再讨论行为](./01-ledger/summary.md) — COMPLETE

## 交易的内部组成

- [02.00 一笔交易是一份完整请求](./02-transactions/index.md) — COMPLETE
- [02.01 签名与 Message](./02-transactions/01-message.md) — COMPLETE
- [02.02 谁签名，谁付费](./02-transactions/02-signers-fees.md) — COMPLETE
- [02.03 失败后还留下什么](./02-transactions/03-results.md) — COMPLETE
- [02.04 版本与地址查找表](./02-transactions/04-versions-alt.md) — COMPLETE
- [02.99 从请求到结果](./02-transactions/summary.md) — COMPLETE

## 指令、程序与调用

- [03.00 从做了什么到谁在执行](./03-instructions/index.md) — COMPLETE
- [03.01 Program 与 Instruction](./03-instructions/01-program-instruction.md) — COMPLETE
- [03.02 CPI 是调用，不是新交易](./03-instructions/02-cpi.md) — COMPLETE
- [03.03 调用顺序、深度与日志](./03-instructions/03-trace-logs.md) — COMPLETE
- [03.04 从字节到可读动作](./03-instructions/04-decoding.md) — COMPLETE
- [03.99 画出一次调用的骨架](./03-instructions/summary.md) — COMPLETE

## 账户与状态

- [04.00 地址后面存着什么](./04-accounts/index.md) — COMPLETE
- [04.01 Account 与程序 Owner](./04-accounts/01-account-owner.md) — COMPLETE
- [04.02 Authority 与 PDA](./04-accounts/02-authority-pda.md) — COMPLETE
- [04.03 状态变化与账户生命周期](./04-accounts/03-activity-lifecycle.md) — COMPLETE
- [04.99 把权限与数据分开](./04-accounts/summary.md) — COMPLETE

## SOL 与代币

- [05.00 金额究竟存在哪里](./05-tokens/index.md) — COMPLETE
- [05.01 SOL 转账与余额变化](./05-tokens/01-sol.md) — COMPLETE
- [05.02 Mint、Token Account 与 ATA](./05-tokens/02-mint-token-account.md) — COMPLETE
- [05.03 单位与 Token-2022](./05-tokens/03-units-token2022.md) — COMPLETE
- [05.04 流量与存量](./05-tokens/04-transfers-balances.md) — COMPLETE
- [05.99 把一笔资产移动连回账户](./05-tokens/summary.md) — COMPLETE

## 从 RPC 到 DuneSQL

- [06.00 进入仓库前先问粒度](./06-warehouse/index.md) — COMPLETE
- [06.01 RPC、原始表与加工表](./06-warehouse/01-rpc-lineage.md) — COMPLETE
- [06.02 JOIN 前先守住行数](./06-warehouse/02-joins.md) — COMPLETE
- [06.03 数组、索引与空值](./06-warehouse/03-arrays.md) — COMPLETE
- [06.04 时间窗口与质量核验](./06-warehouse/04-quality.md) — COMPLETE
- [06.99 一条能解释自己的查询](./06-warehouse/summary.md) — COMPLETE

## 真实行为拆解

- [07.00 用三个案例贯穿数据地图](./07-cases/index.md) — COMPLETE
- [07.01 完整拆开一笔 SOL 转账](./07-cases/01-sol-case.md) — COMPLETE
- [07.02 完整拆开一笔 Token 转账](./07-cases/02-token-case.md) — COMPLETE
- [07.03 聚合路由与多次 Swap](./07-cases/03-swap-case.md) — COMPLETE
- [07.99 让不同视角回到同一事实](./07-cases/summary.md) — COMPLETE

## 独立分析方法

- [08.00 从业务问题出发](./08-analysis/index.md) — COMPLETE
- [08.01 钱包行为与资金流向](./08-analysis/01-wallet-flow.md) — COMPLETE
- [08.02 研究陌生协议](./08-analysis/02-protocol.md) — COMPLETE
- [08.03 让分析可重现](./08-analysis/03-reproducibility.md) — COMPLETE
- [08.99 拥有自己的分析路线](./08-analysis/summary.md) — COMPLETE

## 全篇总结

- [99.00 你的 Solana 数据地图](./99-final-summary/index.md) — COMPLETE

## 资料与维护

- [来源索引](./references/sources.md)
- [数据表与字段](./references/dune-tables.md)
- [查询索引](./references/dune-queries.md)
- [术语](./references/glossary.md)
- [字段关系](./references/field-relations.md)
- [真实案例证据](./references/cases.md)
- [阶段验收报告](./_project/overnight-report.md)
- [出版状态与检查](../../publication/solana/2026-10-13-v0.1/CHECKS.md)
