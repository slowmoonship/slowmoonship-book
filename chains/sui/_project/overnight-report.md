# Sui 篇本轮交付报告

交付日期：2026-10-10。整体状态：**PARTIAL**。本地中文书稿 v0.1 已完成正文、图形与阅读结构验收；新 SQL 的 Dune 运行核验仍有明确 402 限额缺口。

## A. 完成成果

| 项目 | 实际结果 |
|---|---|
| 已写模块 | 10 个核心模块，另有 SUI 00 与 SUI 99 |
| 模块状态 | 9 个核心模块 COMPLETE；SQL 实践模块 VALIDATED，保留运行缺口 |
| 阅读章节 | 45/45 个 Markdown；39 个 COMPLETE，6 个 SQL 相关章节 VALIDATED |
| 中文正文 | 约 25,830 字；统计 CJK 正文字符，排除标题、代码块、表格及导航，不含英文词和数字 |
| 图形 | 13 张原生可编辑 .drawio，13 张 SVG，13 张 PNG 预览 |
| 新本地 SQL | 9 份 STATIC_CHECKED；成功新执行 0 次；提交尝试 1 次 |
| 历史 SQL | 12 份完整源码与版本已缓存，未改写远端查询 |
| 历史执行证据 | 读取 Query 8348409 一个缓存执行的一行；有实际 Execution ID，不声称本轮重新运行 |
| 真实案例 | SUI 原生转移、多路由 SUI→USDC、Shared Pool 创建与版本切片；官方只读接口核验 |

阅读入口：[README](../README.md)。全书采用开篇 → 模块总章 → 细分章节 → 模块总结 → 综合总结。没有空白章节或无效图示占位。

## B. 历史资产复用

找到 Runtime SVG 的原始 draw.io，确实包含可编辑节点与关系。历史源文件和原图保持只读，全部保护性 SHA-256 比较通过。新 Runtime Map 来自原图副本，保留 Swap 视觉布局，补齐 05，改为共同网络排序，再展开同一 PTB 的对象条件。缩短溢出标签，明确 Event 可选、输出只是教学场景、Epoch 为背景、Checkpoint inclusion 不是首次确定性的唯一条件。

旧六表 DBML 的组织结构继续作为教学入口。六张真实表名与字段由 2026-10-10 Catalog API 核实；Data Map 重新建立原生 draw.io，并注明逻辑连接不等于声明的外键约束。

已有 SUI 02 的 Transaction Data、Inputs、Commands 与 Result Flow 解释在新模块中复用整理，历史正文未覆盖。两份用户附件已实际读取并缓存；重复讨论和旧 Fast Path 叙述没有拼入新书。

通过已配置 Dune MCP 搜索确认 slowmoonship 团队的 Sui Dashboard 219547 与十二个 Query。MCP Query 流式内容获取中断后，通过 CLI 只读缓存全部完整 SQL。准确 ID、URL、版本、来源与依赖见 [Query 登记](../references/dune-queries.md)。原看板、Query、Git 状态没有被修改。

## C. 验收结果

- 阅读目录、45 章正文、补充参考资料与本地图像路径有效。
- 原生 XML 的 root/layer、唯一 ID、结构节点、关系与边几何通过；SVG 有真实矢量内容并嵌入模型。
- PNG 实际尺寸与逐图视觉检查通过，修复泛型角括号消失、箭头穿过 Gas 框、Module 到类型的关系，以及 Ownership 分类与主线混淆。
- 图形最终文件哈希与视觉记录绑定于 [diagram-review.json](./diagram-review.json)，来源与概念审查见 [technical-review.json](./technical-review.json)。
- 本地 SQL 表名、限定字段、日期窗口与只读边界检查通过，并人工审查未限定字段、JOIN 粒度和统计语义；没有声称它已由 Dune SQL 引擎编译或执行。
- 案例 A 的金额、收款、输出 Coin 和费用互相一致；案例 B 的 18 MoveCall / 19 Event 与净费用来自完整官方快照；Pool 创建、版本及 Swap 前后数值都有明确证据位置。
- 历史素材 SHA-256 未变；正文无重复整段和待编写占位。

未通过或尚未覆盖：新 SQL 执行、当前 Dune 候选键唯一性与 JOIN 覆盖、新鲜度和完整历史范围、Pool 的全部后续生命周期。已有缓存执行也没有证明当前 SQL 保存版本与当时执行字节一致，不把整份旧 Query 虚报 VERIFIED。

## D. 资源与恢复

Dune 新 SQL 提交 1 次，返回 402 configured datapoint limit，未取得 Execution ID。没有重复新执行、修改付费限额或充值。旧结果 GET 读取了一行（8 个数据点）；执行发生于 2026-08-16，日期行是 2026-05-10，不能当作当前网络快照。Dune 结果读取与模型资源的本轮实际费用无法完整核算。

未调用 Jev 或其他付费审稿模型，外部审稿可核算费用为 0 美元。没有自动充值，没有 GitHub 推送，没有链上签名或 mutation。

App heartbeat 曾成功创建，并实际送达两次恢复触发；本地验收后已暂停。备用 Python supervisor 完成分类、退避与启动预览检查，未启动真实 Codex 子进程、未安装 launchd。单实例锁、写作租约、停止文件、受限日志与最大运行次数已实现。内部调度材料留在作者原工程；出版副本处理见 [出版副本说明](../../../publication/sui/2026-10-13-v0.1/CHANGES.md)。当前没有后台作者继续写作。

## E. 恢复位置与优先阅读

本地正文无需从头重写。恢复只应在 Dune 执行条件发生实际变化或用户提出新编辑要求后进行。运行验证从九份 SQL 的当前 Schema、历史日期覆盖、候选键和连接覆盖开始，保留真实结果，再决定能否升级 SQL 状态。不会自动反复请求 402。

优先阅读：

1. [SUI 00｜From Runtime to Data](../00-from-runtime-to-data/index.md)：两张总地图及它们的桥梁。
2. [SUI 02｜Transaction / PTB](../02-transactions/index.md)：理解请求、结果流与原子性。
3. [09.2｜真实多路由 Swap](../09-sql-practice/02-swap.md)：将协议、对象、事件与资金证据放在同一事务边界。
