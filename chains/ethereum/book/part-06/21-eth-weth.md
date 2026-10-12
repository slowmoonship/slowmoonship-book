# 21｜ETH 和 WETH，为什么要看不同记录？

ETH 是 Ethereum 的原生资产，执行层直接维护账户 Balance。WETH 是合约表达的包装资产，为需要统一代币接口的应用提供便利。名称相近不意味着可以把所有记录放在一列中无差别相加。

普通 ETH 转账可以从顶层 Transaction 的 Value 与成功状态开始核对。合约内部 ETH 支付则要看相应成功调用、回滚祖先和其他状态变化来源。费用又是一类 ETH 支出。ERC-20 Logs 不会自动为这些原生变化补上一条 Transfer。

经典 WETH9 允许调用 `deposit` 并附带 ETH，增加相应地址的 WETH 余额；`withdraw` 则减少 WETH 并按代码释放 ETH。它提供 ERC-20 风格接口，但包装和解包使用 Deposit、Withdrawal 等事件。这正是“所有代币增加都必须有标准 Mint Transfer”会出错的地方。

Case 04 中，用户先把 0.408065 ETH 附带给 Router。执行到支付回调时，Router 调用 WETH Deposit，把同额 ETH 放进包装合约，再把所得 WETH 转给 Pool。Pool 收到 WETH，并向用户交付输出代币。这里有原生路径、包装路径和代币路径。

原始日志 Index 726 是 WETH Deposit，Index 727 是 WETH Transfer。浏览器的资产清单把 Deposit 显示为 Token Minting，并以零地址作为规范化起点。这可以帮助展示，但原始事件并没有因此变成 ERC-20 Transfer。研究报告应注明哪个表达来自原日志，哪个来自加工模型。

如果计算用户支出，顶层 ETH Value 是这次资金输入，费用需要另外加上。若统计 Pool 成交输入，则是收到的 WETH 数量；若统计全系统资金运动，还会看到 ETH 从 Router 到 WETH 合约。三种口径都可能有价值，却不能都加进“用户兑换金额”而不解释重复。

原生 ETH 的完整历史还包含共识提款和不同时期的奖励等来源。只筛 `type = call` 可以得到一类调用资金流，但并不等于所有余额变化。SELFDESTRUCT 等行为也有历史规则边界。应当按问题选择资金来源，并明确不覆盖的部分。

包装资产还有合约身份问题。其他链或其他实现可能使用同名 WETH，地址和行为并不相同。本篇限定主网经典 WETH9 地址 `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`。没有核对合约，就不应把符号相同视作同一资产。

验证 ETH 与 WETH 的转换，最清楚的方式是并排看原生 Value、Deposit/Withdrawal、Transfer 与余额规则。它们共同解释过程；每一条记录都需要保留自己的资产单位和来源。

在资产图里，包装动作会同时改变原生资产保存位置和包装合约里的余额。它们是同一转换过程的两侧；统计使用量时应明确观察原生锁入、包装余额增加，还是最终池级支付。

查询结果若同时出现原生金额与包装增量，先不要认为存在两次独立充值。对照调用路径和事件索引，检查二者是否来自同一笔包装。这个方法也能帮助理解其他凭证型资产，但每种凭证的兑现规则还需单独验证，不能只凭名称推广。

资产包装不能只看余额截图。应把调用的原生金额与保留事件逐项核对，确认本次转换对应哪一地址与哪一条执行路径。

![ETH 和 WETH，为什么要看不同记录？的教学图](../../assets/diagrams/assets.svg)

[编辑此图](../../assets/diagrams/assets.drawio)

[完整 SQL：05-native-call-values](../../examples/sql/05-native-call-values.sql)（STATIC_CHECKED；未在 Dune 执行）。

依据：[WETH 源码](https://github.com/gnosis/canonical-weth/blob/master/contracts/WETH9.sol)；[Dune WETH 来源](https://docs.dune.com/data-catalog/curated/token-transfers/evm/token-transfers)；[原生执行](https://ethereum.org/developers/docs/evm/)。核验日：2026-10-10。

[上一章](../part-05/20-core-data-model.md) · [目录](../../SUMMARY.md) · [下一章](../part-06/22-allowance-approval.md)
