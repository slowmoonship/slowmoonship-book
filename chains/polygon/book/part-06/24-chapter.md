# 第24章｜复读作者的Polygon看板

作者的Polygon PoS核心数据结构看板并不是一个只展示价格的页面。它把区块、交易、费用、调用、部署、日志、资产移动和DEX活动放在同一条学习路线里。本轮取回Dashboard 220013的全部十张图表及十条不同Query，再通过原SQL与旧结果阅读它们的实际口径。

前三条Query观察每日区块、交易与费用，主要窗口为完整UTC日。接下来的合约执行、创建和日志查询展示EVM活动；转账与DEX查询进入Curated层；Aave Supply示例连接解码事件与Raw日志；最后的边界查询读取Ethereum侧特定FxTunnel事件，提醒读者必须回到实际表名确认网络与覆盖。它们适合串成教学过程，而不是十个互不相关的指标。

旧结果有自己的日期。本轮读取的latest执行样本不等于重新执行，也不保证它就是最初建看板当天的版本。原SQL中的滚动窗口依赖当时的current_date；离线教学版本改用固定日期，目的是让范围明确，而不是改写原历史结果。保存SQL与执行结果版本未能独立绑定的地方，也在目录里标出。

看板里最有价值的内容常来自异常。创建表Catalog声称按block_date分区，却没有暴露该列；miner为零地址却不能作为生产者身份；系统交易type 127不能算作普通钱包行为；解码事件的交易索引可能为空。这些发现比一条漂亮增长曲线更能训练数据判断，因为它们迫使我们核对字段与机制。

也有需要纠正的原始文字。看板说明把零地址miner进一步称为Bor proposer，超出了该字段观察能够证明的范围。本篇保留原看板副本，不修改作者远端作品，但正文明确说明应通过区块签名与Span授权识别生产者。复用研究成果，不等于自动继承每一句解释。

DEX查询中的成交段、交易数和多段交易比例，可以解释为什么不能把行数当用户Swap数。费用查询可以比较POL计量与价格富化；转账查询则区分原生路径与ERC-20日志路径。每条查询进入正文的价值，来自它教会读者怎样限定问题，而不是原样复制全部SQL注释。

历史结果与当前Schema也需要分开。当前字段仍在，不代表历史每行完整；旧查询成功过，不代表今天修改后无需重新验证。本轮新教学SQL只做静态核对，运行状态保留为STATIC_CHECKED与BLOCKED_READ_ONLY_ACCOUNT，不把原作者旧执行当作新SQL已经跑通的证据。

看板图表数量与Query数量也不能混用。LGNS看板有十四张图，却只关联六条不同Query，因为一个结果可以生成多个视图。研究目录按Query去重，图表位置另存；这样既不漏掉展示，也不会把同一计算误算成多份独立证据。

研究目录为每条Query保存标题、链接、版本、使用表、旧执行ID、取得行数和章节映射。读者可以从正文回到原作品，再深入SQL副本与结果快照。这使书稿有一个真实研究底座，也为下一部分分析代币、交换和金库提供了共同的数据语言。

![复读作者的Polygon看板](../../assets/diagrams/dashboard-map.svg)

[可编辑原图](../../assets/diagrams/dashboard-map.drawio)

延伸核对：[原看板逐Query目录](../../research/dune/polygon_dashboard_catalog.md)。


来源与核对：[dune-polygon](https://docs.dune.com/data-catalog/evm/polygon/overview.md)；[pip-74-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-74.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](23-chapter.md) · [下一章](../part-07/25-chapter.md)
