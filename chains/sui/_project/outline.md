# Sui 全书结构

每个模块有总章、完整细分章节和总结。普通细分章节目标 600–1200 中文字，模块总章 800–1400 字，总结 400–800 字；实际不以填充文字达标。所有预计章节仅登记在本文件与 manifest，未写正文前不创建空 Markdown。

| 编号 / 模块 | 核心问题 | 知识依赖 | 细分章节 | 主图 / 数据表 | 优先级 |
|---|---|---|---|---|---|
| 01 Object Model｜对象身份与历史 | 对象为什么不能只按 ID 统计？ | SUI 00 | ID、Version、Digest 与 Object Reference；创建、修改、转移、包装与删除 | object-history；transactions / transaction_objects / objects | P0 |
| 02 Transaction / PTB｜请求与结果流 | 用户提交的到底是什么？ | SUI 01 | Sender、签名、Gas 与有效期；Inputs、Commands 与 Result Flow | ptb-flow；transactions / transaction_objects / objects | P0 |
| 03 Ownership / Execution｜权限与执行条件 | 对象归谁、谁能访问、何时执行？ | SUI 02 | 所有权形式与包装边界；共同排序、对象版本与并行执行 | ownership-paths；transactions / transaction_objects / objects | P0 |
| 04 Move for Data｜看懂类型和调用 | 从一串类型名怎样找到业务结构？ | SUI 03 | Package、Module、Function、Type 与升级；Dynamic Field、子对象与数据可见性 | move-structure；transactions / transaction_objects / objects | P0 |
| 05 SUI / Coin / Balance｜资金的表示 | Coin 数量为什么不能当作资产余额？ | SUI 04 | Coin<T>、Balance<T> 与 Split / Merge；Address Balance、费用与余额核对 | asset-balance；transactions / transaction_objects / objects | P0 |
| 06 Effects / Events｜执行留下什么 | 如何证明请求真正产生了结果？ | SUI 05 | 成功、失败、对象输出与 Gas；显式事件、状态与业务证明 | result-evidence；transactions / transaction_objects / objects | P0 |
| 07 Checkpoint / Epoch｜组织历史 | 如何在正确时间位置理解一笔交易？ | SUI 06 | 包含关系、顺序与最终确认；时间、Epoch 与网络指标 | history-time；transactions / transaction_objects / objects | P0 |
| 08 Dune Data Model｜六表与数据质量 | 表的一行到底代表什么？ | SUI 07 | Checkpoint 与 Transaction 主干；Object、Move Call 与 Event 分支；候选键、覆盖率与 JOIN 放大 | warehouse-grains；六表；Package 与 wrapped_object 作扩展 | P0 |
| 09 SQL Practice｜从事务到业务 | 如何还原具体动作并保留证据？ | SUI 08 | 单笔事务、对象与费用；从 Package 调用验证 Swap；追踪一个对象的历史 | sql-route；六表；Package 与 wrapped_object 作扩展 | P0 |
| 10 Analysis / Audit｜从证据到结论 | 哪些结论可以由链上记录支持？ | SUI 09 | 钱包活动、余额与资金流边界；协议用户、流动性与可复核分析 | audit-evidence；六表；Package 与 wrapped_object 作扩展 | P1 |

历史规划对照：十一项主题候选均覆盖。全篇总结采用 99；Dune 六表继续作为入口，move_package 与 wrapped_object 仅在需要时扩展。已发现并缓存十二份 Query，准确 ID 与谱系见 references/existing-query-manifest.json；本地新增 09.4 解释这些成果的复用。真实案例优先从官方只读接口核验，Dune 执行状态独立记录。
