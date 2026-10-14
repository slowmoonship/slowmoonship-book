# tokens.supply_latest

检索：2026-10-12；来源：Dune MCP searchTables，已用 API 验证字段目录。新 SQL 未执行；最新区块与连续覆盖未验证。

数据层：spell；分区：['blockchain']。

| 字段 | 类型 | 可空 |
|---|---|---|
| blockchain | varchar | True |
| token_address | varbinary | True |
| symbol | varchar | True |
| decimals | integer | True |
| supply_raw | uint256 | True |
| supply | double | True |
| _updated_at | timestamp(3) with time zone | True |

字段业务口径以官方文档和模型为准；目录未说明的含义标为待验证。Raw 记录、Decoded 参数与 Curated 加工不能相加为独立活动。
