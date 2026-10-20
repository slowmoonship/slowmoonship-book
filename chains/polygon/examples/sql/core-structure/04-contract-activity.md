# SQL 04｜入口调用活跃度

[SQL](04-contract-activity.sql)

问题与口径：有calldata的入口活动候选；不单靠输入长度证明对方必为合约。

一行代表：顶层入口地址。单位：交易数、地址数。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.transactions`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：EOA可带数据，代理和账户抽象影响身份；若要严格合约集合需历史code证据。
