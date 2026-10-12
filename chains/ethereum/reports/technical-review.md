# 技术审查

2026-10-10。正文、图、字段和案例按下列证据复核；运行与静态检查严格分开。

- 协议事实：[事实台账](../research/fact-ledger.md)；现行7702采用持久委托，授权处理不随后续执行失败回滚；现代主网Fusaka已上线，Glamsterdam未凭路线图推定上线。
- 六张核心表与四张加工/兼容表：[实时Schema](../research/schema-notes/target-schemas.json)。提款文档/目录类型差异与时间类型差异有明确记录。
- 12条新SQL：表、选择字段、连接键、范围、类型和数值转换逐项静态核对；没有完整Dune解析器或运行证据。全部STATIC_CHECKED，未标运行PASS。05采用失败祖先反连接，仅覆盖非根CALL Value；06仅固定普通交易执行费。
- 8条作者SQL原样保存，取回各3行2026-08-19旧执行结果；不把旧运行状态替新SQL背书。同日交易数与成败样本核对，创建地址差数及DEX估值空值保留。
- [案例一致性](case-evidence-validation.json)：15项本地检查通过，包含输入参数、原始日志数量、Pool返回、有符号Swap数量、两次WETH余额读取差额、费用乘积和销毁/优先费拆分。不是完整State Diff审计。
- 图C中Logs与状态并行来自执行，图D没有Trace→Log物理子表关系；代理图把代码来源与状态上下文分开；Swap图未虚构Delegatecall；费用图明确独立Blob费。
- 八个有效案例Hash的观察范围见[案例库](../examples/transactions/README.md)。Case03与05已更换成证据更完整的主案例，旧候选归档；剩余原收据、完整代码及现代授权字段缺口仍限定结论。

技术审查状态：VALIDATED。规定的本地结构与图形检查可完成；新增SQL运行与部分案例外部材料仍未齐备。不存在已知被静态确认不能执行的示例，但不据此保证上线运行无误。

## 2026-10-11续作核对

新增14项[本地检查](continued-evidence-validation.json)通过：授权事件零/最大整数与角色、直接输入ABI、创建动态编码与事件、费用一致性，以及明确标DERIVED的Blob费拆分。原15项保持通过。Dune唯一free探针被只读账户拒绝，运行状态BLOCKED_READ_ONLY_ACCOUNT，不冒充语法错误或查询执行失败。
