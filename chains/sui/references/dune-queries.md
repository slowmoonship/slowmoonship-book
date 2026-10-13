# Dune Query 与 SQL 登记

调查与抓取日期：2026-10-10。已通过现有 Dune MCP 搜索确认 slowmoonship 团队拥有的一个 Dashboard 和十二份 Sui Query。MCP 的 Query 流式读取发生 IncompleteRead，随后用 Dune CLI 只读获取全部完整 SQL。未修改任何远端 Query 或 Dashboard。

Dashboard：[Sui V0.1 — Network Structure & Onchain Data Audit](https://dune.com/slowmoonship/sui-v01-network-structure-onchain-data-audit)，ID 219547。

## 已有成果

| Query | 原始名称 | 准确标题与用途 | SQL 来源 / 版本 |
|---|---|---|---|
| [8347640](https://dune.com/queries/8347640) | SUI_V1_DWS_001_NETWORK_DAILY | SUI_DWS_001_每日网络指标；网络每日事实；先分别聚合 Checkpoint 与事务，再按日期连接 | [完整 SQL](../_project/cache/existing-dune-queries/8347640.sql)；v4 |
| [8348381](https://dune.com/queries/8348381) | SUI_V1_DWS_002_SHARED_OBJECT_DAILY | SUI_Shared_Object_每日事实表；Shared Object 每日事实；区分事务数与关系行数 | [完整 SQL](../_project/cache/existing-dune-queries/8348381.sql)；v4 |
| [8348409](https://dune.com/queries/8348409) | SUI_V1_DWS_003_PACKAGE_DAILY | SUI_DWS_003_Package 每日调用事实表；Package 每日事实；区分调用与不同事务 | [完整 SQL](../_project/cache/existing-dune-queries/8348409.sql)；v5 |
| [8348462](https://dune.com/queries/8348462) | SUI_V1_ADS_001_NET_STATUS | SUI_ADS_001_网络状态快照；网络最新状态；依赖网络每日事实 | [完整 SQL](../_project/cache/existing-dune-queries/8348462.sql)；v4 |
| [8348618](https://dune.com/queries/8348618) | SUI_ADS_002_DAILY_TRAND | 每日趋势数据；每日趋势；依赖网络每日事实 | [完整 SQL](../_project/cache/existing-dune-queries/8348618.sql)；v5 |
| [8348640](https://dune.com/queries/8348640) | SUI_ADS_003_Checkpoint_Gap_MAP | Checkpoint_GaP 分布；Checkpoint 间隔分布；连续序号过滤 | [完整 SQL](../_project/cache/existing-dune-queries/8348640.sql)；v4 |
| [8348694](https://dune.com/queries/8348694) | SUI_ADS_004_UNUSUAL_CHECHPOINT | 异常 Checkpoint 明细；Checkpoint 异常明细；间隔口径 | [完整 SQL](../_project/cache/existing-dune-queries/8348694.sql)；v4 |
| [8348722](https://dune.com/queries/8348722) | SUI_ADS_005_PTB_LABEL_MAP | PTB复杂度分布；PTB transaction_count 分桶；含义与 NULL 分桶需验证 | [完整 SQL](../_project/cache/existing-dune-queries/8348722.sql)；v4 |
| [8349503](https://dune.com/queries/8349503) | SUI_ADS006_SRD_OBJ_TOP20 | Shared Object 排行；Shared Object 排行；依赖对象每日事实 | [完整 SQL](../_project/cache/existing-dune-queries/8349503.sql)；v5 |
| [8349561](https://dune.com/queries/8349561) | SUI_ADS007_SRD_OBJ_GATHER | Shared object 集中度；Shared Object 集中度；跨对象事务可能重复 | [完整 SQL](../_project/cache/existing-dune-queries/8349561.sql)；v5 |
| [8349755](https://dune.com/queries/8349755) | SUI_ADS008_Pkg_Act | Package Activity top20；Package 活动排行；依赖 Package 每日事实 | [完整 SQL](../_project/cache/existing-dune-queries/8349755.sql)；v4 |
| [8349778](https://dune.com/queries/8349778) | SUI_ADS008_PKG_ACT_GATHER2 | Package Activity集中度 2；Package 集中度；调用份额不等于独立事务份额 | [完整 SQL](../_project/cache/existing-dune-queries/8349778.sql)；v4 |

作者/所有者为 slowmoonship；[机器来源清单](./existing-query-manifest.json) 保存准确 URL、依赖与 SHA-256。全部 SQL 已读取，不代表全部重新执行或验证。尤其不能把 transaction_count 自动解释成完整 PTB Command 数，也不能用 SharedInput 推导全部 Party / 共识对象活动。

## 已读取缓存执行

Query 8348409 的缓存 Execution ID 为 `01M05BA97JDYZ1EM2S3SG5C0A1`，状态 QUERY_STATE_COMPLETED，执行时间 2026-08-16。仅读取一行（8 个数据点），该行日期为 2026-05-10，Package 为 `0xb176dd225d658864baf251d5c49ab83a8fd3eb43b94d692c4b9478bc7f4b1ec2`，move_calls=17750、transaction_blocks=2623。总结果行数元数据为 164321，并未全部下载。

[缓存结果与请求方法](../_project/cache/existing-dune-queries/8348409-latest-result.json)。这是读取已有结果，不是本轮新增执行。缓存没有证明当前保存 SQL v5 与当时执行版本字节一致，因此不把整份当前 Query 标成 VERIFIED；该行足以说明调用与事务是不同指标。

## 本地示例 SQL

新增执行提交尝试 1 次：一天窗口、LIMIT 1 的简单事务候选。Dune 返回 402 configured datapoint limit，未返回 Execution ID。零次成功新增执行，未调整账单、未充值。

| 本地 SQL | 状态 | 本轮执行 |
|---|---|---|
| [01-transaction-checkpoint.sql](../09-sql-practice/sql/01-transaction-checkpoint.sql) | STATIC_CHECKED | 未执行成功 |
| [02-object-relationships.sql](../09-sql-practice/sql/02-object-relationships.sql) | STATIC_CHECKED | 未执行成功 |
| [03-move-calls.sql](../09-sql-practice/sql/03-move-calls.sql) | STATIC_CHECKED | 未执行成功 |
| [04-events.sql](../09-sql-practice/sql/04-events.sql) | STATIC_CHECKED | 未执行成功 |
| [05-package-metrics.sql](../09-sql-practice/sql/05-package-metrics.sql) | STATIC_CHECKED | 未执行成功 |
| [06-pool-history.sql](../09-sql-practice/sql/06-pool-history.sql) | STATIC_CHECKED | 未执行成功 |
| [07-candidate-key-check.sql](../09-sql-practice/sql/07-candidate-key-check.sql) | STATIC_CHECKED | 未执行成功 |
| [08-join-coverage.sql](../09-sql-practice/sql/08-join-coverage.sql) | STATIC_CHECKED | 未执行成功 |
| [09-historical-package-grain.sql](../09-sql-practice/sql/09-historical-package-grain.sql) | STATIC_CHECKED | 未执行成功 |

VERIFIED 需要可归属的完整 SQL/参数、Execution ID、返回结果与合理性检查。STATIC_CHECKED 是 Schema 与静态口径核对，未执行。UNVERIFIED 表示尚未满足所需运行核验条件。

[本地 SQL 状态](./sql-manifest.json) · [官方接口案例](./verified-transactions.md)。接口案例不冒充 Dune SQL VERIFIED。当前数据唯一性、匹配率、实时性与 Dune 历史覆盖仍需运行核验。
