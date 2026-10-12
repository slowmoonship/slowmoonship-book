# DuneSQL 教学示例

12 条新增示例全部 STATIC_CHECKED；未启动 Dune 执行。保存真实 Hash 与 UTC 分区。静态审查不证明数据覆盖、执行成本或运行结果。

- [01-one-transaction](01-one-transaction.sql)
- [02-traces-and-logs](02-traces-and-logs.sql)
- [03-usdt-transfer](03-usdt-transfer.sql)
- [04-usdt-approval](04-usdt-approval.sql)
- [05-native-call-values](05-native-call-values.sql)
- [06-execution-fee](06-execution-fee.sql)
- [07-safe-join](07-safe-join.sql)
- [08-contract-creation](08-contract-creation.sql)
- [09-withdrawals](09-withdrawals.sql)
- [10-dex-segments](10-dex-segments.sql)
- [11-token-movements](11-token-movements.sql)
- [12-daily-addresses](12-daily-addresses.sql)

03 与 04 保留原始 Uint256，显示金额为近似值；05 仅覆盖保留的非根 CALL 原生 Value；06 仅计算已核对普通案例的执行费；09 的 Amount 单位为 Gwei。
