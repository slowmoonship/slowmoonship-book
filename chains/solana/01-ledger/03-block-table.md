# 01.03 用区块表观察网络

要知道一天有多少非投票交易，是否必须扫描一天的全部交易？若只研究网络总体，区块表已有合适的计数字段，可以先从更小的粒度层级开始。

`solana.blocks` 的一行是一个区块。`total_transactions` 包含投票和非投票交易，`total_non_vote_transactions` 只计非投票部分，成功和失败也分别有对应字段。查询之前写清楚分母，就能避免把投票增长误读为应用需求增长。

现有 Query 8435308 先筛完整 UTC 日期，再把块级计数按日相加。它的 `block_count` 是区块行数，`transaction_count` 是非投票交易计数之和，两者不应互换。Query 8435334 再从该日级结果挑出交易活动和失败率。这个设计复用了已经建立的口径，保留了从日级图回到块级事实的路径。

失败率通常定义为失败交易数除以总交易数。分母中必须包含成功和失败，而不能只用成功交易数；没有观察记录时则应该保留无法计算的状态。SQL 用 `NULLIF` 避免除以零，得到 NULL 不等于失败率为零，也不等于链停了。

还要区分“记录数量”与“业务价值”。非投票交易可以包括机器人、账户维护和多种程序操作；一次换币也可能只是其中的一笔。这个指标适合描述账本负载，不足以独立证明用户数量、协议收入或资金流入。

下面保留已有查询的统计思路，把窗口缩短到两天。它是教学改写，不能把历史原查询的执行状态转移过来。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT date,
       COUNT(*) AS observed_blocks,
       SUM(total_non_vote_transactions) AS non_vote_transactions,
       SUM(total_vote_transactions) AS vote_transactions,
       CAST(SUM(failed_non_vote_transactions) AS double)
         / NULLIF(SUM(total_non_vote_transactions), 0) AS failure_rate
FROM solana.blocks
WHERE date >= DATE '2026-10-06'
  AND date <  DATE '2026-10-08'
GROUP BY date
ORDER BY date
```

日级结果已经不再是一块一行。若把它 JOIN 回所有指令，再求交易数量之和，同一天的计数就会被重复。聚合改变了粒度，之后每次关联都必须重新检查关系。

看板还用相邻已产出区块的时间差估计观测间隔。这个间隔受区块时间的精度、跳过机会和窗口起点影响，不等于理想 Slot 时长。先把它称为“观察到的区块间隔”，结论才与计算保持一致。下一步，我们会离开总体统计，进入一笔交易的内部。

![用区块表观察网络](./assets/block-to-tables.svg)

[编辑原图（draw.io）](./assets/block-to-tables.drawio)

参考来源（核验日期：2026-10-09）：

- [Dune 区块表](https://docs.dune.com/data-catalog/solana/blocks)
- [Dune 交易表](https://docs.dune.com/data-catalog/solana/transactions)

<!-- NAV -->

[总目录](../README.md) · [上一章：时间与确认程度](02-time-finality.md) · [下一章：先固定坐标，再讨论行为](summary.md)
