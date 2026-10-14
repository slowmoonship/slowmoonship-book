# avalanche_c.blocks

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：canonical；分区：['date']。

| 字段 | 类型 | 可空 |
|---|---|---|
| time | timestamp | False |
| number | bigint | False |
| gas_limit | decimal(38,0) | False |
| gas_used | decimal(38,0) | False |
| difficulty | bigint | False |
| total_difficulty | decimal(38,0) | False |
| size | bigint | False |
| base_fee_per_gas | bigint | False |
| hash | varbinary | False |
| parent_hash | varbinary | False |
| miner | varbinary | False |
| nonce | varbinary | False |
| date | date | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
