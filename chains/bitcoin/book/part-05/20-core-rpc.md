# 20｜为什么一个节点查不到交易，不能证明交易不存在？

你知道一笔很早的交易哈希，向节点调用 `getrawtransaction`，却得到错误。最容易犯的推断是“这笔交易是假的”。其实，一个节点能够验证当前区块链，不意味着它为任意历史交易提供了完整的查询索引。接口失败首先需要解释数据可用性。

Bitcoin Core 节点可能维护 txindex，也可能没有这个索引。调用 `getrawtransaction` 时提供已知 blockhash，可以在该区块数据可用的前提下帮助定位；裁剪节点可能已移除所需旧区块。同步进度、网络选择、参数错误和权限限制也会影响返回，不能把这些服务条件都归为交易不存在。

本篇 RPC 教学采用已取得的 31.0.0 版本文档。`getrawtransaction` 的 verbosity 为零时返回原始序列化，一级提供常见解码结构，二级还可提供费用和 prevout 信息。二级的这些增强字段依赖可用的区块撤销数据，缺少时可能不返回；请求成功也不保证所有预期字段齐全。

`getblockhash` 把高度对应到节点当前有效链中的区块哈希，`getblockheader` 读取头部及有关链信息，`getblock` 可以按 verbosity 返回不同粒度内容。教学里需要先决定是只要头部、交易标识列表还是完整解码交易，避免为了一个字段取得巨大结果或误读返回格式。

`gettxout` 查询当前未花费输出，并可选择是否考虑 Mempool。返回 null 不是“从来没有这笔输出”的唯一解释：它可能已被花费，也可能因为加入交易池视图而被待确认花费排除。历史创建证据与当前未花费状态，应分别向适当来源取得。

`gettxoutsetinfo` 读取 UTXO 集合统计，返回高度和 bestblock 等定位。它不天然提供任何任意地址的完整历史余额。部分模式和历史位置需要索引支持，扫描集合也可能耗时。本书不自动启动昂贵扫描或重新索引；教学文件标明请求用途、预期成本边界与没有实际返回。

`getblockchaininfo` 帮助确认网络、链头、同步和裁剪状态，`getnetworkinfo` 可以核对软件版本；它们应该在解释查询能力之前查看。本文没有连接一个作者授权的本地 Core 节点，因此十二个方法文件是已核对参数的教学请求，执行状态全部明确为未执行。

真正保存 RPC 证据时，需要网络、节点或服务、取得时间、软件版本、方法、参数和原始返回。公共 Esplora API 的解码交易，本书按 API 来源保存，没有把它改名为 Core 的原始 RPC 返回。结构相似，不代表采集路径相同，更不允许编造调用成功记录。

普通读者可以把接口当作不同窗口：一个窗口看历史交易，一个窗口看当前状态，一个窗口看本地未确认交易。窗口没有显示某样东西，先查它的观察范围。这个习惯能避免在链上研究中，把索引限制写成协议事实。

![为什么一个节点查不到交易，不能证明交易不存在？](../../assets/diagrams/rpc.svg)

[编辑此图](../../assets/diagrams/rpc.drawio)

依据：[rpc-getrawtransaction](https://bitcoincore.org/en/doc/31.0.0/rpc/rawtransactions/getrawtransaction/)；[rpc-gettxout](https://bitcoincore.org/en/doc/31.0.0/rpc/blockchain/gettxout/)；[rpc-gettxoutsetinfo](https://bitcoincore.org/en/doc/31.0.0/rpc/blockchain/gettxoutsetinfo/)；[rpc-getblock](https://bitcoincore.org/en/doc/31.0.0/rpc/blockchain/getblock/)。研究基准日：2026-10-13。来源获取状态见[来源目录](../../research/source_catalog.md)。

[上一章](../part-05/19-dune-data-map.md) · [目录](../../SUMMARY.md) · [下一章](../part-06/21-single-transaction-sql.md)
