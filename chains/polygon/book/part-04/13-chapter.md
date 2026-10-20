# 第13章｜从Bhilai到Rio，旧教程哪里变了

搜索Polygon教程时，你可能同时看到两秒出块、多个生产者轮换、五秒最终确认和更快支付等说法。它们未必全部错误，却可能属于不同时间和不同指标。阅读技术材料首先要给它加一个日期，再问它讲的是执行、生产、确认还是容量。本章把2025年的关键变化放回这条时间线。

Bhilai在Bor主网高度73,440,256激活。PIP-63列出Gas容量调整、Base Fee变化分母以及Pectra相关EIP等内容。对数据研究而言，重点是执行能力和交易类型发生变化：EIP-7702相关SetCode交易及授权列表进入观察范围，费用与容量的基线也不能继续沿用更早的参数。

EIP-7702让外部账户能够通过授权指定代码执行行为。看到type 4或Dune中相应类型标签时，应检查authorization_list等字段，不能把它简单算成新增普通合约部署。交易发送者、授权者和被委托代码地址可以不同，钱包身份和执行身份的关系因而比传统转账更丰富。

2025年7月的Heimdall v2升级则作用于共识协调层。官方发布材料强调更快最终确认，具体机制包括CometBFT与投票扩展。它与Bhilai不是同一件事，也不能把一次执行层升级的日期写成全部共识实现同时替换的日期。数据结构、节点版本和观察接口需要分别核对。

Rio于2025年10月8日上线，Bor激活高度77,414,656。VEBloP把区块生产者选择与执行验证进一步分工，每个Span由一位获选生产者负责。旧的Sprint轮换解释不再足以说明当前生产安排。画图时，应把验证者投票、生产者池、Span指派和Bor出块依次表达，而不是画成所有验证者同时生产每个区块。

Rio资料也讨论Stateless Validation。它指借助Witness携带执行所需状态信息，让验证者能够检查执行而不必保持同样完整的本地状态数据库。Witness不是对执行正确性的零知识证明，也不让验证者免于执行检查。架构目标、具体客户端能力与全网部署覆盖仍应分开，不能从发布宣传推断每个节点都已采用完全相同模式。

提案与实现还可能有不同命运。早期区块公告能力曾列入Bhilai，之后回退，再由Giugliano引入经修订的实现。单看某个Final提案的包含列表，会错过这段变化。研究时间线因此同时参考PIP、发布说明和固定版本源码，把提议、计划激活和已发布实现分别标注。

版本还影响失败原因。某个历史交易在当时不支持的操作上失败，不能用今天已支持的指令说明它本应成功。教学复盘保留历史环境，才不会把后来的协议能力倒灌进旧交易，得出合约或节点曾经异常的错误判断。

2025年的变化给出一个实用阅读习惯：遇到性能数字先找分母，遇到机制描述先找版本。支持多少支付每秒、区块间隔、Milestone延迟与平均Gas费用都描述不同维度。后面复读作者看板时，我们使用明确历史窗口中的实际计数，不把某次升级公告上的容量数字冒充看板实测结果。

![从Bhilai到Rio，旧教程哪里变了](../../assets/diagrams/upgrade-timeline.svg)

[可编辑原图](../../assets/diagrams/upgrade-timeline.drawio)


来源与核对：[pip-63-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-63.md)；[rio-blog](https://polygon.technology/blog/polygon-launches-major-payments-upgrade-with-rio-faster-lighter-and-easier-to-build)；[pip-64-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-64.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](../part-03/12-chapter.md) · [下一章](14-chapter.md)
