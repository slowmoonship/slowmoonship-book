# 05｜一个地址为何有多种余额

你看到Spot余额里有HYPE，永续页面显示USDC账户价值，质押页面还有一笔等待退出的HYPE。把三个数字加起来，似乎就得到了钱包资产。但一个地址连接的状态包含不同资产、不同账户模式和不同限制。金额只有在单位与经济含义相同的条件下才能相加。

HyperCore用户通常由一个地址识别。地址像一把索引钥匙，可以找到现货、永续和质押相关状态。它并不意味着所有资产放在一个可随意提款的余额栏里。Spot持有的是代币数量；Perps持仓记录合约敞口；Staking记录参与共识的HYPE及退出队列。

永续账户价值Equity包含风险账户的资金与未实现盈亏。它不等于持仓名义价值，也不一定等于可提取金额。一个账户可以控制相当大的名义仓位，却只有较少保证金。如果把Position Value看成现货资产价值，整个资产负债表就会被严重夸大。

现货余额还可能有hold，即被挂单或其他机制占用的部分。总余额与当前可用余额需要分开。卖出挂单尚未成交时，资产并没有必然转给买方，但可能已经被系统保留用于履约。看到可用余额减少，不能仅据此宣布完成了一次转账或成交。

资产移动还要区分账户内部分类转移与外部地址之间的转移。在Standard模式下，Spot与Perps的同类抵押资产可以分开记账，转移会改变各分区余额。统一账户模式则使用另一套共享规则。只有先知道账户抽象模式，才知道一个分类转移请求对当前账户意味着什么。

本篇取得的案例账户返回`userAbstraction = disabled`，对应手动或Standard体系。它的永续状态包含BTC空仓与USDC风险账户摘要。因此可以按该模式解释这份快照，不能把同样读取方式直接推广给所有采用统一账户或组合保证金的用户。

质押中的HYPE更不能因为地址相同就视为可立即交易的现货。委托、解除委托和从Staking退回Spot属于不同步骤，退出还可能进入等待期。一个正在退出的数量，既不是交易盈利，也不是已经到账的现货。状态字段负责解释数量现在处于哪个阶段。

HyperEVM还维护原生HYPE余额和合约代币余额。与Core使用相同地址格式有利于交互，却不让两份余额自动成为同一条可用余额记录。资产关联、系统地址和执行时点决定两边如何衔接。研究总资产时，要防止把转移途中或系统持有的数量重复计入用户财富。

一个稳妥的账户视图可以先保存网络、用户地址、账户模式、资产身份、分区、观察时间和余额种类，再决定如何汇总。把余额逐项写清楚，页面上看似分散的Spot、Perps和Staking就有了可理解的结构；反过来先追求一个总数，会隐藏最重要的金融区别。

<!-- BOOK RESOURCES -->

![图05：一个地址为何有多种余额](../../assets/diagrams/accounts.svg)

[编辑此图](../../assets/diagrams/accounts.drawio)

实际状态：[账户模式](../../examples/api/22-abstraction.json)、[永续账户](../../examples/api/18-account.json)、[现货账户](../../examples/api/19-spot-account.json)、[BTC市场上下文](../../examples/api/01-meta-context.json)。字段含义见[教学卡](../../research/api-field-guide.md)。

依据：[trading__account-abstraction-modes](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/account-abstraction-modes.md)；[for-developers__api__info-endpoint__spot](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot.md)；[hypercore__staking](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/staking.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-01/04-records.md) · [下一章](../../book/part-02/06-abstraction.md)
