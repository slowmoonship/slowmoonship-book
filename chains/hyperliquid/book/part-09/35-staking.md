# 35｜质押怎样连接验证者与共识

HYPE可以用于交易、支付EVM Gas，也可以进入Staking账户委托给验证者。质押的核心作用是参与共识权重与相应奖励机制，不是建立一个HYPE价格多仓。研究质押活动，需要委托与退出事件，不能从HYPE Spot成交量直接推出网络安全参与程度。

官方说明，HYPE从Spot进入Staking，再委托给一个或多个验证者。验证者按总委托权重参与区块生产与奖励，并可以收取佣金。委托地址、验证者地址和交易账户具有不同角色；同一地址采用多种角色，也不应让这些过程合并成一笔普通Token转账。

当前规范对活跃验证者规定一万HYPE自委托要求及一年锁定。普通委托到指定验证者有一天锁定期，之后可解除委托。解除委托使数量返回Staking可用状态，进一步退回Spot则进入七天退出队列。这两个步骤不能都叫“已经到账”。

等待队列还包含数量、申请时点和完成状态。若研究某天可退出的HYPE，应按队列条件计算，而不是看到undelegate便从网络质押中推断即时可流通供应。公开账户的委托摘要只是当前状态，没有历史事件时，不能编造过去某次退出或奖励领取。

奖励来源与计算也不同于手续费盈利。官方质押文档说明奖励来自未来发行储备，随总质押等条件变化；奖励累计与分配有规定节奏，并自动再委托。实际收益还受验证者佣金、活跃状态和相应Epoch最小委托量等规则影响，不是固定利率存款。

共识中的Quorum按质押权重计算。官方说明质押Epoch按十万轮次划分，验证者集合及共识质押在Epoch内固定；执行高度与轮次分别编号。统计验证者时，应记录权重、集合时点与状态，不把累计出现过的所有验证者地址当成当前活跃集合。

Jailing与Slashing也需要区分。前者可能因消息响应等表现被投票暂停共识参与，影响奖励；后者涉及罚没。当前基础质押页说明没有自动罚没机制，而HIP-3另有部署者罚没规则。两个页面讨论不同角色，不能将部署者条件全部套给普通委托者。

本篇取得样本账户`delegatorSummary`，但它不足以形成一条真实委托、奖励或退出事件链。案例12因此保留状态观察与事件缺口，不以零值或空状态证明用户从未质押。要重建历史，需Delegator History、Rewards或节点Misc Events等实际记录。

HYPE的不同用途在数据上可以并列，却不能互相代替。Spot数量说明持有，EVM Gas说明执行费用，Staking说明共识参与，HIP-3质押说明部署资格。沿角色、账户分区和事件类型组织证据，才能理解同一种资产如何支持不同协议功能，而不把全部活动写成代币投资叙事。

<!-- BOOK RESOURCES -->

![图35：质押怎样连接验证者与共识](../../assets/diagrams/staking.svg)

[编辑此图](../../assets/diagrams/staking.drawio)

证据：[案例12](../../examples/cases/case-12.md)。

依据：[hypercore__staking](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/staking.md)；[validators](https://hyperliquid.gitbook.io/hyperliquid-docs/validators.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-09/34-hip4.md) · [下一章](../../book/part-09/36-vault.md)
