# 第06章｜区块头里藏着哪些版本线索

一个Bor区块不只是一袋交易。区块头保存父区块哈希、状态承诺、交易和回执相关承诺、Gas参数、时间及额外数据。这些字段把当前执行接到前面的历史上。分析者最常用的是高度和时间，但遇到生产者归因、费用变化或协议升级时，只看这两个字段远远不够。

高度告诉你区块在当前历史中的位置，哈希则标识具体内容。保存真实案例时，两者最好同时保留。某个查询只记录高度，后续数据源又使用另一段分叉历史，就可能把同一位置的不同区块误认成同一个对象。交易索引、日志索引和调用轨迹地址，也必须在各自所属的区块或交易上下文里解释。

Ethereum风格的字段名不保证Polygon使用相同语义。作者旧研究发现，所抽查的polygon.blocks.miner为零地址。这个现象应被记录成字段观察，不能顺着名称推论“零地址生产了区块”。Bor生产者使用签名授权，相关签名与版本化额外数据位于区块头中，生产资格还需要Heimdall的Span信息配合验证。

Rio之后，当前Span由单一获选生产者签发区块。旧资料中在Sprint边界嵌入验证者集合、依赖候补生产者轮换的描述，不能直接套到当前主网。图中应当把生产者签名、Span授权与验证者确认分开，而不是从一个miner字段画出整个共识关系。归因需要知道该高度的实际协议版本。

Giugliano又增加了新的可观察线索。PIP-83把GasTarget与BaseFeeChangeDenominator写入版本化的额外数据，并提出bor_getBlockGasParams以及可选的borExtra扩展参数。它们帮助外部工具知道生产者报告的费用参数，但参数存在并不等于其计算方式被逐项强制验证；Base Fee的有效性还受PIP-79规定的边界规则约束。

这类字段未必已经进入Dune的blocks表。本轮Catalog确实返回的字段，与节点RPC能够提供的字段，应分别列清。需要新的头部参数时，先确认节点版本和方法支持，再保存完整响应；接口返回方法不存在，只说明该服务没有提供相应能力，不能据此认定协议没有这个字段。

读取extraData时，还应保留原始字节与解码版本。把签名末尾固定长度截取与中间RLP字段混用，可能在升级后得到错误地址或参数。研究文件中的十六进制内容因此不会先清洗成普通文字，也不把整个字段当成可以自由解释的备注。

区块头也是版本时间线的一部分。Bor高度与Heimdall高度属于不同序列；Zurich和Ithaca的激活数值不能放进Bor高度过滤条件。研究文件因此为每次升级同时保存网络、客户端、激活维度和来源。先给高度写清单位，才能避免把准确的数字用在错误的链上。

![区块头里藏着哪些版本线索](../../assets/diagrams/block-header.svg)

[可编辑原图](../../assets/diagrams/block-header.drawio)


来源与核对：[pip-83-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-83.md)；[bor-asof-config](https://raw.githubusercontent.com/0xPolygon/bor/1cdf43c99d97cb9e18860776d8f69a416b49adf4/params/config.go)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](05-chapter.md) · [下一章](07-chapter.md)
