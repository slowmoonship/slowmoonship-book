# Bitcoin Dune Schema

2026-10-13；已用API验证：MCP searchTables，四张canonical表。字段快照不证明全历史覆盖或新鲜度。

## bitcoin.transactions

分区：block_date。

| 字段 | 类型 | Nullable |
|---|---|---|
| `block_time` | `timestamp` | True |
| `block_date` | `date` | True |
| `block_height` | `bigint` | True |
| `index` | `integer` | True |
| `block_hash` | `varbinary` | True |
| `id` | `varbinary` | True |
| `lock_time` | `bigint` | True |
| `size` | `bigint` | True |
| `virtual_size` | `bigint` | True |
| `coinbase` | `varbinary` | True |
| `is_coinbase` | `boolean` | True |
| `version` | `bigint` | True |
| `input_count` | `integer` | True |
| `output_count` | `integer` | True |
| `input_value` | `double` | True |
| `output_value` | `double` | True |
| `fee` | `double` | True |
| `hex` | `varbinary` | True |
| `input` | `array(row(value double, coinbase varbinary, height bigint, tx_id varbinary, output_number bigint, script_pub_key row(address varchar, asm varchar, desc varchar, hex varbinary, type varchar), script_signature row(asm varchar, hex varbinary), sequence bigint, witness_data array(varbinary)))` | True |
| `output` | `array(row(index bigint, script_pub_key row(address varchar, asm varchar, desc varchar, hex varbinary, type varchar), value double))` | True |

## bitcoin.blocks

分区：date。

| 字段 | 类型 | Nullable |
|---|---|---|
| `time` | `timestamp` | True |
| `height` | `bigint` | True |
| `date` | `date` | True |
| `hash` | `varbinary` | True |
| `bits` | `varbinary` | True |
| `chainwork` | `varbinary` | True |
| `difficulty` | `double` | True |
| `total_fees` | `double` | True |
| `total_reward` | `double` | True |
| `mint_reward` | `double` | True |
| `merkle_root` | `varbinary` | True |
| `transaction_count` | `bigint` | True |
| `nonce` | `bigint` | True |
| `coinbase` | `varbinary` | True |
| `previous_block_hash` | `varbinary` | True |
| `size` | `bigint` | True |
| `stripped_size` | `bigint` | True |
| `version` | `bigint` | True |
| `weight` | `bigint` | True |

## bitcoin.outputs

分区：block_date。

| 字段 | 类型 | Nullable |
|---|---|---|
| `block_time` | `timestamp` | True |
| `block_date` | `date` | True |
| `block_height` | `bigint` | True |
| `block_hash` | `varbinary` | True |
| `tx_id` | `varbinary` | True |
| `index` | `bigint` | True |
| `value` | `double` | True |
| `address` | `varchar` | True |
| `type` | `varchar` | True |
| `script_asm` | `varchar` | True |
| `script_hex` | `varbinary` | True |

## bitcoin.inputs

分区：block_date。

| 字段 | 类型 | Nullable |
|---|---|---|
| `block_time` | `timestamp` | True |
| `block_date` | `date` | True |
| `block_height` | `bigint` | True |
| `block_hash` | `varbinary` | True |
| `tx_id` | `varbinary` | True |
| `index` | `integer` | True |
| `spent_block_height` | `bigint` | True |
| `spent_tx_id` | `varbinary` | True |
| `spent_output_number` | `bigint` | True |
| `value` | `double` | True |
| `address` | `varchar` | True |
| `type` | `varchar` | True |
| `coinbase` | `varbinary` | True |
| `is_coinbase` | `boolean` | True |
| `script_asm` | `varchar` | True |
| `script_hex` | `varbinary` | True |
| `script_desc` | `varchar` | True |
| `script_signature_asm` | `varchar` | True |
| `script_signature_hex` | `varbinary` | True |
| `sequence` | `bigint` | True |
| `witness_data` | `array(varbinary)` | True |

## 语义与风险

blocks是一行一个区块；transactions是一行一笔确认交易记录；inputs/outputs是一行一个列表元素。transactions.id→inputs/outputs.tx_id。inputs.spent_tx_id+spent_output_number→旧outputs.tx_id+index。早期重复TxID特殊项须保留区块定位。

平铺value和交易金额为DOUBLE，官方主Schema定义BTC；raw/API金额用整数聪。transactions文档的嵌套说明出现Satoshi与BTC冲突，嵌套单位API未验证，不自行猜测。

本轮Catalog没有交易级weight列（blocks有）；inputs.script_hex是旧输出锁定脚本，script_signature_hex是当前输入scriptSig。blocks.coinbase是特殊输入数据，不能当Coinbase TxID。数组位置从1，输出index从0。

Catalog blockchains数组含空字符串，已按bitcoin schema与官方文档确认范围，没有由该字段单独证明网络。

来源：[实时Catalog快照](dune/catalog.json)；[官方四表目录](https://docs.dune.com/data-catalog/bitcoin/overview)。后续动作：恢复执行权限后先在固定TxID/块上核对单位、粒度与覆盖。
