# 03.99 画出一次调用的骨架

交易提交顶层指令，指令指定程序并携带账户参数与数据，程序在权限范围内执行，还可能通过 CPI 调用其他程序。所有内部调用保留原交易身份。这个关系让钱包的一次签名请求，与运行时的许多执行动作连在一起。

Dune 的 instruction_calls 展开调用行。数行得到调用量，去重 tx_id 得到涉及的交易量；筛 executing_account 得到程序执行视角，仍需指令解码才能辨认具体业务。outer 索引保留顶层归属，inner 索引提供局部顺序，stack height 帮助恢复嵌套关系。顶层归属不是直接 parent 指针，日志也不是通用成交事件。

解码把字节与参数位置转成有含义的字段，同时应保留原调用身份。NULL-safe inner 索引关联，是连接顶层记录的一个实际细节。已有看板与 QA 查询支持这条研究路线，但历史执行状态不替本书的新 SQL 提供当日验证。

你已经可以在一笔交易中指出执行者、动作和调用归属。还没有解决的是权限与状态：为什么某程序能写这个账户，却不能写那个账户？为什么一个没有普通签名的地址也能授权？账户模块会把这些问题连回 Solana 真正保存的数据。

![画出一次调用的骨架](./assets/action-program.svg)

[编辑原图（draw.io）](./assets/action-program.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana Programs](https://solana.com/docs/core/programs)
- [Solana Instructions](https://solana.com/docs/core/instructions)
- [Solana CPI](https://solana.com/docs/core/cpi)
- [Dune 指令调用表](https://docs.dune.com/data-catalog/solana/instruction-calls)

<!-- NAV -->

[总目录](../README.md) · [上一章：从字节到可读动作](04-decoding.md) · [下一章：地址后面存着什么](../04-accounts/index.md)
