# case-02-usdt｜USDT Transfer

| 项目 | 观测内容 |
|---|---|
| 网络 | Ethereum Mainnet，Chain ID 1 |
| Hash | `0x458584a9b39f8bcfc215cc5990f1776ed5cc485dc56ffb02927032ca79a537ca` |
| Block Number | 26151122 |
| Block Time | 2026-10-08T23:59:59Z |
| 合约与目标 | 0xdac17f958d2ee523a2206206994597c13d831ec7 |
| 来源 | Blockscout MCP get_transaction_info；chain_id=1 |
| 状态 | VALIDATED_INPUT_AND_TRANSFER |

[浏览器交易](https://etherscan.io/tx/0x458584a9b39f8bcfc215cc5990f1776ed5cc485dc56ffb02927032ca79a537ca) · [相关作者 Query](https://dune.com/queries/8378490)

Value 0；Raw Amount 431900785；Decimals 6；Amount 431.900785；Log Index 734；Gas Used 63209；Gas Price 122624522 Wei。原输入与解码参数完整，转移列表未溢出；本轮没有另取独立原 Logs 或 State Diff。见 case-02-usdt.json。

[新教学 SQL](../sql/03-usdt-transfer.sql)：STATIC_CHECKED，未执行。
