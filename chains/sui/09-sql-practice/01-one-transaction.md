# 09.1 | 单笔事务、对象与费用

案例 A 的完整 Transaction Digest 为 `VYZrgeBbYxFaEnm792GKxZB1N5Y4UFiCCetwyic5p6f`。它位于 Mainnet Checkpoint 2000007，历史时间为 2023-05-08 16:58:42.497 UTC，执行状态 SUCCESS。它用于解释稳定的 PTB 与对象结果结构，不用来证明 2026 年网络排序内部实现。

PTB 先从 GasCoin 拆出资金，再把返回的新 Coin 转给接收地址。两个 Pure Inputs 分别提供金额与地址，第二条 Command 使用第一条结果。官方接口完整事件页为空，PTB 中也没有 MoveCall；这是一笔正常成功的原生命令转移。

![单笔事务的分支查询](./assets/sql-route.svg)

[编辑原图](./assets/sql-route.drawio)

接收者增加 14,787,162,276 MIST，即 14.787162276 SUI。发送者减少 14,789,150,156 MIST，差额为 1,987,880 MIST。Effects 的计算费 990,000，加存储费 1,976,000，再减返还 978,120，正好得到这项净费用。

输出 Coin 的 ID 为 `0xba0c7617a47e9a2c2e38491ac47342789d0da007e393bf90771b81a4c29b0d21`，Version 为 2046262。对应历史对象内容显示相同余额与 Coin<SUI> 类型；Effects 表明它被创建并属于接收地址。这比只看一个转移名称更完整。

在 Dune 中，可以先定位事务：

```sql
SELECT transaction_digest, checkpoint, execution_success,
       total_gas_cost, transaction_json, effects_json
FROM sui.transactions
WHERE date = DATE '2023-05-08'
  AND transaction_digest = 'VYZrgeBbYxFaEnm792GKxZB1N5Y4UFiCCetwyic5p6f';
```

这段 SQL 静态核对了当前 Schema，未在 Dune 执行。2023 年案例是否在当前 Dune 历史覆盖中，也需要运行后核查。完整主干连接见 [01 SQL](./sql/01-transaction-checkpoint.sql)，对象关系查找见 [02 SQL](./sql/02-object-relationships.sql)。

读取对象时先保留关系行，再按 ID 与 Version 查状态。02 SQL 明确限制状态日期窗口，可能漏掉更早的未变化输入，因此用 LEFT JOIN 标出未匹配，而不声称全部对象历史已经还原。需要完整输入时，应根据版本证据进一步定位。

这个案例能验证一个清楚的边界：成功转移不必有 MoveCall 或 Event，钱包支出也不等于收款金额。完整请求、Effects、对象输出与费用一起构成可复核解释。[官方查询方法](https://docs.sui.io/develop/accessing-data/graphql/query-with-graphql)

下一步：[多路由 Swap](./02-swap.md) · [案例证据](../references/verified-transactions.md)
