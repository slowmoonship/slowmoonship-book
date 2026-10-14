# HyperCore金融数据模型

基准2026-10-13，官方文档与本地API真实响应核验。运行时主线：签名Action → 共识批次排序 → 订单簿/撮合 → 双侧Fill → Clearinghouse/余额。Funding及非Funding Ledger另行改变状态，不必有成交。

| 对象 | 身份及Grain | 核心字段 / 单位 | 观察边界 |
|---|---|---|---|
| Action | 一个操作，可含多订单 | 类型、权限与专属参数 | 原始签名Action未取得；Exchange仅阅读规范 |
| Order | 用户/市场/oid，cloid辅助追踪 | 价格quote/base、数量base、TIF、reduceOnly | Status不等于完整更新史 |
| Trade | coin/time/tid组合，双方经济匹配 | px、sz、users、hash | 官方WS建议组合键，hash可零 |
| Fill | 一侧账户成交腿 | oid、tid、startPosition、dir、crossed、fee | 单腿不等于单边新增OI |
| Position | 账户×市场×时点 | szi为有符号基础量，entryPx、PnL、margin | 模式决定状态范围 |
| Funding | 账户×市场×结算轮次 | szi、小时小数率、usdc有符号金额 | 不是当前仓位乘过去费率 |
| Ledger | 非Funding账户账务事件 | delta类型、金额、from/to语义依类型 | 余额变动不等于外部净入金 |
| L2 Book | 市场×观察时间×买卖档 | px、sz、n | 聚合快照，不是逐单Delta |
| Token | 网络×Token ID/Index | weiDecimals、szDecimals | 不等于Pair或EVM合约 |
| DEX Market | 网络×完整coin | dex、asset、抵押、Oracle、风险 | 历史参数需版本 |
| Outcome | 网络×outcome×side | encoding、quoteToken、定义及结算比例 | 结果Token不是普通Perp |

账户字段：marginSummary.accountValue为风险账户价值；totalNtlPos为名义规模；totalMarginUsed为保证金使用；crossMaintenanceMarginUsed为维持需求；withdrawable为当前可转出字段。Position中szi负空正多，entryPx为入场会计，unrealizedPnl为估值，liquidationPx为随状态变化的估计，cumFunding分累计范围。Spot total与hold分别表示总量与占用，精确统一模式还需account abstraction。

Funding金额主要以适用报价/抵押单位解释，不因字段名usdc或usd无条件假定全部HIP-3均为USDC。API十进制字符串使用Decimal处理；整数单位另用Meta缩放。

节点路径来自[l1-data-schemas原文](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/nodes/l1-data-schemas.md)：replica_cmds、periodic_abci_states、node_trades、node_order_statuses、node_raw_book_diffs、misc_events。文档样例含注释及个别格式错误，不列为本篇真实JSON返回。

[实际API索引](../examples/api/README.md) · [案例索引](evidence_index.md) · [Dune字段卡](data_table_cards.md)。
