# SQL 11｜工厂创建候选

[SQL](11-creation.sql)

问题与口径：Schema未暴露type/success，不臆造列。

一行代表：物化创建记录。单位：地址、字节码。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.creation_traces`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：Catalog partition声明与字段冲突；使用实际存在block_month；CREATE2及成功路径另读traces。
