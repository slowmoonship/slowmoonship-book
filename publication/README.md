# 出版清单与验收记录

[当前全书文件清单](CURRENT_FILES.md) · [当前全书哈希清单](current-manifest.json)

- [Ethereum v0.1 · 2026-10-12](ethereum/2026-10-12-v0.1/README.md)：首次出版报告完整归档；根目录原5个报告保留为兼容入口，不再作为当前全书清单更新。
- [Solana v0.1 · 2026-10-13](solana/2026-10-13-v0.1/FILES.md)：[本轮检查](solana/2026-10-13-v0.1/CHECKS.md)、[本轮修改](solana/2026-10-13-v0.1/CHANGES.md)。

- [Sui v0.1 · 2026-10-13](sui/2026-10-13-v0.1/README.md)：[检查](sui/2026-10-13-v0.1/CHECKS.md)、[机械修改](sui/2026-10-13-v0.1/CHANGES.md)。

- [Avalanche v0.1 · 2026-10-14](avalanche/2026-10-14-v0.1/README.md)：[检查](avalanche/2026-10-14-v0.1/CHECKS.md)、[机械修改](avalanche/2026-10-14-v0.1/CHANGES.md)。

- [Bitcoin v0.1 · 2026-10-14](bitcoin/2026-10-14-v0.1/README.md)：[检查](bitcoin/2026-10-14-v0.1/CHECKS.md)、[机械修改](bitcoin/2026-10-14-v0.1/CHANGES.md)。

- [Hyperliquid v0.1 · 2026-10-14](hyperliquid/2026-10-14-v0.1/README.md)：[检查](hyperliquid/2026-10-14-v0.1/CHECKS.md)、[机械修改](hyperliquid/2026-10-14-v0.1/CHANGES.md)。

各链目录保存当前公开版，独立版本和日期通过本状态登记及Git历史追溯。单次检查快照不覆盖前次结果。GitBook未配置，无全书Tag或Release。

## 后续增量出版约定

先核对真实远程main和干净/可保留的Checkout；复制前记录新链原稿路径与SHA256、旧链与历史报告Git Blob。只在出版副本修改入口、导航和必要机械引用；用引用闭包白名单选入证据，不能整体上传_project。

链接检查使用完整GFM解析器（本次marked）及github-slugger 2.0.0，逐组件核对路径大小写；检查表格列数，避免有效链接被表格解析截断。XML解析、SVG真实渲染和人工视觉抽样分别记录。SQL静态检查、历史结果、新执行与作者审读分别登记。

单次manifest只哈希所选公链内容；CURRENT_FILES列出所有当前公开文件，current-manifest哈希除自身之外的全部文件，其自身由Git tree绑定。本次checks.json记录提交前检查，不能把Push输出当作远端验收。生成检查后再更新current-manifest，最后复核哈希与暂存路径，不覆盖旧快照。

本机可恢复进度和可重复脚本存放于Checkout之外的publication-audit，正式范围和边界留在每次快照中。提交前再次核对远程，正常Push后验证完整Git tree、HTML与资源；不创建自动Tag/Release或新GitBook Space。
