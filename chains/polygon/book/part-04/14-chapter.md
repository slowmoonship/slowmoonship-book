# 第14章｜2026年的费用和故障恢复规则

2026年的Polygon不能只用“比以前快了”概括。费用参数变得更可配置，区块头增加可观察字段，部分操作重新定价，Heimdall还改进了确定性与故障恢复。它们分别改变计算、数据解释和运行边界。把这些变化压成一条TPS增长曲线，会漏掉真正影响分析的细节。

Lisovo主网Bor高度为83,756,500。PIP-79允许对EIP-1559参数进行受边界约束的配置，PIP-81列出此次升级相关内容。研究者因此不能永远假定固定目标比例和分母。要重建某块Base Fee，应查看相应版本和实际参数；只从当天平均Gas价格倒推生产者选择，容易混入交易需求的变化。

Giugliano的发布公告和Bor配置把主网高度写为85,268,500，而本轮取得的PIP-84正文仍写85,245,000。这里不能默默选一个数字。书稿采用客户端配置与发布公告一致的高度，同时在时间线保留冲突。PIP-83增加Gas参数头部记录与RPC可见性，PIP-66重新引入早期区块公告能力。

Chicago也必须进入本轮研究范围。PIP-88规定在Bor高度87,218,600重新定价部分存储访问、运算和预编译操作。相同业务跨升级后消耗的Gas可能变化，不能仅凭费用增加就认定合约变低效或网络更拥堵。比较前后成本，应同时查看Gas Used、有效单价和调用内容。

Zurich作用于Heimdall，其主网激活维度是Heimdall高度47,880,000。重点包括让状态同步查询更确定、生产者与Milestone选择更一致，以及限制共识关键处理工作。gRPC传输、端点故障切换和桥接恢复等同版本功能，还要区分哪些受高度开关控制，哪些是节点配置或运行改进。

Ithaca的主网Heimdall高度为50,185,000，官方上线文章发布于2026年7月30日。PIP-90描述生产者停顿且Milestone待定时的Span恢复规则。把这个高度当作Bor高度会得到错误历史；把发布文章日期当作区块精确时间，也会丢掉激活时间与公告时间的区别。

截至基准日，官方发布列表还出现Bor v2.10.3等稳定性更新。发布新二进制不一定触发新硬分叉，也不意味着每个RPC已经升级。较新的验证者准入与奖励分配提案，需要核对治理执行，不能仅凭存在提案就宣布已在链上启用。本篇保留这种状态差别，而不编造后续升级。

继续检查官方发布列表，还发现Bor的Valencia与Austin，主网高度分别为89,531,000和91,949,700；Heimdall的Phuket、Kyoto与Lugano也在基准日前出现。Lugano发布说明确认主网于2026年10月1日在Heimdall高度54,627,000激活，强化检查点窗口和消息验证等边界。它们已列入时间线；未取得精确激活日或完整改动复核的条目保留缺口，不能因任务清单没有列出就忽略。

本章采用版本化的解释方式：先确定研究高度，再查当时生效的规则，最后计算指标。激活日没有精确原始区块时间的条目，会保留日期核验缺口。这样既能解释当前网络，也能尊重历史案例原有的执行环境，让2024年的交易不会被2026年的规则重新命名成另一种行为。

![2026年的费用和故障恢复规则](../../assets/diagrams/upgrade-2026.svg)

[可编辑原图](../../assets/diagrams/upgrade-2026.drawio)


来源与核对：[pip-79-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-79.md)；[pip-84-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-84.md)；[pip-88-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-88.md)；[pip-89-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-89.md)；[pip-90-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-90.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](13-chapter.md) · [下一章](15-chapter.md)
