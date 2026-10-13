# 真实案例登记

核验日期：2026-10-10。来源为 [Sui 官方公开 Mainnet GraphQL](https://graphql.mainnet.sui.io/graphql)，方法见 [官方查询文档](https://docs.sui.io/develop/accessing-data/graphql/query-with-graphql)。状态 VERIFIED_OFFICIAL_GRAPHQL 只表示读取与内容交叉核对，不表示 Dune SQL 执行，也不声称本地逐一验证了委员会签名。

完整机器登记：[JSON](./verified-transactions.json)。原始快照内保存请求、响应、取得时间、接口版本与 request ID。没有私钥、签名操作或链上 mutation。

## 案例 A

- Digest：`VYZrgeBbYxFaEnm792GKxZB1N5Y4UFiCCetwyic5p6f`
- Checkpoint：2000007；UTC 时间 2023-05-08T16:58:42.497Z
- Sender：`0xf161fc8850f49cbe93c5152804ae2f45bf1cd1dce3bce34133312688749d8895`
- 状态 SUCCESS；Commands 2，MoveCall 0，Events 0，事件已读完。
- 净 Gas：1987880 MIST。
- [原始请求与响应](../_project/cache/graphql-case-details-response.json)

A 是 2023 年历史原生转移。输入金额、收款变化、输出 Coin 余额三者一致；发送方支出等于收款加净费用。历史格式不被拿来证明当前排序协议。

## 案例 B

- Digest：`5ounE6vvNursjwLpNCUgF8ybtnNfqVbV91fYdpACgBHq`
- Checkpoint：314284234；UTC 时间 2026-08-24T05:14:52.293Z
- Sender：`0x1a8c63c12e8dc7b14e61aeed6798a272eec8636b560922b90349d758e747d25b`
- 状态 SUCCESS；Commands 39，MoveCall 18，Events 19，事件已读完。
- 净 Gas：-86387304 MIST。
- [原始请求与响应](../_project/cache/graphql-case-details-response.json)

B 为 2026-08-24 多路由 SUI→USDC 事务，包含 131 个 PTB Inputs 和 Coin 整理。USDC decimals=6 已用 [元数据响应](../_project/cache/graphql-usdc-metadata-response.json) 核实，输出净增加 38.191592 USDC。SUI 钱包净减少 45.839344920 SUI，净 Gas 为 -0.086387304 SUI；在所述边界下业务净减少 45.925732224 SUI，不能把各池步骤金额再次相加当成这个数。

## 案例 C

Object ID：`0x0df4f02d0e210169cb6d5aabd03c3058328c06f2c4dbb0804faa041159c78443`。创建 Digest：`HVBtju4rFc2wgDxb1qnEMDgxsAp3gbF4ttxG1Wuq4U7M`。创建 Effects 确认输入不存在、ID 操作为 CREATED、输出为 Shared；初始版本 426673878。

| Version | 产生该状态的事务 | Checkpoint |
|---|---|---|
| 426673878 | HVBtju4rFc2wgDxb1qnEMDgxsAp3gbF4ttxG1Wuq4U7M | 82790119 |
| 426674000 | HWtwq6yeRaQKCuoYxiTmi7oahAEpwSvbP2qBH4WBcc3U | 82790154 |
| 426674004 | FxxW9YMFsmkadDJGcU2ewQku4pGChoRTKeq3ijHqfwj5 | 82790180 |
| 426674005 | 7mj7xkaTNG8FRZHhLmUGFgvt2PqZDkVE6hULFyZiQTaP | 82790188 |
| 426674009 | HMU5cddtHKwWwYU9SA3Pnv8Shxq7TpCedPa9JrL4m6am | 82790220 |

hasNextPage=true：上述是已核验切片，不是完整生命周期。还验证了 B 中精确输入/输出版本 975858934 → 975858935，保留 [创建与前后状态快照](../_project/cache/graphql-pool-birth-response.json)。没有虚构 Owner 转移、包装或删除。

Dune 运行状态：全部相关 SQL STATIC_CHECKED；首次轻量执行尝试遭 402 配额拒绝，无成功 Execution ID。
