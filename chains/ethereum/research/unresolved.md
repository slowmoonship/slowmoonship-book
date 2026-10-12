# 当前缺口与已经解决的项

更新：2026-10-11。来源字段读取于2026-10-10，续作的本地检查与归档于2026-10-11。整体状态VALIDATED。

| 项目 | 当前状态 | 已取得／仍缺 |
|---|---|---|
| 12条新SQL运行 | BLOCKED_READ_ONLY_ACCOUNT | 显式free引擎一次探针被服务端拒绝：Your account is read-only. Upgrade to create content or run queries. 没有Query/Execution ID，不回退付费，不充值 |
| 授权教学主案例 | VALIDATED_EVENT_FIELDS | 新案例已取得两条USDT Approval的Owner、Spender、零/最大Uint256额度；原10月候选归档。仍非原RPC收据或完整调用树 |
| 直接授权输入补充 | VALIDATED_INPUT | 11 USDT的完整approve输入与字段核对；原Approval日志未取得，不混用另一个交易事件 |
| 合约创建教学主案例 | VALIDATED_INPUT_CREATION_AND_EVENT | 新工厂调用取得完整顶层输入、创建地址、路径展示及一致创建事件。仍缺完整Raw Trace、Initcode和Runtime Code，不由create标签断定Opcode |
| Blob费用解释 | VALIDATED_DERIVATION | 已按浏览器总费口径精确分拆执行/Blob费并推导单价，取得值与推导值分列。仍缺原收据Blob字段与正文 |
| 7702补充 | VALIDATED_TYPE_ONLY_WITH_AUTH_GAP | 真实类型4及无效授权展示；完整授权字段与历史状态缺失，不推定成功委托 |
| Swap完整状态差异 | VALIDATED_MAJOR_FLOW | 八条含根Raw Trace、四条原Logs及主要资产核对；完整State Diff未取得，不称全面审计 |
| 数据质量覆盖 | SCOPE_LIMIT | Schema已核实10表；未全历史验证唯一性、覆盖及新鲜度，这不是一本入门书必须通过无界扫描清零的范围 |
| 图形桌面导出 | ACCEPTED_FALLBACK | CLI exit134；真实可编辑XML与同场景SVG已实际渲染、视觉检查，未声称桌面导出成功 |

证据缺口不改写为失败链上动作或已完成运行。主案例已选择可核验的更完整材料；剩余原始字段缺口在相关结论中限定。[SQL探针记录](sql-execution/status.json)、[续作核对](../reports/continued-evidence-validation.json)。
