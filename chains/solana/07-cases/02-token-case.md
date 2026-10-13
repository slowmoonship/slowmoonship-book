# 07.02 完整拆开一笔 Token 转账

交易 `4PbUPBscjXmg85MdEwtoDQq1Q2pMoAwjxTSotkRGbX5itYe1gAYufZZFmaqQnyGe8yrakTLf2hsNwYYp11bzjiuQ` 的顶层动作同样叫 transfer，但执行者是 Token Program。它移动的不是两个基础账户的 SOL，而是两份 Token Account data 中的代币数量。

授权及付费者为 `CCSccmE7WBfSF47anEEtevxJp14Fs6DEKT9SZMKmD62T`。源 Token Account 是 `CANqWCUGAS6675FaGJe47ZSZKAndeSDQc7SWYy4WL49d`，目标为 `9xmwheGqzGMSJuZgMrT9HLZPPnJWADWPWqML8y1dWuXR`。两份账户的 Token 元数据都给出相同 owner 和 Mint，不能把这次移动自动解释为两个钱包之间付款。

Mint 为 `EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v`，与 Solana 官方 Token 文档中的 USDC Mint 相符。此次 pre/post Token 字段确认 decimals=6。指令 amount 为原始整数 878,126,444，即 878.126444 个基础展示单位。

源账户从 878,126,444 原始单位减到零；目标从 4,001,829,572 增至 4,879,956,016。两个差额恰好是同一个 amount，合计原始余额不变。业务 owner 的对外流量因此为零，但账户粒度的转账量不为零。这是统计粒度影响结论的真实反例。

SOL 费用另在基础余额中体现：授权者付 5,000 lamports，两个 Token Account 的 lamports 在本交易前后不变。Token 数量为零也不证明该账户关闭；账户关闭要看生命周期指令和状态。这里没有把“Token 清空”写成“账户已删除”。

本次 parsed transfer 没有直接携带 Mint 字段，Mint 与 decimals 来自对应的 Token 余额元数据。这说明同样是解析结果，字段仍可能来自不同结构。Token 账户、授权者和 Mint 三种地址必须一起核对，不能只读一个 amount。

下面的 Dune 映射保留账户与 owner 两种视角，并展示 action 与单位。


这个案例也没有证明两个 Token Account 中哪一个是 ATA。要判断 ATA，需要使用完整派生规则核对地址，不能凭“钱包常用账户”或某个余额大小推断。当前 RPC 元数据足以验证 Mint、owner 和数量，却不替代地址派生证据。

如果把源与目标的变化绝对值相加，会得到这笔内部移动的两倍数量；如果分别报告转入和转出，应说明这是两个方向的账户观察，不能加成新的经济流量。按共同 owner 汇总净差，才能与问题中的对外资金口径对应。

SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT tx_id, action, token_mint_address,
       from_token_account, to_token_account,
       from_owner, to_owner, amount, amount_display
FROM tokens_solana.transfers
WHERE block_date = DATE '2026-10-09'
  AND tx_id = '4PbUPBscjXmg85MdEwtoDQq1Q2pMoAwjxTSotkRGbX5itYe1gAYufZZFmaqQnyGe8yrakTLf2hsNwYYp11bzjiuQ'
```

尚未执行该查询，也未确认加工模型在这笔交易上的具体输出。下一章会让一笔请求跨多个程序，再分清准备、资产动作和业务路由。

![完整拆开一笔 Token 转账](./assets/token-case.svg)

[编辑原图（draw.io）](./assets/token-case.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana RPC getBlock](https://solana.com/docs/rpc/http/getblock)
- [RPC JSON](https://solana.com/docs/rpc/json-structures)
- [Token 模型](https://solana.com/docs/tokens)
- [Dune Transfers](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)

<!-- NAV -->

[总目录](../README.md) · [上一章：完整拆开一笔 SOL 转账](01-sol-case.md) · [下一章：聚合路由与多次 Swap](03-swap-case.md)
