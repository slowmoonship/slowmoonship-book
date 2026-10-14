# avalanche_c.logs_decoded

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：canonical；分区：['contract_name', 'namespace']。

| 字段 | 类型 | 可空 |
|---|---|---|
| block_date | date | False |
| block_time | timestamp | False |
| block_number | bigint | False |
| namespace | varchar | False |
| contract_name | varchar | False |
| contract_address | varbinary | False |
| tx_hash | varbinary | False |
| tx_from | varbinary | False |
| tx_to | varbinary | False |
| tx_index | integer | False |
| index | integer | False |
| signature | varbinary | False |
| event_name | varchar | False |
| decoded_json | varchar | False |
| created_at | timestamp | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
