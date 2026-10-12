# case-04-swap｜Uniswap V3 Swap

| 项目 | 观测内容 |
|---|---|
| 网络 | Ethereum Mainnet，Chain ID 1 |
| Hash | `0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537` |
| Block Number | 26151122 |
| Block Time | 2026-10-08T23:59:59Z |
| 合约与目标 | Router 0xe592427a0aece92de3edee1f18e0157c05861564；Pool 0x807d8084fd2a0e204590514286454dacce902b65 |
| 来源 | Blockscout MCP 元数据、raw-trace 与 logs；chain_id=1 |
| 状态 | VALIDATED_CALLS_LOGS_MAJOR_ASSETS |

[浏览器交易](https://etherscan.io/tx/0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537) · [相关作者 Query](https://dune.com/queries/8378491)

八条含根轨迹，无 error；四条保留日志，Index 725—728。输入 0.408065 ETH，回调中包装 WETH 并支付池。原元数据 Input 标为截断，Raw Trace 根输入完整。未取得节点级 State Diff；Dune 新 SQL 未运行。见 case-04-swap.json、case-04-traces.json、case-04-logs.json。

[新教学 SQL](../sql/02-traces-and-logs.sql)：STATIC_CHECKED，未执行。
