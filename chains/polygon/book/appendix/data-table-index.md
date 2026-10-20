# 数据表索引

[完整实时字段快照](../../research/polygon_schema/SCHEMA.md)。以下仅列本篇核心，不代表Catalog全部返回项都已运行验证。

| 表 | 一行代表/用途 | 关键注意 |
|---|---|---|
| `polygon.blocks` | Bor区块头 | date分区；miner不能当生产者 |
| `polygon.transactions` | 交易记录 | 包含系统类型；block_date |
| `polygon.traces` | 执行帧 | tx_hash+trace_address候选键 |
| `polygon.logs` | Raw事件 | tx_hash+index；topic按ABI |
| `polygon.creation_traces` | 创建记录 | 实际block_month；无type/success |
| `tokens.transfers` | 可替代资产移动 | amount已标准化，缺价单列 |
| `dex.trades` | 池级成交段 | 多跳可能多段 |
| `gas.fees` | 费用模型行 | 分量与收益分别解释 |
| `prices.hour` | 资产小时价格 | 链+合约+时点与价格源 |
| `tokens.erc20` | 代币元数据 | 不是历史状态证明 |
| `tokens.supply_latest` | 最新供应快照 | 不能冒充历史供应 |
| `quickswap_polygon.uniswapv2pair_evt_sync` | Pair储备事件 | token0/1与各自精度 |
| `maker_polygon.dai_evt_transfer` | DAI事件 | 固定Polygon DAI合约 |
| `polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20` | Ethereum侧Fx存款事件 | 特定桥覆盖，非全部存款 |

本轮polygon canonical返回9表；未把候选polygon.withdrawals当作已经确认存在且适用的桥提款表。NFT和Balances候选的Catalog结果单独保留，不用表名推定完整时间覆盖。


[目录](../../SUMMARY.md) · [上一章](bridge-reference.md) · [下一章](glossary.md)
