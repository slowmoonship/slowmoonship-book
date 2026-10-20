# API、权限与费用审查

Dune：只读获取2个Dashboard、24个Visualization、38条Query及对应旧结果样本、Schema快照等。本地保留126份原始MCP读取响应（不含派生query-catalog.json）；握手不计入这一数。未调用execute/create/update/archive等写工具，未重试已知执行权限探针。

SQL实际新执行0；未购买Credits或升级账户。旧executionCostCredits仅属于旧运行，不计入本轮。元数据/结果读取是否另有平台费用未独立核定，不能扩大称精确总账单为0。

Blockscout：初始化、链列表和地址读取尝试；地址读取返回HTTP402额度耗尽。没有充值或绕过。

Bor RPC：两家官方列出公共端点eth_chainId均HTTP403，记录在research/rpc/read-status.json；无成功状态返回，不伪造response。

Heimdall：有界读取历史块，Lugano块成功，其余失败保留；取得链ID、块高、时间，未本地验签。浏览器与官方文档均为有限公开读取，不抓取私人身份信息。

Jev API 0次；其他付费API操作0次；没有钱包连接、签名、发交易、调用合约写方法、部署、服务器配置或远端发布。凭证沿用现有只读配置并仅在内存使用，没有复制配置或密钥到Polygon目录。

来源网页自带的公开资源签名URL、地址与源码常量不是用户钱包私钥；本地秘密扫描不对它们作所有权推断。失败HTTP不是自动审批拒绝，本轮没有遗留需要用户批准的操作。
