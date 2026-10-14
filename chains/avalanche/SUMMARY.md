# Avalanche 篇目录

[前言](book/00-preface.md)

## Part 1｜钱包里的三条链

- [01｜同样是 AVAX，为什么还要换一条链？](book/part-01/01-one-wallet-many-ledgers.md)
- [02｜Primary Network 是整个 Avalanche 吗？](book/part-01/02-network-and-primary.md)
- [03｜三个 Chain ID，究竟哪个能用来关联数据？](book/part-01/03-identities.md)
- [04｜三条链为什么不能共用一张转账表？](book/part-01/04-three-models.md)

## Part 2｜共识、虚拟机与执行

- [05｜谁决定接受，谁决定余额怎样变化？](book/part-02/05-consensus-and-vm.md)
- [06｜抽样投票为什么能形成最终接受？](book/part-02/06-snowman.md)
- [07｜Helicon 为什么让接受和执行分开？](book/part-02/07-helicon.md)
- [08｜区块、收据和状态为什么不总是同时出现？](book/part-02/08-execution-artifacts.md)

## Part 3｜C-Chain 的数据入口

- [09｜一笔普通 AVAX 转账在 C-Chain 留下什么？](book/part-03/09-c-transfer.md)
- [10｜转了 USDT，为什么交易的 To 是合约？](book/part-03/10-tokens-and-logs.md)
- [11｜Gas Limit 为什么也会影响实际计费？](book/part-03/11-fees.md)
- [12｜四张 Raw 表怎样围绕一笔交易连接？](book/part-03/12-dune-raw.md)

## Part 4｜P-Chain 的对象与操作

- [13｜P-Chain 为什么不是普通合约链？](book/part-04/13-p-chain-role.md)
- [14｜服务器、Node 和注册记录怎样分开？](book/part-04/14-p-objects.md)
- [15｜质押与委托在 P-Chain 怎样留下记录？](book/part-04/15-primary-staking.md)
- [16｜七种 L1 相关交易分别改变什么？](book/part-04/16-p-transaction-types.md)

## Part 5｜X-Chain 与原子转移

- [17｜X-Chain 的钱为什么由一组输出组成？](book/part-05/17-x-utxo.md)
- [18｜两个输入、两个输出，究竟转了几次钱？](book/part-05/18-x-real-transfer.md)
- [19｜C→P 的 Export 和 Import 怎样接上？](book/part-05/19-atomic-transfer.md)
- [20｜导出和导入为什么不能各算一次资金流？](book/part-05/20-atomic-reconciliation.md)

## Part 6｜从 Subnet 到 Avalanche L1

- [21｜Etna 之后，Subnet 的名字为什么还在？](book/part-06/21-etna-and-subnets.md)
- [22｜创建一条 L1，实际创建了哪些对象？](book/part-06/22-launch-objects.md)
- [23｜自己的 Gas Token 为什么没有消除 AVAX 成本？](book/part-06/23-genesis-and-gas-token.md)
- [24｜怎样证明 Beam 的身份与今天的运行有关？](book/part-06/24-beam-creation.md)

## Part 7｜验证者管理与持续费用

- [25｜Validator Manager 怎样管理真正的节点？](book/part-07/25-validator-manager.md)
- [26｜转换成功以后，为什么还需要初始化验证者集合？](book/part-07/26-manager-bootstrap.md)
- [27｜停用、费用耗尽和权重归零是同一种退出吗？](book/part-07/27-validator-lifecycle.md)
- [28｜剩余费用余额能告诉我们链还会运行多久吗？](book/part-07/28-continuous-fees.md)

## Part 8｜消息如何跨越链边界

- [29｜不同验证者集合之间，怎样验证消息是真的？](book/part-08/29-warp-trust.md)
- [30｜AWM、ICM 与 Teleporter 分别是哪一层？](book/part-08/30-teleporter.md)
- [31｜发送成功，为什么目标业务仍可能失败？](book/part-08/31-message-stages.md)
- [32｜原子转移、ICM 资产协议与第三方桥怎么区分？](book/part-08/32-asset-messaging.md)

## Part 9｜把链上记录变成分析数据

- [33｜为什么 Dune、RPC 和 Data API 都需要保留？](book/part-09/33-data-sources.md)
- [34｜解码表和加工表为何仍要回查原始记录？](book/part-09/34-decoded-curated.md)
- [35｜一条 SQL 正确，为什么统计仍可能错误？](book/part-09/35-sql-grain.md)
- [36｜怎样把 P/X JSON 接入本地分析？](book/part-09/36-normalize-json.md)

## Part 10｜连通运行地图与数据地图

- [37｜一张统一网络地图怎样保留链的差异？](book/part-10/37-multi-chain-model.md)
- [38｜一个地址在 Avalanche 全网络有多少 AVAX？](book/part-10/38-whole-network-balance.md)
- [39｜怎样从跨链资金走到一笔真实平台操作？](book/part-10/39-end-to-end.md)
- [40｜打开一个陌生 L1，怎样判断它走到了哪一步？](book/part-10/40-observability.md)

## 附录

- [术语表](book/appendix/glossary.md)
- [已核验链身份](book/appendix/chain-identifiers.md)
- [数据源索引](book/appendix/data-source-index.md)
- [交易类型](book/appendix/transaction-types.md)
- [引用](book/appendix/references.md)
