# 数据源索引

| 对象 | 主要入口 | 返回形态 | 观察边界 |
|---|---|---|---|
| C-Chain EVM | C JSON-RPC、Data API、Dune avalanche_c | 请求、收据、日志、轨迹或 SQL 行 | Helicon 后结果与计费需匹配版本；公开 RPC 可能不支持追踪。 |
| P 平台交易 | platform.getTx、Data API Primary transactions | 类型专属 JSON / 编码 | 平台记录不证明节点在线；全历史需独立取得。 |
| P 网络关系 | platform.getBlockchains、Data API subnet | Blockchain / Subnet / VM / Manager | 快照与历史创建不同。 |
| P 注册状态 | platform.getL1Validator、getCurrentValidators、Data API L1 validators | Node / Validation / Weight / Balance | 分页、单位与高度需保留。 |
| X 资产 | avm.getTx、getUTXOs、getAssetDescription、Data API | 输入、输出、资产、集合 | 余额不是单笔输出之和；所有权可为多签。 |
| 原子转移 | C atomic RPC、Primary Data API、P/X Import | 两侧交易与输出消费 | 在途和窗口边界，避免两侧双算。 |
| 独立 L1 | 相应公开 RPC 与专属索引 | 由 VM 决定 | 不能假定全部公开、全部 EVM 或全部被 Dune 收录。 |
| 消息 | 发送/接收/执行事件、认证材料 | 协议与地址专属 | 源事件不能证明目标完成；签名聚合通常链外。 |
| 作者网络目录 | Dune 社区上传与既有 Dashboard | 快照与加工 | 不是穷尽官方注册历史；刷新与覆盖单独说明。 |

[实际请求/响应](../../examples/rpc/README.md) · [字段卡](../../research/schema-notes/avalanche_c.transactions.md) · [案例](../../examples/transactions/README.md)

[上一章](chain-identifiers.md) · [本篇目录](../../SUMMARY.md) · [下一章](transaction-types.md)
