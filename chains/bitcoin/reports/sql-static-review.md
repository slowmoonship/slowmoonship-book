# SQL静态审查

16条新增SQL：STATIC_CHECKED；执行：BLOCKED_READ_ONLY_ACCOUNT。没有新增Query或Execution ID，没有服务端解析器验证。

核对实际四表列名与类型：transactions.id；inputs/outputs.tx_id；前序spent_tx_id与spent_output_number；blocks.date与其他表block_date。SQL02 witness_data已在实时Catalog核实。

费用限定普通交易，避免将Coinbase特殊输入连接为普通前序输出。09/10先在各自粒度汇总；没有未经聚合输入×输出导致的重复金额。

SQL05/11/12/13按真实追踪修订为2010-11-16至18，创建分区保留2009-01-12。SQL06只是单日创建候选；07一个指定地址需此前全部历史，不默认执行，须先审核扫描成本。输入索引延迟、重组与空值会影响解释。

DOUBLE金额保留approximate命名，不能当整数聪精确审计。14/15仅HEURISTIC；15的LIMIT可能截断交易，只用于展示，不计算付款量。16没有首次广播数据，不能计算确认等待或因果关系。

原Query10份只读复用，其中两份旧执行仅取得1+3行，不冒充新增SQL执行。
