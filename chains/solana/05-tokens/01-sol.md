# 05.01 SOL 转账与余额变化

付费账户少了 0.022661664 SOL，接收账户只多了 0.022656664 SOL。差额是否是计算错误？在本篇真实 SOL 案例里，差额正好是 5,000 lamports 的交易费用。

System Program transfer 指令明确给出 source、destination 和 lamports，描述一次原生 SOL 转账。基础账户的 pre/post lamports 则描述整笔交易前后的净变化。前者是动作金额，后者包含同笔交易作用于该账户的全部相关变化。简单案例只有一条转账时，两者很容易对账；多动作交易不能照搬这一对应关系。

创建账户需要投入一定 lamports 支持状态保存，关闭账户会把相应余额退给指定地址。程序也可能在其权限范围内直接调整自身拥有账户的 lamports。于是账户净流出可能包括转账、费用和账户生命周期；净流入可能包括普通收款与关闭退款。把所有余额差都叫转账会漏掉机制区别。

包装 SOL（Wrapped SOL，WSOL）更容易制造误读。普通 SOL 被放入相应 Token Account 后，可以按代币程序接口使用。该账户同时有基础 lamports 和 Token amount，`SyncNative` 将超过存储保留余额的 lamports 同步到代币数量。关闭原生代币账户又可以退回 SOL。不能将包装、代币转账与解包的每一行都算成新增经济资金。

Dune 的 account_activity 用 `balance_change` 观察 SOL 净差，单位为 lamports。System Program transfer 解码表观察特定转账指令，资产移动表则按照加工模型统一部分动作。三个数据来源可以互相核对，但覆盖对象不同，不必期待行数相等。Dune 官方文档还明确 native SOL 资产移动覆盖排除部分质押相关转移。

下面只选账户层，不加入指令行，以避免净差被同笔多次调用重复。


SQL 验证状态：字段已按官方 Schema 或当前已保存 SQL 核对；本书版本仅完成静态检查，尚未执行。

```sql
SELECT tx_id, address,
       balance_change AS delta_lamports,
       CAST(balance_change AS double) / 1000000000 AS delta_sol
FROM solana.account_activity
WHERE block_time >= TIMESTAMP '2026-10-09 11:26:00'
  AND block_time <  TIMESTAMP '2026-10-09 11:27:00'
  AND tx_id = '2my5AGATup7YFYAbCMWaF79T16EFAw4HnMgpYtesn1EsVD2FPQkEvbFcZuwZYJfoqWnMsfcWENrWzoWBNF4gEmxJ'
ORDER BY address
```

这份 SQL 没有执行；真实对账将在案例章直接使用 RPC 缓存。读清原生余额之后，下一章转向另一个状态位置：Mint 与 Token Account。

![SOL 转账与余额变化](./assets/asset-model.svg)

[编辑原图（draw.io）](./assets/asset-model.drawio)

参考来源（核验日期：2026-10-09）：

- [Dune 账户余额字段](https://docs.dune.com/data-catalog/solana/account-activity)
- [Dune 资产移动表](https://docs.dune.com/data-catalog/curated/token-transfers/solana/solana-token-transfers)
- [Sync Native 与 WSOL](https://solana.com/docs/tokens/basics/sync-native)

<!-- NAV -->

[总目录](../README.md) · [上一章：金额究竟存在哪里](index.md) · [下一章：Mint、Token Account 与 ATA](02-mint-token-account.md)
