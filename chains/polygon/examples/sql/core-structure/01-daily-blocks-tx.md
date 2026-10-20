# SQL 01｜区块与交易分别聚合

[SQL](01-daily-blocks-tx.sql)

问题与口径：保留空区块；不把区块连接到交易后再数区块。

一行代表：UTC日。单位：区块数、交易数。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.blocks`, `polygon.transactions`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：实际唯一键、覆盖与服务端解析需恢复权限后运行。
