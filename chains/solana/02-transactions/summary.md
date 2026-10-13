# 02.99 从请求到结果

一笔交易现在可以拆成两侧：请求侧是签名和 Message，执行侧是错误、费用、日志和前后余额。签名授权请求，首个签名用于查询身份；付费者和其他签名者承担不同角色。账户清单描述执行需要的地址，不能直接当成用户列表。

Message 中的顶层指令按请求顺序组织。程序执行时还可能产生内部调用，它们不属于签名数组中的新交易。失败业务指令整体回滚，执行尝试与费用却仍可留下记录。于是统计费用、成功业务和失败率，需要各自明确筛选与分母。

版本决定消息的读取规则。v0 可以用 ALT 补充地址，解析清单必须与余额数组对齐；legacy 与 v1 不应照搬这个步骤。此次主网观察证实读取器需要支持 v1，但 Dune 对该版本的加工覆盖尚未实测。这一边界保存在来源索引里，避免将一种工具的能力错误推广给另一种工具。

交易表解决了“哪一笔、谁授权、结果怎样”。它仍不足以回答某个地址为什么在一次转账中充当收款人，或者路由程序怎样调用另一个程序。下一模块将从一笔交易进入多条指令，保留交易身份，同时逐步恢复执行关系。

![从请求到结果](./assets/request-result.svg)

[编辑原图（draw.io）](./assets/request-result.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana 交易结构](https://solana.com/docs/core/transactions/transaction-structure)
- [Dune 交易 Schema](https://docs.dune.com/data-catalog/solana/transactions)
- [交易版本与 ALT](https://solana.com/docs/core/transactions/versioned-transactions)
- [Solana 费用](https://solana.com/docs/core/fees)

<!-- NAV -->

[总目录](../README.md) · [上一章：版本与地址查找表](04-versions-alt.md) · [下一章：从做了什么到谁在执行](../03-instructions/index.md)
