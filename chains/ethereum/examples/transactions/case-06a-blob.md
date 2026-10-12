# case-06a-blob｜Blob 现代交易

| 项目 | 观测内容 |
|---|---|
| 网络 | Ethereum Mainnet，Chain ID 1 |
| Hash | `0x82258a58b5571d2a38fb011b08fdaac0c6e504ceb80b2d74cf089c3206971e8b` |
| Block Number | 25400543 |
| Block Time | 2026-06-26T08:14:59Z |
| 合约与目标 | 目标 0xbd0d173eeb87d57a09521c24388a12789f33ba96 |
| 来源 | Etherscan 索引交易详情；本轮 web 查询读取 |
| 状态 | VALIDATED_TYPE_AND_BROWSER_FIELDS |

[浏览器交易](https://etherscan.io/tx/0x82258a58b5571d2a38fb011b08fdaac0c6e504ceb80b2d74cf089c3206971e8b) · [相关作者 Query](https://dune.com/queries/8378487)

Type 3；一个 Blob；Value 0；Nonce 3783；Position 11；Gas Used 150203；执行 Gas 单价 1259266248 Wei。浏览器总费包含Blob费用，可在该案例范围内做下面的拆分；未下载Blob正文和原始收据Blob费字段。

## 推导费用拆分

[取得与推导分列的证据](case-06a-blob-fee-evidence.json)。Etherscan自己的[费用说明](https://info.etherscan.com/what-is-a-blob/)确认Blob交易总费包含执行部分和Blob部分；这里不采用该2024文章已过时的主网容量和价格调整表述。

| 项目 | Wei / Gas | 来源 |
|---|---|---|
| 总费 | 190773402010136 Wei | 浏览器展示 |
| 执行费 | 150203 × 1259266248 = 189145568248344 Wei | 取得字段的整数乘积 |
| Blob费 | 1627833761792 Wei | 总费减执行费 |
| Blob Gas | 131072 | 一个Blob × EIP-4844规定单位 |
| Blob实际单价 | 12419386 Wei / Blob Gas | 差额除Blob Gas，余数为零 |

拆分是DERIVED，未取得原收据blobGasUsed/blobGasPrice，不能改标成RPC实读验证。这组结果说明普通执行费公式为什么没有覆盖该笔总费。
