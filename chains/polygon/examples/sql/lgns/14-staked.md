# SQL 14｜已明确Staked事件

[SQL](14-staked.sql)

问题与口径：事件indexed地址是recipient，不默认是顶层付款者。

一行代表：Staked事件。单位：LGNS9位。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：不提供Unstake或净质押，Warmup与claim另核；继承旧Query定位，源码布局已读。
