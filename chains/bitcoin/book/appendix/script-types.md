# 常见脚本类型

| 类型 | 创建时公开 | 花费时重点 | 地址与备注 |
|---|---|---|---|
| P2PK | 公钥 | 签名 | 不必有单一常规地址 |
| P2PKH | 公钥哈希 | 公钥与签名 | Base58Check |
| P2SH | 赎回脚本哈希 | 揭示脚本与所需数据 | Base58Check；可嵌套SegWit |
| P2WPKH | v0 20字节程序 | Witness签名、公钥 | Bech32 |
| P2WSH | v0 32字节程序 | Witness Script与数据 | Bech32 |
| P2TR | v1 32字节程序 | key/script路径 | Bech32m |
| Bare Multisig | 公钥和门槛 | 达门槛的签名 | 未必单一普通地址 |
| OP_RETURN | 不可花费数据 | 不作为普通花费 | 历史有输出，通常排除UTXO集合 |

平台类型名不同需映射；常见列表不是全部可能脚本。P2PKH/P2SH地址前缀不能证明身份。

[目录](../../SUMMARY.md)

[上一章](data-table-index.md) · [下一章](query-index.md)
