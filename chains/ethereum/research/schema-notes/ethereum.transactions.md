# ethereum.transactions

来源：Dune Catalog API（CLI）；读取日：2026-10-10。字段存在性与类型已确认，未据此证明数据行唯一性、覆盖率或实时新鲜度。

| 字段 | 类型 |
|---|---|
| `block_time` | `timestamp` |
| `block_number` | `bigint` |
| `value` | `decimal(38,0)` |
| `gas_limit` | `bigint` |
| `gas_price` | `bigint` |
| `gas_used` | `bigint` |
| `max_fee_per_gas` | `bigint` |
| `max_priority_fee_per_gas` | `bigint` |
| `priority_fee_per_gas` | `bigint` |
| `nonce` | `bigint` |
| `index` | `bigint` |
| `success` | `boolean` |
| `from` | `varbinary` |
| `to` | `varbinary` |
| `block_hash` | `varbinary` |
| `data` | `varbinary` |
| `hash` | `varbinary` |
| `type` | `varchar` |
| `access_list` | `array(row(address varbinary,storageKeys array(varbinary)))` |
| `block_date` | `date` |
| `blob_versioned_hashes` | `array(varbinary)` |
| `max_fee_per_blob_gas` | `bigint` |
| `authorization_list` | `array(row(chainId bigint,address varbinary,nonce bigint,r varchar,s varchar,yParity varchar))` |
