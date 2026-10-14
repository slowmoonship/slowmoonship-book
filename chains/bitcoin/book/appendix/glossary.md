# 术语表

| English | 中文 | 本篇含义 |
|---|---|---|
| UTXO | 未花费交易输出 | 当前确认视图下尚未消费的适用输出 |
| Outpoint | 输出点 | 前序TxID与vout |
| Input | 输入 | 消费旧输出的引用与授权材料 |
| Output | 输出 | 金额与花费条件 |
| Wallet | 钱包 | 密钥、脚本识别、构造与观察软件 |
| Address | 地址 | 常见收款条件编码，不是自然人 |
| Private Key | 私钥 | 签名能力来源，不装着BTC |
| Public Key | 公钥 | 参与授权验证 |
| Signature | 签名 | 授权适用的消息摘要 |
| ScriptPubKey | 锁定脚本 | 输出的花费条件 |
| ScriptSig | 脚本签名 | 输入提供的适用花费数据 |
| Witness | 见证 | 按输入组织的证明材料 |
| TxID | 交易标识 | 基础序列化哈希 |
| WTxID | 见证交易标识 | 包含见证的序列化哈希 |
| Change | 找零 | 钱包用途；链上通常没有通用标记 |
| Fee | 手续费 | 普通输入总额减输出总额 |
| Weight | 交易重量 | 基础大小乘三加完整大小 |
| Virtual Size | 虚拟大小 | Weight除四向上取整 |
| sat/vB | 聪每虚拟字节 | 资源单价 |
| Coinbase | 区块首笔特殊交易 | 输入不引用普通旧输出 |
| Subsidy | 补贴 | 按高度的新发行上限 |
| Maturity | 成熟期 | Coinbase花费的高度差限制 |
| Mempool | 本地未确认交易池 | 非全球统一数据库 |
| RBF | 替换费率 | 冲突交易按政策替换 |
| CPFP | 子付父费 | 子交易提高组合激励 |
| Dust | 粉尘策略 | 按脚本和政策费率评估 |
| Chainwork | 累计工作量 | 有效竞争链比较 |
| Reorg | 链重组 | 节点切换有效历史 |
| MTP | 中位过去时间 | 适用时间规则参照 |
| CLTV | 绝对时间条件 | 脚本检查锁定位置 |
| CSV | 相对时间条件 | 脚本检查相对等待 |
| Descriptor | 输出描述符 | 表达与识别脚本 |
| Miniscript | 结构化脚本表达 | 不是全局合约状态 |
| Taproot | Taproot花费结构 | 密钥或脚本路径 |
| Tapscript | Taproot适用脚本规则 | 按揭示路径验证 |
| CDD | 币天销毁 | 金额乘年龄，非BTC供应销毁 |
| CoinJoin | 协作交易 | 共同输入不证明共同所有者 |
| PayJoin | 付款协作 | 收款方可提供输入 |
| Heuristic | 启发式 | 有限经验规则 |
| External Attribution | 外部归因 | 机构披露或第三方标签 |
| Proportional Allocation | 比例分配 | 价值混合假设下的模型 |
| Ordinal | 聪排序约定 | 非原生永久token_id |
| Inscription | 铭文 | 数据envelope与索引解释 |
| BRC-20 | JSON铭文资产规范 | 依赖版本化索引状态 |
| Rune | Runes资产 | 与BTC value不同单位 |
| Runestone | Runes消息 | 标记候选不证明状态有效 |
| Cenotaph | 无效Runes消息结果 | 附加资产销毁规则，不是BTC自动销毁 |
| Lightning | 闪电网络 | 通道链外状态与主网结算 |
| HTLC | 哈希时间锁条件 | 适用路由支付安排 |
| Wrapped BTC | 包装BTC | 其他账本资产与储备/桥接规则 |

[目录](../../SUMMARY.md)

[上一章](../part-09/36-practical-evidence.md) · [下一章](data-table-index.md)
