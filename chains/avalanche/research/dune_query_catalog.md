# Dune 已有研究目录

本轮 getDashboard 确认两个作者公开看板，没有新建、修改或刷新。

- [Avalanche Network — L1s, Validators & Interchain Activity](https://dune.com/slowmoonship/avalanche-network-l1s-validators-interchain-activity)：220085；[本轮响应](raw/dune-dashboard-network.json)。
- [Avalanche C-Chain — Runtime, Contracts & Onchain Economy](https://dune.com/slowmoonship/avalanche-c-chain-runtime-contracts-onchain-economy)：220086；[本轮响应](raw/dune-dashboard-cchain.json)。

| Query | 角色 | 本轮取得 | 历史执行 |
|---|---|---|---|
| [8674923](https://dune.com/queries/8674923) | C 交易样本 | SQL / 元数据 / 10 行结果 | 01M284AH3HM3H1GRJ4BGNC79TE，COMPLETED，2026-09-11 样本 |
| [8676245](https://dune.com/queries/8676245) | Teleporter 发送端 | SQL / 元数据 / 5 行结果 | 01M284AHJYDGCT2VJB50ZHDJ4J，COMPLETED，2026-09-10 样本 |
| [8674861](https://dune.com/queries/8674861) | 社区网络目录 | SQL / 元数据 / 10 行结果 | 01M278XXCVSPD1DGPBS2ZZEXYP，COMPLETED，旧快照 |
| [8676375](https://dune.com/queries/8676375) | 端点对端 | 本轮 get 返回 HTTPError，停止重复请求 | 仅本地旧索引，不声称本轮成功读取 |

原 SQL 保存在 queries/；结果在 raw/dune-result-*。历史 executionCostCredits 不是本轮执行费用。新书 SQL 全为 STATIC_CHECKED / BLOCKED_READ_ONLY_ACCOUNT，不发执行探针。Catalog 查询返回 9 张 avalanche_c、4 张 Curated/metadata，以及 4 张匹配 Teleporter 的表；另一条 Circle 结果仅是搜索噪声，不被写作 Avalanche ICM 表。
