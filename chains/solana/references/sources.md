# 来源清单

核验日期：2026-10-09。官方文档正文已缓存；日期表示此次读取时间，不等于每条规则首次生效日期。

- [commitment](https://solana.com/docs/rpc)；缓存：`_project/cache/sources/commitment.md`。
- [compute-budget](https://solana.com/docs/core/fees/compute-budget)；缓存：`_project/cache/sources/compute-budget.md`。
- [terminology](https://solana.com/docs/references/terminology)；缓存：`_project/cache/sources/terminology.md`。
- [accounts](https://solana.com/docs/core/accounts)；缓存：`_project/cache/sources/accounts.md`。
- [account-structure](https://solana.com/docs/core/accounts/account-structure)；缓存：`_project/cache/sources/account-structure.md`。
- [programs](https://solana.com/docs/core/programs)；缓存：`_project/cache/sources/programs.md`。
- [instructions](https://solana.com/docs/core/instructions)；缓存：`_project/cache/sources/instructions.md`。
- [transactions](https://solana.com/docs/core/transactions)；缓存：`_project/cache/sources/transactions.md`。
- [transaction-structure](https://solana.com/docs/core/transactions/transaction-structure)；缓存：`_project/cache/sources/transaction-structure.md`。
- [fees](https://solana.com/docs/core/fees)；缓存：`_project/cache/sources/fees.md`。
- [cpi](https://solana.com/docs/core/cpi)；缓存：`_project/cache/sources/cpi.md`。
- [pda](https://solana.com/docs/core/pda)；缓存：`_project/cache/sources/pda.md`。
- [tokens](https://solana.com/docs/tokens)；缓存：`_project/cache/sources/tokens.md`。
- [rpc-getblock](https://solana.com/docs/rpc/http/getblock)；缓存：`_project/cache/sources/rpc-getblock.md`。
- [rpc-gettransaction](https://solana.com/docs/rpc/http/gettransaction)；缓存：`_project/cache/sources/rpc-gettransaction.md`。
- [rpc-json](https://solana.com/docs/rpc/json-structures)；缓存：`_project/cache/sources/rpc-json.md`。
- [dune-blocks](https://docs.dune.com/data-catalog/solana/blocks)；缓存：`_project/cache/sources/dune-blocks.md`。
- [dune-transactions](https://docs.dune.com/data-catalog/solana/transactions)；缓存：`_project/cache/sources/dune-transactions.md`。
- [dune-instructions](https://docs.dune.com/data-catalog/solana/instruction-calls)；缓存：`_project/cache/sources/dune-instructions.md`。
- [dune-accounts](https://docs.dune.com/data-catalog/solana/account-activity)；缓存：`_project/cache/sources/dune-accounts.md`。
- [dune-votes](https://docs.dune.com/data-catalog/solana/vote-transactions)；缓存：`_project/cache/sources/dune-votes.md`。
- [dune-rewards](https://docs.dune.com/data-catalog/solana/rewards)；缓存：`_project/cache/sources/dune-rewards.md`。
- [dune-transfers](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)；缓存：`_project/cache/sources/dune-transfers.md`。
- [dune-metadata](https://docs.dune.com/data-catalog/curated/token-metadata/solana/token-metadata)；缓存：`_project/cache/sources/dune-metadata.md`。
- [dune-token-accounts](https://docs.dune.com/data-catalog/curated/token-metadata/solana/token-accounts)；缓存：`_project/cache/sources/dune-token-accounts.md`。
- [dune-dex](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)；缓存：`_project/cache/sources/dune-dex.md`。
- [drawio-xml](https://raw.githubusercontent.com/jgraph/drawio-mcp/main/shared/xml-reference)；缓存：`_project/cache/sources/drawio-xml.md`。
- [codex-repair](https://developers.openai.com/cookbook/examples/codex/build_iterative_repair_loops_with_codex)；缓存：`_project/cache/sources/codex-repair.md`。
- [versions](https://solana.com/docs/core/transactions/versioned-transactions)；缓存：`_project/cache/sources/versions.md`。
- [ata](https://solana.com/docs/tokens/basics/create-token-account)；缓存：`_project/cache/sources/ata.md`。

## 验证层次

- OFFICIAL_FACT：官方技术文档支持。
- DOCS_SCHEMA：官方 Dune 文档字段与类型；本轮目录 API 未验证。
- CURRENT_SQL_READ：2026-10-09 读取保存查询的 SQL，不表示该日执行通过。
- HISTORICAL_REPORTED：2026-08-25 原材料包报告完成，未取得原执行响应时不称为当日测试。
- RPC_CAPTURED：本轮从官方 mainnet RPC、finalized 区块获取。
- STATIC_ONLY：书稿教学 SQL 静态核对，未执行。
- SCHEMATIC：概念图与简化数值，不能作为链上证据。

## 实际章节引用的补充来源

- [Dune EVM 事件模型](https://docs.dune.com/data-catalog/evm/sei/decoded/event-logs)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Dune IDL 解码表](https://docs.dune.com/data-catalog/solana/idl-tables)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [DuneSQL 数组操作](https://docs.dune.com/query-engine/Functions-and-operators/array)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [原查询 8435196](https://dune.com/queries/8435196)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Jupiter 官方解析器 / Jupiter 官方解析器与 Program ID](https://github.com/jup-ag/instruction-parser)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [PumpSwap 官方文档 / PumpSwap 官方资料](https://github.com/pump-fun/pump-public-docs/blob/main/docs/PUMP_SWAP_README.md)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Solana Core / Solana 核心概念](https://solana.com/docs/core)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Durable Nonces](https://solana.com/docs/core/transactions/durable-nonces)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Transaction Pipeline](https://solana.com/docs/core/transactions/transaction-pipeline)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [RPC getAccountInfo](https://solana.com/docs/rpc/http/getaccountinfo)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Sync Native 与 WSOL / WSOL](https://solana.com/docs/tokens/basics/sync-native)；核验日期 2026-10-09，事实或字段边界见引用章节。
- [Token-2022 官方说明](https://www.solana-program.com/docs/token-2022)；核验日期 2026-10-09，事实或字段边界见引用章节。
