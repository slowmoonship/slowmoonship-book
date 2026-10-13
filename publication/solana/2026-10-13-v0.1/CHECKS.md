# Solana v0.1 增量出版检查

日期：2026-10-13。使用GFM解析、github-slugger 2.0.0及逐组件文件名比较，检查新增Solana内容和当前全书的链接、标题锚点、图片、XML及出版边界。逐条结果与计数见 [checks.json](checks.json)，文件清单见 [FILES.md](FILES.md)。

保留46篇阅读内容、27对SVG/draw.io、13份历史SQL定义、3个RPC案例以及必要验收记录。25段教学SQL仍为STATIC_ONLY / NOT_EXECUTED，新增执行0；原COMPLETE适用于本地书稿完成及原范围验收，不代表SQL全部实测。作者人工审读UNKNOWN。

原先工程缓存中的缺失引用和站点根路径不属于本轮出版范围。按正式引用闭包保留_project中的21个必要文件，并以gitignore白名单限制；不整体上传调度、缓存或日志。SVG中的draw.io文本兼容帮助链接是浏览器不支持SVG文本时的备用说明，不是图片所需外部资源。

[出版副本修改](CHANGES.md)；所有正文和SQL与源稿相同。Ethereum内容和首次快照完整保留。27张SVG已使用独立无账户Chrome全部实际渲染；抽看数据地图与Swap调用图，中文标签和连线可读。所有46篇正文的90个上一篇/下一篇链接与原阅读顺序一致。GitHub远端提交、文件哈希和阅读HTML另做抽样。未进行全外网引用爬取、技术重验证或SQL执行；GitBook仍未配置，版权授权待定，不新增许可证。
