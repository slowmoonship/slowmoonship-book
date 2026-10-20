# SQL 02｜按交易类型观察费用

[SQL](02-gas-by-type.sql)

问题与口径：普通交易费用近似与协议类型分开；gas_price语义需同回执核对。

一行代表：交易类型。单位：Gas；POL近似值。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.transactions`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：系统类型不按钱包交易解释；DOUBLE趋势计算不是整数精确账本，未计算费用最终分配。
