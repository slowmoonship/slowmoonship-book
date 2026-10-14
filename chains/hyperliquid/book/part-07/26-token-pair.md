# 26｜Token编号与Pair编号的区别

HYPE在当前Mainnet元数据中的Token Index为150，HYPE/USDC的Spot Pair Index为107，下单用的Asset ID又是10107。三个数字都与HYPE有关，却识别三个不同对象。把Token编号写进订单市场字段，可能得到完全错误的市场；数据Join也会出现同样错配。

HIP-1定义Core原生的有上限供应可替代Token。Token对象包含名称、Token ID、索引和精度等字段，表达资产身份。Pair对象连接基础Token与报价Token，形成订单簿身份。同一个基础资产可以参与不同报价市场，因此Token与Pair不应该被设计成同一张编号表。

官方Spot Action规则使用一万加Pair Index作为Asset ID。普通第一方Perp使用其Meta顺序索引；HIP-3另有DEX与市场索引组合公式；Outcome又使用更大的独立编码空间。所有这些值都是整数，却不能脱离类别解释。编号域也是身份的一部分。

本篇实际Spot Metadata中，HYPE Token的`weiDecimals`为8、`szDecimals`为2。前者表示最小整数单位与可读Token数量的缩放关系，后者表示订单数量允许的精度。最小账本单位与最小可交易数量并不相等，因此小额余额可能存在，却不能以相同精度直接下单。

EVM常见ERC-20采用合约地址与decimals表达资产身份。HIP-1 Token不自动就是一个ERC-20，也不保证同名EVM代币与其关联。某个Token可以按协议步骤链接具体合约；链接字段、系统地址和精度差异需要分别验证，不能因Ticker相同便将两边余额合并。

Token供应机制与元数据也具有版本范围。HIP-1基础规格介绍上限、Genesis和费用影响；当前规范另有EVM来源资产的关联路径。供应上限不等于当前流通量，系统地址持有数量也不自动属于真实用户。研究发行与分配应找供应状态和Genesis证据，而不是从成交量推断。

报价资产选择已经扩展。基础HIP-1页面仍保留将任意报价对留待未来的早期表述，而当前Permissionless Quote规范描述其他报价资产。目录需要同时保存Pair实际tokens与报价资格，不应只凭旧页把所有Spot市场写成USDC对。案例HYPE/USDC只是其中一个具体市场。

市场注册表可以按网络、产品类型、Token身份、Pair身份和观察时间组织。不要按数组当前位置替代显式Index字段；保留下架或历史市场的身份，避免索引表只保存今天可见名称。Mainnet与Testnet编号不同，相同名字跨网络也不能直接Join。

当读者在SQL看到asset_id、token_id与coin，可以依次问它属于哪种编号域、映射到哪个资产或市场、来源在哪个版本。真实HYPE的150、107与10107形成一个小而完整的练习：同一金融产品的相关编号能够互相连接，却不能互相替换。

身份表还应保留报价Token与基础Token的顺序。相同两种资产组成的名称，不足以确定价格分母；倒置价格会改变数量与名义额含义。精度字段也应随Token身份保存，避免跨表使用错误的缩放规则。

Genesis是初始供应与分配进入账本的起点。部署者登记名称和精度，按协议准备供应、分配及市场配置；部署资格费用通过规定的荷兰式拍卖形成，并以HYPE计价。这笔部署费用不是每一次Spot成交的手续费，Token创建也不保证市场随后具有足够流动性。

<!-- BOOK RESOURCES -->

![图26：Token编号与Pair编号的区别](../../assets/diagrams/token-pair.svg)

[编辑此图](../../assets/diagrams/token-pair.drawio)

证据：[案例06](../../examples/cases/case-06.md)。

依据：[for-developers__api__asset-ids](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/asset-ids.md)；[hyperliquid-improvement-proposals-hips__hip-1-native-token-standard](https://hyperliquid.gitbook.io/hyperliquid-docs/hyperliquid-improvement-proposals-hips/hip-1-native-token-standard.md)；[hypercore__permissionless-spot-quote-assets](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/permissionless-spot-quote-assets.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-07/25-spot.md) · [下一章](../../book/part-07/27-hip2.md)
