# SQL 06｜固定DAI合约的转账与价格覆盖

[SQL](06-stablecoin-transfers.sql)

问题与口径：amount已标准化，不再除1e18；缺价单列。

一行代表：UTC日。单位：DAI；已有价格覆盖的USD。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`tokens.transfers`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：不等于独立支付量或新增资金；价格富化规则见官方Transfers说明。
