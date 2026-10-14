# 《慢月船：链上数据之路》Bitcoin篇

slowmoonship: Gateway to Onchain Data — Bitcoin

从钱包里的BTC到UTXO生命周期，再到SQL、交易图谱和资金血缘。9 Part、36章完整正文；34张双语可编辑draw.io与SVG；16条教学SQL；12个版本化RPC请求；10个真实案例主题（8个不同主交易，另有三层后续交易）。研究基准日2026-10-13。

[顺序阅读目录](SUMMARY.md) · [完整合并稿](BOOK.md) · [前言](book/00-preface.md) · [最终验收](reports/final-acceptance.md)

整体状态：**VALIDATED**。文件工程、结构复算、金额与花费引用检查完成；新SQL未执行，RPC无实际节点返回，完整附加资产索引与独立共识验证留有明确缺口。[验证边界](research/unresolved.md)

图形：[索引](assets/diagrams/DIAGRAM_INDEX.md)。数据：[实时Schema](research/bitcoin_schema.md)、[作者Query](research/dune_query_catalog.md)、[Mainnet案例](research/transaction_case_index.md)、[证据层级](research/evidence_index.md)。

可在Bitcoin目录中运行：

```sh
python3 scripts/verify_case_evidence.py
python3 examples/python/proportional_lineage.py
```

离线核验不访问网络，不执行Dune，不启动节点。研究抓取脚本为显式可选工具，不是阅读或验收的必要前置。

## v0.1 出版说明

2026-10-14，作为第五条公链公开。保留原稿 VALIDATED 的限定范围，16条新SQL为 STATIC_CHECKED / NOT_EXECUTED，12个Core 31.0.0 RPC为 NOT_EXECUTED，作者人工审读 UNKNOWN。GitBook NOT_CONFIGURED（仓库证据；平台账户及同步 UNVERIFIED）。

公开副本保留离线案例核验和比例模型教学脚本；源工程生成、抓取与整体验收工具留在本地。上述离线脚本会更新副本中的报告，不访问网络。[本次出版清单与检查](../../publication/bitcoin/2026-10-14-v0.1/README.md)。三条后续花费边截止高度92640，没有追到当前链头；启发式和比例份额不证明身份或最终归宿。
