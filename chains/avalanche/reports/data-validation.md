# 数据与执行验证

2026-10-13。没有新 Dune SQL 执行，没有链上写操作。

真实资料：官方 RPC 三链身份与 AVAX Asset；官方 Data API 的 P/X/C 交易、Beam 创建与转换、注册历史与快照；Beam RPC 区块和成功收据；作者已有 Dune 执行的交易、消息与目录样本。请求、返回与检索时间完整保存。

9 组真实案例涵盖 12 笔不同交易。Case 03 两側 Atomic UTXO 与后续委托消费实际关联；Case 05 输入输出明细与索引汇总一致；Beam 的目录、Genesis 与 RPC Chain ID 一致，平台注册和运行视图分别保留。9 项离线检查见 [计算报告](case-checks.json)。

X 样本没有独立费用字段，输入输出差额不虚报成独立费用验证。Case 07 没有完整权重变化/停用/移除历史，Case 08 没有目标完成证据。缺口见 [未解决项](../research/unresolved.md)。

Dune：实际取得 Raw 9 表、Curated/metadata 4 表、匹配 Teleporter 4 表字段。搜索返回的 Circle 表没有写作 ICM 表。读取两份既有公开 Dashboard、三份 Query 和三份既有结果；第四份 Query 读取出现 HTTPError，未反复探测。新示例 10 条全为 STATIC_CHECKED / BLOCKED_READ_ONLY_ACCOUNT。

SQL 静态检查验证实际 Catalog 表名和字段、类型使用、窗口、粒度、单位与分支去重；不声称执行引擎解析或新结果验证。历史 COMPLETED 和 executionCostCredits 属于此前执行。本轮没有触发刷新或有偿执行；API 未使用付费密钥，未申请额度。账户最终账单没有独立查询，因此不把历史费用字段计为本轮支出。

BLOCKED_READ_ONLY_ACCOUNT 继承用户明确给定的本轮执行边界；没有重新探测账户权限是否变化。它不冒充一次本轮执行失败所得结论。Dune 读取配额和账户账单没有独立归属核算。

公共 RPC 429、错误路径 400/404、少数文档标题空壳均保留真实记录。之后按核实的有效路径取得数据，不把失败请求标为通过。只采有限样本，不批量扫描全历史。
