# Sui 出版副本机械修改

- `chains/sui/README.md`：增加公开入口、PARTIAL边界及全书导航；内部调度恢复入口改为出版检查，不改变45篇正文。
- `chains/sui/_project/overnight-report.md`：调度恢复文档留在原工程；原报告的正文、SQL与技术缺口保持。
- `chains/sui/_project/source-inventory.md`：历史素材路径明确为原工程调查记录；移除本机工具环境叙述，保留素材复用与技术审查结论。
- `chains/sui/references/official-sources.md`：不随书再分发完整第三方Rust源码；改链到原有官方来源，保留快照哈希和日期边界，避免新增全书许可证。
- `chains/sui/_project/qa-report.md`：将报告中的裸文件名补为有效证据链接。
- `chains/sui/references/dune-queries.md`：修正历史Query表头列数（3→4），使12份SQL链接在GFM表格中正常显示；数据及状态不变。

45篇阅读正文、13组SVG/draw.io/PNG、21份SQL及官方案例快照字节不变。原工程所有文件保持只读。工程调度、无关缓存与本机配置不发布；必要证据按白名单保留。
