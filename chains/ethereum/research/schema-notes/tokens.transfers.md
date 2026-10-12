# tokens.transfers

来源：Dune Catalog API（CLI）；读取日：2026-10-10。字段存在性与类型已确认，未据此证明数据行唯一性、覆盖率或实时新鲜度。

| 字段 | 类型 |
|---|---|
| `unique_key` | `varchar` |
| `blockchain` | `varchar` |
| `block_month` | `date` |
| `block_date` | `date` |
| `block_time` | `timestamp(3) with time zone` |
| `block_number` | `bigint` |
| `tx_hash` | `varbinary` |
| `evt_index` | `bigint` |
| `trace_address` | `array(bigint)` |
| `token_standard` | `varchar` |
| `tx_from` | `varbinary` |
| `tx_to` | `varbinary` |
| `tx_index` | `bigint` |
| `from` | `varbinary` |
| `to` | `varbinary` |
| `contract_address` | `varbinary` |
| `symbol` | `varchar` |
| `amount_raw` | `uint256` |
| `amount` | `double` |
| `price_usd` | `double` |
| `amount_usd` | `double` |
| `_updated_at` | `timestamp(3) with time zone` |
