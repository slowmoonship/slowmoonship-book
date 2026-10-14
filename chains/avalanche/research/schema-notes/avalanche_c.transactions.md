# avalanche_c.transactions

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：canonical；分区：['block_date']。

| 字段 | 类型 | 可空 |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| value | decimal(38,0) | False |
| gas_limit | bigint | False |
| gas_price | bigint | False |
| gas_used | bigint | False |
| max_fee_per_gas | bigint | False |
| max_priority_fee_per_gas | bigint | False |
| priority_fee_per_gas | bigint | False |
| nonce | bigint | False |
| index | bigint | False |
| success | boolean | False |
| from | varbinary | False |
| to | varbinary | False |
| block_hash | varbinary | False |
| data | varbinary | False |
| hash | varbinary | False |
| type | varchar | False |
| access_list | array(row(address varbinary,storageKeys array(varbinary))) | False |
| block_date | date | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
