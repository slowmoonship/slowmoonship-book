# SQL 12｜标准Upgraded事件候选

[SQL](12-upgrade-events.sql)

问题与口径：EIP-1967事件观察，不证明全部代理覆盖。

一行代表：标准事件签名匹配日志。单位：地址/事件。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：任意合约可发同名事件；需源码、槽位、实际调用确认。keccak为DuneSQL函数，未执行验证。
