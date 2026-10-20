# RPC与Heimdall读取示例

[请求集合](requests.json)仅用于教学；response=null表示本轮没有相应成功RPC响应。两家官方公共Bor RPC实际返回403，见[访问记录](../../research/rpc/read-status.json)。不提供伪造成功数据。

标准请求查链ID、交易、回执和区块；bor_getBlockGasParams与borExtra为PIP-83扩展，服务端版本与支持状态另核。Heimdall模块路径来自官方Milestone文档。实际取得的Lugano历史块在[原始响应](https://heimdall-api.polygon.technology/cosmos/base/tendermint/v1beta1/blocks/54627000)，不是下面教学请求的成功替代品。

全部只读，不包含钱包、私钥、签名或写方法。
