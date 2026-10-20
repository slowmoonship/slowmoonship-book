# SQL 05｜从Raw日志读取LGNS转账

[SQL](05-raw-transfer.sql)

问题与口径：按源码9位精度解释，保留整数。

一行代表：Transfer事件。单位：LGNS原始整数/1e9。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：不是Rebase代币通用余额重建；事件签名与ABI已核对，当前余额另取状态。
