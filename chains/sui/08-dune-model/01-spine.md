# 08.1 | Checkpoint 与 Transaction 主干

sui.checkpoints 的逻辑粒度是一条 Checkpoint 记录，sequence_number 是需要验证的候选标识。checkpoint_digest 提供哈希身份，epoch 与 timestamp_ms 放置周期和时间。当前 Catalog 还包含 previous_checkpoint_digest、end_of_epoch 和费用、数量摘要列。[Checkpoints](https://docs.dune.com/data-catalog/sui/checkpoints)

sui.transactions 的逻辑粒度是一条事务记录。transaction_digest 连接多个分支，checkpoint 定位所属历史，sender 表达发起主体。is_system_txn、execution_success 与 is_sponsored_tx 等列，帮助限定事务集合；transaction_json 与 effects_json 则提供更详细结构。[Transactions](https://docs.dune.com/data-catalog/sui/transactions)

![先固定事务主干再连接分支](./assets/warehouse-grains.svg)

[编辑原图](./assets/warehouse-grains.drawio)

查询某个日期的用户事务时，应先定义集合：以 date 限定范围，决定是否排除系统事务，再决定是否仅统计成功。统计用户尝试与统计已完成业务，会使用不同成功条件。sender 为 NULL 或异常值时也不能静默替换成新用户。

事务的数量字段需要明确口径。transaction_count、move_calls、created、mutated 等摘要列不应仅凭名字互相换算。尤其不要把 transaction_count 自动当作全部 PTB Commands 数；完整 Command 结构应从 JSON 或官方接口核对。候选键与摘要定义是不同验证任务。

连接 Checkpoint 时，先以 checkpoint = sequence_number 建立路径。如果按 Digest 定位一笔事务，可同时限定合理日期窗口减少扫描。但日期应来自已确认历史位置；猜错日期会把真实记录过滤掉。返回空集时先查时间与覆盖，而不是断言事务不存在。

主干匹配最好先使用 LEFT JOIN。未匹配事务需要按索引延迟、时间窗口、数据缺失或异常键分类。贸然使用 INNER JOIN 会让未匹配记录从结果中消失，用户可能连缺口的规模都看不到。

最终，主干提供的单位是事务，而不是函数调用或对象变化。将其他分支先聚合到 Digest 粒度，再回到这个主干，才适合回答一笔事务含多少调用、产生多少事件、涉及多少对象等问题。

下一步：[对象、调用与事件分支](./02-branches.md) · [模块入口](./index.md)
