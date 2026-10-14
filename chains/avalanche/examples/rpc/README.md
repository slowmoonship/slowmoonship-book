# RPC / JSON 示例

15 份真实请求与响应封装；每份记录 Endpoint、Network、检索时间和原始返回。GET 请求的 request 为 null，不代表缺少调用；方法标为 HTTP GET。

以下路径全部是已调用样本，未来重放会受到限流与历史保留限制。

- [network-id](network-id.json)
- [blockchain-id-c](blockchain-id-c.json)
- [blockchain-id-x](blockchain-id-x.json)
- [c-chain-id](c-chain-id.json)
- [x-avax-asset](x-avax-asset.json)
- [p-blockchains](p-blockchains.json)
- [atomic-p-import](atomic-p-import.json)
- [c-native-detail](c-native-detail.json)
- [c-erc20-detail](c-erc20-detail.json)
- [beam-subnet-detail](beam-subnet-detail.json)
- [beam-l1-validators](beam-l1-validators.json)
- [beam-validator-history](beam-validator-history.json)
- [beam-block](beam-block.json)
- [beam-receipt](beam-receipt.json)
- [beam-conversion](beam-conversion.json)

P-Chain 教学请求：`platform.getL1Validator({"validationID":"注册编号"})`。这里是方法说明，未额外调用，不附伪造响应。C-Chain `avax.getAtomicTxStatus` 在 Helicon 后公共节点不再提供；按现行文档使用 `avax.getAtomicTx` 获取执行后的 blockHeight。
