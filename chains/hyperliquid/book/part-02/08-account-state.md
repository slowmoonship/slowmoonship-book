# 08｜怎样读懂一份账户状态

一份`clearinghouseState`响应看起来像许多数字组成的财务报表。最容易犯的错，是挑一个最大的数字叫作余额。读懂它可以分三步：先确认账户及DEX范围，再看摘要，最后逐个阅读仓位，并保留响应中的观察时间。摘要和明细应互相解释。

案例账户的实际快照包含BTC仓位`szi = -7.59872`。负号表示净空头，数量单位是BTC基础单位，不是USDC。`positionValue`约为635298.58，表示持仓名义价值，不能当作账户持有的现金。`entryPx`是持仓会计入场价格，`unrealizedPnl`是按当前估值产生的未实现盈亏。

同一响应中的`marginSummary.accountValue`约25882.07，`totalMarginUsed`约24434.56。前者是账户价值，后者描述已使用的保证金。`crossMaintenanceMarginUsed`约7941.23表示全仓维持保证金需求。这些字段共同解释风险账户，却没有一个可以无条件替代`withdrawable`。

该快照的可提款字段为零。账户价值为正却不能立即提取，并不矛盾：持仓、初始保证金与转出规则会占用资金。拿账户价值减去维持保证金，也不能自动得到可提款金额，因为转出限制与清算底线属于不同检查。状态字段的业务含义需要逐项核对。

`leverage`同时记录模式与用户设置值。设置为26倍不意味着当下实际杠杆永远是26。价格、账户资金和盈亏变化，会使名义仓位与权益的比率变化。当前风险要结合状态和市场规则；只看开仓时的用户设置，不能复原已经变化的账户。

`cumFunding`提供不同范围的累计资金费相关状态，例如全部历史、当前持仓或最近变化以来的累计值。它们不同于逐小时Ledger记录。进行期间费用分析时，优先使用带时间与金额的结算事件；简单相减累计字段，需要先确认仓位重置和累计范围如何变化。

当前快照也不能直接充当某笔历史成交后的状态。案例成交先被观察，随后才查询账户，中间可能还有其他Fill。用最新`szi`倒推几分钟前的全部仓位，会混入未枚举的变化。单笔Fill里的`startPosition`更接近该笔事件的前态，但仍只覆盖这个账户与市场。

Spot Clearinghouse State则按Token提供余额、hold及其他字段。两个接口不是同一表的不同排版。账户采用Unified或Portfolio时，还要按其规则理解Spot侧的统一资金状态。因此，保留`userAbstraction`和请求的DEX参数，是这份财务快照能够被正确使用的前提。

最后做一个简单核对：将有符号数量、名义价值、估值价格和摘要范围连接起来，检查单位是否一致，允许价格与时间差导致的小偏差。把原始十进制字符串保存下来，计算时采用明确精度。我们要解释的是某一时刻的金融状态，而不是从一张JSON猜出整个历史账户。

接口中的time应与作者获取响应的时间同时保存。前者定位业务状态，后者定位这次观察；缓存和网络传输可能让两者不完全相同。

<!-- BOOK RESOURCES -->

![图08：怎样读懂一份账户状态](../../assets/diagrams/account-state.svg)

[编辑此图](../../assets/diagrams/account-state.drawio)

实际状态：[账户模式](../../examples/api/22-abstraction.json)、[永续账户](../../examples/api/18-account.json)、[现货账户](../../examples/api/19-spot-account.json)、[BTC市场上下文](../../examples/api/01-meta-context.json)。字段含义见[教学卡](../../research/api-field-guide.md)。

依据：[for-developers__api__info-endpoint__perpetuals](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals.md)；[for-developers__api__info-endpoint__spot](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot.md)；[trading__account-abstraction-modes](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/account-abstraction-modes.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-02/07-identities.md) · [下一章](../../book/part-03/09-book.md)
