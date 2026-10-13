# SUI 02 小结｜事务是有授权的数据流请求

理解一笔事务需要同时看外层与内层。外层提供 Sender、Kind、Gas Data 和有效期，签名表达授权。内层 PTB 提供 Inputs 和 Commands，Arguments 将输入与前序结果串成数据流。

同一笔 PTB 可以完成多个动作，也可以访问不同所有权形式的对象。Commands 顺序执行，业务效果共同提交；某条命令失败，不会留下前半段独立成功的业务状态。失败仍可能收费并形成历史记录。

因此，统计 Transaction、Command、MoveCall 和最终对象输出，是四种不同问题。某次转移没有 MoveCall，不代表没有执行；某个 PTB 有很多调用，不代表有同样多笔事务。中间 Result 也不必成为永久对象。

读一份陌生 PTB，可以先画出外部输入，再按 Command 索引标注参数来自 Input、GasCoin 还是 NestedResult，最后识别哪些值被消费、转移或保留。只凭调用名称和结果对象数，很难还原这条数据流。

接下来需要回答：输入对象有哪些访问限制，为什么有些状态版本要由网络协调，以及哪些事务能并行执行。Ownership 与执行条件将补齐 Transaction 请求进入 Runtime 的关键一段。

[继续：SUI 03 Ownership / Execution](../03-ownership/index.md) · [返回全书目录](../README.md)
