# 关键事实核对台账

核验日：2026-10-10。协议规范与通俗官方页面不完全一致时，以相应主网上线规范的适用条款限定正文。

| 事实 | 主要来源 | 书稿处理 |
|---|---|---|
| 账户四字段及状态承诺 | [Accounts](https://ethereum.org/developers/docs/accounts/)、[MPT](https://ethereum.org/developers/docs/data-structures-and-encoding/patricia-merkle-trie/) | 代码字节/存储内容与承诺字段区分；现代委托单列 |
| EOA 持久委托 | [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) Behavior/Persistence | 不是交易结束自动清除；已处理委托不因后续业务失败回滚 |
| Pectra 上线 | [Pectra](https://ethereum.org/roadmap/pectra/) | 2025-05-07 主网；不沿用传统非空代码分类 |
| Fusaka/PeerDAS | [Fusaka](https://ethereum.org/roadmap/fusaka/)、[EIP-7594](https://eips.ethereum.org/EIPS/eip-7594) | 2025-12-03 已上线，Blob 参数不硬编码为旧常量 |
| Glamsterdam 时间 | [协议公告](https://blog.ethereum.org/category/protocol) | 最新页面仍为测试网公告，不能用旧目标日期证明主网已上线 |
| Call/Delegatecall/Staticcall | [Geth Tracers](https://geth.ethereum.org/docs/developers/evm-tracing/built-in-tracers)、[Solidity](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html) | 代码来源、状态上下文、实际原生转移分开 |
| Event 字节布局 | [ABI](https://docs.soliditylang.org/en/latest/abi-spec.html) | 非匿名 Topic0、动态 indexed 摘要、匿名事件例外 |
| ERC-20 与 NFT Transfer | [ERC-20](https://eips.ethereum.org/EIPS/eip-20)、[ERC-721](https://eips.ethereum.org/EIPS/eip-721) | 相同签名不同标准 indexed 布局；数量与 ID 分开 |
| ERC-1155 批量 | [ERC-1155](https://eips.ethereum.org/EIPS/eip-1155) | 数组位置配对；事件行与展开条目不同 |
| Gas 与费用 | [1559](https://eips.ethereum.org/EIPS/eip-1559)、[7623](https://eips.ethereum.org/EIPS/eip-7623)、[4844](https://eips.ethereum.org/EIPS/eip-4844) | 有效单价、使用量、上限及独立 Blob 费分开 |
| 提款操作与单位 | [4895](https://eips.ethereum.org/EIPS/eip-4895)、[Dune Withdrawals](https://docs.dune.com/data-catalog/evm/ethereum/raw/withdrawals) | Gwei；不是用户普通交易；不补 tx_hash |
| 创建与自毁历史 | [1014](https://eips.ethereum.org/EIPS/eip-1014)、[6780](https://eips.ethereum.org/EIPS/eip-6780) | Initcode/Runtime 区分，现代自毁不能普遍删代码 |
| 核心字段 | 本地 [Catalog 快照](schema-notes/target-schemas.json) | 六核心表与四加工/兼容表实查；不据此证明唯一性 |
| 提款 Amount 类型差异 | 文档 uint256；2026-10-10 Catalog bigint | SQL 按实时 Catalog，正文统一 Gwei 语义 |
| DEX Namespace 类型差异 | Catalog dex.trades / dex_evm.trades | 教学采用后者；不 Union 重复源；时间类型不同 |
| WETH Deposit 加工 | [WETH9](https://github.com/gnosis/canonical-weth/blob/master/contracts/WETH9.sol)、案例原 Logs | 原 Deposit 不改称原始 Transfer；浏览器铸造分类单列 |

案例观察采用实际返回数据；交易哈希、原日志、调用树与静态 SQL 状态分别保留。未使用当前 Token 报价替代历史成交估值。
