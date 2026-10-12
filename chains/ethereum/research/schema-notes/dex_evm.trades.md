# dex_evm.trades

来源：Dune Catalog API（CLI）；读取日：2026-10-10。字段存在性与类型已确认，未据此证明数据行唯一性、覆盖率或实时新鲜度。

| 字段 | 类型 |
|---|---|
| `blockchain` | `varchar` |
| `project` | `varchar` |
| `version` | `varchar` |
| `block_month` | `date` |
| `block_date` | `date` |
| `block_time` | `timestamp(3) with time zone` |
| `block_number` | `bigint` |
| `token_bought_symbol` | `varchar` |
| `token_sold_symbol` | `varchar` |
| `token_pair` | `varchar` |
| `token_bought_amount` | `double` |
| `token_sold_amount` | `double` |
| `token_bought_amount_raw` | `uint256` |
| `token_sold_amount_raw` | `uint256` |
| `amount_usd` | `double` |
| `token_bought_address` | `varbinary` |
| `token_sold_address` | `varbinary` |
| `taker` | `varbinary` |
| `maker` | `varbinary` |
| `project_contract_address` | `varbinary` |
| `tx_hash` | `varbinary` |
| `tx_from` | `varbinary` |
| `tx_to` | `varbinary` |
| `evt_index` | `bigint` |
| `_updated_at` | `timestamp(3) with time zone` |
