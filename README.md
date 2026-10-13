# 慢月船：链上数据之路

**Slowmoonship: Gateway to Onchain Data** · 作者品牌：slowmoonship

面向懂 SQL 的读者，连接公链的数据结构、运行机制、链上分析方法与 DuneSQL 实践。

## 当前出版

当前公开书稿为 **Ethereum v0.1**（2026-10-12）和 **Solana v0.1**（2026-10-13）。各公链独立迭代，不要求共享版本号；本轮不设全书版本标签。

- [Ethereum 阅读入口](chains/ethereum/README.md)
- [Solana 阅读入口](chains/solana/README.md) · [从数据地图开始](chains/solana/00-overview/index.md)
- [从前言开始](chains/ethereum/book/00-preface.md)
- [全书目录](SUMMARY.md) · [Ethereum 目录](chains/ethereum/SUMMARY.md)
- [真实交易案例](chains/ethereum/examples/transactions/README.md) · [教学 SQL](chains/ethereum/examples/sql/README.md)

## 验证边界

Ethereum 保留原验收 **VALIDATED**：10 Part、40 正文章、前言、4 附录、31 对 SVG/draw.io，以及12条新增教学 SQL。新增 SQL 为 **STATIC_CHECKED / NOT_EXECUTED**，实际运行受 Dune 只读账户限制。历史 Query 样本不替代新增 SQL 的运行验证。作者人工审读状态：**UNKNOWN**。

Solana 原稿 **COMPLETE** 覆盖46篇本地阅读内容；25段教学SQL为 **STATIC_ONLY / NOT_EXECUTED**，新增运行0，13份历史SQL为HISTORICAL_REPORTED。案例来自官方RPC，尚未按signature在Dune交叉核对。作者人工审读状态：**UNKNOWN**。

[Ethereum原验收与缺口](chains/ethereum/reports/final-acceptance.md) · [Solana原验收](chains/solana/_project/overnight-report.md) · [各次出版检查](publication/README.md)。出版结构通过及 GitHub 可访问，不表示技术事实、案例原始材料和 SQL 已全部验证。

## 更新与反馈

[更新记录](CHANGELOG.md) · [出版状态](PUBLICATION_STATUS.md) · [当前全书逐文件清单](publication/CURRENT_FILES.md)

欢迎通过 [GitHub Issues](https://github.com/slowmoonship/slowmoonship-book/issues) 提交勘误或阅读反馈。修改建议请注明章节及依据。

GitBook 本轮未配置，尚无经过验证的在线阅读站点。版权授权待作者确定；本仓库未授予开源或自由转载许可。
