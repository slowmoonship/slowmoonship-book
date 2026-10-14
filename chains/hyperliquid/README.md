# 《慢月船：链上数据之路》｜Hyperliquid 篇

**[阅读全文：BOOK.md](BOOK.md)** · [40章目录](SUMMARY.md) · [最终验收](reports/final-acceptance.md)

基准2026-10-13。10 Part、40短章，以金融执行与数据结构为主线：Action、订单簿、撮合、Fill、持仓、保证金、资金费与清算，连接同一L1中的HyperCore/HyperEVM，再进入API、Dune与SQL。

本目录含40张双语可编辑draw.io/SVG、实际渲染PNG、18条静态SQL、32个真实只读HTTP响应、2次有界WebSocket会话、案例证据与5附录。[图形索引](assets/diagrams/DIAGRAM_INDEX.md) · [SQL](examples/sql/README.md) · [API](examples/api/README.md) · [案例](research/evidence_index.md) · [官方来源](research/source_catalog.md)。

整体状态**VALIDATED**：书稿与本地工程已完成；新增SQL未执行，完整清算、HIP-2、资产转移和部分历史状态仍有明确缺口。图形使用同scene导出的SVG，桌面CLI代表性导出退出134，未宣称CLI全图导出。没有签名、交易、链上写、付费S3、节点部署或账户升级。

检查：[本地验收](reports/validation.json)、[案例关联](reports/case-evidence-validation.json)、[技术审稿](reports/technical-review.md)、[编辑审稿](reports/editorial-review.md)。原始资料与正文分离，其他链书稿受保护哈希检查。

本机离线案例复验：`python3 scripts/verify_case_evidence.py`。仅核验保存证据的身份、字段与Decimal算术，会更新副本中的案例报告，不访问网络；不构成金融状态独立重放。源工程生成和整体验收工具保留本地。

## v0.1 出版说明

2026-10-14，作为第六条公链篇章公开。原稿 VALIDATED 的范围保持；18条新SQL为 STATIC_CHECKED / NOT_EXECUTED（原阻碍 BLOCKED_READ_ONLY_ACCOUNT），12份历史Query和2份旧结果未重跑。作者人工审读 UNKNOWN；GitBook NOT_CONFIGURED（仓库证据），平台账户与同步 UNVERIFIED。

32份匿名只读HTTP原响应和2次WebSocket会话均取得于2026-10-13（详见各文件retrieved_at UTC）。全文“当前”、327个Outcome/35个Question、价格、仓位、Funding和市场数量均指当时观察窗口，不能当作出版日或阅读日实时值。API实取、字段核验和完整金融事件证明分别成立；unknownOid与空数组不替代订单终态或清算证据。

10个主体案例之外另有2个接口/状态观察与2个未取得完整事件的研究主题，共14主题。真实清算、HIP-2指定事件、HIP-3全权限、HIP-4创建权限与完整结算、Core/EVM双侧资产转移、HLP完整份额会计等缺口仍保留。无新增金融采样、SQL执行或链上写。[缺口](research/unresolved.md) · [出版检查与文件清单](../../publication/hyperliquid/2026-10-14-v0.1/README.md)。
