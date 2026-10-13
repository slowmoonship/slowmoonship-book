# 技术来源与版本边界

核验日期：2026-10-10。以下为实际读取的官方资料；内容写作以协议事实、接口结构、平台 Schema 与本书分析推导分层。官方源码 main 分支不等于主网全部功能已启用，当前网络可用性需要接口与 ProtocolConfig 另证。

| 主题 | 实际来源 | 核验要点 |
|---|---|---|
| 交易生命周期 | [Life of a Transaction](https://docs.sui.io/develop/transactions/transaction-lifecycle) | 当前共同网络排序、执行与 Effects 结果确认、Checkpoint inclusion |
| 对象模型 | [Object Model](https://docs.sui.io/develop/sui-architecture/object-model) | 身份、元数据、Package、对象与事务依赖 |
| Ownership | [Ownership](https://docs.sui.io/develop/objects/object-ownership)、[Address-Owned](https://docs.sui.io/develop/objects/object-ownership/address-owned)、[Shared](https://docs.sui.io/develop/objects/object-ownership/shared)、[Immutable](https://docs.sui.io/develop/objects/object-ownership/immutable)、[Party](https://docs.sui.io/develop/objects/object-ownership/party)、[Wrapped](https://docs.sui.io/develop/objects/object-ownership/wrapped) | 权限、版本与可见性分开 |
| 对象版本 | [Versioning](https://docs.sui.io/develop/objects/versioning) | 严格递增、Lamport、引用与初始共享版本 |
| PTB | [PTB](https://docs.sui.io/develop/transactions/ptbs/)、[Commands / semantics](https://docs.sui.io/develop/transactions/ptbs/prog-txn-blocks)、[Inputs and Results](https://docs.sui.io/develop/transactions/ptbs/inputs-and-results) | 原子业务边界、结果引用与 GasCoin |
| 请求实现 | [transaction.rs](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/transaction.rs) | TransactionDataV1、GasData、CallArg、Expiration；有本地源码缓存 |
| 结果实现 | [Effects](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/effects/mod.rs)、[Gas](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/gas.rs) | 原始 Effects 与派生对象变化、净费用公式；有本地缓存 |
| 共识 | [Consensus](https://docs.sui.io/develop/sui-architecture/consensus) | 网络排序与无冲突并行执行的分层 |
| Move | [Writing Move](https://docs.sui.io/develop/write-move/)、[Packages](https://docs.sui.io/develop/publish-upgrade-packages/)、[Upgrading](https://docs.sui.io/develop/publish-upgrade-packages/upgrade)、[Package Versioning](https://docs.sui.io/develop/publish-upgrade-packages/versioning) | 调用、类型来源与 Package 谱系 |
| 动态字段 | [Dynamic Fields](https://docs.sui.io/develop/objects/dynamic-fields) | 普通字段包装与动态对象字段可见性 |
| 资产 | [Coin](https://docs.sui.io/onchain-finance/fungible-tokens/coin)、[Fungible Tokens](https://docs.sui.io/onchain-finance/fungible-tokens)、[Address Balances](https://docs.sui.io/onchain-finance/asset-custody/address-balances)、[Using Address Balances](https://docs.sui.io/onchain-finance/asset-custody/address-balances/using-address-balances)、[Payment](https://docs.sui.io/develop/transaction-payment/) | Coin、累加器、元数据与费用支付的不同表示 |
| Events | [Emitting Events](https://docs.sui.io/develop/accessing-data/using-events) | 显式业务记录，不等于全部状态变化 |
| 历史 | [Checkpoint Verification](https://docs.sui.io/develop/sui-architecture/checkpoint-verification)、[Epoch](https://docs.sui.io/develop/sui-architecture/epochs) | 认证历史与周期背景 |
| 当前数据接口 | [GraphQL](https://docs.sui.io/develop/accessing-data/graphql/graphql-rpc)、[Querying GraphQL](https://docs.sui.io/develop/accessing-data/graphql/query-with-graphql)、[Providers](https://docs.sui.io/develop/accessing-data/rpc-providers) | 官方公开端点、接口 Schema 与历史访问；不使用已停用的 Foundation Mainnet JSON-RPC |
| Dune | [Sui Catalog](https://docs.dune.com/data-catalog/sui/overview)、[Freshness](https://docs.dune.com/data-catalog/data-freshness) | 以实际 Catalog API 核实字段，更新策略说明不代替本次六表的新鲜度查询 |
| 进阶业务 | [Asset Custody](https://docs.sui.io/onchain-finance/asset-custody)、[Kiosk](https://docs.sui.io/onchain-finance/kiosk) | 对象归属、容器与业务规则的边界 |
| 本地恢复 | [Codex CLI Reference](https://learn.chatgpt.com/docs/cli/reference) | 本机另实际执行 codex --help / exec --help，不猜参数 |

## 来源冲突与处理

对象 Ownership / Versioning 文档仍使用 Fastpath 术语，当前交易生命周期明确说明所有交易经过共识排序。本书将事务网络排序与对象精确引用、锁定及共识版本机制分开；不写 Owned 交易绕过共同网络排序。图形也按此分层。

事务概览的部分概括与源码不同：例如 Gas Budget 的单位和有效期变体。正文以当前结构与 Gas 实现限定，不照搬预算乘价格的粗略描述。源码 Expiration 还包含 Validity；不是每个分支新功能都凭 main 源码宣称已在主网启用。

Dune Overview 的概括措辞不能用作协议定义。六表关系以 API 字段为事实，记录粒度和候选键为分析模型；唯一性、值域、历史范围、累加器覆盖仍需数据验证。无法验证的字段不编造含义。

## 本地证据

- [Dune Schema 快照](../_project/cache/dune-catalog-2026-10-10.json)
- [交易实现官方来源](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/transaction.rs)、[Effects 官方来源](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/effects/mod.rs)、[Gas 官方来源](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/gas.rs)。本地完整源码缓存留在原工程，公开副本保留来源与快照 SHA256，见 [来源记录](../../../publication/sui/2026-10-13-v0.1/source-provenance.json)；main 链接可能随上游更新
- [真实案例](./verified-transactions.md)：请求、响应、时间、接口版本、完整标识和本地交叉检查。

源码及网页核验日期用于重现本轮判断。后续升级时先检查来源差异，不将本书快照冒充永远最新。
