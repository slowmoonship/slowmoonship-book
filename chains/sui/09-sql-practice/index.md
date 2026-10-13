# SUI 09 | SQL Practice

## 从一笔事务，走到可以复核的解释

本模块使用三个真实主网案例。案例 A 是历史上的原生 SUI 转移，展示 SplitCoins → TransferObjects。案例 B 是一次多路由 SUI→USDC 兑换，展示复杂 PTB、共享池、事件与余额。案例 C 追踪 B 中一个 Shared Pool 的创建与早期状态，再回到兑换前后版本。

所有案例在 2026-10-10 从 Sui 官方公开 GraphQL 接口读取，保存请求、响应、查询时间与完整标识。接口验证说明这些链上记录实际可查，不等于 Dune SQL 已执行成功。本轮首次新增 SQL 被 402 数据点限制拒绝，下列 Dune 示例均为 STATIC_CHECKED，没有可声称成功的 Execution ID。

![从事务入口到证据包](./assets/sql-route.svg)

[编辑原图](./assets/sql-route.drawio)

学习顺序从小到大。先读取一笔事务主干，核对 Checkpoint、状态与费用；再按 Digest 分别查询对象、调用和事件；最后把证据放回 PTB 与业务边界。我们不从六表全量 JOIN 开始，因为那样很难保留问题本身的粒度。

案例 A 的 PTB 只有两条 Command，没有 MoveCall，也没有 Event。它证明零调用和零事件可以对应真实成功转移。案例 B 有 39 条 Command、18 条 MoveCall 和 19 条 Event；这些数量来自完整官方接口快照，不是 Dune 查询结果。相同一笔事务中的数目差异，正好解释为何不同指标不能互换。

真实数据还有教学图没有展开的细节。B 同时合并多枚 Coin，涉及多个路由步骤，并有显著存储返还。它比开篇的 Alice 交换 5 SUI 更复杂，因此不会把开篇金额套到真实记录上。先用 A 学会基本读取，再用 B 练习辨别请求、池步骤与钱包净变化。

C 则把事务视角转成对象视角。一个池保持相同 Object ID 与 Shared 归属，状态、版本和引发变化的事务却持续更新。最早五个可查版本之外仍有后续页，不能把这五行称为完整生命周期。我们另外验证创建 Effects，才说明它确实是创建入口。

本模块附带九份有界 SQL，并复用 slowmoonship 十二份已有 Query 的分层结构。每份本地示例保存准确表名、列名和固定参数，供读者在具备 Dune 执行条件后复现。执行前先核查日期覆盖和候选键，执行后保留结果与合理性检查。若结果与官方快照不同，先调查索引覆盖、展开规则与窗口，不能修改快照来迎合 SQL。

[单笔事务](./01-one-transaction.md) → [Swap](./02-swap.md) → [对象历史](./03-object-history.md) → [复用已有 Query](./04-existing-queries.md) → [总结](./summary.md) · [案例登记](../references/verified-transactions.md) · [SQL 状态](../references/dune-queries.md) · [返回目录](../README.md)
