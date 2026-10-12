# gas.fees

来源：Dune Catalog API（CLI）；读取日：2026-10-10。字段存在性与类型已确认，未据此证明数据行唯一性、覆盖率或实时新鲜度。

| 字段 | 类型 |
|---|---|
| `blockchain` | `varchar` |
| `block_month` | `date` |
| `block_date` | `date` |
| `block_time` | `timestamp(3) with time zone` |
| `block_number` | `bigint` |
| `tx_hash` | `varbinary` |
| `tx_index` | `bigint` |
| `tx_from` | `varbinary` |
| `tx_to` | `varbinary` |
| `gas_price` | `uint256` |
| `gas_used` | `bigint` |
| `currency_symbol` | `varchar` |
| `tx_fee` | `double` |
| `tx_fee_usd` | `double` |
| `tx_fee_raw` | `uint256` |
| `tx_fee_breakdown` | `map(varchar,double)` |
| `tx_fee_breakdown_usd` | `map(varchar,double)` |
| `tx_fee_breakdown_raw` | `map(varchar,uint256)` |
| `tx_fee_currency` | `varbinary` |
| `block_proposer` | `varbinary` |
| `gas_limit` | `uint256` |
| `gas_limit_usage` | `double` |
