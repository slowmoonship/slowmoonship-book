# DuneSQL教学索引

18条新增SQL均为STATIC_CHECKED；实际执行BLOCKED_READ_ONLY_ACCOUNT，本轮未提交运行。日期固定为2026-10-12完整UTC日。Schema来自实时Catalog；文档和Catalog时间戳类型有差异，运行前核对。金额含quote单位，跨抵押市场合并只是名义代理，不是经FX核验美元收入。

- [01-markets](01-markets.sql)：当前市场有哪些、采用哪些风险参数？；one row per current coin。
- [02-volume](02-volume.sql)：指定完整UTC日BTC的经济成交量？；one output market-day。
- [03-maker-taker](03-maker-taker.sql)：市场两种参与角色各有多少Fill与费用？；coin-role-day, participation legs。
- [04-hourly-flow](04-hourly-flow.sql)：BTC成交的小时分布？；market-hour。
- [05-open-interest](05-open-interest.sql)：BTC小时站立敞口？；coin-hour stock。
- [06-flow-stock](06-flow-stock.sql)：同一小时成交与OI有何不同？；one market-hour。
- [07-funding-rates](07-funding-rates.sql)：已经结算的BTC资金费率？；market funding-hour。
- [08-user-funding](08-user-funding.sql)：案例账户在各轮实际收到或支付多少？；user-market-funding-round。
- [09-liquidation](09-liquidation.sql)：BTC被清算角色有多少腿与账户？；liquidation-role legs grouped by method。
- [10-depth](10-depth.sql)：BTC买盘快照各档有多少基础数量？；one row per snapshot price level。
- [11-spread](11-spread.sql)：一分钟簿快照点差多大、是否陈旧？；coin-minute sparse snapshot。
- [12-hip3-classification](12-hip3-classification.sql)：当前HIP-3产品按部署者和资产类别怎样组织？；current market registry。
- [13-first-hip3](13-first-hip3.sql)：同一天第一方与HIP-3的来源指标如何比较？；dex-type-day。
- [14-evm-transactions](14-evm-transactions.sql)：HyperEVM一天的交易执行活动？；UTC day。
- [15-core-interfaces](15-core-interfaces.sql)：观察到多少CoreWriter或BTC Oracle接口调用？；one interface-address-day。
- [16-outcome-volume](16-outcome-volume.sql)：HIP-4正常成交单计数与定义？；market-day normal taker trade legs。
- [17-trade-book-join](17-trade-book-join.sql)：BTC成交能连接到同分钟快照吗？；one fill leg with optional minute snapshot。
- [18-kpi-and-quality](18-kpi-and-quality.sql)：一日市场活动与数据质量怎样一起报告？；coin-day。
