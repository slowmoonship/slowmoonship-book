# avalanche_c.logs

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：canonical；分区：['block_date']。

| 字段 | 类型 | 可空 |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| block_hash | varbinary | False |
| contract_address | varbinary | False |
| topic0 | varbinary | False |
| topic1 | varbinary | False |
| topic2 | varbinary | False |
| topic3 | varbinary | False |
| data | varbinary | False |
| tx_hash | varbinary | False |
| index | integer | False |
| tx_index | integer | False |
| block_date | date | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
