# SQL 03｜同一交易的Trace与Log计数

[SQL](03-transaction-grain.sql)

问题与口径：先聚合子表，避免多对多。

一行代表：目标交易。单位：计数与原始Gas参数。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.transactions`, `polygon.traces`, `polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：原始样本可定位；新查询未执行，Trace覆盖仍需核对。
