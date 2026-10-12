# 36｜查询 DEX 成交，应该从转账表还是成交表开始？

一次 Swap 里可以有多条 Token Transfer。用户把输入交给 Router，Router 把资金给 Pool，Pool 再交付输出。若把这些金额全部累加，就会同时计入输入、中间搬运和输出，结果很难叫作单一业务成交量。

我们要看 Case 04 的池级成交解释，应从已核实的 `dex_evm.trades` 开始。示例限定 Ethereum、UTC 日期、月份分区与交易哈希，查看项目、版本、池地址、输入输出资产和数量，并保留金额估值是否为空。结果一行代表模型识别的执行段。

当前官方文档说明，多跳经过多个池会出现多行。用户一次 USDC 到某代币的兑换，可以先经 WETH，再到目标资产。两段各自都有池级成交价值；按池吞吐量汇总有其意义，但不能把它自动称为用户最终支付额。

作者 Query 8378491 明确采用这个粒度，并同时输出成交段数与去重交易数。2026-05-21 的已有结果样本记录 358,418 段、223,698 笔相关交易，平均每笔约 1.60224 段。样本说明两种计数不同，不代表每个用户都恰好做了 1.6 次兑换。

`tx_from` 是交易发起地址代理指标；Taker、Maker 与事件 Recipient 又可能有不同语义。Aggregator、Keeper 与合约钱包参与后，不能把任意其中一列直接叫作最终用户。选择指标时，应先查模型定义，再说明现实角色的证据缺口。

USD 金额也不是链上原生字段。它来自价格模型或协议转换规则。样本有 3,416 条缺失估值，比例约 0.953%。SUM 通常跳过空值，如果不报告覆盖率，看起来完整的成交额实际上只覆盖有估值部分。

同一交易也能查 `tokens.transfers`。这份查询更适合观察资产移动，包括 WETH Deposit 的规范化记录。它与 DEX 表相互补充，但不会自动组成无重复总流水。把 Raw Transfer、Curated Transfer 与 DEX 行全部 Union，实际上多次使用了同一底层活动。

本章提供两条独立示例：一条看 DEX 执行段，一条看指定资产流水。二者都经过字段与结构静态审查，尚未在 Dune 执行。真实案例的 Pool、日志与调用已经取得，模型是否覆盖这笔新的主网交易，仍须运行后确认。

读取结果时，先用资产地址与事件定位回到原证据，再看人类单位和估值。Curated 帮助我们快速提出业务问题；准确结论仍需解释它的粒度、来源与覆盖。

若加工表没有覆盖这笔新交易，可以退回已取得的原日志与调用资料，说明主要过程。空结果需要检查模型支持、索引延迟与范围，不能因为高级模型没返回，就抹去已由原始记录支持的执行事实。

反过来，高级模型返回了一条成交也不保证能回答全部资金问题。它可能只记录池结算段，未包含费用与包装路径。把成交表与流水表并排，而不直接相加，有助于分别解释协议吞吐量、用户支付和最终资产接收。

执行段统计也需选择协议范围。同一查询包含多个项目时，结果描述应明确网络和模型覆盖，不能给所有记录贴同一个应用名称。

下面的固定范围示例与外链文件一致，供逐行阅读；运行状态为静态审查，未执行。

```sql
SELECT blockchain,project,version,tx_hash,evt_index,project_contract_address,
       token_sold_address,token_bought_address,token_sold_amount_raw,token_bought_amount_raw,
       token_sold_amount,token_bought_amount,amount_usd,amount_usd IS NULL AS usd_missing,tx_from
FROM dex_evm.trades
WHERE blockchain='ethereum' AND block_month=DATE '2026-10-01'
  AND block_date=DATE '2026-10-08' AND tx_hash=0x7ca3d8182d16bf406ba0780df78748bd6ee01d33df012ff0e359e081e6d69537
ORDER BY evt_index;
```

![查询 DEX 成交，应该从转账表还是成交表开始？的教学图](../../assets/diagrams/lineage.svg)

[编辑此图](../../assets/diagrams/lineage.drawio)

[完整 SQL：10-dex-segments](../../examples/sql/10-dex-segments.sql)（STATIC_CHECKED；未在 Dune 执行）。

依据：[DEX 模型](https://docs.dune.com/data-catalog/curated/dex-trades/evm/dex-trades)；[作者 DEX Query](https://dune.com/queries/8378491)；[Token Transfer 模型](https://docs.dune.com/data-catalog/curated/token-transfers/evm/token-transfers)。核验日：2026-10-10。

[上一章](../part-09/35-raw-log-sql.md) · [目录](../../SUMMARY.md) · [下一章](../part-10/37-swap-reconstruction.md)
