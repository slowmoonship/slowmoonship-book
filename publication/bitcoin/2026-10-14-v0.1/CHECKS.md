# Bitcoin v0.1 出版检查

2026-10-14。复用既有marked GFM与github-slugger 2.0.0，对最终全书副本检查相对文件、引用式链接、图片、中文/重复标题ID、URL编码、大小写、越界/本机路径、代码围栏、表格、全书和单链导航。数字与结果见 [checks.json](checks.json)。外链未全面重爬；不开展第二轮协议研究。

正式36章、前言及5附录为42阅读页；原9 Part和排序保留，9个Part索引全部可访问，共51个内容/索引导航页面。正文仅补边界导航，移除新增链接后与源字节一致；合并稿、SQL/RPC/交易身份及34对图形字节不变。XML解析、尺寸、资源、节点/边、内嵌原生XML一致性与真实Chrome渲染分别记录；视觉抽样查看UTXO生命周期、交易Input/Output、Taproot和花费图，未逐图人工审读。原生draw.io桌面交互未执行。

源工程2026-10-13原验收 VALIDATED / 25项本地PASS，以及65项离线结构检查只支持其记录的范围。新16条DuneSQL STATIC_CHECKED / NOT_EXECUTED（原阻碍BLOCKED_READ_ONLY_ACCOUNT），本轮执行0；10份历史Query和旧结果未重跑。12组Core31.0.0 RPC NOT_EXECUTED，response=null；未启动节点、下载区块或调用RPC。

本轮只对保存的字节/金额/prevout引用重复离线核验，不证明验签、脚本、PoW或全链共识。案例取得日期2026-10-13，10主题对应8个主交易；三条后续花费边截止高度92240、92241、92640，未追到今天链头。UTXO花费引用与找零、共同输入、地址聚类、实体归因、比例模型分别登记。模型份额不是协议逐聪映射或身份概率，地址不是确定现实用户；路径截点不是最终资产归宿。Case09不认定CoinJoin，Case10只核验Runestone候选标记；外部热钱包披露不证明现时密钥控制和受益所有权。保留嵌套Dune金额单位冲突、完整附加协议资产索引和其他原稿缺口。

安全检查扫描全部拟公开文件，补充RPC账号/密码/Cookie、WIF/扩展私钥、助记词、API/SSH、配置/钱包/内网候选；对候选只记录位置不输出秘密。公开TxID、地址、脚本及witness保留。没有添加许可证；第三方素材整体授权审查UNKNOWN，整页文档留在本地。

源目录366个路径及SHA256前后比较；旧Ethereum/Solana/Sui/Avalanche内容和历史审计Blob比较。作者人工审读UNKNOWN，工程自审不替代作者审读。GitBook仓库NOT_CONFIGURED，平台账户同步UNVERIFIED；没有创建Space。快照manifest只哈希239个Bitcoin内容文件；current-manifest覆盖全书，仅排除自身哈希，由Git tree绑定审计与manifest。

最终结构PASS：全书2582本地引用有效，711标题ID；42/42阅读页和9/9 Part索引覆盖。34/34 SVG真实Chrome渲染；抽样utxo、lifecycle、transaction、taproot、spend-graph五图，未观察到正文裁切；transaction图两处连线标签较拥挤，为非阻断性排版事项，保留原图待作者审读。原稿366路径/SHA256和740个旧内容/历史快照Blob不变；安全模式扫描与公开字段复核无阻断项。
