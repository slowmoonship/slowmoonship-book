# 07.00 用三个案例贯穿数据地图

概念要真正变成分析能力，需要回到同一笔交易。这个模块固定三个来自主网最终确认区块的案例，从请求、调用、权限和余额四个视角拆解；它们与前面章节用到的 signatures 相同。

三个案例属于 Slot 454852499，区块时间为 2026-10-09 11:26:30 UTC。数据由官方 mainnet RPC 的 getBlock 返回，使用 finalized、jsonParsed 和支持版本上限 1。这个设置读取整个区块，包括实际存在的 v1 交易；选出的两个转账案例是 legacy，路由案例是 v0。版本不能由案例名称猜测。

第一个案例只有一条顶层 System Program transfer，没有内部调用。发送者也是付费者，接收者 SOL 增加量与指令金额一致，发送者多减少的 5,000 lamports 对应交易费用。它提供一个很小的闭环，让账户数组、签名角色和动作金额都容易对上。

第二个案例只有一条 Token Program transfer。两个 Token Account 都指向官方文档列出的 USDC Mint，decimals 为 6，业务 owner 相同。源账户的 Token 数量减少、目标增加，但 owner 合计不变。这不是一个困难协议案例，却能直接反驳“账户转出量就是用户对外资金流”的错误口径。

第三个案例调用 Jupiter，并在内部调用 PumpSwap 与 Token 程序。它包含准备、SOL 转入、SyncNative、路由和账户关闭；全部共有 7 条顶层指令、19 条内层记录和 2 个签名者。一个用户可见的换币流程，因此不能被概括成一条 transfer，更不能仅按程序地址出现次数统计 Swap。

本地核验已经检查三个案例的账户清单与 SOL 余额长度、成功状态，以及全账户 SOL 净变化与 fee 的关系。两个简单转账额外检查了具体 source/destination 差额，Token 案例检查 Mint、decimals、共同 owner 和合计守恒。路由案例检查版本、ALT、调用数量与实际资产动作。

这些检查建立的是 RPC 证据，不是 Dune 执行结果。各章会给相应的仓库映射 SQL，但此次没有执行，也没有保证 Dune 已收录这些当日 signatures。静态 SQL 与真实缓存分别保存，不能把 RPC 数组直接排列成某张表后声称“Dune 查询得到”。

完整地址、signature、原始 JSON 与读取时间放在资料索引中，图上只使用可核对的缩写以维持可读性。程序归属由官方项目资料支持；尚未解码的指令和自然人身份不补写猜测。沿这个边界阅读三个案例，你会看到同一方法怎样从简单转账延伸到真实业务调用。

本模块阅读顺序：

- [完整拆开一笔 SOL 转账](./01-sol-case.md)
- [完整拆开一笔 Token 转账](./02-token-case.md)
- [聚合路由与多次 Swap](./03-swap-case.md)
- [让不同视角回到同一事实](./summary.md)

![用三个案例贯穿数据地图](./assets/sol-case.svg)

[编辑原图（draw.io）](./assets/sol-case.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana RPC getBlock](https://solana.com/docs/rpc/http/getblock)
- [RPC JSON](https://solana.com/docs/rpc/json-structures)
- [Token 模型](https://solana.com/docs/tokens)
- [Jupiter 官方解析器与 Program ID](https://github.com/jup-ag/instruction-parser)
- [PumpSwap 官方文档](https://github.com/pump-fun/pump-public-docs/blob/main/docs/PUMP_SWAP_README.md)

<!-- NAV -->

[总目录](../README.md) · [上一章：一条能解释自己的查询](../06-warehouse/summary.md) · [下一章：完整拆开一笔 SOL 转账](01-sol-case.md)
