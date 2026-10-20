# SQL 18｜复算旧结果的AMM情景

[SQL](18-exit-scenario.sql)

问题与口径：VALUES来自2026-08-18 09:28:58UTC旧结果，非实时取数。

一行代表：旧Query8390372固定截止的一种假设仓位。单位：LGNS、DAI、无量纲费率。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：仅复算公式；没有保证未来成交，未重建全部历史费率、储备或真实用户收益。
