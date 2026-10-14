# 03｜同一条L1的两种执行环境

Hyperliquid页面可以交易永续合约，也可以连接运行智能合约的应用。看见两套入口，很容易以为背后是两条链。正确的结构是：同一条Hyperliquid L1由HyperBFT保护，状态执行包含HyperCore与HyperEVM两大部分，两者承担不同工作。

HyperCore专门处理订单簿、撮合、持仓和保证金等金融原语。用户下单时，无须先找到一个普通EVM交易所合约，再调用合约里的撮合函数。核心交易状态是协议自身执行的一部分。这也是为什么分析HyperCore不能只从ERC-20 Transfer事件入手。

HyperEVM提供通用EVM合约环境。开发者熟悉的账户、字节码、交易收据和日志仍然有用，Gas使用HYPE支付。它让借贷或其他应用与Core中的金融状态组合，但不能因此把HyperCore改画成EVM内部的一个合约。专用执行与通用执行的边界始终存在。

两种环境之间的连接有明确接口。读取预编译允许合约查询特定Core状态；CoreWriter系统合约允许EVM侧表达随后由Core处理的操作。原生资产还可以按系统地址规则在两边移动。这些路径共享L1排序，却具有不同的处理时点和可观察结果。

例如，合约读到BTC预言机价格，只能说明指定读取在相应EVM执行状态下得到这个值。合约向CoreWriter提交操作，则需要继续核对Core是否执行成功。EVM收据中的成功，不能自动替代最终订单状态。共享底层共识没有消除跨执行职责的业务检查。

资产交互也不是普通两条L1之间的外部桥模型。HYPE对应EVM原生余额；某些Core现货资产与具体ERC-20关联。关联规则、精度转换和合约实现决定如何记账。把所有资产都画成同一种锁定与铸造流程，会掩盖原生HYPE与关联代币的差异。

数据入口因此分成两套。Core Info API呈现市场、账户、订单和成交等业务数据；EVM RPC呈现区块、交易和收据。节点输出和索引服务可以把二者进一步整理。Dune中的`hyperevm.transactions`与`hyperliquid.perp_trades`描述不同事件，行数没有直接相等的理由。

官方页面还存在更新节奏差异：介绍页仍保留部分功能尚未主网上线的早期文字，而交互规范列出了扩展后的CoreWriter操作。本篇实际取得主网读取预编译返回与CoreWriter代码；已有Dune结果也保留接口调用观察。它们支撑指定接口的存在，不能证明所有列出的操作都已逐项验证。

阅读后面的运行时总图时，可以先沿上半部分理解共同的L1和共识，再分别进入Core与EVM的执行职责，最后沿下半部分寻找数据接口。分析金融行为时选Core记录，分析合约执行时选EVM记录，分析交互时连接两边证据。这就是两张数据地图共享同一底层状态的含义。

共享L1还意味着，研究者不应把两套接口返回的高度直接当作相同编号。需要先查明高度属于共识、Core执行还是EVM区块，再寻找正式关联。

<!-- BOOK RESOURCES -->

![图03：同一条L1的两种执行环境](../../assets/diagrams/runtime.svg)

[编辑此图](../../assets/diagrams/runtime.drawio)

证据：[案例08](../../examples/cases/case-08.md)。

依据：[hyperevm](https://hyperliquid.gitbook.io/hyperliquid-docs/hyperevm.md)；[for-developers__hyperevm__interacting-with-hypercore](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/hyperevm/interacting-with-hypercore.md)；[for-developers__hyperevm__interaction-timings](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/hyperevm/interaction-timings.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-01/02-consensus.md) · [下一章](../../book/part-01/04-records.md)
