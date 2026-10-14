# 本轮已取证市场注册

基准2026-10-13；真实获取时间在API包装中。该表是少量案例注册，不冒充完整历史市场数据库。

| 市场 | 身份来源 | 资产映射 | 观察范围 |
|---|---|---|---|
| BTC第一方Perp | metaAndAssetCtxs / universe | 索引0；szDecimals5 | 当前Meta/价格/OI、一天Funding、双侧成交 |
| HYPE/USDC Spot | spotMeta | Token150/0；Pair107；Asset10107 | 实际Meta、L2、WS Trade |
| xyz:TSLA | perpDexs + XYZ Meta | dex1、Meta1、Asset110001 | 当前部署者/参数/上下文，非股票所有权 |
| Outcome95 | settledOutcome | outcome95，encoding950/951，Asset100000950/951 | 历史结算比例0与规格 |
| 当前Question411 | outcomeMeta | namedOutcomes10824/10825/10826，fallback10823 | 35个Question中取一项，未取得用户结算链 |

[案例06](../examples/cases/case-06.md)、[案例09](../examples/cases/case-09.md)、[案例10](../examples/cases/case-10.md)保留原始来源与编号推导。Token/Pair/Asset不会用Ticker替代；市场参数保留版本，标准化分类不冒充协议原字段。
