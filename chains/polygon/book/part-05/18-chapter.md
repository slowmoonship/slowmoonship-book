# 第18章｜State Sync怎样把消息带到Bor

状态同步可以传递桥接存款，也可以传递其他应用消息。它并不是把Ethereum整个状态数据库复制到Polygon，更不是让两条链共享全部账户余额。它选择特定合约事件，把载荷经过验证与协调后交给Bor上的接收入口，再由目标合约解释。

根链StateSender发出StateSynced类事件，其中的记录标识、接收地址和data共同描述一条消息。Heimdall的Clerk模块保存事件记录，包括来源链交易、日志位置与载荷等信息。这个模块提供的是经过协议处理的消息记录，不等于用户资产已经到达目标地址。

Bor在Sprint边界获取待处理记录，通过StateReceiver提交执行。目标接收合约必须理解载荷并遵守自己的规则。成功提交、目标回调成功与代币余额增加，需要按具体实现检查。若应用接收的是治理消息，结果甚至不涉及代币铸造，所以不能把全部StateSynced事件数量命名为桥接转账次数。

历史上的状态同步还具有特殊的交易与回执表现。PIP-74用0x7f包络规范StateSyncTx，使协议生成的记录能够更规范地进入交易和回执数据。本轮作者历史结果里出现的type 127，与这个类型编号对应；但Dune的字段填充方式属于索引表示，不能据零地址from就称它是普通钱包转账。

系统交易会影响统计分母。计算用户活跃发送者、签名交易数量或Gas支付分布时，要决定是否排除这类协议记录；研究执行覆盖时，则可能需要保留。最稳妥的做法是先按类型单列，再说明口径，而不是在清洗时静默删除所有零地址数据，把重要协议行为一起抹掉。

Zurich进一步处理了历史重放的一致性问题。若状态同步查询只按记录时间、并根据查询时“已经看见”的记录集合回答，后来重放同一历史区块可能得到不同消息。新的可见高度与时间映射规则，目的是让相同链状态下的回答更确定。这种改动直接关系到数据回放，不能只解释为接口提速。

研究消息时，应保存来源事件、Heimdall记录、可见性条件、Bor处理边界与接收合约结果。ID顺序和重复处理保护也很重要：同一消息被多个服务看到，不代表发生多次经济动作。一个状态同步失败样本，不能直接推导为全部桥接资产丢失；需要看实际失败层次和后续恢复。

这一机制还提醒我们，Transaction表只是观察网络的一种方式。用户交易、协议消息与合约回调虽然最终可能出现在相近的执行记录里，其授权来源不同。把它们分别标清，才能在下一章研究反向提款时，看出为什么销毁事件之外还需要检查点和Ethereum退出调用。

![State Sync怎样把消息带到Bor](../../assets/diagrams/state-sync.svg)

[可编辑原图](../../assets/diagrams/state-sync.drawio)


来源与核对：[clerk](https://docs.polygon.technology/pos/architecture/heimdall_v2/clerk.md)；[state-sync](https://docs.polygon.technology/pos/architecture/bor/state-sync.md)；[pip-74-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-74.md)；[pip-89-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-89.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](17-chapter.md) · [下一章](19-chapter.md)
