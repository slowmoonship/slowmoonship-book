# 02.01 签名与 Message

同一笔交易为何要同时保存签名、账户清单和指令？因为它们回答的是三类问题：谁授权，执行需要哪些对象，要做什么动作。任何一个部分都不能替代另两个。

签名可以理解为对一份精确请求的授权凭据。Message 内容发生变化，原来的签名就不能当作修改后请求的授权。Solana 常用首个签名标识整笔交易；它是交易查询的 signature，不是地址，也不是区块哈希。多个签名者对应多个签名，但仍共同授权同一笔请求。

以 legacy 与 v0 的公共结构为例，Message 包含头部（Header）、账户地址、recent blockhash 和编译指令。Header 中的计数帮助运行时区分需要签名的账户与只读账户。账户清单把公共地址集中起来，指令则通过位置索引引用它们。这样同一地址被多条指令使用时，不必在每条指令里重复写完整公钥。

recent blockhash 提供普通交易的有效性与重放保护信息。它不是本笔交易的最终所在区块哈希，也不是可以拿来直接测量用户点击时间的钟表。另有 durable nonce 机制解决不同的有效性需求；本篇不展开其开发流程，读到此类交易时应按官方规则识别，不能强行套普通近期 blockhash 的过期判断。

一条编译指令指定程序、账户参数和数据。参数清单有顺序，程序会按其接口解释这些位置。仅知道“交易引用了地址 A”无法证明 A 在某个转账动作里是收款人；必须继续定位具体指令及参数含义。Dune 已解析出的 `executing_account` 与 `account_arguments` 让分析更便利，但仍需程序接口支持业务角色判断。

下面先观察三种清单的长度，并保留交易身份。它刻意不展开数组，避免一笔交易被多次复制。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT id, version,
       cardinality(signers) AS signer_count,
       cardinality(account_keys) AS account_count,
       cardinality(instructions) AS outer_instruction_count
FROM solana.transactions
WHERE block_date = DATE '2026-10-07'
  AND block_time >= TIMESTAMP '2026-10-07 00:00:00'
  AND block_time <  TIMESTAMP '2026-10-07 00:01:00'
ORDER BY block_slot, "index"
LIMIT 10
```

这里 `instructions` 的长度观察顶层请求，不等于执行中所有 CPI 的数量。签名数量、账户数量和动作数量各自有独立意义。下一章会把“谁授权”进一步拆成付费者与其他权限角色。

![签名与 Message](./assets/request-result.svg)

[编辑原图（draw.io）](./assets/request-result.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana 交易结构](https://solana.com/docs/core/transactions/transaction-structure)
- [Dune 交易 Schema](https://docs.dune.com/data-catalog/solana/transactions)

<!-- NAV -->

[总目录](../README.md) · [上一章：一笔交易是一份完整请求](index.md) · [下一章：谁签名，谁付费](02-signers-fees.md)
