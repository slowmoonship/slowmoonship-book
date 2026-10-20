# 第10章｜Heimdall v2为什么不是另一台EVM

Heimdall也有区块和交易，却不是第二条用来执行用户Solidity合约的EVM链。它的工作更像一个有明确业务模块的协调账本：跟踪验证者，组织生产安排，处理检查点和状态同步，并对Bor历史形成Milestone。理解它最有效的方式，是按职责阅读模块，而不是把Ethereum交易字段逐项搬过去。

当前Heimdall v2建立在Cosmos SDK与CometBFT基础之上。Cosmos SDK提供模块化应用框架，CometBFT负责拜占庭容错共识与应用交互。ABCI++及投票扩展允许验证者在共识过程中携带需要的额外意见。它们解释的是Heimdall怎样组织协调，并不是在说Polygon用户必须改用Cosmos钱包发送普通EVM交易。

2025年的v2迁移改变了序列化、签名与模块处理等细节。旧版命令、REST路径、交易型Milestone叙述，可能仍出现在搜索结果甚至部分文档残留中。遇到这种冲突，应先看当前机制与源码，再把旧命令标为历史接口。一个页面仍能打开，不代表其中每一段都适用于当前节点。

两个客户端的高度也不能互换。Bor高度定位EVM执行区块，Heimdall高度定位共识应用自己的区块。一个Heimdall区块可以处理关于某段Bor区块的意见，两者没有“一块对一块”的普遍对应关系。协议升级如果在Heimdall高度激活，研究者必须保存这个维度，否则同一个数字会被错误地拿去筛Bor交易。

模块状态把两层连接起来。Stake模块管理验证者信息，Bor模块处理Span，Milestone模块保存最终确认区间，Checkpoint模块协调Ethereum提交，Clerk模块保存状态同步记录。普通polygon.transactions主要描述Bor执行，不会因为名称带着Polygon就自然包含这些模块的全部历史。

接口选择因此从问题出发。查一笔代币转账用Bor RPC或EVM表；查某次生产安排用Heimdall的Bor模块；查最终确认范围用Milestone接口；查Ethereum是否接受检查点则要回到根链交易和合约。需要按同一时点比较时，保存各自高度、时间和来源，不能把几个latest响应当成原子快照。

节点内部的信任边界也值得看清。Bor从其配置的Heimdall端点取得协调数据，服务连接方式与故障切换影响运行。2026年新增的传输与恢复能力属于具体版本的实现变化，不能统称为“共识更快”。有的改动影响全体节点必须一致遵守的规则，有的只是本地通信优化。

节点日志可以帮助定位运行问题，却不是永久链上事实。日志中的超时、重试和端点切换需要与已提交状态区分；某节点观察失败，不等于网络所有验证者都未处理。分析共识异常时，应注明这是本地运行证据还是已进入共识的记录。

这种分层观察能解释一个常见疑问：为什么EVM交易照常可查，共识研究却仍需要另一套接口？因为执行历史与组织这些历史的协调状态，本来就是不同的数据对象。把Heimdall理解为具有模块和版本的应用后，Milestone与Checkpoint之间的区别就容易具体说明了。

![Heimdall v2为什么不是另一台EVM](../../assets/diagrams/heimdall-v2.svg)

[可编辑原图](../../assets/diagrams/heimdall-v2.drawio)

![两套高度与数据来源](../../assets/diagrams/heimdall-bor-data.svg)

[可编辑原图](../../assets/diagrams/heimdall-bor-data.drawio)


来源与核对：[heimdall](https://docs.polygon.technology/pos/architecture/heimdall_v2/introduction.md)；[heimdall-changes-v2](https://docs.polygon.technology/pos/architecture/heimdall_v2/changes-from-v1.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](09-chapter.md) · [下一章](11-chapter.md)
