# 25｜现货成交如何改变两种资产

买入HYPE现货与买入HYPE永续，界面上都可能显示Buy HYPE，账户变化却不同。现货买入通常增加基础Token数量并减少报价Token；永续买入改变有符号合约仓位，不自动增加可转走的HYPE。一个简单的市场类别字段，决定整段金额应怎样解释。

教学模拟中，Alice用100个报价单位买入2单位Token X。忽略费用时，她的X增加2，报价资产减少100；卖方正好反向变化。这次成交交换两类资产数量。不能像永续那样只用`szi`表达它，也不能把现货账本的Token余额称作合约多头持仓。

Spot订单簿仍然使用买卖盘、价格数量和撮合，但约束来自具体资产余额与账户规则。卖方需要能够交付基础资产，买方需要相应报价能力。Portfolio Margin可能允许符合规则的借入资金参与，届时还产生负债。现货交易本身与融资机制仍然应该分别记账。

本篇实际订阅HYPE现货`@107`的公开Trade与L2 Book。该市场由Spot Metadata的Pair Index映射到Token索引150和0。Trade里的coin不是永续HYPE名称。记录可以证明现货撮合存在，却不同时给出每个参与账户成交前后的完整余额或转账权限。

现货基础数量`sz`乘价格`px`形成报价名义额。HYPE数量、USDC金额和最小整数单位不能混成同一种amount。接口可能以十进制字符串呈现可读数量，而账本或EVM日志使用缩放整数。计算前先核对单位，再决定是否需要按Token精度换算。

挂单占用也会影响余额显示。未成交买单可能保留报价资产，未成交卖单保留基础资产。取消释放占用，未必产生外部转账；成交使用占用并更新两边数量。只看可用余额差额，无法区分取消、成交、转移或其他资金用途，必须接入订单与Ledger类型。

Spot成交量是资产交换名义额，但不等于平台净入金。用户可能反复买卖同一笔资金，或者两个原有用户相互交换。链上资产存量几乎不变，期间交易量仍可以很大。计算净流入应该寻找账户范围之外的资金移动，并处理同一范围内部转移。

界面命名还可能重映射。官方说明，前端显示的BTC/USDC可能对应Core原生名称UBTC/USDC。相似Ticker不足以证明原生BTC、封装或关联资产具有同样兑付关系。Spot分析应记录Token ID与具体Pair，而不是只保留界面文本。

将现货与永续并排展示是合理的市场研究，但两类指标需要清楚命名：现货交换量、永续名义量、Token余额和合约敞口分别属于不同经济对象。只要从“这次成交交付什么、形成什么状态”出发，页面上相似的买卖按钮就不会误导数据模型。

对于成交双方，费用会使最终余额变化与无费用教学数字略有不同。准确核对需要实际收费资产和整数精度，不能仅凭两条价格数量记录判断全部到账金额。

<!-- BOOK RESOURCES -->

![图25：现货成交如何改变两种资产](../../assets/diagrams/spot.svg)

[编辑此图](../../assets/diagrams/spot.drawio)

证据：[案例06](../../examples/cases/case-06.md)。

依据：[for-developers__api__info-endpoint__spot](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot.md)；[for-developers__api__websocket__subscriptions](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/websocket/subscriptions.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-06/24-fees.md) · [下一章](../../book/part-07/26-token-pair.md)
