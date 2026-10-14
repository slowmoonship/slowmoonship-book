# Case 04｜实际用户资金费收款

状态：**OBSERVED**；证据层级：1；基准日2026-10-13。

- [原始记录：20-user-funding.json](../../examples/api/20-user-funding.json)
- [原始记录：06-btc-funding.json](../../examples/api/06-btc-funding.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "user_funding_excerpt": {
    "time": 1791788400061,
    "hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "delta": {
      "type": "funding",
      "coin": "BTC",
      "usdc": "9.034535",
      "szi": "-9.69594",
      "fundingRate": "0.0000110632",
      "nSamples": null
    }
  },
  "records_observed": 24
}
```

边界：直接使用支付金额；未独立取得该轮完整Oracle输入并重算全协议。
