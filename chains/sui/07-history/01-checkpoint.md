# 07.1 | 包含关系、顺序与最终确认

一笔事务有自己的 Digest，Effects 也有对应承诺。Checkpoint 将这些结果组织成历史批次，并通过序号与前一哈希连接历史。事务被收录后，外部系统可以沿 Checkpoint 验证历史、同步状态或建立索引。

这里要分清三个对象。Transaction Digest 标识事务请求；Effects Digest 标识执行结果承诺；Checkpoint Digest 标识历史批次。它们都是哈希身份，但不能互换。一个 Checkpoint 对应多笔 Transaction，一笔 Transaction 通常被定位到一个历史收录位置。

![结果收录为认证历史](./assets/history-time.svg)

[编辑原图](./assets/history-time.drawio)

最终确认与历史收录具有联系，但不是同一个概念。认证 Effects 可以提供不可逆结果的证据，认证 Checkpoint 也可以承诺其包含的结果。当前生命周期允许在 Checkpoint inclusion 前获得结果确认，因此不能写成未入 Checkpoint 就始终没有确定性。[Life of a Transaction](https://docs.sui.io/develop/transactions/transaction-lifecycle)

认证历史也不自动等于平台显示内容已被逐字核验。Dune 查询结果来自索引与转换层；如果审计需要密码学证明，还应验证 Checkpoint 签名、包含关系和内容承诺。普通 SQL 的成功执行只能证明平台返回了结果，不替代协议历史验证。

顺序有不同层次。Checkpoint Sequence 组织历史批次，批次内位置辅助定位事务；PTB Command Index 则组织事务内部操作。对象 Version 表达状态依赖与演化，也不是全网事务序号。不能根据版本较大就断言它属于比某个不相关对象更晚的业务动作。

验证 Checkpoint 需要正确网络和相应 Epoch 委员会信息。周期边界的历史还承载后续委员会相关数据，使验证能够连续推进。本书不要求读者实现签名校验，但应知道可验证历史具体依赖哪些承诺与信任入口。

查询一笔陌生事务时，保存其 Digest、Checkpoint Sequence、Checkpoint 时间与 Epoch，再核对返回的 Effects 状态。这样可以把结果放进稳定的历史位置，也方便以后使用同一标识复现。只保存浏览器截图里的短 Digest，通常不足以完成这一步。

下一步：[时间与 Epoch](./02-time-epoch.md) · [模块入口](./index.md)
