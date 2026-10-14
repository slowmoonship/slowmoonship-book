# tokens.transfers

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：spell；分区：['block_month', 'blockchain']。

| 字段 | 类型 | 可空 |
|---|---|---|
| unique_key | varchar | True |
| blockchain | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp(3) with time zone | True |
| block_number | bigint | True |
| tx_hash | varbinary | True |
| evt_index | bigint | True |
| trace_address | array(bigint) | True |
| token_standard | varchar | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| tx_index | bigint | True |
| from | varbinary | True |
| to | varbinary | True |
| contract_address | varbinary | True |
| symbol | varchar | True |
| amount_raw | uint256 | True |
| amount | double | True |
| price_usd | double | True |
| amount_usd | double | True |
| _updated_at | timestamp(3) with time zone | True |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
