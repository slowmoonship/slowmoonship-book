# SQL 15｜sLGNS比率与Index分开缩放

[SQL](15-rebase.sql)

问题与口径：比率18位，index9位；事件未直接发出实际增发量。

一行代表：LogRebase事件。单位：无量纲比率；sLGNS Index。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon.logs`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：不把比率当Token数量；没有生成完整收益率或历史余额。
