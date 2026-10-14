# Case 13｜子账户USDC转移账务

状态：**OBSERVED**；证据层级：1；基准日2026-10-13。

- [原始记录：21-user-ledger.json](../../examples/api/21-user-ledger.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "time": 1791843401112,
  "hash": "0x1591c53917dc0683170b04466d677301de00dd1eb2df2555b95a708bd6dfe06d",
  "delta": {
    "type": "subAccountTransfer",
    "usdc": "277.0",
    "user": "0x78dce96236804d6958bf3c4598cf5efbc371629c",
    "destination": "0x7839e2f2c375dd2935193f2736167514efff9916"
  }
}
```

边界：接口标注subAccountTransfer；技术关系不是现实受益归属证明。
