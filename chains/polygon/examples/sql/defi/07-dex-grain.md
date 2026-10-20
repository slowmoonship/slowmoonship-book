# SQL 07｜DEX成交段与交易数

[SQL](07-dex-grain.sql)

问题与口径：池级成交量与交易数分别报告。

一行代表：项目。单位：段数、交易数、USD。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`dex.trades`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：多跳价值可能重复出现；不是净收入或独立用户Swap总量。
