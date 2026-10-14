# Bitcoin 篇目录

[前言](book/00-preface.md)

## [Part 01｜钱包与输出](book/part-01/index.md)

- [01｜钱包显示的 1 BTC，究竟在哪里？](book/part-01/01-wallet-balance.md)
- [02｜为什么转出 0.3 BTC，要花掉整笔 1 BTC？](book/part-01/02-one-payment.md)
- [03｜怎样准确找到一笔旧输出？](book/part-01/03-outpoint.md)
- [04｜旧输出被花掉以后，还留下什么？](book/part-01/04-utxo-lifecycle.md)

## [Part 02｜交易、字节与授权](book/part-02/index.md)

- [05｜一笔交易为什么可以有很多输入和输出？](book/part-02/05-transaction-anatomy.md)
- [06｜浏览器怎样把一串字节变成交易页面？](book/part-02/06-bytes-and-identifiers.md)
- [07｜网络怎样判断谁有权花掉一笔输出？](book/part-02/07-signatures-and-scripts.md)
- [08｜为什么地址长得不同，花费方式也不同？](book/part-02/08-addresses-and-conditions.md)

## [Part 03｜时间条件、区块与发行](book/part-03/index.md)

- [09｜有了私钥，为什么仍可能暂时花不了？](book/part-03/09-multisig-and-timelocks.md)
- [10｜一笔交易被装进区块时，多了哪些证据？](book/part-03/10-block-anatomy.md)
- [11｜为什么六次确认也不是绝对不可逆？](book/part-03/11-proof-of-work.md)
- [12｜矿工新得到的 BTC，为什么不是普通转账？](book/part-03/12-coinbase-and-halving.md)

## [Part 04｜费用、交易池与SegWit](book/part-04/index.md)

- [13｜为什么转账金额小，手续费却可能更高？](book/part-04/13-fees-and-units.md)
- [14｜未确认交易究竟存在哪个地方？](book/part-04/14-mempool-and-policy.md)
- [15｜想让交易快一点，为什么有两种加费方式？](book/part-04/15-rbf-and-cpfp.md)
- [16｜见证移到哪里去了，为什么还有两种交易标识？](book/part-04/16-segwit-and-commitments.md)

## [Part 05｜Taproot与两张数据地图](book/part-05/index.md)

- [17｜一个 Taproot 输出，藏着几种未来可能？](book/part-05/17-taproot-paths.md)
- [18｜有了 BIP 编号，就已经能在主网使用吗？](book/part-05/18-proposals-and-activation.md)
- [19｜四张表，怎样把 Bitcoin 历史接起来？](book/part-05/19-dune-data-map.md)
- [20｜为什么一个节点查不到交易，不能证明交易不存在？](book/part-05/20-core-rpc.md)

## [Part 06｜用SQL重建输出状态](book/part-06/index.md)

- [21｜怎样用 SQL 读完一笔交易，而不漏掉旧输出？](book/part-06/21-single-transaction-sql.md)
- [22｜为什么三条输入加四条输出，可能查出十二行？](book/part-06/22-join-grain.md)
- [23｜怎样计算某地址在指定高度的余额？](book/part-06/23-balance-at-height.md)
- [24｜一个输出很久没动，究竟说明什么？](book/part-06/24-age-and-cdd.md)

## [Part 07｜指标、图谱与钱包行为](book/part-07/index.md)

- [25｜数了很多输出，为什么仍不知道有多少用户？](book/part-07/25-network-metrics.md)
- [26｜一张资金图里，哪些箭头可以严格重建？](book/part-07/26-transaction-graph.md)
- [27｜两个输出，哪一个才是付款，哪一个是找零？](book/part-07/27-change-heuristics.md)
- [28｜为什么共同花费的输入，未必属于同一个人？](book/part-07/28-coinjoin-and-clusters.md)

## [Part 08｜实体归因与资金血缘](book/part-08/index.md)

- [29｜链上为什么没有一份权威交易所地址名单？](book/part-08/29-exchange-attribution.md)
- [30｜可以追踪输出，为什么不能直接追踪一枚永久编号的 BTC？](book/part-08/30-lineage-methods.md)
- [31｜按比例分配价值，怎样把假设写进计算？](book/part-08/31-proportional-model.md)
- [32｜为什么同一份交易字节，还能被解释成铭文？](book/part-08/32-ordinals-and-inscriptions.md)

## [Part 09｜附加协议与综合追踪](book/part-09/index.md)

- [33｜OP_RETURN 里有数据，就一定是有效代币转移吗？](book/part-09/33-runes-and-runestones.md)
- [34｜一笔真实 BTC 支付，为什么链上可能没有对应交易？](book/part-09/34-lightning-and-custody.md)
- [35｜从一笔早期交易出发，今天还能说它在哪里吗？](book/part-09/35-where-is-the-btc.md)
- [36｜遇到陌生交易，怎样写出一份可复查的结论？](book/part-09/36-practical-evidence.md)

## 附录

- [术语表](book/appendix/glossary.md)
- [数据表索引](book/appendix/data-table-index.md)
- [脚本类型](book/appendix/script-types.md)
- [SQL与RPC索引](book/appendix/query-index.md)
- [参考资料](book/appendix/references.md)
