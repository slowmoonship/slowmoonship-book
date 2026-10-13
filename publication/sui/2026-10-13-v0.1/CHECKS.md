# Sui v0.1 出版检查

日期：2026-10-13。GFM解析沿用前两次出版的marked与github-slugger 2.0.0；检查最终副本的相对链接、图片、引用式链接、中文/重复标题锚点、逐组件大小写、代码围栏、导航、XML及必要证据闭包。实际计数与逐条结果见 [checks.json](checks.json)。

正文45/45；原状态39 COMPLETE、6 VALIDATED；10核心模块及SUI 00/99。新9份SQL为STATIC_CHECKED / NOT_EXECUTED，新成功执行0；原稿记录首次提交被Dune 402 configured datapoint limit拒绝，未获得Execution ID。本轮未访问Dune或消耗查询额度。12份历史SQL为源码缓存，只有Query 8348409的一行历史缓存执行，保存版本与执行字节一致性NOT_PROVEN。

[原交付报告](../../../chains/sui/_project/overnight-report.md) · [技术缺口](../../../chains/sui/_project/technical-review.json) · [SQL状态](../../../chains/sui/references/sql-manifest.json)。未解决：候选键、JOIN覆盖、数据最新性和完整历史、完整Pool生命周期、作者人工审读。

SVG/XML解析和真实渲染分别记录；draw.io文本兼容帮助链接是备用提示，不是渲染资源依赖。未爬取全部外部来源；GitHub与GitBook对SVG foreignObject/标题锚点可能存在渲染差异，GitBook尚未配置或验收。宽图移动端需要缩放查看。

安全检查覆盖所有准备提交的文件及已公开全书文件；链上地址/哈希保留。格式扫描不保证覆盖所有未知秘密形式。第三方整份Rust缓存不再分发，保留官方来源与SHA256；自有SQL、派生图及公开API证据保留来源。第三方素材综合授权审查UNKNOWN；版权授权待作者确定，不添加全书许可证。

旧链及历史快照逐文件Git Blob保持；Sui原稿路径及SHA256前后逐一比较。[副本改动](CHANGES.md)。哈希清单对自身与机器检查文件明确排除，避免循环。

13张SVG全部在独立无账户Chrome实际渲染，阻断外部请求；抽看Runtime Map、Data Map、Ownership图，中文、连线和边界可读，未发现样本裁切。全部图形真实渲染通过不等于每张图都完成逐项人工视觉验收。

本次GFM重新检查原稿发现2处缺失图片，均在未选入的historical-opening工程缓存；此前预检报告的4处缺失无法作为当前解析结果沿用。最终正式副本遗留失效链接0。历史Query表头列数机械修复，12份SQL链接恢复显示。
