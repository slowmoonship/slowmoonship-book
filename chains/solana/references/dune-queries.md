# Dune 查询索引

账号：slowmoonship。现有看板优先研究；本轮无新增 SQL 执行、无远端资源修改。当前 Dune usage 返回 included=0，无法判断额外计算成本。

## [8435308 Solana Daily Blocks ｜ Solana 每日区块](https://dune.com/queries/8435308)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435308.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：solana.blocks。
- 窗口/边界：90 complete UTC days。

## [8435334 Solana Daily Transactions ｜ Solana 每日交易](https://dune.com/queries/8435334)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435334.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：query_8435308, solana.blocks。
- 窗口/边界：90 complete UTC days。

## [8435352 Solana Instruction Activity ｜ Solana 指令活动](https://dune.com/queries/8435352)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435352.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：solana.instruction_calls。
- 窗口/边界：7 complete UTC days, 2026-08-16 through 2026-08-22。

## [8435384 Solana Outer and Inner Instructions ｜ Solana 外层与内部指令](https://dune.com/queries/8435384)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435384.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：query_8435352, solana.instruction_calls。
- 窗口/边界：7 complete UTC days, 2026-08-16 through 2026-08-22。

## [8435396 Solana Program Activity ｜ Solana 程序调用活动](https://dune.com/queries/8435396)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435396.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：query_8435352, solana.instruction_calls。
- 窗口/边界：7 complete UTC days, 2026-08-16 through 2026-08-22。

## [8435414 Solana Account Activity ｜ Solana 账户活动](https://dune.com/queries/8435414)

- 作者：slowmoonship。当前版本：5。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435414.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：solana.account_activity。
- 窗口/边界：7 complete UTC days, address_prefix='25' cohort only。

## [8435487 Solana SOL Balance Changes ｜ Solana SOL 余额变化](https://dune.com/queries/8435487)

- 作者：slowmoonship。当前版本：4。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435487.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：solana.account_activity。
- 窗口/边界：7 complete UTC days, address_prefix='25' cohort only。

## [8435548 Solana Token Transfers ｜ Solana 代币转账](https://dune.com/queries/8435548)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435548.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：tokens_solana.transfers。
- 窗口/边界：7 complete UTC days, 2026-08-16 through 2026-08-22。

## [8435262 Solana Token Accounts Catalog Probe ｜ Solana 代币账户目录探针](https://dune.com/queries/8435262)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435262.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：solana_utils.token_accounts。
- 窗口/边界：static one-row schema/access probe。

## [8435564 Solana DEX Activity ｜ Solana DEX 活动](https://dune.com/queries/8435564)

- 作者：slowmoonship。当前版本：2。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435564.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：dex_solana.trades。
- 窗口/边界：30 complete UTC days, 2026-07-24 through 2026-08-22。

## [8435082 Solana Core Grain and Relationship QA ｜ Solana 核心粒度与关系 QA](https://dune.com/queries/8435082)

- 作者：slowmoonship。当前版本：5。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435082.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：见 SQL 定义。
- 窗口/边界：受控粒度 QA，见 SQL。

## [8435196 Solana IDL Decoding Example ｜ Solana IDL 解码示例](https://dune.com/queries/8435196)

- 作者：slowmoonship。当前版本：4。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435196.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：见 SQL 定义。
- 窗口/边界：受控粒度 QA，见 SQL。

## [8435570 Solana Curated, Vote and Rewards Grain QA ｜ Solana 精选、投票与奖励粒度 QA](https://dune.com/queries/8435570)

- 作者：slowmoonship。当前版本：3。
- SQL：已于 2026-10-09 读取并缓存 [本地定义](../_project/cache/queries/8435570.sql)。
- 执行状态：HISTORICAL_REPORTED；原材料报告 2026-08-25 完成，本轮未重跑，未取得原执行结果响应。
- 表：见 SQL 定义。
- 窗口/边界：受控粒度 QA，见 SQL。

## 教学查询

各章 SQL 均以 STATIC_ONLY 登记在 `_project/sql-validation.json`，附内容 hash。它们可供读者理解和运行，但不附伪造结果。

[教学 SQL 静态状态记录](../_project/sql-validation.json)。
