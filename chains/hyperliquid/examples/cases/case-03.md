# Case 03｜BTC一笔撮合与双侧Fill

状态：**OBSERVED**；证据层级：1；基准日2026-10-13。

- [原始记录：capture.json](../../examples/websocket/capture.json)
- [原始记录：17-fills-0.json](../../examples/api/17-fills-0.json)
- [原始记录：17-fills-1.json](../../examples/api/17-fills-1.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "trade": {
    "coin": "BTC",
    "side": "A",
    "px": "83592.0",
    "sz": "0.00012",
    "time": 1791871824909,
    "hash": "0x9b950e1c389b236e9d0e0446737a2e0205e30001d39e42403f5db96ef79efd59",
    "tid": 972262344723288,
    "users": [
      "0x78dce96236804d6958bf3c4598cf5efbc371629c",
      "0xab9b1d113cd5e91e13418c4cb70c2cd682ef2c2a"
    ]
  },
  "buyer_fill": {
    "coin": "BTC",
    "px": "83592.0",
    "sz": "0.00012",
    "side": "B",
    "time": 1791871824909,
    "startPosition": "-7.53687",
    "dir": "Close Short",
    "closedPnl": "-0.04236",
    "hash": "0x9b950e1c389b236e9d0e0446737a2e0205e30001d39e42403f5db96ef79efd59",
    "oid": 572837845060,
    "crossed": false,
    "fee": "-0.0003",
    "tid": 972262344723288,
    "cloid": "0x40d33ceaf99a5c5a6c6cbd1ccac06fff",
    "feeToken": "USDC",
    "twapId": null
  },
  "seller_fill": {
    "coin": "BTC",
    "px": "83592.0",
    "sz": "0.00012",
    "side": "A",
    "time": 1791871824909,
    "startPosition": "0.00307",
    "dir": "Close Long",
    "closedPnl": "-0.005376",
    "hash": "0x9b950e1c389b236e9d0e0446737a2e0205e30001d39e42403f5db96ef79efd59",
    "oid": 572837864082,
    "crossed": true,
    "fee": "0.004513",
    "tid": 972262344723288,
    "feeToken": "USDC",
    "twapId": null
  },
  "single_trade_quote_notional": "10.031040",
  "double_leg_quote_sum": "20.062080",
  "buyer_after_local": "-7.53675",
  "seller_after_local": "0.00295"
}
```

边界：本地后态是此事件局部推导；不是稍后API快照；两腿各在平空/平多。
