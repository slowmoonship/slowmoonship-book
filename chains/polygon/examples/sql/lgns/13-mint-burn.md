# SQL 13｜LGNS可见Mint与Burn

[SQL](13-mint-burn.sql)

问题与口径：普通LGNS铸销事件，不能用于sLGNS Rebase会计。

一行代表：UTC日。单位：LGNS，9位精度。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：仅一天可见变化，非完整totalSupply；不等于外部DAI流入。
