# 附录A｜术语表

| 中文 / English | 本篇含义 |
|---|---|
| 一层链 / Layer 1 | 具有自身共识与状态执行的网络 |
| HyperBFT | 受HotStuff家族启发的共识，不能与EVM执行互换 |
| 验证者 / Validator | 参与提议与确认，权重依质押规则 |
| 法定权重集合 / Quorum | 当前官方质押规范中的超过三分之二质押权重集合 |
| 轮次 / Round | 共识推进单位，不等于EVM区块编号 |
| 执行高度 / Height | L1执行区块的编号体系 |
| 最终性 / Finality | 在协议安全假设下已提交历史不由正常共识改写 |
| HyperCore | 原生金融执行，包括簿、撮合与风险状态 |
| HyperEVM | 同一L1中的通用EVM合约环境 |
| 状态转换 / State transition | 依规则从前态计算后态 |
| 操作 / Action | 进入协议的用户或系统操作 |
| 订单 / Order | 限定方向、数量、价格与执行条件的交易意图 |
| 订单编号 / oid | 订单业务身份，跨来源仍需核对范围 |
| 客户端编号 / cloid | 用户追踪订单的编号，不是经济成交身份 |
| 成交 / Trade | 撮合形成的经济事件 |
| 用户成交腿 / Fill leg | 某一参与账户的成交记录 |
| 成交标识 / tid | 官方WS建议结合coin与事件时间使用，不单独宣称全局唯一 |
| 买盘 / Bid | 等待买入的意图 |
| 卖盘 / Ask | 等待卖出的意图 |
| 最优价 / Best bid / ask | 当前最有利的买卖等待价格 |
| 点差 / Spread | 指定最优买卖价格之间的距离 |
| 深度 / Depth | 指定价格范围内的等待数量或名义金额 |
| 中价 / Mid | 最优买卖价平均，不保证可成交 |
| 数量精度 / Lot size | 允许的订单数量步长或最小可交易数量 |
| 价格约束 / Tick rules | 价格有效数字与小数位规则 |
| 等待侧 / Maker | 提供等待流动性的成交角色 |
| 主动侧 / Taker | 与等待流动性相遇的角色 |
| GTC | 合规未成交余量可继续等待 |
| IOC | 立即成交后终止余量 |
| ALO / Post-only | 只挂单意图，不按普通跨簿路径立即吃单 |
| 部分成交 / Partial fill | 一张订单的一部分被执行 |
| 撤单 / Cancel | 终止未执行意图，不删除已发生历史 |
| 触发订单 / Trigger order | 条件满足后进入相应执行路径 |
| TWAP | 随时间切片的执行计划；父、子订单、Fill分别统计 |
| 只减仓 / Reduce-only | 限制不得按规则增加敞口 |
| 基础资产 / Underlying | 合约参考的价格对象，不自动交付所有权 |
| 永续 / Perpetual | 无普通到期日的合约，仍可能停止与行政结算 |
| 多头 / Long | 有符号仓位为正的价格敞口 |
| 空头 / Short | 有符号仓位为负的价格敞口 |
| 反手 / Position flip | 成交跨过零仓位并建立另一方向 |
| 名义价值 / Notional | 数量按指定价格估值，不等于现金本金 |
| 入场价 / Entry price | 持仓会计参考，可能由多次成交形成 |
| 未实现盈亏 / Unrealized PnL | 未平部分按指定价格估值的结果 |
| 已实现盈亏 / Realized PnL | 关闭部分的会计结果，不包含所有账户现金流 |
| 未平仓量 / Open interest | 时点站立敞口，必须声明单双边与估值规则 |
| 全仓 / Cross margin | 适用集合共享抵押与权益 |
| 逐仓 / Isolated margin | 指定仓位及资金与其他范围隔离 |
| 严格逐仓 / Strict isolated | 还具有保证金移除限制 |
| 初始保证金 / Initial margin | 开仓及相应维持操作的资金要求 |
| 维持保证金 / Maintenance margin | 持仓继续满足的风险底线 |
| 权益 / Equity | 风险账户价值，不同模式有不同范围 |
| 标记价 / Mark price | 风险与未实现盈亏的估值参考 |
| 预言机价 / Oracle price | 规定的参考价格，资金费使用其名义估值 |
| 冲击价 / Impact price | 规定规模穿过订单簿的平均执行价格 |
| 市场清算 / Market liquidation | 风险触发后尝试在簿上处置 |
| 后备接管 / Backstop liquidation | 接管适用仓位与资金的风险路径 |
| 自动减仓 / ADL | 在适用条件下强制减少盈利对手方敞口 |
| 资金费率 / Funding rate | 无量纲结算率，区别预测、当前与历史 |
| 资金费用 / Funding payment | 真实持仓结算现金流，不计作普通成交 |
| 返佣 / Maker rebate | 指定Fill负费用，不自动代表整体交易盈利 |
| 部署者费用 / Deployer fee | 市场运营相关费用分配，检查是否已包含 |
| Builder code | 应用入口费用相关标识，区别HIP-3市场部署者 |
| HIP-1 | Core原生有上限供应Token与Spot结构 |
| HIP-2 | 在共同订单簿上执行的协议流动性策略 |
| HIP-3 | 部署者建立的Perp DEX与市场 |
| HIP-4 | 全额抵押、有界结果支付的Outcome原语 |
| 现货 / Spot | 实际Token数量交换，区别永续敞口 |
| Token Index | 资产编号，区别Pair Index |
| Spot Pair Index | 基础与报价资产订单簿编号 |
| Asset ID | Action的产品编码，按不同类别使用不同编号域 |
| Wei Decimals | 原始整数与可读Token数量的缩放精度 |
| Size Decimals | 市场订单数量允许的小数精度 |
| Outcome | 一个有结果支付规则的市场及两侧Token |
| Question | 互斥Outcome集合，按定义恰有一个Yes |
| Settle fraction | Yes对应的报价支付比例，No为其补数 |
| Read Precompile | 从EVM读取指定Core状态的协议接口 |
| CoreWriter | EVM表达Core后续操作的系统入口 |
| 系统交易 / System transaction | 与Core交互相关的特殊EVM处理记录 |
| Vault | 自身执行策略、出资人通过份额参与的账户结构 |
| HLP | 多策略协议Vault，不是固定收益产品 |
| 委托 / Delegation | 将HYPE质押权重关联到验证者 |
| 退出队列 / Unstaking queue | 从Staking退回Spot的等待状态 |
| 粒度 / Grain | 数据一行对应的业务对象 |
| 快照 / Snapshot | 一个观察时点的状态 |
| 增量 / Delta | 指定语义的状态变化，不能与完整快照混用 |
| 血缘 / Lineage | 原始输入、加工与指标之间的来源链 |
| Curated | 经过规范化、分类或汇总的数据 |

完整版本边界与来源见[附录D](hip-standards.md)及[附录E](references.md)。


[目录](../../SUMMARY.md) · [上一章](../part-10/40-reconstruction.md) · [下一章](market-identifiers.md)
