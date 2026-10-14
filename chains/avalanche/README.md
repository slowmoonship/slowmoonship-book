# 慢月船：链上数据之路｜Avalanche 篇

**slowmoonship: Gateway to Onchain Data**

从钱包里的 AVAX 出发，理解多链运行、P/X/C 异构数据、独立 L1、验证者管理与跨链证据。研究基准日 2026-10-12；工程续作与验收 2026-10-13。

10 Part、40 章完整正文、40 张双语可编辑图、10 条 DuneSQL、15 份真实 API 示例、9 组真实案例。总体等级以 [最终验收](reports/final-acceptance.md) 为准。

[开始阅读](book/00-preface.md) · [全书目录](SUMMARY.md) · [图形索引](assets/diagrams/DIAGRAM_INDEX.md) · [真实案例](examples/transactions/README.md)

[SQL](examples/sql/README.md) · [RPC / JSON](examples/rpc/README.md) · [离线校验](examples/python/normalize_cases.py) · [官方来源](research/source_catalog.md) · [协议时间线](research/protocol-timeline.md)

本篇保留四层证据：真实直接数据、计算推导、官方协议与教学模型。C→P 资金关联已核对，消息样本仅确认源侧；新 SQL 未实际执行。详见 [证据索引](research/evidence-index.md) 与 [缺口](research/unresolved.md)。

## v0.1 出版说明

公开日期：2026-10-14。保留原验收 VALIDATED；本次只作出版结构与证据表述检查，新 SQL 实际执行 0。作者人工审读 UNKNOWN，GitBook NOT_CONFIGURED（仓库证据；账户配置未核验）。

官方整页文档缓存留在作者本地；公开副本以官方链接与 [来源哈希登记](research/source-manifest.json) 替代，不再分发整页缓存。案例、Schema 与必要请求响应随稿保留。原稿验收统计属于 2026-10-13 源工程；本次公开范围与检查见 [出版快照](../../publication/avalanche/2026-10-14-v0.1/README.md)。

可在本篇目录执行 `python3 examples/python/normalize_cases.py`，仅核对已保存样本，会更新 `reports/case-checks.json`；没有联网、查询执行或部署。
