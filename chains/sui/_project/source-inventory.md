# Sui 素材调查

调查日期：2026-10-10。范围仅限本项目、用户附件与已配置技能。

| 素材 | 结论与复用方式 |
|---|---|
| `reports/sui-00-how-sui-works/sui-one-transaction-through-runtime.svg` | 存在，约 1.87 MB；配套 `.drawio`、PNG 均存在。作为 Swap 图的视觉与案例基础，复制后纠正编号及当前排序口径。 |
| 同目录 `sui-master-runtime.drawio` | 原生结构节点与关系可编辑；已有共同网络排序口径。旧导出 SVG 与源文件可能不同步，不直接采用旧导出。 |
| `sui-master-runtime.before-runtime-fix.drawio` | 历史版本，只读保留。 |
| `diagrams/sui_core_data_model.dbml` | 2026-09-07 历史六表关系；复用组织思路，以 2026-10-10 API Catalog 重新核对字段，候选键不声称数据库约束。未找到对应可编辑六表 draw.io。 |
| `reports/sui-02-transactions-and-ptb/README.md` | 已有正式中文段落，复用 Transaction Data、Inputs、Commands、Result Flow 解释，拆分整理到新模块，图示占位由新图取代。 |
| 根目录两张 Balance `.drawio` | 可编辑历史图；币对象与地址余额的知识线索需当前官方来源核对。 |
| 本次总任务书与 SUI 00 附件 | 均已实际读取并缓存；开篇有多轮重复讨论，保留两张地图结构与数据分析入口，删除旧 Fast Path 叙述。 |
| 项目范围的 Sui SQL / Query ID | 初次本地调查未找到；后经现有 Dune MCP 确认十二份 Query 与一个 Dashboard，全部 SQL 已用 CLI 缓存，另读取一份历史缓存执行的一行。详见 references/dune-queries.md。 |

历史素材清单与保护性 SHA-256 留在作者原工程，不在公开仓库发布本机路径；本页所列旧素材路径属于历史研究位置，不是公开阅读链接。

六表 Schema 与历史 Query 的必要证据随书发布；本机工具配置和调度细节留在作者原工程。六表 Schema：[API 快照](cache/dune-catalog-2026-10-10.json)。

旧图审计重点：Swap 图缺 05；共识节点放在共享路径后可能暗示只有 Shared 交易排序；Event 必须为显式业务记录且不保证每个 DEX 发出；对象输出变化只是教学场景；Epoch 是背景；Checkpoint inclusion 不等于首次确定性。后续修订均在新目录副本进行。
