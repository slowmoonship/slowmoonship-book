# HyperEVM数据模型

Mainnet Chain ID999经实际eth_chainId验证；Testnet998依据官方网络资料。EVM区块编号、Core高度、共识Round分别定义。双区块在一条EVM编号序列中交错。

| 数据 | 身份 | 本篇核验 |
|---|---|---|
| Block | number/hash | 固定块实际JSON；Gas Limit3M只是样本 |
| User transaction | hash | 实际块中的交易及相应Receipt |
| Receipt | transactionHash/blockHash | status、Gas、日志归属 |
| Log | tx_hash/index | 原始topic与data，ABI语义另验 |
| Trace | tx_hash/trace_address | Dune实时Schema与旧Query结果，无本轮新执行 |
| System transaction | 指定块系统交易集合 | 样本块返回空，不代表全链无系统活动 |
| Precompile read | 具体地址与输入时点 | 0807读取实际非错误返回 |
| CoreWriter | 系统地址及动作编码 | 主网代码非空；不发送写操作 |

RPC单位：数量十六进制编码；value与原生金额EVM最小单位；Gas是执行计量。fee等于适用Gas单价乘消耗，SQL浮点展示明确近似。历史区块/收据可读不表示默认RPC支持任意历史eth_call或余额。

CoreWriter入口成功 ≠ Core业务成功 ≠ 订单成交。Read值对应EVM构建时的Core状态。Core→EVM排队下一EVM块；EVM→Core在EVM构建后处理，之后处理相应CoreWriter。订单/Vault等指定操作另有延迟。

普通Logs与Transactions不能完整覆盖Core原生活动。Dune概览与实时Trace Catalog有冲突，保留而不将概览旧文当作当前能力的唯一依据。当前可查询授权及最新完整数据范围未通过新SQL运行验证。

来源：[RPC原文](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/hyperevm/json-rpc.md)、[交互时序](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/hyperevm/interaction-timings.md)、[实时Catalog](dune/catalog-hyperevm.json)。
