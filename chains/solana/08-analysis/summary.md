# 08.99 拥有自己的分析路线

你已经可以把业务问题改写成明确的对象与范围：网络负载看区块计数，交易费用看交易，执行路径看指令，账户净差看活动，资产移动和池段看相应整理模型。选择主对象以后，再决定是否需要 JOIN，而不是先把所有表拼起来。

钱包分析要分账户、owner 与实体，同 owner 的内部移动不能当作对外资金流。协议研究先确认程序身份，再核对动作、状态和资金，最后定义业务指标。未知 Mint 不补名称，缺失估值不填成真实零，调用数量也不替代成交意图。

完成一个小范围闭环之后，可以扩大时间与统计范围，但每次扩大都要重新检查粒度、覆盖与单位。固定窗口、保存来源和执行状态，让结果在两周后仍能被解释。一个可重现的方法，比一次漂亮截图更接近真正的独立能力。

全篇最后将所有对象放回同一张图。面对陌生交易时，你不需要记住全部字段；只要知道请求、执行、状态、接口、加工与统计之间的边界，就能按问题找到正确入口，并明确下一项需要什么证据。

![拥有自己的分析路线](./assets/analysis-route.svg)

[编辑原图（draw.io）](./assets/analysis-route.drawio)

参考来源（核验日期：2026-10-09）：

- [Dune Transactions](https://docs.dune.com/data-catalog/solana/transactions)
- [Dune Instruction Calls](https://docs.dune.com/data-catalog/solana/instruction-calls)
- [Dune Account Activity](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune Transfers](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)
- [Dune DEX 模型](https://docs.dune.com/data-catalog/curated/dex-trades/solana/solana-dex-trades)

<!-- NAV -->

[总目录](../README.md) · [上一章：让分析可重现](03-reproducibility.md) · [下一章：你的 Solana 数据地图](../99-final-summary/index.md)
