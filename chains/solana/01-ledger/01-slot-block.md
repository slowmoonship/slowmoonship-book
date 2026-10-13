# 01.01 Slot 为什么不等于 Block

假设区块表中的 Slot 依次为 100、102、103。缺少 101，是否说明数据丢了？答案不能仅由这三行决定。先要知道 Slot 和 Block 分别代表什么，再判断数据源是否完整。

Slot 是带编号的出块机会。网络安排领导者（Leader）在相应机会中产出区块；这不保证每个机会都在最终链上形成一个块。Block 则是实际产出的账本对象，包含交易并引用前序关系。图中把 Slot 101 留空，只是展示“机会与结果不一一对应”，不是对真实编号做缺块认定。

区块高度统计的是沿链形成的块，而 Slot 编号还包含没有留下最终链区块的机会。因此 Slot 的跨度可能大于同一段链的区块数量。不要用 `MAX(slot)-MIN(slot)+1` 代替区块行数；那个差值是编号范围，`COUNT(*)` 才是在当前表与窗口下观察到的块记录数。

这一区分还影响关联方式。Dune 交易表的 `block_slot` 对应区块表的 `slot`；`block_height` 对应高度。优先使用被明确说明的身份字段连接，不要因为数字看起来相近就把高度和 Slot 连在一起。时间戳则可能被许多交易共享，更不适合当作主键。

缺少一行至少有几种可能：该 Slot 没有最终链区块、观察窗口没有包含它、索引延迟，或数据覆盖不足。要判断具体原因，需要 RPC 的区块可用性、节点历史保留范围和仓库覆盖证据。RPC 查询不到一个老块，也可能是提供者没有保留那段历史，不能单凭空结果证明网络曾经跳过该 Slot。

下面的 SQL 查看一段时间内被索引的块，而不对缺号自动分类。读结果时把 `parent_slot` 当作父块关系，别要求它总等于 `slot-1`。沿最终链的父子关系可以越过没有块的时隙。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT slot, height, time, parent_slot
FROM solana.blocks
WHERE date = DATE '2026-10-07'
  AND time >= TIMESTAMP '2026-10-07 00:00:00'
  AND time <  TIMESTAMP '2026-10-07 00:01:00'
ORDER BY slot
LIMIT 20
```

查询回答“窗口内观察到了哪些区块坐标”。它不回答全网跳过率，也不估计每个 Slot 的精确持续时间。位置弄清楚之后，还要解释这些块所附的时间究竟测量了什么。

![Slot 为什么不等于 Block](./assets/ledger-coordinates.svg)

[编辑原图（draw.io）](./assets/ledger-coordinates.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana 术语](https://solana.com/docs/references/terminology)
- [Dune 区块表](https://docs.dune.com/data-catalog/solana/blocks)
- [RPC getBlock](https://solana.com/docs/rpc/http/getblock)

<!-- NAV -->

[总目录](../README.md) · [上一章：把一笔行为放回账本](index.md) · [下一章：时间与确认程度](02-time-finality.md)
