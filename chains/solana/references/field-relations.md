# 字段关系索引

| 关系 | 建议键 | 基数与防护 |
| --- | --- | --- |
| Block → Transaction | blocks.slot = transactions.block_slot | 1 对多；不要混用 height |
| Transaction → Instruction | transactions.id = instruction_calls.tx_id | 1 对多；交易级费用先聚合或半连接 |
| Transaction → Account activity | transactions.id = account_activity.tx_id | 1 对多；先限制账户或先按交易聚合 |
| Outer → Inner call | tx_id + outer_instruction_index | 1 对多；不是每个 CPI 的直接 parent |
| Raw call → Decoded call | tx_id + outer index + NULL-safe inner index + program | 目标 1 对1；查询匹配次数验证 |
| Token movement → Metadata | token_mint_address | 先测 metadata mint 唯一性，避免放大金额 |
| Token Account → Authority | token_balance_owner 或协议状态 | 权限关系；不直接等同自然人 |
| DEX segment → Transaction | tx_id = id | 多 对1；池段和用户意图口径分开 |

Solana 账户 owner 是程序身份；Token data 内部 owner 是资产授权者。相同词必须结合结构层级解释。

RPC accountIndex 从 0 开始；DuneSQL 数组下标从 1 开始。Dune 展开表的索引起点需实测，不从 SQL 数组习惯猜测。
