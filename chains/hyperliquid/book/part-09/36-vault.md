# 36｜HLP与Vault的份额和盈亏

你向一个Vault投入资金，后来界面显示价值增加。增加可能来自策略盈利，但存入资金本身也会抬高Vault总权益。判断策略表现，需要区分总资产变化、净出入金和单位份额价值。一个Vault越来越大，不自动表示每位出资人的收益率越来越高。

Vault用自身账户执行交易，出资人通过相应份额参与结果。份额不等于一笔固定本金债权，也不意味着Vault买入的每个资产都直接记在每位出资人的交易账户。研究资金流与交易行为时，应分别观察Vault地址与出资人记录，再用份额关系连接。

教学模拟中，Vault初始权益1000、份额100，单位价值10。策略盈利100后，在份额不变的简化条件下单位价值11。另一个人此时存入110，会增加10份额；总权益变为1210，单位价值仍是11。把110新增入金当策略盈利，会得到明显错误回报。

真实制度还涉及费用、锁定、申赎时点和会计规则，不能用这一模拟替代所有Vault实现。当前协议Vault文档说明HLP最近存款后有四天锁定。锁定中的权益可以随策略变化，但不等于随时可提款。当前状态与当时申赎资格应一起保存。

HLP是协议Vault，提供多种做市策略、参与清算、向Earn供应USDC并取得部分费用。它不是只有一种清算策略，也不只是被动收息账户。策略承受库存价格变化、执行条件和极端市场风险，历史正收益不形成未来固定支付承诺。

本篇实际调用公开HLP地址的`vaultDetails`并保存元数据、权益相关状态与历史呈现。返回名称用于核对所研究的Vault身份，不凭地址记忆直接贴标签。它提供指定观察时点及接口历史片段，没有完整取得所有出资人的存入、份额变化与提款链。

分析Vault PnL时，应检查是否扣除存入和取出，以及统计的是总额还是单位份额。以总权益简单相减，可能主要测到资金募集；以当前出资比例乘历史盈亏，又可能把加入前的收益分给后来出资人。正确归属需要份额生效期间与协议会计规则。

Dune的Perp Position表将HLP及其子Vault视为普通账户，文档不提供完整实体角色标记。看到大量仓位不能自动认定某地址是HLP。Vault身份、子策略关系和资本参与需要外部登记或官方状态证据；交易数据只是其中一层，不是完整组织关系表。

把Vault画成资金、份额、策略仓位、费用与盈亏相互连接的状态模型，就能避免将资金管理活动简化成一条“收益”曲线。读者应能回答钱从哪里来、由谁交易、收益如何计量、何时能够取回。回答这些问题，比展示一个漂亮的历史百分比更接近可核验的金融研究。

<!-- BOOK RESOURCES -->

![图36：HLP与Vault的份额和盈亏](../../assets/diagrams/vault.svg)

[编辑此图](../../assets/diagrams/vault.drawio)

证据：[案例11](../../examples/cases/case-11.md)。

依据：[hypercore__vaults](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/vaults.md)；[hypercore__vaults__protocol-vaults](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/vaults/protocol-vaults.md)；[trading__fees](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/fees.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-09/35-staking.md) · [下一章](../../book/part-10/37-data-sources.md)
