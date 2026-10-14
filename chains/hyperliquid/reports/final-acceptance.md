# Hyperliquid篇最终验收

基准日：2026-10-13（Asia/Shanghai）。整体：**VALIDATED**。本地完整书稿已交付；新SQL实际执行、部分金融事件与外部独立技术审查仍有明确缺口。

路径：`chains/hyperliquid`。

[完整阅读BOOK](../BOOK.md) · [短章目录](../SUMMARY.md) · [机器验收](validation.json) · [统计与分级JSON](final-acceptance.json)。

| 书稿成果 | 实际数量 / 状态 |
|---|---|
| Part / 正文章 | 10 / 40；另有前言与5附录 |
| 正文汉字 | **33,564**；各章800—1500，排除标题、图注、资源与导航 |
| 原生draw.io / SVG / PNG | 40 / 40 / 40，40张中英文同图 |
| 新增DuneSQL | 18，STATIC_CHECKED；实际执行BLOCKED_READ_ONLY_ACCOUNT |
| API教学与真实调用 | 32份实际HTTP请求/原响应，25种只读类型/方法；2次有界WS会话 |
| 真实案例 | 10个主体案例，含快照与局部事件；另2个接口/状态观察、2个未取得事件，共14主题 |
| 附录 | 5：术语、身份、表、HIP、来源 |

书稿主线为Action→订单簿→撮合→Fill→持仓→保证金→Funding/清算→State，连接同一L1中的HyperCore/HyperEVM，并进入Node/API/Dune。原始资料、正文、代码和审查分开保存。

| 研究成果 | 数量 / 结论 |
|---|---|
| 已取得官方来源 | 67：Hyperliquid文档55，Dune来源12（11文档+1公告）；另1候选URL失败 |
| 已有Dune Query | 12份原SQL及元数据；2个旧执行结果各最多3行，无重跑 |
| 实时Catalog | 20表：7 Perp、5 HIP-4、8 HyperEVM；Oracle表仅官方文档核验 |
| HyperCore模型 | Action/Order/Trade/双侧Fill、账户模式、持仓、Funding、Ledger与Token/Pair分层 |
| HyperEVM模型 | 区块、交易、日志、Trace与系统接口，普通EVM记录不覆盖全部Core活动 |
| HIP-3 | XYZ Meta实取，coin带DEX前缀；Cross/NoCross及独立后备按当前规范 |
| HIP-4 | 当前主网327 Outcome/35 Question快照、Outcome95实际历史结算；创建权限不外推 |

质量分级：正文与工程COMPLETE；技术和金融口径VALIDATED自审；图形完成本地XML、SVG与实际渲染检查；SQL静态检查通过但未经过服务端解析或执行；API真实读取不将unknownOid或空数组改成业务成功；案例检查仅覆盖明确身份、字段和Decimal算术；外部独立技术审查未进行。

本地验收 **31/31 PASS**，1096条本地Markdown引用已检查；案例与金融算术 **82/82 PASS**；1504个已有篇章文件保护哈希未变。首次本地检查包含尚未生成的报告自引用，生成后复验通过。所有通过项均不代替运行权限、全链共识或完整金融模型证明。

图形：统一scene先写原生mxGraphModel，再导出SVG并嵌入原生XML；真实PNG由SVG渲染。5张联系表全图观察，加3张完整尺寸代表图。STHeiti替代字体几何测量无画布文本溢出候选、无节点框重叠。原生编辑器使用自动正交路线，出版SVG使用固定路线；不承诺两者像素相同。桌面CLI代表导出退出134，未产生文件；没有宣称CLI逐图导出或逐图原生编辑器打开。[视觉QA](visual-qa.json)。

案例重点：一笔BTC撮合同时对应买方平空、卖方平多，双侧Fill共享组合身份；一张订单对应两笔Fill但状态返回unknownOid，故不宣称完整成交比例。用户Funding有实际金额，24轮与历史Rate按小时交叉核对。HYPE Spot编号、XYZ Asset映射、Outcome95结算、子账户Ledger与固定EVM收据都有实际来源。HLP及其Liquidator父子身份已确认，但Liquidator30分钟Fill为空，仍未取得真实清算。

| 外部费用与操作 | 本轮记录 |
|---|---|
| Dune | 23个只读MCP调用（含工具目录、不含握手）；新增SQL执行0；读取账单未独立核定 |
| Jev | 0次，0美元；未使用计费不明服务 |
| API / WebSocket | 32次公开匿名只读HTTP、2个短会话；未购买API订阅 |
| S3 | Requester-pays下载0；没有付费归档 |
| 其他 | 未购买服务、部署节点、升级账户、安装额外包或提交任何链上写 |

没有精确总账证据时，不把外部读取扩大声明为全部成本绝对0。旧Result里的Credits属于旧执行，不能计作本轮重跑。

未解决：18SQL未运行；当前具体entitlement与各表首尾/完整性未运行；Oracle表实时Catalog缺口；原始签名Action、Case02终态、真实清算、指定HIP-2、Core/EVM真实资产转移、质押事件链和HLP完整份额会计缺失；未独立全市场OI、Funding全输入重放、历史全簿/全保证金；文档冲突激活日期与所有CoreWriter Action权限未证明；跨抵押FX与外部独立评审未完成。[完整缺口表](../research/unresolved.md)。

[技术审稿](technical-review.md) · [逐章三层审查](chapter-review.json) · [编辑审稿](editorial-review.md) · [SQL审稿](sql-static-review.md) · [金融单位](financial-units-review.md) · [案例索引](../research/evidence_index.md)。

出版注：以上31/31、1096引用和82/82为2026-10-13源工程验收记录；本轮公开范围、离线复验与渲染另见[出版检查](../../../publication/hyperliquid/2026-10-14-v0.1/CHECKS.md)。市场快照及“当前”均指2026-10-13观察时点，作者人工审读 UNKNOWN。
