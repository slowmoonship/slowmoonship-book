# case-12｜Swap与Mint共存的LP交易

网络：Polygon PoS Mainnet，Chain ID 137。

交易：[0x0659b2f4e397b4dd0a7b98d63700f4060b0004f9893ba0441da39fe63a65335b](https://polygonscan.com/tx/0x0659b2f4e397b4dd0a7b98d63700f4060b0004f9893ba0441da39fe63a65335b)

Bor高度：74,942,064；时间：2025-08-08T07:05:23+00:00。

观察问题：不能按交易标签分类所有Transfer。

[原字段与推导JSON](case-12.json)；来源缓存：`research/sources/tx-lgns-add-liquidity.md`。 [作者原Query](https://dune.com/queries/8369227)。

验证范围：浏览器记录已归档；取得的旧Dune样本按高度和哈希交叉核对。没有本地全节点重放、共识验签或完整历史状态。未取得字段保持空值。

此交易同时包含Swap、Mint、Transfer，直接展示按交易标签给所有转移归类的局限；未将整笔交易所有DAI移动视为独立加池。
