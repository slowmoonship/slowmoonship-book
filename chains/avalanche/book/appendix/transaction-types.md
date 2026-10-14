# 平台与资产交易类型

| 类型 | 对象与时期 | 主要含义 / 审查要点 |
|---|---|---|
| CreateSubnetTx | Subnet 身份，传统和现代启动路径 | 建立网络组织与 Owner 条件，不自动启动链。 |
| CreateChainTx | Blockchain | 所属网络、VM、Genesis；不证明 RPC 或应用运行。 |
| AddValidatorTx / AddDelegatorTx | 历史 Primary 质押路径 | 固定期限模型，按对应时期规范解释。 |
| AddSubnetValidatorTx / RemoveSubnetValidatorTx | 传统 Subnet | 与现代 L1 Register/Weight 操作分开。 |
| TransformSubnetTx | Banff-era 转换 | 传统许可型到相应无许可型机制；不是 ACP-77 转换的别名。 |
| AddPermissionlessValidatorTx / AddPermissionlessDelegatorTx | Primary 及适用历史无许可型网络 | 对象与资产/周期条件由状态与版本确定。 |
| RewardValidatorTx | 适用固定期限验证 / 委托结算 | 由协议处理，不能当成用户普通 EVM 支付。 |
| ConvertSubnetToL1Tx | Etna / ACP-77 现代 L1 | 设定管理位置与初始集合，保留 Subnet ID。 |
| RegisterL1ValidatorTx | 已转换 L1 | 管理认证消息、BLS 持有证明、费用余额；Validation ID 不等于 Node ID。 |
| SetL1ValidatorWeightTx | 已转换 L1 | nonce 防重放；零权重移除有特别条件。 |
| DisableL1ValidatorTx | 现代注册费用状态 | 停用与余额处理，不等于从总权重永久移除。 |
| IncreaseL1ValidatorBalanceTx | 现代注册费用状态 | AVAX 充值，可恢复活跃条件，不自动增加投票权重。 |
| AddAutoRenewedValidatorTx | Helicon / Primary | 自动续期验证注册，按周期解释。 |
| SetAutoRenewedValidatorConfigTx | Helicon / Primary | 配置周期与复利；period 0 在当前周期结束后不续期。 |
| RewardAutoRenewedValidatorTx | Helicon / Primary | 协议周期结算，不代表新的独立注册。 |
| BaseTx / CreateAssetTx | X AvalancheVM | 输入、输出与资产规则；不得解析为普通 EVM 请求。 |
| ExportTx / ImportTx | 各 VM 的适用原子转移 | 类型结构因链而异；每侧 ID 与费用分开。 |

本表是语义索引，不替代二进制规范。依据：[P 交易格式](https://build.avax.network/docs/rpcs/p-chain/txn-format.md)、[X 交易格式](https://build.avax.network/docs/rpcs/x-chain/txn-format.md)、[C 原子格式](https://build.avax.network/docs/rpcs/c-chain/txn-format.md)、[Helicon](https://build.avax.network/docs/primary-network/helicon-upgrade.md)。本轮不执行这些写操作。

[上一章](data-source-index.md) · [本篇目录](../../SUMMARY.md) · [下一章](references.md)
