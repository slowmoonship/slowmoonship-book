# 真实案例索引

9 个真实案例组，原始响应均已保存。COMPLETE 仅指索引所列具体问题，不能扩展到缺失字段。

| 案例 | 状态 | 可检查的材料 | 仍缺材料 |
|---|---|---|---|
| 01 C-Chain 原生 AVAX 转账 | VALIDATED | [身份与字段](case-01.json)；[c-native-detail](../../research/raw/c-native-detail.json) | 原始 RPC 收据、目标历史代码、逐交易前后余额；Dune 同笔新查询结果 |
| 02 C-Chain USDT transfer | VALIDATED | [身份与字段](case-02.json)；[c-erc20-detail](../../research/raw/c-erc20-detail.json) | 原始完整 Logs/Trace、历史余额；ABI/实现完整独立审查 |
| 03 C→P 原子转移 | COMPLETE | [身份与字段](case-03.json)；[data-c-chain-latest](../../research/raw/data-c-chain-latest.json)、[atomic-p-import](../../research/raw/atomic-p-import.json) | 用户全余额、源 EVM 精确状态差分 |
| 04 Primary Network 后续委托 | VALIDATED | [身份与字段](case-04.json)；[atomic-p-import](../../research/raw/atomic-p-import.json)、[atomic-p-followup](../../research/raw/atomic-p-followup.json) | 奖励最终支付；全部资金来源的经济分摊 |
| 05 X-Chain 多输入转移 | VALIDATED | [身份与字段](case-05.json)；[data-x-chain-latest](../../research/raw/data-x-chain-latest.json)、[x-avax-asset](../../research/raw/x-avax-asset.json) | 钱包全 UTXO 快照、找零所有权解释；响应未返回独立费用字段 |
| 06 Beam 网络、链与转换 | VALIDATED | [身份与字段](case-06.json)；[beam-subnet](../../research/raw/beam-subnet.json)、[beam-create-chain](../../research/raw/beam-create-chain.json)、[beam-conversion](../../research/raw/beam-conversion.json)、[beam-subnet-detail](../../research/raw/beam-subnet-detail.json) | 管理端初始化事件、完整权限与历史升级 |
| 07 Beam 注册与后续费用快照 | VALIDATED | [身份与字段](case-07.json)；[beam-validator-history](../../research/raw/beam-validator-history.json)、[beam-l1-validators](../../research/raw/beam-l1-validators.json) | 管理端发起与确认；完整权重、停用、充值、移除历史 |
| 08 ICM 源侧发送事件 | VALIDATED | [身份与字段](case-08.json)；[dune-result-8676245-parsed](../../research/raw/dune-result-8676245-parsed.json)、[dune-query-8676245-parsed](../../research/raw/dune-query-8676245-parsed.json) | 本结果未返回源高度；签名本体、目标交易、接收、执行和余额；目标是否完成未知 |
| 09 Beam 独立 L1 交易 | COMPLETE | [身份与字段](case-09.json)；[beam-block](../../research/raw/beam-block.json)、[beam-receipt](../../research/raw/beam-receipt.json)、[beam-chain-id](../../research/raw/beam-chain-id.json)、[beam-identity](../../examples/transactions/beam-identity.json) | 长期持续运行、所有节点一致性 |
