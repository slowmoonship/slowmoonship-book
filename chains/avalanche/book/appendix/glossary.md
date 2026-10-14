# 术语表

| 中文 / English | 本篇含义与边界 |
|---|---|
| Avalanche Network | 多条异构区块链组成的网络；不能用 C-Chain 替代全部网络。 |
| 主网 / Mainnet | 本篇案例网络，Network ID 为 1。 |
| Fuji | Avalanche 测试网，Network ID 为 5；与主网资产和证据分开。 |
| Primary Network | 承载 C/P/X 的特殊 L1，共同验证集合不合并三链状态。 |
| 区块链 / Blockchain | 独立链历史与状态，归属于一个 L1。 |
| Avalanche L1 | 自定成员与经济规则的网络组织，可以验证多条链。 |
| Subnet | 历史术语与持久平台身份；是否已转换需查真实状态。 |
| Virtual Machine / VM | 定义链的状态与合法转换，不限于 EVM。 |
| AvalancheGo | 组织链实例、网络、共识与 VM 等组件的节点软件。 |
| C-Chain | Contract Chain，EVM 执行链，原生币 AVAX。 |
| P-Chain | Platform Chain，PlatformVM 平台对象与资金记录。 |
| X-Chain | Exchange Chain，AvalancheVM 资产与 UTXO。 |
| Coreth | Helicon 前 C-Chain 历史执行引擎及相关实现背景。 |
| Continuous Execution | C-Chain 的共识接受与持续执行解耦，执行结果随后承诺。 |
| Accepted / Executed / Settled | 接受、执行、后续记录结果承诺，三种阶段分开。 |
| Consensus | 形成接受决定的协议职责，不定义全部应用语义。 |
| Snowman | 线性链接受机制，基于重复抽样等思想。 |
| Snowman++ / ProposerVM | 提议者组织相关机制，不是 EVM 或成员管理合约。 |
| Finality | 协议安全条件下的接受稳定性，不是应用或服务永不失败。 |
| Transaction | 交易请求与具体类型；P/X 不按普通 EVM 格式强制解析。 |
| Receipt | EVM 执行结果；与消息协议回执不同。 |
| Logs | 合约显式发出的保留事件，不覆盖全部状态变化。 |
| Traces | 服务重建的调用过程，不是新的用户签名交易。 |
| ABI | 字节接口描述，需匹配历史版本与实现。 |
| ERC-20 / ERC-721 / ERC-1155 | 不同资产接口；数量、Token ID 与批量条目分开。 |
| UTXO | 未花费输出，带资产、数量与控制条件。 |
| Change Output | 找零解释需依据输入输出与控制条件。 |
| Asset ID | AVM 资产身份，不凭 symbol 与 EVM 合约资产混同。 |
| Avalanche Native Token | AVM 的资产机制概念；不是所有 EVM ERC-20 的统称。 |
| Atomic UTXO | 供目标链导入消费的跨链输出对象。 |
| Export / Import | 原子转移两侧操作，分别有交易身份与费用。 |
| Shared Memory | 节点链间原子状态交换机制，不是中心资产托管合约。 |
| Validator Set | 某位置的验证集合与权重，不等于运营者集合。 |
| Node ID | 网络节点身份，不自动确定物理服务器或现实主体。 |
| Validation ID | L1 验证注册身份，不总是提交交易哈希。 |
| Validator Weight | 共识与认证相关权重，经济换算依 L1 规则。 |
| Validator Manager | 管理位置与程序，不会启动服务器。 |
| PoA / PoS | 权限或抵押等成员机制，具体实现与网络配置决定。 |
| BLS Public Key | 验证签名所用公钥；持有证明与消息签名需分别识别。 |
| Continuous Fee | P-Chain 活跃 L1 注册的持续费用，不是用户链内 Gas。 |
| Genesis | 初始状态与配置；不能替代今天的全部参数。 |
| Native Token / Gas Token | 基础资产与执行费资产，依链具体机制解释。 |
| AWM / Warp | 跨链消息认证原语；不是自动资产转移。 |
| ICM | 官方消息术语有宽窄语境，本篇按功能层区分。 |
| TeleporterMessenger | 具体消息合约协议，按地址与版本识别。 |
| TeleporterRegistry | 协议版本入口关联，不能省略历史版本。 |
| Relayer | 收集与搬运消息、提交目标交易；不决定伪消息成为真。 |
| ICTT | 消息之上的代币转移应用，需要额外资产规则。 |
| Raw / Decoded / Curated | 原始、解码与加工观察层，可能描述同一业务。 |
| Network ID / Blockchain ID / EVM Chain ID | 环境、具体 Avalanche 链、EVM 签名环境的不同身份。 |

[返回目录](../../SUMMARY.md) · [官方来源](../../research/source_catalog.md)

[上一章](../part-10/40-observability.md) · [本篇目录](../../SUMMARY.md) · [下一章](chain-identifiers.md)
