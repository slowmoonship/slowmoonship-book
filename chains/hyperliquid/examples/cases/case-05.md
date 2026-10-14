# Case 05｜清算事件

状态：**BLOCKED_EVIDENCE**；证据层级：1；基准日2026-10-13。

- [原始记录：30-hlp-child.json](../../examples/api/30-hlp-child.json)
- [原始记录：31-liquidator-fills.json](../../examples/api/31-liquidator-fills.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "verified_liquidator_name": "HLP Liquidator",
  "finite_30min_fills": []
}
```

边界：两账户样本无清算标记；定向核对HLP Liquidator身份后，30分钟Fill返回空。无真实清算，不编造金额或终态，也不推断全市场没有清算。
