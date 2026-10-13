# 05.99 把一笔资产移动连回账户

SOL 数量存在基础账户 lamports；Token 数量通常存在 Token Account 的 data.amount。Mint 定义资产身份与 decimals，Token Account 定位余额与业务授权，ATA 提供按完整规则派生的默认位置。这些对象共同组成钱包界面的资产视图，链上并没有把它们合成一种账户。

原始动作金额与整笔交易余额差不必相等，费用、账户创建和关闭都可能影响 SOL。Token 原始整数、decimal 调整值和美元估值需要分别读取；Token-2022 的实际扩展还可能改变金额与展示解释。不能固定小数位、不能重复换单位，也不能把 NULL 估值填成真实零价值。

流量需要时间窗口和 action 范围，余额需要时点与完整状态。Token Account 之间移动，不一定是 owner 之间的经济流出。当前关系也不能无条件覆盖历史授权者。已有看板的移动数量与账户余额变化两类图，正是不同视角，不应该为了让数值相等而强行合并。

至此，你已经掌握链上主要对象的含义。下一步是进入仓库：RPC 怎样提供结构，Dune 怎样展开和加工，同一笔交易为什么变成多种粒度，SQL 又怎样在关联之后仍保住原本的金额与计数。

![把一笔资产移动连回账户](./assets/asset-model.svg)

[编辑原图（draw.io）](./assets/asset-model.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana Token 模型](https://solana.com/docs/tokens)
- [关联代币账户](https://solana.com/docs/tokens/basics/create-token-account)
- [Token-2022 官方说明](https://www.solana-program.com/docs/token-2022)
- [Dune 资产移动表](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)
- [Dune 账户余额字段](https://docs.dune.com/data-catalog/solana/account-activity)

<!-- NAV -->

[总目录](../README.md) · [上一章：流量与存量](04-transfers-balances.md) · [下一章：进入仓库前先问粒度](../06-warehouse/index.md)
