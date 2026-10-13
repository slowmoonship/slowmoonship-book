# SUI 07 小结｜先定位历史，再解释时间

Checkpoint 在执行后组织事务与 Effects，提供历史承诺和认证入口。Transaction、Effects 与 Checkpoint 各有自己的 Digest；Checkpoint Sequence 提供历史位置，不能与对象 Version 或 Command Index 混用。

交易结果确认与历史收录有关联，但不能简单写成必须等入 Checkpoint 才第一次确定。平台可见性又是另一层：认证结果已经存在，索引分支仍可能尚未到齐。协议证明与 SQL 返回分别提供不同保证。

Epoch 是网络运行背景，不是每笔事务的独立处理步骤。它帮助理解委员会、配置与边界，但持续时间要从实际记录取得。事务包含在 Epoch 内，并不意味着业务字段中的 version 就是 Epoch 序号。

时间分析先保留单位、来源与时区，再定义窗口。Checkpoint 时间、平台摄取时间与应用时间不能直接混合成执行耗时。最新窗口不完整时，还应限定有效覆盖范围。

到这里，两张地图里的主要协议概念已经展开。下一模块回到 Dune，核对六表字段、行粒度、候选键和连接覆盖，让协议知识真正成为可靠查询的依据。

[继续：SUI 08 Dune 数据模型](../08-dune-model/index.md) · [返回目录](../README.md)
