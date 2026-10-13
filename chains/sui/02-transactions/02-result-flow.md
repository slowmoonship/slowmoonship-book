# 02.2 | Inputs、Commands 与 Result Flow

PTB 的 Inputs 提供可被 Commands 使用的值。Object Input 指向链上对象；Pure Input 表达地址、整数等普通值。当前实现还包含专用的资金提取输入，Object Input 内部也有 Owned/Immutable、Shared 和 Receiving 等形式。入门时用“对象与普通值”建立模型，遇到余额提取和父子对象再细化。[Inputs and Results](https://docs.sui.io/develop/transactions/ptbs/inputs-and-results)

Commands 描述操作。核心类别包括 MoveCall、TransferObjects、SplitCoins、MergeCoins、Publish、MakeMoveVec 和 Upgrade。它们不都是 Move 函数调用，也不都产生业务 Event。一个转移事务可以没有 MoveCall，复杂事务也可能包含多条不涉及 MoveCall 的命令。

![从输入到最终输出的 PTB 数据流](./assets/ptb-flow.svg)

[编辑原图](./assets/ptb-flow.drawio)

Argument 用索引指向已有值。`Input(i)` 指向第 i 个输入；`GasCoin` 是特殊费用参数；`NestedResult(i,j)` 指向第 i 条 Command 的第 j 个结果；`Result(i)` 只适用于该 Command 恰好返回一个结果的情况。索引描述内部依赖，不能当作全网交易序号。

Alice 的教学转移可以这样阅读：Command 0 对 GasCoin 执行 SplitCoins，金额来自一个 Pure Input；生成的新 Coin 位于 `NestedResult(0,0)`；Command 1 用 TransferObjects 消费这个结果，将它交给由另一个 Pure Input 指定的 Bob。新 Coin 在同一 PTB 内流动，没有两次独立提交。

有些值被借用，有些被按值消费。`&T` 表示不可变借用，`&mut T` 表示可变借用，`T` 的处理依类型能力决定复制或移动。对于不可复制的对象，按值移动以后不能继续从原位置使用。理解这些约束有助于解释为什么看似合理的参数组合会执行失败。

中间结果不等于永久对象。某个返回值可能只是数值、向量或必须在当前 PTB 内处理的凭证；某个中间 Coin 也可能随后被合并或消费。对象变化表记录最终链上状态，通常不能显示每一个 Command 中间时刻。要还原结果流，需要完整 PTB，而不能只连接输出对象表。

MoveCall 表的 `cmd_idx` 可以帮助定位记录的 Command，但 Catalog 存在该列并不足以证明所有内部函数调用都被列出。将调用行与 PTB 结构比对以后，再决定它能代表哪个操作层次。

下一步：[模块总结](./summary.md) · [模块入口](./index.md)
