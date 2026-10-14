# 技术事实审查

状态：VALIDATED。执行者自审，基准2026-10-13；官方原文、实时API、Catalog及已有旧结果核对。没有外部独立审校，没有新SQL执行或全链重放。

| 检查 | 正文章 | 处理与边界 |
|---|---|---|
| 1 Core/EVM不是两链 | 03、28—32 | 同一L1双执行，资产路径与接口时点分开 |
| 2 共识不是EVM执行 | 02、03 | Round、L1 Height与EVM号独立 |
| 3 Order≠Fill | 04、11、12 | 多Fill真实关联，零Fill订单不在Fill表 |
| 4 Maker/Taker双侧 | 10、39 | 角色与Buy/Sell独立，市场单计数 |
| 5 Volume双倍风险 | 04、16 | 真实10.03104与20.06208核对 |
| 6 OI单双边 | 16 | 按当前Dune双边语义保留原列与换算 |
| 7 Spot/Perps分开 | 13、25 | 资产交付与合约敞口分别建模 |
| 8 Rate≠Payment | 21—23 | 小时率与真实金额分列 |
| 9 Fee≠Funding | 21、24 | 收款方向与经济过程不同 |
| 10 Mark/Oracle区别 | 17、23 | 清算Mark，Funding名义Oracle |
| 11 Side≠开平仓 | 14 | 实际买平空、卖平多 |
| 12 Close不是清算证明 | 19 | 真实清算案例缺口保留 |
| 13 Margin模式 | 06、18—20 | Standard/Unified/Portfolio与市场资格分开 |
| 14 HIP-1≠ERC-20 | 26、28 | 链接与精度需实际身份 |
| 15 Token≠Pair | 26 | 150、107、10107不同域 |
| 16 HIP-3同名碰撞 | 33、38 | coin留DEX前缀，不按market_symbol Join |
| 17 RWA价格敞口≠所有权 | 33 | 股票/商品关联Perp不交付基础资产 |
| 18 HIP-4主网范围 | 34 | 实际Question集合与初始介绍差异；创建权限未外推 |
| 19 快照≠历史 | 08、40 | API时点、事件时点、重建分别标注 |
| 20 EVM Logs≠全部Core事件 | 32、37 | 双体系数据地图 |
| 21 Writer入口≠Core成功 | 31 | 入队、执行与终态分层 |
| 22 Curated非原生字段 | 38 | 角色分类、OI估值、血缘说明 |
| 23 更新时间 | 37—40 | 业务时间、构建时间、覆盖与延迟 |
| 24 API真实状态 | 全书案例 | 原始32响应，unknownOid与空数组未改写 |
| 25 账户/子账户/Vault | 07、36 | 地址、权限、管理与受益关系分开 |
| 26 HLP风险 | 36 | 多策略与份额，非无风险固定收益 |
| 27 历史规则与当前 | 附录D | Cross、Quote、费用与Writer文档冲突保留 |

重点修订：Case02终态查询unknownOid，删除原始数量/全部成交推断；补充Unified/Portfolio；HIP-4 API实际Question覆盖优先作为观察，部署权限另列；DuneOI采用来源双边，费用份额不重复；并保留Oracle表Catalog缺口。

每章问题、来源、图、案例、SQL与审查范围见[逐章索引](../research/chapter_manifest.json)。[未解决事项](../research/unresolved.md)属于结论边界，不因本地自动验收消失。
