# Hyperliquid 篇目录

[前言](book/00-preface.md) · [完整合并稿](BOOK.md)

## Part 01｜订单为何需要共识

- [01｜点击买入之后，链上发生了什么](book/part-01/01-click.md)
- [02｜订单先后顺序为何需要共识](book/part-01/02-consensus.md)
- [03｜同一条L1的两种执行环境](book/part-01/03-runtime.md)
- [04｜把一次金融行为拆成不同记录](book/part-01/04-records.md)

## Part 02｜账户与金融状态

- [05｜一个地址为何有多种余额](book/part-02/05-accounts.md)
- [06｜账户模式决定保证金怎样共享](book/part-02/06-abstraction.md)
- [07｜主账户、子账户和代理钱包](book/part-02/07-identities.md)
- [08｜怎样读懂一份账户状态](book/part-02/08-account-state.md)

## Part 03｜订单簿与成交

- [09｜读懂订单簿的两边](book/part-03/09-book.md)
- [10｜撮合怎样选择交易对手](book/part-03/10-matching.md)
- [11｜一张订单怎样分成多个成交](book/part-03/11-partial.md)
- [12｜挂单、撤单和条件订单的生命周期](book/part-03/12-orders.md)

## Part 04｜永续合约与持仓

- [13｜买入BTC永续为何没有收到BTC](book/part-04/13-perpetual.md)
- [14｜成交方向怎样改变持仓](book/part-04/14-position.md)
- [15｜盈利为何不等于账户余额增加](book/part-04/15-pnl.md)
- [16｜成交量与未平仓量分别数什么](book/part-04/16-oi.md)

## Part 05｜价格、保证金与清算

- [17｜成交价、标记价与预言机价](book/part-05/17-prices.md)
- [18｜保证金是怎样一层层检查的](book/part-05/18-margin.md)
- [19｜清算为何不是一次普通卖出](book/part-05/19-liquidation.md)
- [20｜后备接管与自动减仓的区别](book/part-05/20-backstop.md)

## Part 06｜持仓现金流与费用

- [21｜持仓没有交易，为何出现现金流](book/part-06/21-funding-flow.md)
- [22｜资金费率怎样从溢价产生](book/part-06/22-funding-rate.md)
- [23｜怎样核对用户实际资金费用](book/part-06/23-funding-payment.md)
- [24｜手续费、返佣与协议收入](book/part-06/24-fees.md)

## Part 07｜现货与原生资产

- [25｜现货成交如何改变两种资产](book/part-07/25-spot.md)
- [26｜Token编号与Pair编号的区别](book/part-07/26-token-pair.md)
- [27｜HIP-2怎样把流动性放进订单簿](book/part-07/27-hip2.md)
- [28｜Core与EVM之间怎样移动资产](book/part-07/28-transfers.md)

## Part 08｜HyperEVM与Core交互

- [29｜HyperEVM的区块与Gas](book/part-08/29-evm.md)
- [30｜智能合约怎样读取Core状态](book/part-08/30-precompiles.md)
- [31｜CoreWriter为何需要两阶段核对](book/part-08/31-corewriter.md)
- [32｜EVM交易、日志与调用树](book/part-08/32-evm-data.md)

## Part 09｜新市场与协议参与

- [33｜HIP-3怎样定义一个独立市场](book/part-09/33-hip3.md)
- [34｜HIP-4从交易走向结果结算](book/part-09/34-hip4.md)
- [35｜质押怎样连接验证者与共识](book/part-09/35-staking.md)
- [36｜HLP与Vault的份额和盈亏](book/part-09/36-vault.md)

## Part 10｜数据地图与研究方法

- [37｜协议状态怎样进入数据接口](book/part-10/37-data-sources.md)
- [38｜Dune表的粒度、覆盖与权限](book/part-10/38-dune.md)
- [39｜把金融问题写成可审查的SQL](book/part-10/39-sql.md)
- [40｜重建历史状态并解释研究边界](book/part-10/40-reconstruction.md)

## 附录

- [术语表](book/appendix/glossary.md)
- [市场与资产身份](book/appendix/market-identifiers.md)
- [数据表索引](book/appendix/data-table-index.md)
- [HIP与版本边界](book/appendix/hip-standards.md)
- [来源与证据等级](book/appendix/references.md)
