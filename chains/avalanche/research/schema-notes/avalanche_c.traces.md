# avalanche_c.traces

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：canonical；分区：['block_date']。

| 字段 | 类型 | 可空 |
|---|---|---|
| block_time | timestamp | False |
| block_number | bigint | False |
| value | uint256 | False |
| gas | bigint | False |
| gas_used | bigint | False |
| block_hash | varbinary | False |
| success | boolean | False |
| tx_index | integer | False |
| sub_traces | bigint | False |
| error | varchar | False |
| tx_success | boolean | False |
| tx_hash | varbinary | False |
| from | varbinary | False |
| to | varbinary | False |
| trace_address | array(bigint) | False |
| type | varchar | False |
| address | varbinary | False |
| code | varbinary | False |
| call_type | varchar | False |
| input | varbinary | False |
| output | varbinary | False |
| refund_address | varbinary | False |
| block_date | date | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
