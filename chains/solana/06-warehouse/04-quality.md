# 06.04 时间窗口与质量核验

SQL 成功返回一张表，只说明引擎完成计算，不说明指标已经可信。质量核验要检查对象身份、覆盖、时间、单位与关联，而不只是看图形是否平滑。

先固定数据范围：网络、时间区间、UTC 或本地时区、成功状态、投票是否纳入、地址或协议筛选。LIMIT 限制返回或样本大小，不保证扫描免费；更不能把 LIMIT 10000 当成随机全网样本。大表查询要使用确认的时间分区与选择性条件，新增执行之前还需判断额度。

接着验证粒度。交易的 id、调用的复合位置键、账户活动的 `(tx_id,address)` 都是候选身份，不应直接宣布数据库有相应唯一约束。检查空 identity、重复组和关联匹配次数，才能知道一份结果是否符合你假定的一行含义。`approx_distinct` 可以估算规模，不能证明精确唯一性。

覆盖检查有两侧。RPC 查不到记录，可能受确认程度、历史保留或版本兼容影响；Dune 查不到则还可能是更新延迟和模型覆盖。新版本 v1 已在此次 RPC 区块实测到，但 Dune 对它的支持未实测。近实时窗口与完整历史日应分开比较，空结果不能自动解释成零业务。

金额质量还需检查单位、NULL 与极端值。Token raw 与 display 不能混算，USD 缺值要报告覆盖率，不能全填零再把总量称为完整美元成交量。一个极大池段值也应回到交易与价格核查，不应仅因数据格式合法就直接进入结论。

下面先检测短窗口中是否有交易 identity 重复组。这种检验只覆盖当前窗口，不替代全表或未来版本保障。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT id, COUNT(*) AS rows_per_id
FROM solana.transactions
WHERE block_date = DATE '2026-10-07'
  AND block_time >= TIMESTAMP '2026-10-07 00:00:00'
  AND block_time <  TIMESTAMP '2026-10-07 00:01:00'
GROUP BY id
HAVING COUNT(*) > 1
LIMIT 20
```

返回零重复组只有在确认查询执行成功与范围完整时，才支持“这个窗口未观察到重复”。本篇只提供静态检查版本，因此没有填写结果。下一模块会对三个真实案例应用这套方法，分别注明 RPC 已观察和 Dune 尚未交叉核验的部分。

![时间窗口与质量核验](./assets/join-fanout.svg)

[编辑原图（draw.io）](./assets/join-fanout.drawio)

参考来源（核验日期：2026-10-09）：

- [Dune Transactions](https://docs.dune.com/data-catalog/solana/transactions)
- [Dune Instruction Calls](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [Dune Account Activity](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune DEX 数据模型](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)

<!-- NAV -->

[总目录](../README.md) · [上一章：数组、索引与空值](03-arrays.md) · [下一章：一条能解释自己的查询](summary.md)
