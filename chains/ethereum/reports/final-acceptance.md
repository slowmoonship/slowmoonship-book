# Ethereum 篇最终验收与续作状态

更新：2026-10-11。协议与Catalog主要观察基准：2026-10-10。整体状态：**VALIDATED**。

40章正文及本地工程已完成并通过本地检查。续作补强授权、创建与Blob费用案例；新增SQL仍未运行，原因已确定为当前Dune接入账户只读，不能将整体标为全部验证COMPLETE。

## 书稿成果

出版路径：`chains/ethereum/`。原始本地工作路径不公开；以下为原书稿验收记录，原校验计数不代表出版清单的计数。

| 成果 | 数量／状态 |
|---|---|
| Part／正文章 | 10／40，另有前言与4个附录 |
| 正文汉字 | 34,976；仅40章正文，排除标题、代码、图注、来源、导航 |
| 正文全部字符 | 51,380；含英文、数字、标点 |
| draw.io／SVG | 31／31：29张原图，加授权与创建具体案例2张 |
| 新增教学SQL | 12；STATIC_CHECKED；实际运行BLOCKED_READ_ONLY_ACCOUNT |
| 有效案例Hash | 8：六类主案例及直接授权、代码委托两个补充；旧候选独立归档 |
| 作者Query获取／复用 | 8／8，原SQL及每条3行旧结果 |
| 已核实Schema | 10表：六核心表及四加工／兼容表 |
| 正文来源URL | 66，其中官方文档、规范及项目主源51 |
| 本地证据一致性 | 29项：原15项及续作14项，全通过；不是Dune运行结果 |

[逐章字数](word-counts.md)没有800字以下或1500字以上异常。主网请求、执行树、日志、状态与平台模型明确分开；原Solana、Sui稿件及审计数据未修改。

## 续作完成的事项

授权主案例更换为可取得事件参数的交易：USDT在同交易保留零与最大Uint256两条Approval，Owner、Spender、顶层提交者分别标注。另保存11 USDT直接授权完整输入，不能拿另一交易事件补齐它的日志。旧10月索引候选保留归档。

创建主案例更换为工厂调用：取得完整顶层输入、新地址、过滤创建路径与一致创建事件。图上未补画未知父调用，不仅凭create标签推定CREATE/CREATE2。旧Uniswap索引候选归档。

Blob总费与执行费差额已按浏览器明示口径推导：执行费189145568248344 Wei、Blob费1627833761792 Wei、一个Blob的131072 Gas以及推导单价12419386 Wei。取得与推导分别保存，未伪造原收据字段或Blob正文。

12/22/28/35章、对应SQL定位、来源、案例索引及进度已同步，两张新案例图实际渲染并单独视觉检查。[续作记录](continuation-2026-10-11.md)、[新增核对](continued-evidence-validation.json)。

## 验收状态

| 检查 | 状态 | 证据范围 |
|---|---|---|
| 文件结构、UTF-8、编号 | COMPLETE | 40章、10 Part与规定工程文件 |
| 本地引用 | COMPLETE | 最终校验通过，计数见validation.json；当前495个引用 |
| 图形XML／SVG | COMPLETE | 31对有效XML、非空非零SVG、独立可编辑节点与连接 |
| 实际渲染与视觉检查 | COMPLETE | 31张PNG，最终联系表及新增图独立看；SVG哈希绑定检查记录 |
| SQL静态审查 | VALIDATED | 表、字段、类型、单位、粒度、范围、连接；无完整Dune解析器验证 |
| SQL实际运行 | BLOCKED | 唯一显式free探针被当前只读账户拒绝，无Query或Execution ID |
| 作者旧执行样本 | VALIDATED | 八条2026-08-19运行各3行，未重跑、未审核全90日结果 |
| 技术事实与案例 | VALIDATED | 官方规范、实时Catalog和明确取得材料；原字段缺口限定结论 |
| 编辑与一致性 | COMPLETE | 40章逐章检查，四章按新证据修订 |

程序结果见[validation.json](validation.json)。本地结构通过不代表Dune执行通过。图形验收针对SVG真实渲染；桌面CLI曾exit134，使用任务允许的同场景脚本导出，没有声称桌面导出或原生编辑器逐图打开成功。小屏可缩放SVG阅读长表名与双语附注。

## 费用与外部操作

- Jev：0次，已知0美元；不购买或充值。
- Dune：先只读取得原SQL、24行旧结果、Catalog与用量。MCP元数据支持free引擎后，仅发出1次私有临时查询请求，固定真实Hash、UTC日及高度，max_rows_returned=0。服务端返回：`Your account is read-only. Upgrade to create content or run queries.` 未返回Query/Execution ID，没有启动SQL。脚本已防止自动重试和付费回退。
- Dune用量快照返回本周期credits_included=0、credits_used=0；不将该字段扩大解释为完整预付余额或精确账单。API读取/下载额度计费未单独推定。
- Blockscout：原会话8次免费数据调用，含1次尺寸限制失败；未新开会话绕过额度，未购买PRO Key。
- 本地采用已有捆绑sharp/Pillow，未安装新包。没有充值、升级订阅、发起链上交易、修改作者Dashboard或建站部署。

## 剩余验证边界

1. 12条新SQL实际运行需要Dune接入恢复创建/执行权限。当前阻碍是服务端权限，不能靠改SQL、重复重试或静态推理解决。[拒绝记录](../research/sql-execution/status.json)。
2. 授权案例仍未取完整原RPC收据、调用树和部分原Topic/Data；已取得的解码值不重新编码成“原始实读”。直接授权补充也未取独立Approval Log。
3. 创建案例未取完整Raw Trace、完整Initcode与Runtime Code；足以演示内部创建证据对应，尚非完整部署字节验证。
4. Blob费已明确推导，原收据Blob字段与正文仍缺；7702补充的完整授权字段和历史账户状态仍缺。
5. Swap完整State Diff未取，主要调用和原Logs已核对；Schema快照不证明全历史唯一性、覆盖或新鲜度。

这些边界不妨碍已限定的书稿内容阅读，但妨碍宣称全部运行与原始证据均COMPLETE。[当前缺口](../research/unresolved.md)、[技术审查](technical-review.md)、[编辑审查](editorial-review.md)、[SQL静态审查](sql-static-review.md)。

[阅读入口](../README.md) · [全篇目录](../SUMMARY.md) · [出版状态](../../../PUBLICATION_STATUS.md)
