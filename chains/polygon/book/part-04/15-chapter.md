# 第15章｜MATIC与POL怎样接上历史

旧钱包界面写MATIC，新文档写POL，历史费用表又可能统一显示POL。读者很容易把它理解成所有历史余额都换成了另一份资产。要看清这件事，必须区分协议中的原生手续费单位、Ethereum上的ERC-20代币、迁移操作和界面符号，这四者会一起变化，却不是同一个对象。

2024年9月4日，Polygon PoS完成MATIC向POL的原生币升级。对于PoS链上的原生余额，官方说明用户通常无需执行手动迁移操作。钱包若仍配置旧符号，可能继续显示MATIC，但这不代表余额留在旧协议。给一笔历史交易改显示名称，也不等于为它新增一笔链上转账或兑换。

Ethereum上的情况不同。MATIC和POL是具有不同合约地址的ERC-20资产，迁移需要对应合约流程。研究者应分别保存根链代币地址、迁移合约和迁移事件，而不是把两个合约的Transfer历史按符号直接拼接。其他网络和交易所的处理方式，也应以其具体支持状态解释。

质押记录还涉及Ethereum上的StakeManager与验证者份额体系。它与用户在Polygon支付Gas使用的原生余额具有经济联系，但数据位置不同。统计“POL质押量”时，应说明是在读取根链质押合约、包装代币余额，还是某种流动性质押产品的供应量。后者不能直接替代协议锁定量。

原生币和包装币也要分开。原生POL通过账户余额与交易费用表现，包装版本通过合约的ERC-20账本表现。包装或解包会改变两种表现形式，不能把它们视为两次外部资金进入网络。若使用跨链转账总表，还应确认平台怎样识别原生资产、包装合约和历史名称。

作者旧Polygon研究在指定日期观察到gas.fees.currency_symbol为POL。这是有关平台返回值的历史事实，并不能单独证明所有年份都采用同一归一化规则。重做长期费用序列时，需要保留原始数量单位与价格键，检查旧MATIC价格是否被映射到POL，以及迁移附近是否出现缺值或重复。

一个稳妥的资产档案可以列四栏：网络、表现形式、合约地址或原生标识、适用时间。Ethereum上的代币合约应给出完整地址；Polygon原生POL则不能为了凑地址随便套用根链合约。系统原生代币接口地址与包装币地址也有不同职责，读者应从官方合约清单核对。

长期分析还应保留价格口径。即使原生数量连续，美元价值也依赖当时采用哪种价格序列。迁移窗口若出现两套符号同时有价格，不能把两者价值相加；应先确认它们是否代表同一份经济敞口，再选择合适的连接规则。

| 表现与网络 | 地址或标识 |
|---|---|
| Ethereum MATIC ERC-20 | `0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0` |
| Ethereum POL ERC-20 | `0x455e53CBB86018Ac2B8092FdCd39d8444aFFC3F6` |
| Polygon原生接口 | `0x0000000000000000000000000000000000001010`，不等于根链ERC-20 |
| Polygon包装币 | `0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270`，历史常标WMATIC |

前三项来自官方合约清单，包装地址来自固定Bor配置；实际当前元数据另需指定区块读取。

历史名称是进入过去数据的钥匙，而不是需要消灭的错误。书稿引用旧交易时会保留其历史背景，同时解释当前名称；分析表若做统一计价，则明确说明归一化规则。这个习惯同样适用于后面的DAI、USDC和LGNS：名称可以帮助阅读，身份与金额仍由网络、地址、精度和时点决定。

![MATIC与POL怎样接上历史](../../assets/diagrams/matic-pol.svg)

[可编辑原图](../../assets/diagrams/matic-pol.drawio)


来源与核对：[matic-to-pol](https://docs.polygon.technology/pos/concepts/tokens/matic-to-pol.md)；[pol](https://docs.polygon.technology/pos/concepts/tokens/pol.md)；[genesis-contracts](https://docs.polygon.technology/pos/reference/contracts/genesis-contracts.md)；[bor-asof-config](https://raw.githubusercontent.com/0xPolygon/bor/1cdf43c99d97cb9e18860776d8f69a416b49adf4/params/config.go)；[pol-live-2024](https://polygon.technology/blog/matic-to-pol-migration-is-now-live-everything-you-need-to-know)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](14-chapter.md) · [下一章](16-chapter.md)
