# 02.1 | Sender、签名、Gas 与有效期

Transaction 的外层安排，与 PTB Commands 是不同层。当前 Rust 实现的 `TransactionDataV1` 包含 `kind`、`sender`、`gas_data` 和 `expiration`。普通 PTB 位于 Transaction Kind 内部。签名授权这份 Transaction Data，但不是其中一条 Command，也不是 PTB Input。[Sui transaction.rs](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/transaction.rs)

Sender 回答谁发起请求。Object Owner 回答对象如何被访问，Gas Owner 回答谁承担费用。普通用户操作中三者经常相关，但不能因此将它们视为同一主体。Sponsored Transaction 中，用户请求动作而赞助方支付费用，需要相应授权。

![外层请求与内部数据流](./assets/ptb-flow.svg)

[编辑原图](./assets/ptb-flow.drawio)

Gas Data 包含支付来源、费用所有者、Gas Price 和 Gas Budget。Budget 是费用上限安排，Price 是单位 Gas 价格，二者不能与最终费用混用。分析实际成本应读取执行后的费用记录，核对计算费、存储费和返还项，不能直接把预算求和当作用户支出。

支付来源也不能一概写成“永远有一枚 Gas Coin”。Coin payment 可以包含多枚 SUI Coin，执行过程中可能发生 Gas Smashing。当前地址余额支付可以使用空 payment 列表，从费用承担者的 SUI Address Balance 支付。是否包含 Gas 对象变化，取决于支付模式与实际执行。[Paying for Transactions](https://docs.sui.io/develop/transaction-payment/)

Expiration 给请求设置有效边界。不设置期限、按截止 Epoch，或使用具有最小和最大 Epoch 的 ValidDuring 窗口，是不同情况。窗口不是钱包展示的秒级倒计时。当前 main 源码还包含带提议者范围约束的 Validity 变体，其网络启用需另核对 ProtocolConfig。地址余额 Gas 场景有相应有效期与防重放要求，本节不是全部格式的穷尽清单。

签名证明授权，不能仅凭 Sender 字段就证明一个现实中的人执行了操作。多签、赞助与其他身份机制会影响授权形式。数据分析通常先使用链上地址标识主体，再把现实身份归因作为独立证据问题。

检查陌生事务时，先记录网络、完整 Digest、Sender、Transaction Kind、费用承担者、预算与有效期。再进入 PTB 检查 Commands。这样既能避免把 System Transaction 当成用户动作，也能在业务分析与费用分析之间保持正确主体。

下一步：[Inputs 与 Result Flow](./02-result-flow.md) · [模块入口](./index.md)
