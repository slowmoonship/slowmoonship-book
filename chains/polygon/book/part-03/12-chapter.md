# 第12章｜Checkpoint把什么带到Ethereum

Polygon已经有Milestone，为什么还要把检查点提交到Ethereum？因为本地确认与根链合约能够使用的证明，是两个问题。Ethereum合约不能凭一个钱包页面的绿色状态放款，需要读取它所认可的链上承诺，再验证用户提交的退出证明。Checkpoint正是在这个连接位置发挥作用。

检查点覆盖一段Bor区块范围，并以根哈希等字段表达对相关历史的承诺。Heimdall协调提议与验证，检查点提交者再向Ethereum合约发送交易。研究者应分别记录范围起止、根哈希、提议者、Ethereum交易和确认状态。把“创建了检查点”与“根链已经接受”混为一谈，会漏掉中间失败或延迟。

提交可能因为Ethereum手续费、交易失败或网络条件而受阻，所以协议还有提交后的确认与后续协调。一个检查点流程至少可以观察到提议、Heimdall处理、Ethereum提交、根链接受和相应确认。它们不是同一条记录上的五个别名，也不保证发生在同一秒钟。

Merkle承诺的直觉是把大量内容压成一个可以验证成员关系的摘要。退出证明需要把目标事件或回执连接到相应承诺。承诺能够支持特定验证，不能自动替代被承诺数据的完整可用性，也不能让Ethereum像验证Rollup那样承担Polygon全部执行安全。系统仍有自身验证者、桥合约和管理机制的假设。

标准PoS桥从Polygon往Ethereum退出时，常需要先在子链发起销毁，再等相关区块被检查点覆盖，最后把证明提交到Ethereum，触发释放。检查点覆盖只是其中一个条件。已经覆盖的销毁事件，也可能尚未被用户完成退出；查询“提款笔数”时应先说明统计发起、具备证明条件还是已完成释放。

质押奖励与检查点还有经济联系，但不应把每次提交都视为固定金额的Ethereum收入。奖励参数、签名参与、区块范围和协议阶段都会影响结果。2026年的奖励调整提案尤其说明，区块时间变化会改变检查点频率，单次参数和年度发行不能脱离时间背景直接比较。

取数据时，Bor提供被覆盖的区块与回执，Heimdall提供检查点协调记录，Ethereum提供接受承诺的实际交易。三个来源中的高度需要明确所属链。作者原Polygon看板的边界查询实际读取Ethereum侧FxRootTunnel事件；即便网络归属正确，也不能把特定Tunnel事件当作根链全部桥接存款。

检查点范围还可用于判断证明覆盖，而不是估算全部用户活跃度。一份检查点可能覆盖很多普通转账，也可能覆盖不同业务组合。提交次数变化可能来自区块间隔或参数变化，不能直接解释成跨链提款需求同比增长。

因此，Checkpoint最适合被画成一条独立的跨链承诺路线，与Milestone本地确认路线并列。两条路线可以引用同一段Bor历史，却解决不同问题。保持这种区分，后面阅读桥接SQL时，便能看出一个事件计数到底是在测量用户操作，还是在测量协议为跨链证明准备的基础设施活动。

![Checkpoint把什么带到Ethereum](../../assets/diagrams/checkpoint.svg)

[可编辑原图](../../assets/diagrams/checkpoint.drawio)


来源与核对：[checkpoints](https://docs.polygon.technology/pos/architecture/heimdall_v2/checkpoints.md)；[stakingmanager](https://docs.polygon.technology/pos/reference/contracts/stakingmanager.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](11-chapter.md) · [下一章](../part-04/13-chapter.md)
