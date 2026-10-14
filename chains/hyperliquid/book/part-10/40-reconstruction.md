# 40｜重建历史状态并解释研究边界

取得今天订单簿，不等于知道昨天每一秒有哪些订单；取得全部成交，也不自动知道哪些挂单曾经撤回。当前状态、历史事件和历史状态重建是三种任务。它们可以连接，但需要不同输入。一本数据书的最后一步，是让读者知道哪些问题能直接回答，哪些需要算法和额外证据。

重建订单簿通常需要可信起始快照、覆盖完整的增量、正确排序和明确变更语义。新增订单、修改数量和移除订单必须按相应身份应用。只有成交记录，会漏掉未成交新单与撤单；只比较两个快照，无法补出期间所有事件。线性插值更不能创造真实订单历史。

WebSocket的L2 Book在本篇规范下是聚合快照，不是逐张订单Diff。节点Raw Book Diff才表达另一类变化。重连必须先明确订阅类型，不能把新的完整快照继续叠加到旧簿上。记录断线、重连与最后完整时点，有助于将“没有观察”与“市场没有变化”区分开。

Dune一分钟Book文档有更具体的模型保证：其事件驱动系列缺少某分钟表示簿未变，可按该模型向前延续。这项保证适用于该经过加工的来源及其覆盖，不应泛化为所有WebSocket缺失分钟都是无变化。实际使用仍需检查边界、取样时间和模型版本。

持仓重建也需要前态和完整状态变化。Fill给出局部增减，Funding轮次快照给出站立仓位；某段只取得部分账户Fill时，无法重建全市场OI。Dune称其现有Fill覆盖不能补出早期OI，描述的是该数据集缺失站立状态的边界，不意味着数学上任何完整状态重放都不可能。

保证金历史比持仓更复杂，还需要当时账户模式、资金、所有相关仓位、价格与风险参数。Portfolio还包括借款、供给和折算。把最新快照退回到过去，或只用静态杠杆算一条清算线，应标作近似情景，不能冒充直接观察的历史风险状态。

可靠分析可以将结论标为Directly Observed、Reconstructed、Approximate、Incomplete或Unknown。重建结果应保留输入版本、算法、缺失窗口和与后续快照的校验差异。没有足够资料时，Unknown是一项准确结果；随意填零或平滑会使后续指标失去可验证基础。

综合看板也应保留不同对象：成交量是流量，OI是存量，Funding是持仓现金流，净入金是指定范围资金移动，清算量是强制风险转移，EVM调用量是程序执行活动。它们可以共同解释市场，却不能揉成一个所谓总活跃度，更不能单靠其中一项推断现实用户或资本归属。

回到全篇的两张地图：运行时说明意图怎样进入订单簿、形成成交并改变金融状态；数据地图说明这些过程怎样被接口与索引呈现。把两张图连接起来，读者就能提出准确问题、选择合适记录、建立有界SQL，并让研究结论始终保留来源、单位、时间和可检验的范围。

<!-- BOOK RESOURCES -->

![图40：重建历史状态并解释研究边界](../../assets/diagrams/reconstruction.svg)

[编辑此图](../../assets/diagrams/reconstruction.drawio)

数据练习：[SQL17](../../examples/sql/17-trade-book-join.sql) · [SQL18](../../examples/sql/18-kpi-and-quality.sql)（静态审查，未执行）。

依据：[for-developers__nodes__l1-data-schemas](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/nodes/l1-data-schemas.md)；[dune-perp-orderbook-1m](https://docs.dune.com/data-catalog/curated/perpetuals/hyperliquid/perp-orderbook-1m.md)；[for-developers__api__websocket__subscriptions](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/websocket/subscriptions.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-10/39-sql.md)


[下一章](../appendix/glossary.md)
