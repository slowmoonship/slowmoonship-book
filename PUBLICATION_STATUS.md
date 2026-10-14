# 公链独立出版状态

| 公链 | 当前公开版本 | 出版日期 | 内容入口 | 对应提交 | 原验收 | SQL实际运行 | 作者人工审读 | GitBook |
|---|---|---|---|---|---|---|---|---|
| Ethereum | v0.1 | 2026-10-12 | [Ethereum](chains/ethereum/README.md) | [efc2ddbc](https://github.com/slowmoonship/slowmoonship-book/commit/efc2ddbc7b5276dc833598b35a460e98b8603ca6) | VALIDATED | 新12条STATIC_CHECKED / NOT_EXECUTED；BLOCKED_READ_ONLY_ACCOUNT | UNKNOWN | NOT_CONFIGURED |
| Solana | v0.1 | 2026-10-13 | [Solana](chains/solana/README.md) | 本文件新增Solana记录的提交，见[内容提交历史](https://github.com/slowmoonship/slowmoonship-book/commits/main/chains/solana) | COMPLETE：46篇本地阅读内容及原范围验收 | 新25段STATIC_ONLY / NOT_EXECUTED，运行0；13份历史定义HISTORICAL_REPORTED | UNKNOWN | NOT_CONFIGURED |
| Sui | v0.1 | 2026-10-13 | [Sui](chains/sui/README.md) | 本次新增Sui记录的提交，见[内容提交历史](https://github.com/slowmoonship/slowmoonship-book/commits/main/chains/sui) | PARTIAL：45/45正文；39 COMPLETE、6 VALIDATED（SQL相关） | 新9份STATIC_CHECKED / NOT_EXECUTED，成功执行0；Dune 402 configured datapoint limit；12份历史SQL未重跑，旧缓存1行不证明版本一致 | UNKNOWN | NOT_CONFIGURED |
| Avalanche | v0.1 | 2026-10-14 | [Avalanche](chains/avalanche/README.md) | 本次新增Avalanche记录的提交，见[内容提交历史](https://github.com/slowmoonship/slowmoonship-book/commits/main/chains/avalanche) | VALIDATED；40章及前言/5附录；有限样本 | 10条新SQL STATIC_CHECKED / NOT_EXECUTED，执行0；原稿BLOCKED_READ_ONLY_ACCOUNT；15份历史API样本，出版未重采 | UNKNOWN | NOT_CONFIGURED |
| Bitcoin | v0.1 | 2026-10-14 | [Bitcoin](chains/bitcoin/README.md) | 本次新增Bitcoin记录的提交，见[内容提交历史](https://github.com/slowmoonship/slowmoonship-book/commits/main/chains/bitcoin) | VALIDATED；9 Part/36章，有限离线结构检查 | 新16条STATIC_CHECKED / NOT_EXECUTED；Core 31.0.0 RPC 12组NOT_EXECUTED，response=null；历史Query未重跑 | UNKNOWN | NOT_CONFIGURED |

[当前全书清单与每次验收](publication/README.md)。Ethereum历史Query保存每条3行旧结果，未重跑；Solana的历史执行状态只由原材料报告，本轮没有取得新的运行证据。官方RPC案例尚未在Dune按signature交叉核对。

每条链独立迭代；chains目录保存当前公开稿，历史通过Git提交追溯，不复制正文版本文件夹。本轮无全书Tag/Release；远端Push及渲染结果以实际交付核验为准。版权授权待作者确定，不添加许可证。

Bitcoin RPC 实调为 NOT_EXECUTED；案例取得日期2026-10-13，三条后续边止于高度92640，未追至当前链头。UTXO引用为结构证据，聚类/找零/比例模型保留推断边界。GitBook仓库无配置证据，平台账户同步 UNVERIFIED。
