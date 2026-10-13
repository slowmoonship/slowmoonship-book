# 04.01 Account 与程序 Owner

如果账户保存了一串 data，分析师怎样知道它代表代币余额还是池状态？先读基础账户的 owner，找到负责解释这份数据的程序，再检查该程序定义的布局。

Solana 的地址是 32 字节值，通常显示为 Base58 字符串。字符串本身不告诉你它是不是钱包、程序或 PDA。基础账户的 lamports 是原生 SOL 余额，data 是字节状态，owner 是程序地址，executable 表示可执行属性；rent_epoch 是兼容保留的旧字段，不应据此制造现代账户按期扣租的故事。

Owner 约束数据由哪个程序修改。只有相应 Owner 程序能按运行时规则改账户 data 或扣减它的 lamports；给其他可写账户增加 lamports 则有不同规则。具体元数据修改和特殊运行时账户还有约束，所以“只要知道地址就能更新账户”并不成立。交易列为 writable 也不会覆盖 Owner 检查，它只提供这次执行允许写入的边界。

程序账户本身同样有 Owner。对通过 loader 部署的程序，基础 Owner 是相应 loader，并不是程序 ID 自己。程序逻辑使用的业务数据账户可以由该程序拥有。代码与状态因此形成两个关系：loader 管理程序部署结构，业务程序解释其状态账户。可升级程序还可能有另外的程序数据账户与升级权限，不能只检查 executable 就声称永远不可升级。

账户清单和读写标记还让运行时检查访问冲突。两笔交易都需要写同一个账户时，就要受账户锁与调度规则约束，不能同时任意修改同一余额。一笔交易中的顶层指令仍按 Message 顺序执行。因此，writable 不只是展示标签，它还参与运行时对访问关系的判断。

以 Token Account 为例，它的基础 Owner 是 Token Program，data 内部还保存 mint、amount 和业务 owner。前者让运行时知道由哪个程序维护数据；后者告诉 Token Program 谁能授权代币操作。钱包可以是业务 owner，但并没有因此成为这份基础账户 data 的任意写入者。

Dune 的 `account_activity` 主要提供使用与余额字段，没有把所有账户的完整 data 或基础 owner 历史都放在每一行里。`token_balance_owner` 属于代币余额授权视角，不能当作基础 Owner。要研究任意账户结构，可用 `getAccountInfo` 读取当前状态，但必须声明这是读取时状态，不能直接套回一年前的交易。

因此，解释一个陌生地址的顺序是：确定网络和观察时点，读取基础账户信息，核对 owner 程序，按其接口解读 data，再寻找相应历史事件或分析表。这比仅按地址标签猜测角色多几步，却能避免把程序、用户与资产余额混为一谈。下一章继续解释谁能在业务上授权这些状态变化。

![Account 与程序 Owner](./assets/account-fields.svg)

[编辑原图（draw.io）](./assets/account-fields.drawio)

参考来源（核验日期：2026-10-09）：

- [Transaction Pipeline](https://solana.com/docs/core/transactions/transaction-pipeline)

- [Solana Accounts](https://solana.com/docs/core/accounts)
- [Account Structure](https://solana.com/docs/core/accounts/account-structure)
- [Solana Programs](https://solana.com/docs/core/programs)
- [Dune 账户活动表](https://docs.dune.com/data-catalog/solana/account-activity)
- [Token 账户结构](https://solana.com/docs/tokens)

<!-- NAV -->

[总目录](../README.md) · [上一章：地址后面存着什么](index.md) · [下一章：Authority 与 PDA](02-authority-pda.md)
