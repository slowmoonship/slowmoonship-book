# 版本与规则时间线

| 项目 | 依据 | 本书判断 |
|---|---|---|
| Coinbase成熟期 | Core v31.0 consensus.h | 100区块高度差；非立即可花费 |
| SegWit | BIP141/143/144、Mainnet参数 | 高度481824；本地取得该块样本 |
| Taproot | BIP340/341/342、部署参数、真实花费 | 2021激活范围；参数min_activation_height709632并非单独状态证明 |
| 2024减半 | 高度840000与补贴规则 | 3.125 BTC补贴，奖励另加费用 |
| Core28 | 发布说明 | full RBF默认启用，有限package relay |
| Core29 | 发布说明 | 删除mempoolfullrbf选项；ephemeral dust策略 |
| Core31 | 发布说明 | cluster mempool、默认64交易/101kB vsize簇；feerate diagram替换 |
| Core31.1 | 官方发布页 | 当前列出的补丁版；未运行节点 |
| CTV/APO/OP_CAT | BIP119/118/347与版本化解释 | 仅提案讨论，本书不作为Mainnet活跃规则 |

来源逐项见[source_catalog](source_catalog.md)。不从BIP文档状态推出激活，不把策略当共识。
