# 05.2 | Address Balance、费用与余额核对

当前地址余额模型允许资金直接计入协议管理的累加器。对于某个地址与 Coin Type，余额值不要求表现为一枚拥有 ID 的 Coin。资金提取后仍可转换为 Coin，交给需要 Coin 参数的 DeFi 函数。两种表示能够在同一业务流程中衔接。

本书使用的总余额口径是：同一地址、同一资产、同一观察时点的存活 Coin 余额之和，加上该地址的 Address Balance。它不自动包括地址控制的应用对象、托管账户或资产估值。扩大范围时需要单独定义主体与资产权利。[Using Address Balances](https://docs.sui.io/onchain-finance/asset-custody/address-balances/using-address-balances)

![总余额需要合并正确范围](./assets/asset-balance.svg)

[编辑原图](./assets/asset-balance.drawio)

Effects 中的累加器操作与普通 Move Event 是不同层。累加器 Merge/Split 记录协议资金变化，结算机制再组织相应状态。不能因为业务 Event 表没有记录，就断言地址余额没有改变；也不能只查询 Coin 对象输出就声称还原了全部资金变动。

费用核对同样应以 Effects 为入口。当前 `GasCostSummary` 的净 Gas 使用量采用计算费加存储费再减存储返还。`non_refundable_storage_fee` 需要按实现与返回语义解释，不能看见另一列就再次机械加到已经计算的净额里。净值可能因存储返还而为负，负数不必然是坏数据。[gas.rs](https://github.com/MystenLabs/sui/blob/main/crates/sui-types/src/gas.rs)

Gas Budget 是上限，最终费用是结果。费用承担者也可能与 Sender 不同。一笔 SUI 转移中，接收人收到的金额、发送人的净变化和赞助方费用，应分别核对；它们的和只有在明确币种、主体、返还及全部资金出口后，才适合做守恒检查。

地址余额付款可以没有显式 Gas Coin payment。当前协议也有满足特定规则的零费用稳定币转移。它是限定场景，不能推广成“所有稳定币操作免费”或“Gas Price 永远大于零”。本书不靠 Gas 对象是否存在判断事务是否有效，而以实际支付模式和 Effects 为准。

六张 Dune 基础表有对象余额与 Effects JSON 等线索，但 Catalog 不能证明它已完整展开最新累加器变化。完整资金核对需要验证这些字段覆盖，必要时读取官方接口的派生余额变化，并登记派生方法、版本和边界。

下一步：[模块总结](./summary.md) · [模块入口](./index.md)
