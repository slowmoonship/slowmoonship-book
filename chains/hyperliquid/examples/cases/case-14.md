# Case 14｜固定HyperEVM区块与收据

状态：**OBSERVED**；证据层级：1；基准日2026-10-13。

- [原始记录：14-evm-block.json](../../examples/api/14-evm-block.json)
- [原始记录：16-evm-receipt.json](../../examples/api/16-evm-receipt.json)

下列为教学节选或明确推导，完整原始响应在上述文件：

```json
{
  "height": 48408687,
  "block_hash": "0xe0fa471844f22a3c77e41ceffee7bbc7fb547348f992f63888b6cab94102b404",
  "transaction_hash": "0x24ff8a2f920e9bc8cb98be8feb9943713e3d1d6789f202d1152dd70e79c5432e",
  "receipt_status": "0x1",
  "gas_used": 66498,
  "log_count": 1
}
```

边界：固定块归属检查，非独立EVM或L1共识重放；不声称Core业务完成。
