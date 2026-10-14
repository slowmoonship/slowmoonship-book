# SQL与RPC教学索引

新增SQL：STATIC_CHECKED；实际执行BLOCKED_READ_ONLY_ACCOUNT。无新增结果；RPC：12方法NOT_EXECUTED。

| 编号 | 查询 | 范围 |
|---|---|---|
| 01 | [定位单笔真实交易](../../examples/sql/01-transaction.sql) | 一行确认交易；Case01；BTC DOUBLE |
| 02 | [展开全部输入](../../examples/sql/02-inputs.sql) | 每输入一行；金额来自前序索引；BTC DOUBLE |
| 03 | [展开全部输出](../../examples/sql/03-outputs.sql) | 每创建输出一行；不代表当前未花费 |
| 04 | [普通交易手续费](../../examples/sql/04-fee.sql) | 交易层金额合计DOUBLE舍入，仅近似；精确费用用JSON整数复核 |
| 05 | [一个输出的有界生命周期](../../examples/sql/05-utxo-lifecycle.sql) | Case07种子输出零；花费窗口2010-11-16至18，空值不代表今日UTXO |
| 06 | [地址窗口内未花费候选](../../examples/sql/06-address-utxo-candidates.sql) | 仅2017-08-24创建候选，块481824末；不覆盖更早地址输出；普通花费只可能在创建后 |
| 07 | [地址在指定高度的确认余额](../../examples/sql/07-balance-at-height.sql) | 一个地址，完整历史至481824；成本需审核；余额非可立即花费金额；P2PKH案例地址 |
| 08 | [输出脚本类型分布](../../examples/sql/08-script-types.sql) | 一个UTC日；输出粒度；不是用户数或经济付款量 |
| 09 | [区块手续费与交易汇总核对](../../examples/sql/09-block-fees.sql) | 块840000；普通交易每交易一次汇总；DOUBLE差额非整数精度证明 |
| 10 | [Coinbase补贴、费用与领取](../../examples/sql/10-coinbase.sql) | 每块Coinbase；平台奖励列需解释，允许少领；输出成熟期另查 |
| 11 | [已花费输出年龄](../../examples/sql/11-utxo-age.sql) | 仅种子输出于2010-11-16至18花费；块时间差非精确持有时间 |
| 12 | [2010窗口币天销毁](../../examples/sql/12-coin-days-destroyed.sql) | 单位BTC-days；值DOUBLE；负时间差显式排除并需另审异常；非卖出指标 |
| 13 | [两层输出花费依赖](../../examples/sql/13-two-hop-graph.sql) | 创建分区2009-01-12与2010-11-16至18；花费分区2010-11-16至18；不分配输入到新输出经济份额；可有多分支 |
| 14 | [多输入整合结构候选](../../examples/sql/14-consolidation-candidates.sql) | 25条结构候选；不证明共同所有权或业务整合 |
| 15 | [找零候选与反例](../../examples/sql/15-change-candidates.sql) | 较大输出找零候选；等额不判；LIMIT可能截断交易仅展示；不用来证明经济量 |
| 16 | [确认费率与区块时间分布](../../examples/sql/16-confirmed-feerates.sql) | 两UTC日；无首次广播字段，不计算确认等待或因果关系 |

- [getblockchaininfo教学请求](../../examples/rpc/getblockchaininfo.json)
- [getnetworkinfo教学请求](../../examples/rpc/getnetworkinfo.json)
- [getblockhash教学请求](../../examples/rpc/getblockhash.json)
- [getblockheader教学请求](../../examples/rpc/getblockheader.json)
- [getblock教学请求](../../examples/rpc/getblock.json)
- [getrawtransaction教学请求](../../examples/rpc/getrawtransaction.json)
- [gettxout教学请求](../../examples/rpc/gettxout.json)
- [gettxoutsetinfo教学请求](../../examples/rpc/gettxoutsetinfo.json)
- [getblockstats教学请求](../../examples/rpc/getblockstats.json)
- [getrawmempool教学请求](../../examples/rpc/getrawmempool.json)
- [getmempoolentry教学请求](../../examples/rpc/getmempoolentry.json)
- [estimatesmartfee教学请求](../../examples/rpc/estimatesmartfee.json)

[目录](../../SUMMARY.md)

[上一章](script-types.md) · [下一章](references.md)
