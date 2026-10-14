# 附录D｜HIP与版本边界

| 原语 | 改变的对象 | 本篇核验 | 边界 |
|---|---|---|---|
| HIP-1 | 原生Token、精度、供应及Spot身份 | 官方规范与实际HYPE Meta | 旧USDC-only文字不能替代当前Quote规则 |
| HIP-2 | 协议流动性策略与共同订单簿 | 正式规范 | 指定策略真实状态链未取得 |
| HIP-3 | 部署者Perp DEX、Oracle、风险与管理 | 当前规范、XYZ实际Meta | 当前Cross能力不能按早期isolated-only理解 |
| HIP-4 | 全额抵押、结果解析与支付 | 当前规范、327 Outcome/35 Question快照、历史Outcome95 | 主网市场存在不证明任意市场创建权限 |

HIP-3当前规范涉及符合资格的Cross、DEX独立后备与用户模式相关共享。HIP-4部署者接口仍标注Testnet-only。初始Mainnet范围与今天API市场集合不是同一时间描述。

几处来源差异必须保留：HyperEVM介绍页保留写系统未主网上线文字，交互规范已扩展操作，实际Mainnet读取0807和CoreWriter代码成功；HIP-4介绍页保留初始零费用，费用页描述收费机制；HIP-1基础页保留USDC主导的旧范围，Quote规范与HIP-3抵押规则已扩展；Dune概览称无Trace，Catalog及作者旧结果可见Trace。

这些差异不能靠任意选择一页消除。本篇对具体API实际观察负责；未调用的操作、权限和完整最新数据范围仍留待外部验证。[版本事实表](../../research/protocol_timeline.md)记录对应来源与观察。


[目录](../../SUMMARY.md) · [上一章](data-table-index.md) · [下一章](references.md)
