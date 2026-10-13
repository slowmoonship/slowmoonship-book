# 09.3 | 追踪一个对象的历史

案例 C 使用 B 中的 Shared Pool：`0x0df4f02d0e210169cb6d5aabd03c3058328c06f2c4dbb0804faa041159c78443`。其完整 Type 表明资产参数包含 SUI 与本例 USDC，池状态还包含储备、价格、tick 和费用等字段。这里追踪的是一个复杂业务对象，不能只观察钱包名下 Coin。

官方对象版本接口返回最早五个版本：426673878、426674000、426674004、426674005、426674009。它们属于不同事务与 Checkpoint，Owner 都显示 Shared。相邻版本并不都加一，实际记录直接展示了版本跳跃。

![从对象版本回到事务](./assets/sql-route.svg)

[编辑原图](./assets/sql-route.drawio)

我们进一步读取首个版本对应事务 `HVBtju4rFc2wgDxb1qnEMDgxsAp3gbF4ttxG1Wuq4U7M` 的 Effects。该对象输入状态为不存在，ID 操作为 CREATED，输出为 Shared，明确证明创建。这个证据将生命周期起点放在 2024-11-23，不能只因它是第一页第一行就判断创建。

第二个版本的储备与首个不同，同时关联新的 previousTransaction。这里的 previousTransaction 表示产生这个状态的相关事务，不是全网时间上紧挨的一笔事务。把它连回 Effects，才能解释具体变化。

回到 B，我们另取 Pool 的输入版本 975858934 与输出版本 975858935，比较精确内容。coin_a 增加 5,635,794,816，coin_b 减少 4,697,819；与该池 Event 的原始数量一致。该对象保持 ID 与 Shared 归属，价格及费用字段也改变。Shared Pool 的状态追踪应尊重这种业务模型，不能为了展示转移而虚构 Owner 变化。

Dune 的 [06 SQL](./sql/06-pool-history.sql) 查询 2024-11-23 的这段早期版本切片，保留 Version、状态、previous_transaction 与 object_json。它静态核对字段但未执行。日期范围和版本界限让查询有界，也限定了能支持的结论。

官方版本页的 hasNextPage 为 true，说明五个版本之外仍有历史。我们没有遍历全部生命周期，也没有证明它从未包装或删除。完整追踪需要继续分页、核对输出状态并记录结束条件；局部证据只支持所观察的历史切片。

这个过程把两张地图连成一个闭环：从事务找到对象，从对象版本找到下一相关事务，再把执行结果放回 Checkpoint。对象历史因而不只是版本列表，而是一组具有输入、输出和业务解释的状态转换证据。

下一步：[复用已有 Query](./04-existing-queries.md) · [案例证据](../references/verified-transactions.md)
