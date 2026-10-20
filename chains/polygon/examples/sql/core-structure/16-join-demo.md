# SQL 16｜三乘四Join陷阱与修正

[SQL](16-join-demo.sql)

问题与口径：VALUES明确为合成数据；预期12组合与1交易。

一行代表：合成演示一个交易。单位：行数。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：不是主网案例。未服务端运行；简单预期来自组合数学。
