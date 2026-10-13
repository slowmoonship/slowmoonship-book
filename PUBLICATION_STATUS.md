# 公链独立出版状态

| 公链 | 当前公开版本 | 出版日期 | 内容入口 | 对应提交 | 原验收 | SQL实际运行 | 作者人工审读 | GitBook |
|---|---|---|---|---|---|---|---|---|
| Ethereum | v0.1 | 2026-10-12 | [Ethereum](chains/ethereum/README.md) | [efc2ddbc](https://github.com/slowmoonship/slowmoonship-book/commit/efc2ddbc7b5276dc833598b35a460e98b8603ca6) | VALIDATED | 新12条STATIC_CHECKED / NOT_EXECUTED；BLOCKED_READ_ONLY_ACCOUNT | UNKNOWN | NOT_CONFIGURED |
| Solana | v0.1 | 2026-10-13 | [Solana](chains/solana/README.md) | 本文件新增Solana记录的提交，见[内容提交历史](https://github.com/slowmoonship/slowmoonship-book/commits/main/chains/solana) | COMPLETE：46篇本地阅读内容及原范围验收 | 新25段STATIC_ONLY / NOT_EXECUTED，运行0；13份历史定义HISTORICAL_REPORTED | UNKNOWN | NOT_CONFIGURED |

[当前全书清单与每次验收](publication/README.md)。Ethereum历史Query保存每条3行旧结果，未重跑；Solana的历史执行状态只由原材料报告，本轮没有取得新的运行证据。官方RPC案例尚未在Dune按signature交叉核对。

每条链独立迭代；chains目录保存当前公开稿，历史通过Git提交追溯，不复制正文版本文件夹。本轮无全书Tag/Release；远端Push及渲染结果以实际交付核验为准。版权授权待作者确定，不添加许可证。
