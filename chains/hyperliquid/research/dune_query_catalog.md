# 既有Dune Query目录

来源作者：slowmoonship既有看板及本地旧研究指向的Query。看板：[Hyperliquid Data Structure](https://dune.com/slowmoonship/hyperliquid-data-structure-v0-1-expanded-runtime-dashboard)。2026-10-13只读取，不创建、不更新、不执行。搜索SMS HYPE返回空，使用已知ID取得原SQL。

| ID / URL | 当前返回名称 | 主要表 | 已有执行状态 | 原SQL |
|---|---|---|---|---|
| [8675901](https://dune.com/queries/8675901) | D01: HyperEVM Daily Blocks (90d) | hyperevm.blocks | QUERY_STATE_COMPLETED（旧） | [8675901.sql](dune/queries/8675901.sql) |
| [8675913](https://dune.com/queries/8675913) | D02: HyperEVM Daily Transactions (90d) | hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8675913.sql](dune/queries/8675913.sql) |
| [8675918](https://dune.com/queries/8675918) | D03: HyperEVM Contract Activity (90d) | hyperevm.logs | QUERY_STATE_COMPLETED（旧） | [8675918.sql](dune/queries/8675918.sql) |
| [8675927](https://dune.com/queries/8675927) | D10: HyperEVM-HyperCore Interface (30d) | hyperevm.traces | QUERY_STATE_COMPLETED（旧） | [8675927.sql](dune/queries/8675927.sql) |
| [8678766](https://dune.com/queries/8678766) | SMS HYPE 10: Hyperliquid Overview KPIs (latest complete UTC day) | hyperevm.blocks, hyperevm.logs, hyperevm.traces, hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8678766.sql](dune/queries/8678766.sql) |
| [8678771](https://dune.com/queries/8678771) | SMS HYPE 11: HyperEVM transaction type distribution (last 30 UTC days) | hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8678771.sql](dune/queries/8678771.sql) |
| [8678774](https://dune.com/queries/8678774) | SMS HYPE 12: HyperEVM active sender addresses (last 30 / 90 UTC days) | hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8678774.sql](dune/queries/8678774.sql) |
| [8678775](https://dune.com/queries/8678775) | SMS HYPE 13: HyperEVM contracts interacted with via event-log emissions (30D, top 15) | hyperevm.logs | QUERY_STATE_COMPLETED（旧） | [8678775.sql](dune/queries/8678775.sql) |
| [8678780](https://dune.com/queries/8678780) | SMS HYPE 14: HyperEVM top contracts by inbound transactions (30D, top 15) | hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8678780.sql](dune/queries/8678780.sql) |
| [8678786](https://dune.com/queries/8678786) | SMS HYPE 15: HyperEVM contract deployments (last 30 UTC days) | hyperevm.creation_traces | QUERY_STATE_COMPLETED（旧） | [8678786.sql](dune/queries/8678786.sql) |
| [8678788](https://dune.com/queries/8678788) | SMS HYPE 16: HyperCore read-precompile activity by address (latest complete UTC day) | hyperevm.traces, hyperevm.transactions | QUERY_STATE_COMPLETED（旧） | [8678788.sql](dune/queries/8678788.sql) |
| [8678790](https://dune.com/queries/8678790) | SMS HYPE 17: CoreWriter traces per day (last 30 UTC days) | hyperevm.traces | QUERY_STATE_COMPLETED（旧） | [8678790.sql](dune/queries/8678790.sql) |

旧Result仅取2个执行各最多3行：

- [result-8678766](dune/result-8678766.json)：executionId `01M2833JAJENX5B0F8HGVATAGQ`；总结果行数6，本地仅取3行。原执行Credits是历史成本，不是本轮新执行。
- [result-8675927](dune/result-8675927.json)：executionId `01M27GDBJNJ3VVPBJEBR8X9357`；总结果行数60，本地仅取3行。原执行Credits是历史成本，不是本轮新执行。

既有内容主要是HyperEVM/接口，不能代替最新HyperCore分析。HyperCore历史权限错误来自2026-09-11旧资料；本轮只读约束不提交运行探针。当前具体entitlement未运行复核。
