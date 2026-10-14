# Case 11｜HLP当前Vault身份与历史呈现

状态：**OBSERVED**；证据层级：2；基准日2026-10-13。

- [原始记录：29-hlp-vault.json](../../examples/api/29-hlp-vault.json)
- [原始记录：30-hlp-child.json](../../examples/api/30-hlp-child.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "parent": {
    "name": "Hyperliquidity Provider (HLP)",
    "vaultAddress": "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303",
    "leader": "0x677d831aef5328190852e24f13c46cac05f984e7",
    "description": "This community-owned vault provides liquidity to Hyperliquid through multiple market making strategies, performs liquidations, and accrues platform fees.",
    "leaderFraction": 0.0020053895374148403,
    "isClosed": false,
    "relationship": {
      "type": "parent",
      "data": {
        "childAddresses": [
          "0x010461c14e146ac35fe42271bdc1134ee31c703a",
          "0x2e3d94f0562703b25c83308a05046ddaf9a8dd14",
          "0x2ed5c4484ea3ff8b57d5f2fb152a40d9f2b68308",
          "0x31ca8395cf837de08b24da3f660e77761dfb974b",
          "0x469f690213c467c39a23efacfd2816896009d7d8",
          "0x5e177e5e39c0f4e421f5865a6d8beed8d921cb70",
          "0xb0a55f13d22f66e6d495ac98113841b2326e9540"
        ]
      }
    }
  },
  "liquidator_child": {
    "name": "HLP Liquidator",
    "vaultAddress": "0x2e3d94f0562703b25c83308a05046ddaf9a8dd14",
    "relationship": {
      "type": "child"
    }
  }
}
```

边界：原响应有权益历史，公开父子关系与HLP Liquidator身份已取得；没有完整申赎、份额与用户收益对账。
