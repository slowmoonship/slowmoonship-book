# 数据表索引

| 表 | 粒度 | 键与用途 |
|---|---|---|
| bitcoin.blocks | 区块 | height/hash；time/date分区 |
| bitcoin.transactions | 交易记录 | id与区块定位；嵌套列表 |
| bitcoin.inputs | 输入 | tx_id/index；spent_tx_id+spent_output_number |
| bitcoin.outputs | 创建输出 | tx_id/index；不是当前UTXO表 |

[完整实时Schema](../../research/bitcoin_schema.md) · [作者原Query](../../research/dune_query_catalog.md) · [目录](../../SUMMARY.md)

[上一章](glossary.md) · [下一章](script-types.md)
