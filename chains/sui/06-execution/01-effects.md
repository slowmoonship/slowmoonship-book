# 06.1 | 成功、失败、对象输出与 Gas

Execution Status 是读结果的第一道入口。成功表明事务按照执行规则完成，不自动证明我们希望识别的全部业务动作。失败则需要读错误与费用；不能因为已经进入 Checkpoint，就改写为业务成功。

PTB 的 Commands 共享原子业务边界。中途失败时，先前 Commands 的业务修改不会作为独立成功效果保留。但费用处理及其关联状态仍可能发生变化。分析失败率应同时明确分母：已提交、已进入链上历史，还是应用观察到的全部请求。

![请求、Effects 与对象状态](./assets/result-evidence.svg)

[编辑原图](./assets/result-evidence.drawio)

Effects 的具体结构有版本。旧接口常展示 Created、Mutated、Deleted 等易读列表，当前实现也通过更统一的输入/输出状态表示变化。数据平台可能继续抽取历史标签。分析时应识别原始 Effects 版本与派生字段，不把某份旧返回格式当作永久协议结构。[Effects 实现](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/effects/mod.rs)

某个对象被写入新版本，不一定表示它的业务数值增加。Owner、余额、存储元数据等都可能相关；要证明具体字段改变，需要前后状态。某个输入未变化，也不能仅凭缺少对象输出内容就认定平台漏掉了修改。输入角色、状态标记与匹配规则应一起看。

Gas 摘要提供计算费、存储费和返还等结果。把失败记录全删掉，会低估用户成本；把 Gas Budget 当实际费用，会高估成本。不同支付模式又可能让费用体现在 Coin 或 Address Balance，赞助交易则改变承担者。

数据还原可以分两步。先固定事务并读取完整 Effects，列出状态与费用。再对需要解释的 Object ID，找本次输入状态和输出状态，保留 Version、Digest、Owner 与 Type。这样既不把所有变化等同于转账，也不遗漏没有 Event 的真实状态变化。

验证结论时，要区分“成功”“状态改变”“业务目标完成”。成功调用可能只是创建报价或授权对象；状态改变可能只是扣 Gas。只有读取参数、合约与输出语义，才能把这三层连成完整业务说明。

下一步：[Events 与业务证明](./02-events.md) · [模块入口](./index.md)
