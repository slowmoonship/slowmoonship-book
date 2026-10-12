# ethereum.traces

来源：Dune Catalog API（CLI）；读取日：2026-10-10。字段存在性与类型已确认，未据此证明数据行唯一性、覆盖率或实时新鲜度。

| 字段 | 类型 |
|---|---|
| `block_time` | `timestamp` |
| `block_number` | `bigint` |
| `value` | `uint256` |
| `gas` | `bigint` |
| `gas_used` | `bigint` |
| `block_hash` | `varbinary` |
| `success` | `boolean` |
| `tx_index` | `integer` |
| `sub_traces` | `bigint` |
| `error` | `varchar` |
| `tx_success` | `boolean` |
| `tx_hash` | `varbinary` |
| `from` | `varbinary` |
| `to` | `varbinary` |
| `trace_address` | `array(bigint)` |
| `type` | `varchar` |
| `address` | `varbinary` |
| `code` | `varbinary` |
| `call_type` | `varchar` |
| `input` | `varbinary` |
| `output` | `varbinary` |
| `refund_address` | `varbinary` |
| `block_date` | `date` |
