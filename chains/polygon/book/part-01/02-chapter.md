# 第02章｜先确认自己在哪一条链

相同的钱包地址，可以同时出现在Ethereum和Polygon。地址看起来一样，余额却不同，发送交易使用的手续费资产也不同。这不是钱包显示故障，而是两个网络维护着不同状态。开始分析前，最便宜也最重要的一次检查，是确认网络身份，而不是先看代币名称或网站Logo。

本篇只讨论Polygon PoS Mainnet，当前官方也称Polygon Chain，Chain ID为137。JSON-RPC的eth_chainId通常把它返回为十六进制0x89。Chain ID参与交易签名的网络区分，但一个页面写着137，还不足以证明页面的全部内容可靠。实际研究应同时保存RPC来源、区块号、区块哈希和交易所属网络，使不同服务返回的记录能够对齐。

Polygon品牌还包含zkEVM、CDK和Agglayer等对象。zkEVM是另一套执行与证明系统，CDK是构建链的技术工具，Agglayer讨论的是互操作与聚合关系。这些名称与Polygon PoS存在联系，却不能共享一份交易总数或合约地址清单。把zkevm表中的活动并入polygon表，会让看似完整的统计失去明确对象。

地址同样需要带上网络。一个完整的代币身份至少应写成“链＋合约地址”，符号只方便阅读。Polygon上的DAI与Ethereum上的DAI不是同一个状态槽里的余额；同名稳定币也可能分别是原生发行版本和桥接表示。研究中如果只按symbol='USDC'筛选，就可能把不同机制、不同信用关系的资产混在一起。

当前Polygon使用POL支付原生手续费。历史材料中常见MATIC，数据平台也可能保留旧符号或进行历史归一化。网络身份、计量单位与显示名称应分别记录。一个平台把旧交易显示为POL，不意味着当年那笔交易又发生了一次兑换；反过来，界面仍写MATIC，也不能证明主网尚未完成协议迁移。

在Dune中，本篇的Raw表使用polygon命名空间，跨链Curated表则还要加blockchain='polygon'。在浏览器里，交易链接应指向PolygonScan，而不是Ethereum浏览器。跨链案例确实需要两条链时，应给每条证据各自标明Chain ID，并通过消息或退出标识建立联系，不能仅因时间接近就合并。

实际建立案例文件时，可以把网络身份放在每条记录旁，而不是只写在文件标题。CSV导出后常被单独使用，脱离正文的哈希与地址仍应能够正确定位。尤其在合约跨链部署地址相同的情况下，这一步能够阻止看似匹配、实际属于另一个账本的连接。

你可以把研究起手式理解成给包裹贴地址：先写网络，再写合约或交易，再写观察时刻。这个步骤没有复杂计算，却能阻止很多后续错误。本篇的案例索引保留这些定位字段；某个字段尚未取得时会明确留空，而不会用另一条链的记录补齐。只有对象固定下来，统计结果才有机会被别人复核。

![先确认自己在哪一条链](../../assets/diagrams/chain-identity.svg)

[可编辑原图](../../assets/diagrams/chain-identity.drawio)


来源与核对：[rpc-endpoints](https://docs.polygon.technology/pos/reference/rpc-endpoints.md)；[dune-polygon](https://docs.dune.com/data-catalog/evm/polygon/overview.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](01-chapter.md) · [下一章](03-chapter.md)
