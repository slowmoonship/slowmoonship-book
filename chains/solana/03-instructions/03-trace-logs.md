# 03.03 调用顺序、深度与日志

一条内层指令知道自己归属顶层指令 2，就知道是谁直接调用它了吗？仍不知道。顶层归属提供一组执行范围，直接父节点还需要深度与顺序来恢复。

RPC 将内部调用按对应顶层指令组织。Dune 展开后保留 outer、inner 索引，以及 `stack_height`。顶层通常处在深度 1，直接 CPI 处在深度 2，更深嵌套继续增加。图中的 A→B→Token Program 是概念示意；它说明同一个 outer 之下仍可能有不同的直接调用者。

在有完整顺序与深度的单组轨迹中，可以用栈理解关系：读到深度增加的调用，进入新的子层；回到较浅深度时，前一个分支结束。若只用 `outer_instruction_index` 将所有 inner 连向顶层，画出来的是归属星形图，不能把它称为完整调用树。内部索引也不是跨全链唯一键，必须连同 tx_id 和 outer 使用。

字段缺失会限制重建能力。旧历史或索引过程可能没有完整 stack height、日志或内部记录；NULL 不等于深度 0，也不一定意味着没有 CPI。索引从 0 还是 1 开始同样应对照实际数据，而不是照搬 DuneSQL 数组的习惯。查询时保留原索引即可排序，不需要凭空偏移。

日志记录程序输出和运行时调用信息，可帮助辨认开始、结束、报错与 CU 消耗。但程序可以写任意文本，日志可能截断，内容也有版本变化。它是执行证据的一部分，不是每个协议都遵循的统一事件格式。研究成交或授权变更时，应以解码和状态字段建立判断，再用日志补充解释。

计算单位描述执行资源，不能直接视为毫秒。较多 CU 可能来自复杂计算或账户处理，但网络等待、调度和确认需要其他观测。看板的 Program Activity 按调用行统计执行者；它与按 CU 统计资源消耗也是不同口径。

下面用主网路由案例的 identity 查看仓库轨迹；日期对应缓存区块的 UTC 日期，但 Dune 是否已收录尚未验证。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT outer_instruction_index, inner_instruction_index,
       stack_height, is_inner, executing_account, tx_success
FROM solana.instruction_calls
WHERE block_time >= TIMESTAMP '2026-10-09 11:26:00'
  AND block_time <  TIMESTAMP '2026-10-09 11:27:00'
  AND tx_id = '3d5V1UTKTAB6uAD7GAd2Rv9o9nFNm9X5pfr3uebL93LxDT91RrHR2ndtJBbPmNttvSDG1TgXGUdLCcdpWxKgiztQ'
ORDER BY outer_instruction_index, inner_instruction_index NULLS FIRST
```

查询返回零行时先检查更新延迟与覆盖。下一章会保留这些身份字段，把不易读的字节变成具体动作。

![调用顺序、深度与日志](./assets/cpi-tree.svg)

[编辑原图（draw.io）](./assets/cpi-tree.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana CPI](https://solana.com/docs/core/cpi)
- [Dune 指令调用表](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [RPC JSON](https://solana.com/docs/rpc/json-structures)
- [计算预算](https://solana.com/docs/core/fees/compute-budget)

<!-- NAV -->

[总目录](../README.md) · [上一章：CPI 是调用，不是新交易](02-cpi.md) · [下一章：从字节到可读动作](04-decoding.md)
