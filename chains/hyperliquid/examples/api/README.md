# 只读API教学与实际响应

每个包装包含Network、Method、Endpoint、Request、Response、Time、Status、Grain、Unit、Limitations；`.response.json`保留原始响应字节。实际32次HTTP请求，无Exchange调用。示例地址是公开事件观察对象，不进行现实身份归因。

| 文件 | 类型/方法 | 状态 | 业务粒度 |
|---|---|---|---|
| [01-meta-context.json](01-meta-context.json) | metaAndAssetCtxs | OBSERVED | market-index aligned metadata/context |
| [02-btc-book.json](02-btc-book.json) | l2Book | OBSERVED | price-level L2 snapshot |
| [03-spot-meta.json](03-spot-meta.json) | spotMeta | OBSERVED | token registry + pair registry |
| [04-perp-dexs.json](04-perp-dexs.json) | perpDexs | OBSERVED | dex registry |
| [05-outcome-meta.json](05-outcome-meta.json) | outcomeMeta | OBSERVED | outcome registry |
| [06-btc-funding.json](06-btc-funding.json) | fundingHistory | OBSERVED | market-hour funding rate |
| [07-spot-context.json](07-spot-context.json) | spotMetaAndAssetCtxs | OBSERVED | spot market current contexts |
| [08-settled-outcome.json](08-settled-outcome.json) | settledOutcome | OBSERVED | one historical outcome settlement |
| [09-hip3-meta.json](09-hip3-meta.json) | metaAndAssetCtxs | OBSERVED | one HIP-3 DEX universe/context |
| [10-hype-book.json](10-hype-book.json) | l2Book | OBSERVED | HYPE spot L2 snapshot |
| [11-outcome-book.json](11-outcome-book.json) | l2Book | OBSERVED | one outcome side L2 snapshot |
| [12-evm-chain.json](12-evm-chain.json) | eth_chainId | OBSERVED | network identity |
| [13-evm-height.json](13-evm-height.json) | eth_blockNumber | OBSERVED | latest EVM height |
| [14-evm-block.json](14-evm-block.json) | eth_getBlockByNumber | OBSERVED | fixed EVM block |
| [15-evm-system.json](15-evm-system.json) | eth_getSystemTxsByBlockNumber | OBSERVED | system transactions at fixed EVM height |
| [16-evm-receipt.json](16-evm-receipt.json) | eth_getTransactionReceipt | OBSERVED | one EVM receipt |
| [17-fills-0.json](17-fills-0.json) | userFillsByTime | OBSERVED | one unaggregated user fill leg |
| [17-fills-1.json](17-fills-1.json) | userFillsByTime | OBSERVED | one unaggregated user fill leg |
| [18-account.json](18-account.json) | clearinghouseState | OBSERVED | user perpetual current state |
| [19-spot-account.json](19-spot-account.json) | spotClearinghouseState | OBSERVED | user current spot balances |
| [20-user-funding.json](20-user-funding.json) | userFunding | OBSERVED | user market-hour funding payment |
| [21-user-ledger.json](21-user-ledger.json) | userNonFundingLedgerUpdates | OBSERVED | non-funding user ledger event |
| [22-abstraction.json](22-abstraction.json) | userAbstraction | OBSERVED | account mode current state |
| [23-delegation.json](23-delegation.json) | delegatorSummary | OBSERVED | staking current state |
| [24-order-status.json](24-order-status.json) | orderStatus | OBSERVED | one order current/historical status |
| [25-read-oracle.json](25-read-oracle.json) | eth_call | OBSERVED | precompile BTC oracle latest state |
| [26-hype-transfer-logs.json](26-hype-transfer-logs.json) | eth_getLogs | OBSERVED | HYPE EVM-to-Core Received logs, bounded 50 blocks |
| [27-multiple-fill-order.json](27-multiple-fill-order.json) | orderStatus | OBSERVED | one multiple-fill order status |
| [28-corewriter-code.json](28-corewriter-code.json) | eth_getCode | OBSERVED | Mainnet CoreWriter current bytecode, no action execution |
| [29-hlp-vault.json](29-hlp-vault.json) | vaultDetails | OBSERVED | public HLP vault metadata/state |
| [30-hlp-child.json](30-hlp-child.json) | vaultDetails | OBSERVED | one observed HLP child identity and state |
| [31-liquidator-fills.json](31-liquidator-fills.json) | userFillsByTime | OBSERVED | verified liquidator public fill legs, finite30min |

Info请求虽然POST，类型白名单限定只读。Request与Response分开保存，API错误和unknownOid不会改成伪造成功。所有时间另存UTC；毫秒时间使用事件粒度解释。
