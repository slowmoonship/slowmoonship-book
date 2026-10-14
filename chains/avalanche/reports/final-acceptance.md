# 最终验收

工程收尾：2026-10-13（Asia/Shanghai）；研究基准日：2026-10-12。

**总体：VALIDATED。** 完整教学书稿、可编辑图形、真实有限样本和自动检查已经交付；新 SQL 没有执行，部分原始、管理端及目标通信证据仍有明确缺口。不是只有目录或样章，也不强行将全部分项标为 COMPLETE。

## 书稿成果

路径：`chains/avalanche`。

| 成果 | 数量 / 状态 |
|---|---|
| Part / 正文章 | 10 / 40 |
| 40 章正文汉字 | 34,604 |
| 前言汉字 | 749 |
| 正文含前言 | 35,353；不含附录、图注与源台账 |
| draw.io / SVG / 完整渲染 PNG | 40 / 40 / 40 |
| DuneSQL | 10，STATIC_CHECKED，实际新执行 0 |
| RPC / JSON 教学样本 | 15 份真实请求响应 |
| Python | 1 份离线取证与计算脚本 |
| 真实案例 / 不同交易 | 9 组 / 12 笔 |
| 附录 | 5 项；术语、链身份、数据源、交易类型、引用 |

汉字数按章节正文中汉字字符计，含叙述与实证片段；示例中的哈希、英文和原始数字不计汉字。不是凭字节数推估。

## 研究成果

40 项完整有效官方来源，33 项重要事实索引。主线协议包括 Banff、Cortina、Durango、Etna/ACP-77、ACP-99、Fortuna、Granite/ACP-181 与 Helicon/ACP-194；不编造未来激活。当前 C-Chain 的 CE 与 Subnet-EVM L1 同步执行分开，旧 Coreth 文档冲突明确处理。

实际核对 Dune 的 avalanche_c 9 表，以及 tokens.transfers、tokens.erc20、tokens.supply_latest、dex.trades 和 4 张相关 Teleporter call/event 表。Catalog 证明字段，不单独证明所有 SQL 可运行或全历史实时覆盖。P/X JSON-RPC 与官方 Data API 返回结构和单位保留。

高价值证据：C→P Export/Import 的共同 Atomic UTXO，Import 输出到委托的后续消费；X 多输入多输出明细；Beam 创建、转换、管理位置、注册及区块/收据；真实 ICM 源侧历史事件。每案原始来源与缺失字段在案例 JSON 中。

## 验收矩阵

| 分项 | 等级 | 实际检查与限度 |
|---|---|---|
| 全章与目录 | COMPLETE | 40 章、10 Part、连续编号、正文与图源均存在 |
| UTF-8 / JSON | COMPLETE | 可解析；4 处正文 JSON 节选也验证 |
| 本篇 Markdown 本地引用 | COMPLETE | 自动检查；原始官方快照保留上游链接，不混作自写正文 |
| 外部来源 | VALIDATED | 核心页面实际读取并归档 SHA；没有穷举上游全部深层链接 |
| draw.io / SVG | COMPLETE | XML、ID 唯一性、边引用、尺寸与内嵌源一致性 |
| 实际视觉渲染 | COMPLETE | 40 张完整 PNG；尺寸对齐；逐张视觉自审 |
| 原生 draw.io 桌面交互 | VALIDATED | 未执行，不声称桌面导出成功 |
| SQL 静态字段与语义 | VALIDATED | 本轮 Catalog 支持；人工口径审查；不冒充完整引擎解析 |
| SQL 新执行 | BLOCKED | 用户给定只读边界；不试探权限，无执行请求 |
| API 响应与有限样本 | VALIDATED | 26 个成功读取响应；失败与限流记录分开；没有全网覆盖保证 |
| 离线案例关联 | COMPLETE | 9 项身份、方向、单位及消费关系检查通过 |
| 技术事实与编辑自审 | VALIDATED | 40 章三层自审表；核心源核对；不是外部独立专家评审 |

自动运行结果见 [validation.json](validation.json)；案例计算见 [case-checks.json](case-checks.json)。唯一明确警告是 Case 08 历史 Dune 结果没有返回区块高度，缺口保留。核心数据与图形文件本轮均已实际存在和检查。

## 费用与边界

Dune 工具目录与只读数据请求共 13 项，12 项取得结果、1 项 HTTPError；初始化握手不作为内容请求计。读取三份已完成历史结果，无新执行、新建 Query、Dashboard 变更或刷新。历史 executionCostCredits 不计为本轮新执行费用，读取配额金额未独立核算。

Jev 调用 0，消耗 0 美元。官方链/API 有界请求 35 项，26 成功、9 错误/限流；使用公开接口，无新付费套餐/密钥。文档快照请求独立记录。没有购买、充值、付款、钱包签名、链上写操作、发链、部署或新服务器；现有其他书稿、thaw.fun 与远端看板只读。

## 剩余证据缺口

1. 新 DuneSQL 执行与 Helicon 后数仓字段逐笔收据对账。
2. C 原始完整收据/Logs/Trace 与历史余额；X 独立费用字段验证。
3. Beam 管理初始化与完整权限/升级、注册生命周期全部分支。
4. ICM Case 08 的签名材料、目标接收/执行和最终业务状态，以及源高度补齐。
5. 所有 L1 的完整覆盖、长期健康与现实运营者归因，本篇没有据有限样本输出这些结论。

这些缺口均已进入 [unresolved](../research/unresolved.md)，不会以虚构哈希、响应或执行结果填补。后续更新可继续补原始证据；本轮书稿工程已经完整落盘。

出版注：以上为原稿验收，原始文档快照与生成工程留在本地；公开范围见 [v0.1出版清单](../../../publication/avalanche/2026-10-14-v0.1/FILES.md)。作者人工审读 UNKNOWN；工程编辑自审不视为作者已人工审读。
