# 慢月船：链上数据之路｜Polygon PoS 篇

**slowmoonship: Gateway to Onchain Data**

研究基准2026-10-19，整理与验收2026-10-20。范围Polygon PoS Mainnet（Chain ID137），当前官方称Polygon Chain。

10Part、40章，正文33,957汉字；44张双语原生draw.io与SVG；18条教学SQL；12个真实案例主题（10个不同交易）；6篇附录。LGNS独立专题另附22项证据矩阵与5份合约源码/ABI；六条关键旧Query完整结果8082行另行核对。本地验收37/37通过。

[开始阅读](book/00-preface.md) · [完整目录](SUMMARY.md) · [合并阅读版](BOOK.md)

[图形](assets/diagrams/DIAGRAM_INDEX.md) · [教学SQL](examples/sql/README.md) · [真实案例](examples/transactions/README.md) · [LGNS专题](research/lgns/LGNS_CASE_STUDY.md)

[Polygon原Query目录](research/dune/polygon_dashboard_catalog.md) · [LGNS原Query目录](research/lgns/original_dashboard_catalog.md) · [版本时间线](research/protocol_timeline.md) · [来源](research/source_catalog.md)

本地书稿与工程交付完成；证据与技术范围为**VALIDATED（有明确子项缺口）**，不标整体COMPLETE。新增SQL未执行，RPC访问受限，PoS桥完整双侧案例、LGNS当前管理/供应/LP和部分完整历史尚未取得。[逐项验收](reports/final-acceptance.md) · [缺口](research/unresolved.md)。

## v0.1 出版与证据范围

2026-10-20，作为第七条公链篇章公开。原稿 VALIDATED（含明确缺口）；作者人工审读 UNKNOWN；18条新SQL STATIC_CHECKED / NOT_EXECUTED，38条历史SQL未重跑。GitBook NOT_CONFIGURED，平台账户及同步 UNVERIFIED。

LGNS直接观察、基于证据的分析、尚未独立验证的判断必须分开阅读。研究基准2026-10-19；旧模型主要固定截止2026-08-18 09:28:58 UTC，部分Query覆盖到8月20日，不能拼成出版日实时快照。当前Controller、Supply、LP、Treasury可用资产、收入、负债与现实身份均保留 UNKNOWN / NOT_VERIFIED。

3,584个退出情景的离线复算只验证给定模型、输入与假设的算术一致性；不能证明真实成交价格、市场深度、同时退出能力、合约状态不变、未来价格或实际收益。源码权限表示能力，不能据此认定已发生恶意行为或损失。[LGNS完整限制](research/lgns/limitations.md) · [历史结果与复算范围](research/lgns/full_results_review.md)。

第三方整页缓存与完整Solidity副本留在原工程；公开版提供浏览器源码链接、原获取时间、SHA256、5份ABI及已有研究摘录，未本地重编译。未给本书添加开源许可证，综合第三方授权状态 UNKNOWN。离线复算算法保留于 `scripts/verify_deep_results.py`，本轮未重算研究结论；执行该脚本会写入研究副本报告，请在自行复制的目录中运行。

[本次出版清单与验收](../../publication/polygon/2026-10-20-v0.1/README.md) · [未解决技术问题](research/unresolved.md)。原工程生成工具与调度日志保留本地。
