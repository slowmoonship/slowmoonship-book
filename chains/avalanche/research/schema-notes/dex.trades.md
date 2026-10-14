# dex.trades

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：spell；分区：['blockchain', 'project', 'block_month']。

| 字段 | 类型 | 可空 |
|---|---|---|
| blockchain | varchar | True |
| project | varchar | True |
| version | varchar | True |
| block_month | date | True |
| block_date | date | True |
| block_time | timestamp | True |
| block_number | bigint | True |
| token_bought_symbol | varchar | True |
| token_sold_symbol | varchar | True |
| token_pair | varchar | True |
| token_bought_amount | double | True |
| token_sold_amount | double | True |
| token_bought_amount_raw | uint256 | True |
| token_sold_amount_raw | uint256 | True |
| amount_usd | double | True |
| token_bought_address | varbinary | True |
| token_sold_address | varbinary | True |
| taker | varbinary | True |
| maker | varbinary | True |
| project_contract_address | varbinary | True |
| tx_hash | varbinary | True |
| tx_from | varbinary | True |
| tx_to | varbinary | True |
| evt_index | bigint | True |
| _updated_at | timestamp | True |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
