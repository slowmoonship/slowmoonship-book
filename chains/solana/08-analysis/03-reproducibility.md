# 08.03 让分析可重现

两周后重跑同一段 SQL，结果为什么可能不同？因为窗口可能用了相对日期，数据更新了，模型或元数据变化了，甚至程序版本也发生了变化。可重现分析需要保存比 SQL 文本更多的信息。

先保存固定范围。`current_date - interval '7' day` 每天改变样本，而固定 UTC 起止时间更适合出版案例。需要滚动看板时可以用相对日期，但报告应注明当次实际窗口。链名、确认程度、成功筛选、程序与 Mint 身份也属于查询定义，不该只存在于作者记忆里。

第二步保存来源版本。官方技术资料记录核验日期，Dune Schema 记录字段与类型来源，已有 Query 保存 SQL 版本和作者，新查询保存内容 hash。程序接口与数据模型变更时，这些记录可以说明哪一个假设需要重新核查。保存 SQL 不意味着永久冻结了上游数据。

第三步分开执行状态。STATIC_ONLY 表示只检查了结构与字段；执行成功需要执行 ID、时间、结果与错误状态证据；历史报告里的 completed 只是历史来源，不能替新改写背书。没有结果时不要写“查询证明”，可以写“此查询用于检验”。一份真实 RPC 缓存也不能冒充仓库执行响应。

第四步保存粒度与 QA。候选唯一键、NULL 解释、JOIN 前后行数、美元覆盖和单位转换都应随结果留下。一个正确 SQL 可能因为上游新增字段或重复元数据而失去旧假设；对这些关系的检查，比只保存一张图更能支持后续维护。

本篇的查询与来源索引展示了这种做法：已有 13 个定义、官方字段快照、三个 RPC 案例、SQL hash 和图源各自保存。章节完成还需要正文、来源、图导出与视觉审核通过，不能只因文件存在就自动完成。读者因此可以按证据类型复用材料，而不会在恢复时重新执行昂贵历史扫描。

复现的目标也需要诚实。如果源平台已更新历史加工，你可以复现方法，却未必得到与旧快照完全相同的数值。此时比较变化的来源和影响，保留两次结果与条件，别为了数字相等而更换口径。下一步是把全篇知识收成一条可独立执行的调查路线。

![让分析可重现](./assets/analysis-route.svg)

[编辑原图（draw.io）](./assets/analysis-route.drawio)

参考来源（核验日期：2026-10-09）：

- [Dune Transactions](https://docs.dune.com/data-catalog/solana/transactions)
- [Dune Instruction Calls](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [Dune Account Activity](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune Transfers](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)
- [Dune DEX 模型](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)

<!-- NAV -->

[总目录](../README.md) · [上一章：研究陌生协议](02-protocol.md) · [下一章：拥有自己的分析路线](summary.md)
