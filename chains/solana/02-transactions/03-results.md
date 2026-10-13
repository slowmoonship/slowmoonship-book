# 02.03 失败后还留下什么

交易失败了，为什么 Dune 里仍有它的记录，付费者还少了一点 SOL？因为业务状态是否提交，与执行尝试是否发生、费用是否扣取，是不同的问题。

一笔已进入账本的失败交易可能通过了前面的验证并开始执行，随后某条指令报错。普通业务指令的状态变化整体回滚：不能认为第一条转账成功、第二条换币失败后就只保留第一条。原子性使应用能把多个动作作为一个整体提交。费用仍按协议规则收取，不应被业务回滚的描述抹去；nonce 等特殊机制的维护状态还应按其专门规则读取。

RPC 的 `meta.err` 描述执行错误，Dune 用 `success` 与 `error` 暴露相应结果。失败交易的指令和日志仍然有研究价值，它们帮助定位尝试执行到哪里。但日志中出现“转账”或内部调用，不足以证明业务资金最终移动。统计实际资产流时，应先检查最终状态和前后余额，而不是只数调用文本。

另一方面，根本没有被接受进账本的请求，不一定能在交易表里找到。无效签名、过期有效性信息、客户端发送失败等情况可能止于不同阶段。因此表中的失败率是“被索引的交易记录中的失败占比”，不是所有用户点击发送的失败概率。分母缺少那些未落链的尝试，二者不能混用。

分析目标决定是否保留失败交易。研究费用消耗要把收取费用的失败记录纳入；研究成交量通常只统计成功业务；研究协议易用性可以单列失败，但还需要链外请求数据才能评价完整用户体验。最危险的处理是先不说明，直接在所有 SQL 里固定 `success=true`，之后忘记分母发生了变化。

下面按结果分组，分别观察记录数量与费用。它不为失败原因作业务归因，也不把有日志的指令当作成功事件。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT success,
       COUNT(*) AS transaction_rows,
       SUM(fee) AS fee_lamports
FROM solana.transactions
WHERE block_date = DATE '2026-10-07'
  AND block_time >= TIMESTAMP '2026-10-07 00:00:00'
  AND block_time <  TIMESTAMP '2026-10-07 00:01:00'
GROUP BY success
```

如果两组都有记录，结果表达的只是该窗口内被观察到的交易和费用。完成结果判断后，还要确认读取器是否完整处理了各个交易版本，否则连“没有记录”都可能只是兼容性问题。

![失败后还留下什么](./assets/request-result.svg)

[编辑原图（draw.io）](./assets/request-result.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana 交易原子性](https://solana.com/docs/core/transactions)
- [Dune 交易 Schema](https://docs.dune.com/data-catalog/solana/transactions)
- [Solana 费用](https://solana.com/docs/core/fees)
- [Durable Nonces](https://solana.com/docs/core/transactions/durable-nonces)

<!-- NAV -->

[总目录](../README.md) · [上一章：谁签名，谁付费](02-signers-fees.md) · [下一章：版本与地址查找表](04-versions-alt.md)
