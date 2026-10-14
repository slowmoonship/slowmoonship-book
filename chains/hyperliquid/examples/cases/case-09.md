# Case 09｜XYZ的TSLA价格关联永续

状态：**OBSERVED**；证据层级：2；基准日2026-10-13。

- [原始记录：04-perp-dexs.json](../../examples/api/04-perp-dexs.json)
- [原始记录：09-hip3-meta.json](../../examples/api/09-hip3-meta.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "dex_index": 1,
  "dex": {
    "name": "xyz",
    "fullName": "XYZ",
    "deployer": "0x88806a71d74ad0a510b350545c9ae490912f0888",
    "oracleUpdater": null,
    "feeRecipient": "0x83ffcfb1f2ad843c474b2e28df86c721cb869d3a"
  },
  "market_index": 1,
  "meta": {
    "szDecimals": 3,
    "name": "xyz:TSLA",
    "maxLeverage": 20,
    "marginTableId": 20,
    "growthMode": "enabled",
    "lastFeeScaleChangeTime": "2025-11-23T17:37:10.033211662",
    "deployerFeeScale": "1.0"
  },
  "context": {
    "funding": "0.0000079172",
    "openInterest": "109629.86",
    "prevDayPx": "383.4",
    "dayNtlVlm": "18341916.6711999886",
    "premium": "0.0005584353",
    "oraclePx": "374.26",
    "markPx": "374.42",
    "midPx": "374.455",
    "impactPxs": [
      "374.45",
      "374.488"
    ],
    "dayBaseVlm": "48376.127"
  },
  "asset_id": 110001,
  "collateral_token": 0
}
```

边界：不是股票所有权；Oracle具体外部定义与完整历史风险参数未独立核验。
