# SQL 08｜LGNS池Mint与Burn事件

[SQL](08-lp-events.sql)

问题与口径：保留事件对象，不把同交易全部DAI移动归为加撤池。

一行代表：Mint或Burn事件。单位：原始整数；token0/token1顺序来自旧Query，需历史状态再核。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`quickswap_polygon.uniswapv2pair_evt_mint`, `quickswap_polygon.uniswapv2pair_evt_burn`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：DAI18/LGNS9已分别取得精度依据；Pair token0/1本轮无指定高度eth_call。
