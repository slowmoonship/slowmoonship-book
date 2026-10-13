# 04.02 Authority 与 PDA

一个没有私钥的地址，为什么能作为 Token 账户的授权者？关键在于程序派生地址与运行时授权，而不是某个隐藏钱包替它签名。

Authority 是程序定义的业务权限角色。代币账户授权者可以控制转账，Mint Authority 可以允许增发，关闭权限或冻结权限则回答其他问题。它们可能指向不同地址，也可能按程序规则变更。一个账户出现在 signer 数组中，只说明它签了当前消息；它是否有权完成某种业务，还要核对程序状态中的权限配置。

PDA 由种子（Seeds）、程序 ID 和 bump 等参数确定。它被要求落在 Ed25519 曲线之外，所以不存在用于普通交易签名的对应私钥。相同有效派生输入能得到确定地址，便于程序定位某个用户或业务的状态。这个确定性不等于账户已存在，也不等于账户 data 的 Owner 就是派生程序。

程序执行 CPI 时，可以通过 `invoke_signed` 提交种子。运行时按调用程序 ID 验证派生结果，为匹配 PDA 提供本次内部调用所需的签名权限。程序并没有获得一份可导出的密码学私钥，也不能给任意他人 PDA 这样授权。业务操作仍需满足被调用程序的账户、可写与权限检查。

ATA 是很好的边界例子：其地址由关联代币账户程序的规则派生，但账户数据通常由对应 Token Program 拥有。地址由哪个程序派生，data 由哪个程序负责，是不同关系。池协议也可能把 PDA 作为 Token Account 的业务 owner，而 Token Account 的基础 owner 仍是 Token Program。

数据分析时，不能因一个地址没在交易签名者列表里，就断言它没有授权；也不能因为它是 PDA，就给它贴某个自然人身份。要证明 PDA 归属，需要可核验的派生规则与输入；要证明业务权限，需要相应状态字段和程序接口。仅凭地址外观无法完成这些判断。

在后面的路由案例里，某些池相关 Token Account 的 owner 不同于付费者。我们能报告这次 RPC 观察到的 owner 与转账指令，却不会在缺少派生证明时把它们全叫 PDA。这种有限而准确的归因，会让钱包资金流分析保留应有边界。下一章转向账户前后状态与生命周期。

![Authority 与 PDA](./assets/owner-authority.svg)

[编辑原图（draw.io）](./assets/owner-authority.drawio)

参考来源（核验日期：2026-10-09）：

- [Solana PDA](https://solana.com/docs/core/pda)
- [CPI 权限](https://solana.com/docs/core/cpi)
- [Token 账户结构](https://solana.com/docs/tokens)
- [创建 ATA](https://solana.com/docs/tokens/basics/create-token-account)

<!-- NAV -->

[总目录](../README.md) · [上一章：Account 与程序 Owner](01-account-owner.md) · [下一章：状态变化与账户生命周期](03-activity-lifecycle.md)
