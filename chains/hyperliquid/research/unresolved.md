# 未解决事项与验证缺口

| 项目 | 状态 | 原因 / 后续验证对象 |
|---|---|---|
| 新增18SQL运行 | BLOCKED_READ_ONLY_ACCOUNT | 用户限定只读，不创建、不执行；无新结果 |
| 最新HyperCore/Outcome entitlements | UNKNOWN_RUNTIME_PERMISSION | Catalog可见，当前未提交运行探针；官方与旧资料表明gate |
| Oracle表实时Catalog | DOC_SCHEMA_ONLY | 有官方字段页，限定搜索未返回该表，不反复绕权限 |
| 原始签名Action | BLOCKED_EVIDENCE | 订单状态与Fill已取得，完整Action未取得 |
| Case02终态 | BLOCKED_ORDER_HISTORY | 返回unknownOid；不宣称原始量/余量/完整成交比例 |
| 真实清算 | BLOCKED_EVIDENCE | 两账户无标记；核对HLP Liquidator后30分钟Fill为空；没有处置全链 |
| 指定HIP-2策略 | BLOCKED_EVIDENCE | 无策略余额、订单身份及完整变化 |
| Core/EVM真实资产移动 | BLOCKED_EVIDENCE | 50块HYPE系统日志及固定块系统交易为空；接口存在不补齐转移 |
| 质押事件链 | SNAPSHOT_ONLY | 摘要不证明委托、奖励与退出历史 |
| HLP申赎份额全史 | SNAPSHOT_ONLY | VaultDetails已取得，未取得全体份额对账 |
| 全市场OI独立核算 | NOT_REPLAYED | 采用官方Dune单双边语义，未枚举全账户同刻状态 |
| Funding独立重算 | PARTIAL_INPUTS | 支付金额真实，未取得每轮全部Oracle和精度执行输入 |
| HIP-4任意主网部署 | NOT_PROVEN | 官方部署接口Testnet-only，已有主网市场不代替权限 |
| 所有CoreWriter Actions | NOT_EXECUTED | 用户禁止链上写；只读取规范和主网代码 |
| 历史全簿/全保证金 | NOT_RECONSTRUCTED | 无完整起始状态和有序增量 |
| 默认RPC历史状态 | LIMITED | 可读区块/收据不代表任意历史eth_call |
| 文档冲突激活日期 | UNKNOWN | 保存原文与实际观察，没有补造升级日 |
| 各表最新时点/缺失/唯一性 | NOT_RUN | Metadata不能证明数据质量 |
| 跨抵押市场美元金额 | ASSUMPTION_REQUIRED | usd列部分为quote单位；FX与稳定币偏离需外部验证 |
| 外部独立技术审查 | NOT_PERFORMED | 本篇执行者完成自审，未声称独立第三方背书 |

工程完整性可本地验证；以上外部事实与运行缺口不因自动PASS消失。整体保持VALIDATED，不标成全部运行COMPLETE。
