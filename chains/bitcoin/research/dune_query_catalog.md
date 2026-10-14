# 作者既有 Query

2026-10-13只读取回；没有新建、更新或重跑。Dashboard [Bitcoin Data Structure v0.1](https://dune.com/slowmoonship/bitcoin-data-structure-v0-1-bitcoin)（218997）已取得实时状态。

| Query | 名称 | 表 |
|---|---|---|
| [8471262](https://dune.com/queries/8471262) | Bitcoin Core Grain and Relationship QA ｜ Bitcoin 核心粒度与关系 QA | bitcoin.blocks, bitcoin.inputs, bitcoin.outputs, bitcoin.transactions |
| [8471408](https://dune.com/queries/8471408) | Bitcoin Daily Blocks ｜ Bitcoin 每日区块 | bitcoin.blocks |
| [8471410](https://dune.com/queries/8471410) | Bitcoin Inputs and Outputs ｜ Bitcoin 输入与输出 | bitcoin.transactions |
| [8471475](https://dune.com/queries/8471475) | Bitcoin Daily Transactions ｜ Bitcoin 每日交易 | bitcoin.blocks, bitcoin.transactions, query_8471408 |
| [8471478](https://dune.com/queries/8471478) | Bitcoin UTXO Creation and Spending ｜ Bitcoin UTXO 创建与花费 | query_8471410 |
| [8471514](https://dune.com/queries/8471514) | Bitcoin Coinbase Transactions ｜ Bitcoin Coinbase 交易 | bitcoin.blocks, bitcoin.transactions, query_8471408, query_8471410 |
| [8471516](https://dune.com/queries/8471516) | Bitcoin Transaction Fees ｜ Bitcoin 交易手续费 | bitcoin.transactions, query_8471410 |
| [8471578](https://dune.com/queries/8471578) | Bitcoin Input References ｜ Bitcoin 输入引用关系 | bitcoin.blocks, bitcoin.inputs, bitcoin.outputs |
| [8471581](https://dune.com/queries/8471581) | Bitcoin Output Value Distribution ｜ Bitcoin 输出金额分布 | bitcoin.outputs |
| [8471584](https://dune.com/queries/8471584) | Bitcoin Output Script Types ｜ Bitcoin 输出脚本类型 | bitcoin.outputs |

旧执行取回两组：QA一行、UTXO创建消费趋势三行（2026-08-11至13，原结果共14行）。QA高度963924：1860交易、4062输入、5207输出；1000同日引用候选全匹配。仅历史样本，未重跑，不证明当前全链UTXO状态。

原UTXO趋势以output_count与普通input_count近似创建/消费，不剔除所有不可花费与特殊项，因此本书只把它作为结构活动指标。

新增16条教学SQL静态审查；执行状态BLOCKED_READ_ONLY_ACCOUNT（按用户指定只读范围与已有Ethereum拒绝记录，未再次发探针）；没有新增Execution ID。
