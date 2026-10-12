# SQL 静态审查

12条新增示例表与字段按实时Catalog核对，粒度、单位、分区范围和连接逻辑按正文与规范审查。没有启动Dune执行；没有使用另一SQL方言运行结果冒充Dune验证。尚无完整Dune解析器验证，运行可能暴露额外类型或优化器限制。

| 示例 | 审查要点 | 状态 |
|---|---|---|
| 01-one-transaction | 固定主网Hash/日期/高度；顶层Value不代表总流量。 | STATIC_CHECKED / NOT_EXECUTED |
| 02-traces-and-logs | 带类型标签的证据列表，不把UNION结果作为资产流水；NULL与Uint256/Varbinary类型对齐。 | STATIC_CHECKED / NOT_EXECUTED |
| 03-usdt-transfer | 固定USDT与Transfer布局；地址按字节切片；保留原Uint256；显示列近似。 | STATIC_CHECKED / NOT_EXECUTED |
| 04-usdt-approval | 固定新双Approval主案例，Owner/Spender/额度已在浏览器核对；原字节仍由新SQL查证。 | STATIC_CHECKED / NOT_EXECUTED |
| 05-native-call-values | 非根CALL正Value，排除失败祖先；明确不覆盖创建、销毁、提款、费及历史奖励。 | STATIC_CHECKED / NOT_EXECUTED |
| 06-execution-fee | 固定普通案例，精确Wei乘积；不当作完整Blob或全时代通用总费。 | STATIC_CHECKED / NOT_EXECUTED |
| 07-safe-join | Trace/Log分别汇总到Hash粒度后再连接；没有明细乘法。 | STATIC_CHECKED / NOT_EXECUTED |
| 08-contract-creation | 使用核实block_month分区；内部创建不靠顶层To为空识别。 | STATIC_CHECKED / NOT_EXECUTED |
| 09-withdrawals | 独立操作粒度，Gwei换算；50行固定一天样本，不伪造tx_hash。 | STATIC_CHECKED / NOT_EXECUTED |
| 10-dex-segments | 核实dex_evm命名空间；链+月+日+Hash范围；段粒度及空估值保留。 | STATIC_CHECKED / NOT_EXECUTED |
| 11-token-movements | 核实Curated来源身份字段；不与Raw或原生Trace重复叠加。 | STATIC_CHECKED / NOT_EXECUTED |
| 12-daily-addresses | 固定UTC日；地址指标非真实用户；空Hash与状态单列。 | STATIC_CHECKED / NOT_EXECUTED |

作者8条Query的历史已执行样本另见[查询目录](../research/dune_query_catalog.md)，不替这些新例子提供运行PASS。

2026-10-11：04与08定位改为新主案例；01显式free探针被账户只读拒绝，不产生运行证据。
