# SUI 08 | Dune Data Model

## 六张表，怎样组成同一条链的数据？

至此，我们已经能够解释对象、事务、调用、结果和历史。进入 Dune 后，第一件事是把这些概念连接到真实表名与记录粒度。不要因为协议里有 Effects，就先假定数据库一定存在一张 sui.effects。

2026-10-10 的 Catalog API 确认本书六个入口为 sui.checkpoints、sui.transactions、sui.transaction_objects、sui.objects、sui.move_call、sui.events。Move 调用表使用单数 move_call。API 同时返回 move_package 与 wrapped_object，因此六表是一套教学入口，并非全部数据模型。[Dune Sui Catalog](https://docs.dune.com/data-catalog/sui/overview)

![六表的统计粒度与连接验证](./assets/warehouse-grains.svg)

[编辑原图](./assets/warehouse-grains.drawio) · [六表总关系图](../00-from-runtime-to-data/assets/data-map.svg)

主干以事务为中心。Checkpoint Sequence 连接事务的 checkpoint，Transaction Digest 再连接对象关系、MoveCall 与 Event。对象关系中的 ID 与 Version 可以尝试连接对象状态。每条线都是分析路径，需要验证键、类型与覆盖；Dune Catalog 没有为我们声明关系数据库外键约束。

同一链上动作进入不同表，行数差异非常正常。一笔事务可能有两条调用、四条对象关系和两条事件。如果直接将三个分支按 Digest 全部展开，可能得到十六行。这十六行是组合结果，不能按一行一笔事务解释。平台没有替分析师决定指标粒度。

当前字段类型也应保留。事务 Digest 是 varchar，地址、Object ID 和 Package 常为 varbinary，序号和版本多为 decimal(20,0)。把二进制地址与带引号的显示字符串直接比较，可能出现类型错误或没有匹配。显示转换与实际过滤要分开。

平台时间、摘要计数和 JSON 又提供不同观察层。transaction_json 可以补充请求，effects_json 可以补充结果；单列计数方便网络汇总，却不一定能够还原每个内部步骤。字段存在不意味着已经证明其值域、空值处理和最新协议覆盖。

本模块采用两步验证。先用 API 核实 Schema，确保表与列真实存在；再用有界数据查询核查候选键、匹配率、时间范围与业务语义。当前 API Schema 已读取，新增执行被 Dune 的 402 数据点限制拒绝，因此第二步不能冒充完成。示例 SQL 会保留 STATIC_CHECKED 或 UNVERIFIED 状态。

这种区分不会阻止阅读。读者可以先掌握可靠的表选择与连接方法，再在有执行条件时验证数据。一个清楚标注边界的模型，比看似完整却没有运行证据的字段说明更适合复用。

[主干](./01-spine.md) → [分支](./02-branches.md) → [质量与 JOIN](./03-quality.md) → [总结](./summary.md) · [完整字段快照](../references/dune-tables.md) · [返回目录](../README.md)
