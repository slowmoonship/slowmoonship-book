# 18｜保证金是怎样一层层检查的

保证金像一份履行未来盈亏责任的资金缓冲，但不同检查使用不同底线。开仓所需的Initial Margin、继续持仓所需的Maintenance Margin、能够转出的金额，是三项相互关联的规则。通过开仓检查，不意味着以后永远安全；满足维持保证金，也不意味着剩余价值都可提走。

教学模拟中，名义仓位1000，用户设置十倍杠杆，简化初始保证金为100。公式是绝对持仓数量乘Mark价格，再除以用户杠杆。它帮助理解资金需求，实际系统还检查市场最大杠杆、风险档位、已有仓位与挂单，以及账户模式。不能用一条式子覆盖所有边界。

维持保证金以市场适用规则和规模档位计算，普通规范描述为最大杠杆下初始保证金比例的一半。用户选择较低杠杆，不会自动把市场的维持保证金率改成用户初始保证金率的一半。市场上限、用户设置与当前实际杠杆应分成三个字段。

Cross Margin让规定范围内的全仓仓位共享权益。一个仓位的盈利可以影响另一个仓位的风险缓冲，亏损也会消耗共同资金。Standard模式的范围通常是同一DEX；Unified或Portfolio模式的范围更广。研究全仓清算时，必须知道共享集合中还有哪些仓位和负债。

Isolated Margin把指定持仓的抵押与其他风险账户隔离。按官方普通规则，该隔离仓位被清算，不应直接取走其他逐仓或全仓资金。Strict Isolated还限制移除保证金。隔离控制的是风险资金范围，不保证基础价格、流动性或仓位自身没有损失。

转出保证金需要满足另一项规则。普通Margin文档规定，剩余资金至少满足初始保证金需求与总名义价值百分之十两者中的较大值。这个约束解释了为什么一个账户尚未触发清算，却可能没有可提款金额。提款能力和清算健康度不是同一个比率。

案例账户价值约25882，维持保证金约7941，已用保证金约24435，可提款为零。它是一份当前状态观察，不是精确风险预测。BTC价格变化、后续Fill、资金费和转移都会改变结果。把这些快照数值固定下来推算未来所有清算时点，会忽略持续变化的状态机。

风险档位使计算进一步分段。规模较大时，适用最大杠杆或维护要求可能变化，档位规则还涉及累进与扣减结构。分析者需要读取相应Margin Table，而不是给所有仓位使用固定百分比。HIP-3不同产品的参数也应按完整市场身份查找。

保证金分析因此从“资金能担保什么”开始，再检查开仓、维持和转出三层要求。组合保证金还要加入借入资产、折算与额度规则。把这些层次画清楚，就能解释杠杆怎样建立敞口、权益怎样吸收盈亏，以及为什么风险不会被一个开仓时的杠杆按钮永久决定。

<!-- BOOK RESOURCES -->

![图18：保证金是怎样一层层检查的](../../assets/diagrams/margin.svg)

[编辑此图](../../assets/diagrams/margin.drawio)

实际状态：[账户模式](../../examples/api/22-abstraction.json)、[永续账户](../../examples/api/18-account.json)、[现货账户](../../examples/api/19-spot-account.json)、[BTC市场上下文](../../examples/api/01-meta-context.json)。字段含义见[教学卡](../../research/api-field-guide.md)。

依据：[trading__margining](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/margining.md)；[trading__margin-tiers](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/margin-tiers.md)；[trading__portfolio-margin](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/portfolio-margin.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-05/17-prices.md) · [下一章](../../book/part-05/19-liquidation.md)
