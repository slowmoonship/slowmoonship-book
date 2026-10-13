# SUI 05 | SUI, Coin and Balance

## 一个地址有多少资金，为什么不能数 Coin？

假设 Alice 拥有两枚 SUI Coin，一枚有 2 SUI，另一枚有 3 SUI。她可以把它们合并成一枚 5 SUI Coin，也可以再拆成五枚。资产数值没有因此增加或减少，对象数量却改变了。Coin Object 数量适合观察资金组织方式，不能直接表示金额。

`Coin<T>` 是带对象身份的同质资产容器。T 识别币种，内部 Balance 表示数量。同一 T 的不同 Coin 可以持有不同数值，价值单位可以互换，对象身份却各不相同。`Balance<T>` 自身没有 Coin 那样独立的 UID，可放在 Pool 或其他业务结构中。[Coin Standard](https://docs.sui.io/onchain-finance/fungible-tokens/coin)

![Coin、Balance 与地址余额](./assets/asset-balance.svg)

[编辑原图](./assets/asset-balance.drawio)

SUI 是网络原生资产，最小单位为 MIST，1 SUI 等于十亿 MIST。其他币种使用自己的精度。分析时保存原始整数，再依据经过核验的 decimals 转换显示；不能用 SUI 的精度处理所有 Token，也不能仅凭 Symbol 判断币种身份。

当前 Sui 还支持 Address Balance。它按地址与 Coin Type 维护协议累加器值，不是一枚由地址拥有的普通 Coin Object。Coin 与地址余额可以共存。相同地址、相同 T、相同时点的总余额，需要将当前 Coin 余额之和与 Address Balance 合在一起。[Address Balances](https://docs.sui.io/onchain-finance/asset-custody/address-balances)

这项变化对数据分析很直接。某次资金转移可能没有给收款人创建新的 Coin；资金可能进入地址累加器。DEX 函数仍可能要求 Coin 输入，因此钱包在 PTB 中从地址余额提取 Coin，再交给函数。资金来源与合约参数形式不能互相替代。

我们在 Runtime Map 中画 Coin 输入，是为了讲清一笔混合对象 Swap，并没有断言所有 SUI 都必须存在独立 Coin 中。对同一资产，还应区分地址直接持有、业务对象内部 Balance、托管结构和池储备等口径。把所有对象里的数值一起归到 Sender，往往会把协议资金当作钱包资金。

Gas 又添加另一层。发送方可以用 SUI Coin 或地址余额支付，赞助方也可以承担费用。一笔 SUI Swap 的钱包净变化可能同时含交换资金与费用。核对业务投入时应区分它们；仅看 SUI 负变化，不足以确定兑换金额。

因此，这个模块从资金表示开始，再解释地址余额和费用核对。后面的 SQL 不会把 Coin 历史行直接求和当作当前余额，也不会假设六张基础表已经覆盖所有累加器变化。先把价值放回正确主体与时点，资金流分析才有意义。

[Coin 与 Balance](./01-coins.md) → [地址余额与 Gas](./02-address-gas.md) → [模块总结](./summary.md) · [返回目录](../README.md)
