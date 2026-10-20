# LGNS关键旧结果完整取回与核对

整理日期2026-10-20；固定研究基准2026-10-19。本次只取既有执行，未重跑SQL。

| Query | 完整取得行数 |
|---|---:|
| [8369671](https://dune.com/queries/8369671) | 2632 |
| [8389592](https://dune.com/queries/8389592) | 898 |
| [8389804](https://dune.com/queries/8389804) | 898 |
| [8390372](https://dune.com/queries/8390372) | 3584 |
| [8390785](https://dune.com/queries/8390785) | 40 |
| [8391200](https://dune.com/queries/8391200) | 30 |

共8082行。完整取回仅表示等于服务端声明的结果行数，不表示全部Raw事件已下载或独立重新索引。原有38份每项最多5行样本保留；新增六份文件以full-开头，分别记录执行ID。

- 8369671 retrieved_all_declared_result_rows：PASS。
- 8389592 retrieved_all_declared_result_rows：PASS。
- 8389804 retrieved_all_declared_result_rows：PASS。
- 8390372 retrieved_all_declared_result_rows：PASS。
- 8390785 retrieved_all_declared_result_rows：PASS。
- 8391200 retrieved_all_declared_result_rows：PASS。
- 8390372 all_retrieved_exit_scenarios_formula：PASS。
- 8369671 all_rebase_ratio_index_scaling：PASS。
- 8391200 monthly_net_sum_matches_repeated_total：PASS。
- 8391200 published_classification_diagnostics：PASS。
- 8389592 published_reserve_reconciliation_samples：PASS。

退出模型共3584个情景，最大算术差2.31137742205531435608292663730E-8DAI；Rebase2632行单位换算；月度净额与总额一致；储备对照仅针对原查询非空样本日，不扩大为898天均有独立余额验证。

初始仓位以历史日价线性换算，未模拟大额初始建仓冲击；费用历史与储备输入仍来自旧研究。查询之间的截止差异继续保留，不拼成新的统一观测。
