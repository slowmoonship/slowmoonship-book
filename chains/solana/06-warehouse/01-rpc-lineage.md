# 06.01 RPC、原始表与加工表

在浏览器看到一笔 Swap，Dune 却有三条 trades 记录，谁错了？先查记录在哪一层被加工，以及每条行代表什么；不要立即要求两个界面数量相同。

链上保存账户状态和交易历史，运行时执行程序并产生观察结果。RPC 按方法与编码返回这些信息：`getBlock` 提供区块及交易集合，`getTransaction` 按 signature 返回一笔交易，`getAccountInfo` 读取指定地址的账户状态。它们是不同问题的接口，当前账户状态不能直接替代历史交易前后状态。

RPC JSON 的结构也不是唯一的。普通 json 编码保留编译指令和索引；jsonParsed 尽可能解析被支持程序的动作，但并不保证所有未知协议都获得同样清楚的字段。v0 的 loadedAddresses 与解析后的 accountKeys 表达方式不同，v1 读取还需版本支持。工具输出的字段缺失要先按编码和版本解释。

Dune 基础表把这些对象变成可查询结构。交易表保留一笔记录和数组，instruction_calls 展开调用，account_activity 聚焦账户使用和余额。后两张表已包含整理，不是运行时另外存了两套 SQL 关系。它们仍保持接近账本对象的语义，所以适合检查交易身份和执行关系。

解码表使用程序接口，为指令数据和参数地址命名。整理表则进一步定义业务对象：资产移动跨程序统一，DEX 数据按池执行段保留路由环节。一次用户换币可能经过不同池，因此出现多行不是自动重复错误。真正的重复应按模型身份和加工规则确认。整理模型可以自行解释原始调用，也可以依赖已有解码表；图展示语义层次，并不规定所有表都必须经过同一条物理流水线。

价格、symbol、项目名等字段还可能来自额外元数据与模型。它们不因与 tx_id 同行就变成签名 Message 中的原生事实。归因与估值是有来源、有时点和覆盖边界的加工结果。分析师应尽量保留 Mint、Program 和交易 identity，让友好标签可以被复核。

本篇图展示接口与语义血缘，不声称揭示 Dune 内部每项抓取设施的具体实现。可核查的是字段来自什么对象、经过什么类型的展开或解释。下一章会在这些已明确的粒度之间建立 JOIN，并保护交易级金额不被重复。

![RPC、原始表与加工表](./assets/data-lineage.svg)

[编辑原图（draw.io）](./assets/data-lineage.drawio)

参考来源（核验日期：2026-10-09）：

- [RPC JSON 结构](https://solana.com/docs/rpc/json-structures)
- [Dune Transactions](https://docs.dune.com/data-catalog/solana/transactions)
- [Dune Instruction Calls](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [Dune Account Activity](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune DEX 数据模型](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)
- [RPC getAccountInfo](https://solana.com/docs/rpc/http/getaccountinfo)

<!-- NAV -->

[总目录](../README.md) · [上一章：进入仓库前先问粒度](index.md) · [下一章：JOIN 前先守住行数](02-joins.md)
