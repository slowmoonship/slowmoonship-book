# 技术审查

36章逐章复核：UTXO与账户不同；Address/Wallet/Entity分开；普通输入金额回查prevout；Coinbase特殊输入与100块成熟期；OP_RETURN历史记录与UTXO排除；TxID/WTxID与Weight单位；Merkle根和见证承诺；PoW有效性、chainwork与确认非绝对最终性；块时间与首次广播分开。

Core31.0发布说明核对cluster mempool、64交易/101kB默认簇、feerate diagram替换与carveout移除，28/29全RBF变化按版本标注。31.1列为发布页补丁版，不宣称运行节点版本。提案119/118/347未作为当前Mainnet活跃功能。

Taproot创建承诺与花费路径公开范围分开；不据P2TR推断具体业务。附加协议保持原字节→规范→索引解释分层，Case10只证明6a5d标记候选，不证明资产余额。

8个不同主交易、3条后续花费边已做65项本地字节/整数/标识/引用核验。Case01跨浏览器核心字段一致；mempool.space另有sigops=8增强字段，未要求整个JSON完全相同。没有本地验签或PoW，API的确认状态是索引证据。

Case08的官方披露固定版本明确BTC hot wallet；链上验证地址对应prevout，现实标签仍是External Attribution。Case09为复杂176输入11输出，不认定CoinJoin。

比例模型使用Fraction守恒，费用单独终点；价值权重不当身份概率、模型份额不当协议逐聪映射。

结论：VALIDATED，适用范围内技术解释已核对；运行、完整资产索引和独立共识验证仍见unresolved.md。
