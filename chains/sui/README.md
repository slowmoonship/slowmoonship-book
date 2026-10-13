# 慢月船：链上数据之路｜Sui 篇

**slowmoonship: Gateway to Onchain Data**

协议运行的是交易、对象与状态；数据分析师研究的是这些运行过程留下的记录。

公开书稿 v0.1（2026-10-13）。原稿整体状态 **PARTIAL**，45/45 篇阅读正文完成；39 篇 COMPLETE、6 篇 SQL 相关内容 VALIDATED，保留运行缺口。作者人工审读 UNKNOWN。

[全书首页](../../README.md) · [统一阅读目录](../../SUMMARY.md) · [本次出版验收](../../publication/sui/2026-10-13-v0.1/README.md)。

核心技术与 Schema 核验日：2026-10-10。正文为阅读内容，工作状态单独保存。Dune SQL 执行遭遇 402；实例接口核验与 SQL 执行状态分别标明。

## 阅读目录

- [00｜From Runtime to Data](./00-from-runtime-to-data/index.md)
- [01.index｜Object Model｜对象身份与历史](./01-object-model/index.md)
- [01.01-identity｜ID、Version、Digest 与 Object Reference](./01-object-model/01-identity.md)
- [01.02-lifecycle｜创建、修改、转移、包装与删除](./01-object-model/02-lifecycle.md)
- [01.summary｜模块总结](./01-object-model/summary.md)
- [02.index｜Transaction / PTB｜请求与结果流](./02-transactions/index.md)
- [02.01-envelope｜Sender、签名、Gas 与有效期](./02-transactions/01-envelope.md)
- [02.02-result-flow｜Inputs、Commands 与 Result Flow](./02-transactions/02-result-flow.md)
- [02.summary｜模块总结](./02-transactions/summary.md)
- [03.index｜Ownership / Execution｜权限与执行条件](./03-ownership/index.md)
- [03.01-forms｜所有权形式与包装边界](./03-ownership/01-forms.md)
- [03.02-coordination｜共同排序、对象版本与并行执行](./03-ownership/02-coordination.md)
- [03.summary｜模块总结](./03-ownership/summary.md)
- [04.index｜Move for Data｜看懂类型和调用](./04-move/index.md)
- [04.01-types-packages｜Package、Module、Function、Type 与升级](./04-move/01-types-packages.md)
- [04.02-dynamic-fields｜Dynamic Field、子对象与数据可见性](./04-move/02-dynamic-fields.md)
- [04.summary｜模块总结](./04-move/summary.md)
- [05.index｜SUI / Coin / Balance｜资金的表示](./05-assets/index.md)
- [05.01-coins｜Coin<T>、Balance<T> 与 Split / Merge](./05-assets/01-coins.md)
- [05.02-address-gas｜Address Balance、费用与余额核对](./05-assets/02-address-gas.md)
- [05.summary｜模块总结](./05-assets/summary.md)
- [06.index｜Effects / Events｜执行留下什么](./06-execution/index.md)
- [06.01-effects｜成功、失败、对象输出与 Gas](./06-execution/01-effects.md)
- [06.02-events｜显式事件、状态与业务证明](./06-execution/02-events.md)
- [06.summary｜模块总结](./06-execution/summary.md)
- [07.index｜Checkpoint / Epoch｜组织历史](./07-history/index.md)
- [07.01-checkpoint｜包含关系、顺序与最终确认](./07-history/01-checkpoint.md)
- [07.02-time-epoch｜时间、Epoch 与网络指标](./07-history/02-time-epoch.md)
- [07.summary｜模块总结](./07-history/summary.md)
- [08.index｜Dune Data Model｜六表与数据质量](./08-dune-model/index.md)
- [08.01-spine｜Checkpoint 与 Transaction 主干](./08-dune-model/01-spine.md)
- [08.02-branches｜Object、Move Call 与 Event 分支](./08-dune-model/02-branches.md)
- [08.03-quality｜候选键、覆盖率与 JOIN 放大](./08-dune-model/03-quality.md)
- [08.summary｜模块总结](./08-dune-model/summary.md)
- [09.index｜SQL Practice｜从事务到业务](./09-sql-practice/index.md)
- [09.01-one-transaction｜单笔事务、对象与费用](./09-sql-practice/01-one-transaction.md)
- [09.02-swap｜从 Package 调用验证 Swap](./09-sql-practice/02-swap.md)
- [09.03-object-history｜追踪一个对象的历史](./09-sql-practice/03-object-history.md)
- [09.04-existing-queries｜从已有 Query 复用网络指标](./09-sql-practice/04-existing-queries.md)
- [09.summary｜模块总结](./09-sql-practice/summary.md)
- [10.index｜Analysis / Audit｜从证据到结论](./10-analysis/index.md)
- [10.01-wallet｜钱包活动、余额与资金流边界](./10-analysis/01-wallet.md)
- [10.02-protocol｜协议用户、流动性与可复核分析](./10-analysis/02-protocol.md)
- [10.summary｜模块总结](./10-analysis/summary.md)
- [99｜分析一笔陌生事务](./99-final-summary/index.md)

## 编辑与研究资料

- [全书规划](./_project/outline.md)
- [技术来源与版本边界](./references/official-sources.md)
- [质量与验证缺口](./_project/qa-report.md)
- [历史素材清单](./_project/source-inventory.md)
- 每张图下方有可编辑 draw.io 链接；SVG 用于正文展示。

- [本轮交付报告](./_project/overnight-report.md)
- [Dune Query 与 SQL 验证状态](./references/dune-queries.md)
- [出版检查与验证边界](../../publication/sui/2026-10-13-v0.1/CHECKS.md)
