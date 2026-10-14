# avalanche_teleporter_avalanche_c.teleportermessenger_evt_receivecrosschainmessage

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：decoded；分区：以字段及模型为准。

| 字段 | 类型 | 可空 |
|---|---|---|
| contract_address | varbinary | False |
| evt_tx_hash | varbinary | False |
| evt_tx_from | varbinary | True |
| evt_tx_to | varbinary | True |
| evt_tx_index | integer | False |
| evt_index | bigint | False |
| evt_block_time | timestamp | False |
| evt_block_number | bigint | False |
| evt_block_date | date | False |
| deliverer | varbinary | False |
| message | varchar | False |
| messageID | varbinary | False |
| rewardRedeemer | varbinary | False |
| sourceBlockchainID | varbinary | False |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
