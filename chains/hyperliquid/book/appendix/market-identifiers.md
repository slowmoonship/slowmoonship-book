# 附录B｜市场与资产身份

| 编号域 | 构造 / 来源 | 不能混用 |
|---|---|---|
| 第一方Perp Asset | 对应网络meta中的市场索引 | 不是Token Index |
| HIP-3 Perp Asset | 100000 + dex_index × 10000 + index_in_meta | 不按裸Symbol猜索引 |
| Spot Token | spotMeta.tokens显式index及tokenId | 不等于Pair Index |
| Spot Pair | spotMeta.universe中的index及tokens顺序 | 不按数组位置替代字段 |
| Spot Action Asset | 10000 + Pair Index | 不使用Token Index代入 |
| Outcome encoding | 10 × outcome + side，side为0或1 | 与Spot Pair不同编号域 |
| Outcome coin / Token | `#encoding` / `+encoding` | 不是Perp coin |
| Outcome Action Asset | 100000000 + encoding | 独立产品编码 |
| HyperEVM Mainnet / Testnet | Chain ID 999 / 998 | 不是Core DEX或Asset |
| EVM Token | 网络与具体合约地址；HYPE为原生余额 | 同名Ticker不能代替链接证据 |

实际HYPE案例：Token Index150，Pair Index107，tokens为[150,0]，Spot Action Asset10107。当前精度weiDecimals8、szDecimals2。接口原始返回见[案例06](../../examples/cases/case-06.md)。

实际XYZ市场：完整coin为xyz:TSLA，DEX来自perpDexs，市场索引来自对应Meta；编号推导与原返回见[案例09](../../examples/cases/case-09.md)。它是价格关联永续，不交付股票。

推荐身份键：网络 + 产品类别 + 完整原生市场标识；注册表另外保存DEX、Asset ID、基础/报价Token、抵押、Oracle及观察版本。Dune市场连接使用coin，market_symbol可能跨DEX碰撞。当前注册快照不自动提供全部历史参数。

订单键、成交键和账务键分别记录。官方WS对tid建议结合coin与事件时间使用；oid与cloid识别订单；全零hash不能作为唯一去重键。EVM哈希与Core业务hash没有天然一对一连接。

来源：[Asset IDs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/asset-ids)、[Spot Info](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot)、[WS数据类型](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/websocket/subscriptions)。基准2026-10-13。


[目录](../../SUMMARY.md) · [上一章](glossary.md) · [下一章](data-table-index.md)
