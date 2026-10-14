# 37｜协议状态怎样进入数据接口

同一笔金融行为可以在节点文件、Info API、WebSocket和Dune中出现不同形态。它们不是四个彼此独立的事实来源，而是从协议执行向外呈现的不同路径。研究开始时，先画运行时地图，再画数据地图，最后找到两张图之间哪些连接已经有实际证据。

Info API适合市场元数据、当前簿和账户状态，也提供有界历史Fill、Funding与Ledger查询。虽然使用POST，明确只读的请求类型仍然是读取。本篇只允许这些类型，没有调用Exchange写接口。响应中保存请求参数、获取时间、业务粒度和原始结果，以便检查实际观察范围。

WebSocket适合实时订阅。BTC与HYPE现货的本篇会话各自最多十二秒、八条消息，取得Trades与L2 Book。簿消息是聚合快照，不应当作逐张订单增量；用户时间序列还可能先发送`isSnapshot`历史快照。重连后重复收到的数据，需要按相应身份与状态处理。

节点可以输出Replica Commands、Trades、Order Status、Raw Book Diffs和Misc Events，也保存周期状态快照。官方路径与JSON样例帮助理解结构，但文档中的示例不是本篇取得的真实节点样本。没有运行节点时，不应把复制的示例标成已下载的Mainnet原始事件。

节点输出结构还因版本和启动选项不同。Trades可将双方信息放在一条记录的`side_info`里，Fills则从用户角度呈现两侧。转换不是简单改列名，它会改变一行对应什么。官方样例中有注释及格式问题，教学JSON需明确规范化来源，不能称作未改动原始返回。

历史归档提供另一路径。官方说明部分Asset Context和L2快照按月上传，可能缺失且不保证及时；节点成交与非交易事件位于另外的目录。S3可能由请求方支付传输费用。本篇只研究目录和格式，没有触发Requester-pays下载，也没有取得全链历史。

HyperEVM RPC提供区块、收据、日志与指定状态读取。默认历史状态能力有限，范围查询也有边界。Explorer可以帮助定位具体业务记录，却不能替代完整事件流；本篇没有取得原始Action，因此订单案例只说明订单状态与Fill的关联，不宣称完整Action验证。

Dune在这些来源上进行索引、解码、规范化和汇总。Curated字段可能分类金融角色、补充元数据或按结算轮次构造状态。表中的美元金额、资金费和OI不应被自动称为原生协议字段。追溯血缘，才知道哪些步骤可能丢失精度、造成延迟或引入研究分类。

选来源可以从问题反推：当前有多少仓位用状态，发生多少成交用事件，订单为何结束用生命周期，过去一秒的簿用快照加完整变化。不同入口都可能有用，但没有一种有限接口天然回答所有历史问题。数据地图的价值，是让每个问题找到对应记录，也让缺口有明确位置。

<!-- BOOK RESOURCES -->

![图37：协议状态怎样进入数据接口](../../assets/diagrams/data-sources.svg)

[编辑此图](../../assets/diagrams/data-sources.drawio)

依据：[for-developers__nodes__l1-data-schemas](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/nodes/l1-data-schemas.md)；[historical-data](https://hyperliquid.gitbook.io/hyperliquid-docs/historical-data.md)；[for-developers__api__websocket__subscriptions](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/websocket/subscriptions.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-09/36-vault.md) · [下一章](../../book/part-10/38-dune.md)
