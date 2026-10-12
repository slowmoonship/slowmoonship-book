# Case 03｜两条 USDT Approval：清零与最大额度

Ethereum Mainnet；核验日2026-10-10。Hash：`0xcb961e7be2376292335004a134aa87cb775e624e3db5883c5ac1babdf70ff1ad`。区块25272722；时间2026-06-08 12:33:59 UTC。

[浏览器详情](https://etherscan.io/tx/0xcb961e7be2376292335004a134aa87cb775e624e3db5883c5ac1babdf70ff1ad) · [结构化证据](case-03-approval-evidence.json) · [相关作者Query](https://dune.com/queries/8378485) · [教学SQL](../sql/04-usdt-approval.sql)

顶层From为`0x30D09cC334FC5f033371045f76f7Ca8071C68F23`，To为`0xdCf29f7E1e0EC833E6C3c52Bc0E60A95316092dD`，网页方法显示approveTokens。USDT合约在同交易保留两条Approval，Owner为顶层To，Spender为Uniswap V3 Router `0xE592427A0AEce92De3Edee1F18E0157C05861564`。

| Log Index | 发出合约 | 额度最小单位 | 观察 |
|---|---|---|---|
| 772 | 主网USDT | 0 | 网页原Data为全零32字节 |
| 773 | 主网USDT | 2^256-1 | 网页解码给出完整最大无符号整数 |

它们是同一权限设置过程的两条事件，不能相加为转账额。顶层提交者也不是事件Owner。原Topic1/2字节、第二条原Data、完整调用树与历史allowance状态未取得；结构化文件保留null，不按已解码字段伪造原字节。状态：VALIDATED_EVENT_FIELDS。新增Dune SQL仍未执行。

原10月候选只取得索引，已保留在research/archived-candidates，不再用它承载缺少参数的教学主案例。
