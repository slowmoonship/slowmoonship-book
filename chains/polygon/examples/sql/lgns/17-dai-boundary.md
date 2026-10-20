# SQL 17｜六合约DAI边界与内部流量

[SQL](17-dai-boundary.sql)

问题与口径：事件级边界；内部互转另列。

一行代表：指定日、指定集合。单位：DAI18位。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`maker_polygon.dai_evt_transfer`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：六地址沿用旧研究模型，其中Turbine当前角色尚未独立核实；外部流入不是利润或新增用户投资。
