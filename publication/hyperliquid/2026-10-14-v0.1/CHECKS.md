# Hyperliquid v0.1 出版检查

2026-10-14。复用marked GFM + github-slugger 2.0.0解析全部最终Markdown，检查相对链接、图片、中文路径、引用式链接、重复标题锚点、大小写、BOOK内部跳转、代码围栏和表格。全书SUMMARY与单链SUMMARY保持10 Part、40章及5附录层次，46阅读页各出现一次，BOOK另作完整合并版。上一章/下一章/目录补齐缺失边界；剥除记录的新增导航后所有阅读正文与源稿相同。

40对SVG/draw.io检查XML、尺寸、内嵌原生XML一致性、节点边关系和活动脚本/外部资源；Chrome真实渲染并作代表性视觉抽样。图形不重建。原draw.io CLI退出134保留，不能写成CLI逐图导出成功。PNG依正式索引引用全部保留。

全部JSON解析、引用闭包、API包装/原响应一致性、UTC获取时间和SQL字节核查。源工程31/31与1096引用为2026-10-13历史验收，不能替代本次公开范围检查。本轮复用离线verify_case_evidence.py检查保存证据的身份、字段及Decimal算术，结果单列；不重新计算模型，不进行独立金融重放。新增18条SQL STATIC_CHECKED / NOT_EXECUTED（BLOCKED_READ_ONLY_ACCOUNT）；12份历史Query及2旧结果未重跑。API获取为2026-10-13历史样本，出版未刷新。

unknownOid不证明完整成交，空数组不证明业务事件不存在。真实清算尚有证据缺口；HLP/Liquidator身份关联不代替真实处置事件或完整份额会计。HIP-2指定事件、HIP-3全权限、HIP-4创建权限/完整结算、Core/EVM双侧资产移动、质押和其他缺口均保持。327 Outcome/35 Question及正文“当前”按2026-10-13观察窗口解释。作者人工审读UNKNOWN，独立外部技术评审NOT_PERFORMED。

全部拟公开文件扫描私钥、助记词、API/Dune令牌、账户/交易认证、私有WS认证、SSH、环境配置、本机敏感路径和活动SVG；公开地址/OID/TxHash/Market标识保留，候选需上下文判断。第三方整页缓存留在本地，提供官方URL与哈希；综合版权/授权审查UNKNOWN，未添加许可。

旧Ethereum/Solana/Sui/Avalanche/Bitcoin内容及历史出版快照的路径/Git Blob逐文件比较，原Hyperliquid目录全部路径/SHA256比较。快照manifest覆盖本链内容，审计文件由Git Tree绑定；current-manifest仅排除自身哈希，避免循环。GitBook仓库NOT_CONFIGURED，平台账户和同步UNVERIFIED；未新建Space。外链不全面重爬，远端HTML资源验证与本地检查分开登记。

本轮最终结构PASS：全书3695/3695本地引用、889标题ID、46/46阅读页；40/40 XML配对与Chrome渲染、82/82离线案例检查。源稿460文件路径/SHA256及985旧内容/快照Blob不变；安全扫描无阻断项，JSON敏感键候选0。抽样runtime、hip4、liquidation、funding-payment、transfers五图；transfers上部连线标签较拥挤，为非阻断排版事项，原图保留待作者审读。

暂存空白检查：默认git diff --cached --check仅提示源BOOK.md第1703行原有EOF空行。为保留完整合并稿字节，按单次命令-c core.whitespace=-blank-at-eof明确豁免这一原稿空行；其余默认空白规则仍检查，不修改仓库配置。
