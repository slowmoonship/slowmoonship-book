# 第01章｜为什么转账很快，却有三套系统

你在钱包里发送一笔POL转账，几秒钟后，收款人就看到了余额。打开网络介绍，却同时遇到Bor、Heimdall和Ethereum三个名字。难道一笔钱要先后经过三条链，才能到达对方？这个疑问正好是认识Polygon的入口：先分清谁执行交易，谁组织确认，谁承担跨链合约职责。

钱包连接的通常是一个RPC节点。它接收签名交易，检查格式，再把交易传播出去。Bor是Polygon的执行客户端，能够运行EVM，也就是执行Solidity合约所需的虚拟机。转账或合约调用被放进Bor区块后，节点按照同样的规则计算新状态。钱包看到的交易哈希、Gas消耗、回执和事件，主要都来自这一层。

执行正确还不够，网络还必须解决另一类问题：谁有资格生产区块，验证者怎样认可一段区块历史，生产者停止工作后怎样恢复。Heimdall承担这部分协调与共识职责。当前的Heimdall v2基于Cosmos SDK和CometBFT构建，拥有自己的区块、消息和状态。它不是部署在Bor上的一个普通合约，也不会把每笔用户交易再执行一次。

Ethereum上的合约又负责不同的事情。验证者质押、相关管理与检查点提交，都有Ethereum侧的记录。检查点把一段Bor历史的承诺提交过去，供桥接等机制使用。用户在Polygon给朋友转POL，通常不需要自己再发一笔Ethereum交易；取款跨回Ethereum时，才会进入包含检查点与退出证明的另一条流程。

因此，本篇采用三层观察图：Ethereum合约、Heimdall共识、Bor执行。图中连线表示信息与职责的联系，不能读成每笔交易依次在三个地方执行。尤其要记住，本地最终确认由Polygon自己的协议建立；把检查点提交到Ethereum，并没有把Polygon自动变成一个由Ethereum验证全部执行的Rollup。

这也决定了研究方法。Bor数据适合回答谁调用了哪个合约、产生了什么事件；Heimdall数据适合解释验证者、Span与Milestone；Ethereum数据适合核对质押、检查点和桥接的根链步骤。只打开一张交易表，就想同时回答三类问题，常会把看不到的数据误认成不存在。

从用户体验看，钱包只需要告诉你收款是否完成；从研究角度看，同一句话却要拆成执行、共识与跨链三个问题。比如比较两个网络的确认速度，必须先确定双方采用的确认定义。否则把一个网络的回执时间与另一个网络的桥接等待时间相比，得到的数字再精确，也没有共同衡量对象。

后面我们会沿着一笔交易往下走，再把网络记录转换成可查询的数据，最后调查一个真实DeFi项目。读者不必先背熟全部名称。先把三个动作记清：Bor执行，Heimdall协调确认，Ethereum合约记录特定的质押和跨链事务。每遇到一份数据，都先问它属于哪一层，解释就有了落点。

![为什么转账很快，却有三套系统](../../assets/diagrams/architecture.svg)

[可编辑原图](../../assets/diagrams/architecture.drawio)


来源与核对：[architecture](https://docs.polygon.technology/pos/architecture/overview.md)；[heimdall](https://docs.polygon.technology/pos/architecture/heimdall_v2/introduction.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](../00-preface.md) · [下一章](02-chapter.md)
