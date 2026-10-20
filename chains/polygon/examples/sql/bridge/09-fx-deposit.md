# SQL 09｜Ethereum侧Fxdeposit候选

[SQL](09-fx-deposit.sql)

问题与口径：只读根侧事件，不能推定全部PoS桥覆盖或双侧配对。

一行代表：Ethereum侧特定FxTunnel事件。单位：rootToken原始整数，未缩放。

表结构依据：[本轮Schema](../../../research/polygon_schema/SCHEMA.md)。使用表：`polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20`。

验证：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT；本轮未执行，不以旧Query成功冒充本文件结果。

限制与后续：需根Token精度和具体Tunnel源码；缺少子链消息及完成证明，不把候选命名为完整闭环案例。
