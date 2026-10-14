# avalanche_teleporter_avalanche_c.teleportermessenger_call_receivecrosschainmessage

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：decoded；分区：以字段及模型为准。

| 字段 | 类型 | 可空 |
|---|---|---|
| contract_address | varbinary | False |
| call_success | boolean | False |
| call_tx_hash | varbinary | False |
| call_tx_from | varbinary | True |
| call_tx_to | varbinary | True |
| call_tx_index | integer | False |
| call_trace_address | array(bigint) | False |
| call_block_time | timestamp | False |
| call_block_number | bigint | False |
| call_block_date | date | False |
| messageIndex | bigint | False |
| relayerRewardAddress | varbinary | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
