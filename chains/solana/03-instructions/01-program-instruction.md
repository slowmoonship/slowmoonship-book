# 03.01 Program 与 Instruction

看到 Program ID，只能知道执行者，不能立即知道本次动作。相同 Token Program 既能转账，也能发行、销毁或改变授权；程序调用次数不是某一种业务动作的次数。

Program 是实现逻辑的链上程序。Solana 程序本身也由账户体系承载，但业务数据通常放在另外的账户中。指令是传给程序的一次具体要求，包含目标程序、按顺序排列的账户参数，以及程序解释的数据。这类似调用接口时提供方法与参数，但链上还需要满足签名、可写权限和账户 Owner 的运行规则。

指令中的数据未必以 JSON 保存。程序按照自己的格式读取字节，识别操作和数值；没有接口定义时，一串 data 不能自动读成转账金额。账户参数同样依靠程序接口确定含义：第一项在某个程序里可能是付费者，在另一个程序里可能是状态账户。不能仅按位置套用全链通用角色。

Dune 的 `executing_account` 指向当前这一行调用的程序地址，`account_arguments` 保存这一条指令用到的账户。两者不同于交易的 `account_keys`：后者是全交易有效账户集合，前者是局部动作参数。知道某地址被交易引用，不等于知道它在哪个动作中被写入；要把交易、指令和账户三层结合起来。

程序地址也不是钱包。若研究应用触达，可从 Program ID 筛选相关调用，再按 `tx_id` 统计涉及的交易。若研究真实转账，需要继续区分指令类型和结果。一个协议可能使用多个程序版本，聚合器还会调用其他协议，程序级筛选本身就包含范围选择。

下面统计 System Program 在短窗口中的调用行，并区分顶层与内层。System Program 地址由官方接口定义；这个筛选不会仅保留 transfer，还可能包括创建账户等其他操作。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT is_inner,
       COUNT(*) AS instruction_calls,
       COUNT(DISTINCT tx_id) AS distinct_transactions
FROM solana.instruction_calls
WHERE block_time >= TIMESTAMP '2026-10-07 00:00:00'
  AND block_time <  TIMESTAMP '2026-10-07 00:01:00'
  AND executing_account = '11111111111111111111111111111111'
GROUP BY is_inner
```

结果的第一列计动作，第二列计涉及的交易。如果一笔交易在同组调用多次，它只给去重交易数贡献一次。下一章解释为什么内层动作仍然属于同一笔交易。

![Program 与 Instruction](./assets/action-program.svg)

[编辑原图（draw.io）](./assets/action-program.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana Programs](https://solana.com/docs/core/programs)
- [Solana Instructions](https://solana.com/docs/core/instructions)
- [Dune 指令调用表](https://docs.dune.com/data-catalog/solana/instruction-calls)

<!-- NAV -->

[总目录](../README.md) · [上一章：从做了什么到谁在执行](index.md) · [下一章：CPI 是调用，不是新交易](02-cpi.md)
