# DuneSQL 示例

10 条教学 SQL。字段由本轮实际 Catalog 验证；语法与单位人工静态审查。全部 STATIC_CHECKED，未调用执行。

| 例 | 文件 | 结论边界 |
|---|---|---|
| 01 C-Chain 每日交易和成功发送地址 | [01-daily-transactions.sql](01-daily-transactions.sql) | 地址不是人数；只包括 C-Chain。 |
| 02 Case 01 交易定位 | [02-one-transaction.sql](02-one-transaction.sql) | 未运行，不保证索引已收录；value 为十八位原始整数。 |
| 03 观测到的 C-Chain 执行费 | [03-execution-fees.sql](03-execution-fees.sql) | 含失败；double 为显示近似；Helicon 后字段与收据尚待逐笔核对，不代表全网烧毁或净发行。 |
| 04 区块与交易的定位一致性 | [04-block-link.sql](04-block-link.sql) | 保留无交易块；不假定 CE 原始块头 gas 等于同块交易消耗。 |
| 05 Case 02 的原始日志候选 | [05-erc20-logs.sql](05-erc20-logs.sql) | 解码需历史 ABI；topic0 不独立识别 ERC20 与 ERC721。 |
| 06 Case 02 的调用树候选 | [06-trace-tree.sql](06-trace-tree.sql) | 调用不是另一笔签名交易；局部成功还需检查失败祖先。 |
| 07 各明细分支先汇总到交易粒度 | [07-safe-join.sql](07-safe-join.sql) | 轨迹包含根；计数对象不等于经济转移。 |
| 08 USDT 加工转移样本与估值覆盖 | [08-usdt-movements.sql](08-usdt-movements.sql) | 毛流量不是付款量或净流入；当前日不完整；价格缺失不填零。 |
| 09 DEX 成交段与独立交易数 | [09-dex-segments.sql](09-dex-segments.sql) | 多跳可多段；NULL 估值保留；不是用户数。 |
| 10 C-Chain 发送事件与窗口内消息身份 | [10-icm-sent.sql](10-icm-sent.sql) | 只观测 C 端发送，不是全网流量或完成率；回执与重试需协议解释。 |
