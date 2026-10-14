# API字段与单位教学卡

基准2026-10-13。[32个实际请求及原始返回](../examples/api/README.md)。所有请求类型均来自官方读取接口；下表解释本篇实际使用字段，未解释的新字段保持待验证。

| 请求 / 字段 | 粒度及含义 | 单位 / 时点 |
|---|---|---|
| meta.universe | 各市场定义；上下文按相同Meta顺序对应 | name、szDecimals、maxLeverage、marginTableId为身份/参数 |
| metaAndAssetCtxs / openInterest | 当前市场站立敞口 | 基础单位；双边解释依据Dune文档，未全账户核算 |
| oraclePx / markPx / midPx | 三种当前价格 | quote/base，不能互换 |
| funding | 当前展示资金费率 | 无量纲小数，区别已结算history |
| dayNtlVlm / dayBaseVlm | 接口当前日统计 | 报价名义量 / 基础量；窗口按接口定义 |
| l2Book.levels | [bids, asks]聚合档位 | px价格、sz数量、n订单数；time为毫秒事件时点 |
| spotMeta.tokens | Token注册身份 | 显式index、tokenId、weiDecimals、szDecimals |
| spotMeta.universe | Pair注册 | index、tokens中base/quote顺序 |
| perpDexs | DEX注册 | deployer、oracleUpdater、feeRecipient及部署参数 |
| outcomeMeta | Outcome、Question与部署者集合 | outcome、question为整数身份；description定义产品 |
| settledOutcome | 一个Outcome历史结算 | settleFraction为每Yes Token报价支付；No为补数 |
| userFillsByTime | 一侧用户Fill | px quote/base、sz base、fee为feeToken单位；time毫秒 |
| startPosition / dir | 成交前仓位与经济影响 | 有符号基础单位 / 类别；不是纯Buy/Sell |
| crossed | 此腿是否主动 | bool；false可为Maker |
| oid / cloid / tid / hash | 不同记录身份 | 不无条件单列全局去重；hash可能全零 |
| orderStatus | 指定oid/cloid查询结果 | 外层status=order后还要读内层状态；unknownOid不补造 |
| clearinghouseState | 账户×DEX当前摘要与仓位 | 模式决定范围；time与作者获取时间分开 |
| accountValue / totalMarginUsed | 权益 / 使用保证金 | 适用抵押会计单位；不能等同withdrawable |
| szi / positionValue | 有符号仓位 / 名义值 | 基础数量 / 指定估值报价单位 |
| liquidationPx | 当前规则下估计触发价格 | 会随资金费、状态与其他仓位变化 |
| spotClearinghouseState | 当前Token余额 | total与hold按Token可读数量；统一模式余额在此 |
| userFunding.delta | 用户结算现金流 | usdc有符号报价金额，szi结算基础数量，fundingRate小时小数 |
| userNonFundingLedgerUpdates | 非Funding账务事件 | delta.type决定金额与方向语义；不全是外部入金 |
| userAbstraction | 当前账户模式 | disabled/standard、unifiedAccount、portfolioMargin等规范返回 |
| delegatorSummary | 当前质押摘要 | HYPE数量与队列相关状态，非历史事件链 |
| vaultDetails | 指定Vault信息与历史呈现 | 名称、地址、portfolio权益/PnL及出资关系按官方结构 |
| eth_getBlockByNumber | 固定EVM块 | 数值多为hex quantity；时间为Unix秒 |
| eth_getTransactionReceipt | 指定EVM执行收据 | Gas计量、日志身份、status；不是Core成功证明 |
| eth_getLogs | 固定50区块系统地址日志 | 返回空即该窗口没有取得记录，不推断全历史 |
| eth_call 0807 | BTC Oracle指定只读预编译 | ABI整数；价格缩放按6−szDecimals |
| eth_getCode CoreWriter | 代码读取 | 非空字节证明系统入口代码，不执行任何Action |

Info十进制字符串不使用二进制浮点做证据金额相等检查。本篇案例金额由Decimal核对，SQL部分double只用于注明的分析展示。完整金融金额及单位审查见[财务口径记录](../reports/financial-units-review.md)。
