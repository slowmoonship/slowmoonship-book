# 第11章｜Milestone怎样确认一段Bor历史

假设你看到Bor高度一百万处有一笔付款。确认付款执行成功，只需要交易和回执；判断它是否属于网络已经最终认可的历史，还需要知道这一高度是否落入Milestone确认的连续区间。Milestone针对区块序列，而不是为每笔交易单独盖章。

验证者通过Heimdall v2的投票扩展提交对近期Bor区块哈希的意见。协议从这些意见中寻找具备足够投票权支持、并与此前已确认历史连续的序列。高度与哈希必须一起比较，因为同一个高度在分叉情况下可能出现不同区块。只对高度投票，无法表达认可的是哪一份具体内容。

官方文档用约三分之二投票权门槛解释Milestone确认，并在具体规则中说明连续序列与多数支持。这里的计量单位是投票权，不是收到多少个HTTP响应。一个研究者询问三个公共RPC并得到相同结果，并不等于已经复现Heimdall的投票检查；它只是取得了多个服务对当前状态的回答。

Milestone一旦按协议确认，相关Bor历史获得本地确定性最终确认。这个过程不必等待下一个Ethereum检查点。它依赖Polygon验证者与共识实现的安全假设，不能被写成Ethereum在这时重新执行并验证了每一笔Bor交易。确认位置在Polygon本地，后续跨链承诺另有职责。

v2还改变了观察方式。旧版可能把Milestone描述成一种提交交易，当前核心流程依靠ABCI++与投票扩展推进，因此不能只在交易列表里搜索某个方法名来统计全部最终确认活动。应读取相应模块状态、区间和实现规定的消息结构，再与目标交易所在区块对照。

后续升级表明，最终确认与网络活性必须一起看。Zurich强化了多数序列选择的确定性；Ithaca处理了生产者停顿、Milestone处于特定待定状态时无法自主恢复的问题。它们不等于宣布任何条件下都不会停机，而是在协议中补足明确的故障恢复路径。时间宣传数字也不能代替逐笔延迟测量。

实际检查可分三步：保存交易所属Bor区块哈希，取得覆盖该高度的Milestone记录，再核对区间和末端承诺的含义。本轮提供的是接口和证据定位方法，没有把缺少的验证者签名包写成已经验签。如果只有索引器返回的confirmed标签，就按该服务的确认口径记录，不把它升级为本地共识证明。

同样，最终确认延迟需要起止点。以钱包签名时刻开始，会包含本地等待和传播；以Bor入块时刻开始，则更接近共识确认阶段。两种测量都可以使用，但不能在一张图中无说明地混合，随后把差异全部归因于Milestone机制。

Milestone使“交易已经确定”与“跨链退出已经完成”能够分开叙述。对普通收款，前者通常是关心的终点；对把资产取回Ethereum的人，前者只是后续证明流程的基础。下一章讨论的Checkpoint，就是这条后续路线里的另一种历史承诺。

![Milestone怎样确认一段Bor历史](../../assets/diagrams/milestone.svg)

[可编辑原图](../../assets/diagrams/milestone.drawio)

![Milestone与Checkpoint并列比较](../../assets/diagrams/milestone-vs-checkpoint.svg)

[可编辑原图](../../assets/diagrams/milestone-vs-checkpoint.drawio)


来源与核对：[milestones](https://docs.polygon.technology/pos/architecture/heimdall_v2/milestones.md)；[pip-89-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-89.md)；[pip-90-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-90.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](10-chapter.md) · [下一章](12-chapter.md)
