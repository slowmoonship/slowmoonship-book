# 23｜NFT 的 Token ID 为什么不能当作数量相加？

同样叫 Transfer，ERC-20 与 NFT 事件的最后一个整数可以有完全不同的含义。代币转移可能是“发送 100 个最小单位”，NFT 转移则可能是“转移编号 100 的那件资产”。把后者当成金额，是一个很隐蔽的数据错误。

ERC-721 用合约地址与 Token ID 共同识别一件 NFT。`ownerOf(tokenId)` 返回当前所有者；余额接口统计地址持有的件数，不能替代每个 Token 的身份。编号可以不连续，可以从零开始，也不代表发行顺序一定与数值相同。

ERC-721 的 Transfer 参数类型同样是两个 Address 和一个 Uint256，因此标准事件签名摘要与 ERC-20 Transfer 相同。但标准 indexed 布局不同：ERC-721 的 Token ID 也被索引到 Topic。只筛 Topic0，不能可靠地把两种资产的语义分开。

图中把 ERC-20 的“地址 → 数量”与 ERC-721 的“Token ID → Owner”并排展示。一个人转出 Token ID 100 与 200，不能说转了 300 个 NFT。若问题是转移件数，可以在确认每条事件语义后计件；若问题是市场成交额，还要另找支付与成交规则。

Mint 常用零地址作为来源，Burn 常用零地址作为目标，但标准与特殊发行方式仍有边界。例如 ERC-721 允许构造阶段某些创建不逐个发出 Transfer。仅从全历史 Transfer 流水重建全部 Token，可能漏掉初始状态或不合规实现。

Metadata URI 提供名称、图像或其他内容，不是所有权记录本身。外部服务器与内容更新还会影响展示。一个 NFT 的图片一样、符号一样，不足以证明它与另一个合约中的编号属于同一资产，更不说明图片内容被永久保存在链上。

授权也有两类范围：某件 NFT 的 Approval，以及针对整个账户资产操作资格的 ApprovalForAll。它们与转移事件分开；授权给 Operator 不代表 NFT 已经换了所有者。查询“谁持有”应优先根据有效转移与状态读取回答。

分析历史持有者，要检查区块位置、标准布局、是否存在非标准移动与初始发行缺口。若只关注某笔交易，按具体合约、Hash 和 Log Index 定位，再解码 Token ID，就能避免全历史重建的不必要复杂性。

本章不讨论 NFT 的估值。读者先掌握资产身份与数量的区别，便能看懂为什么 ERC-20、ERC-721 和后面的 ERC-1155 不能套进同一个无条件求和公式。

为一件资产建立身份卡时，写下链、合约和编号，再写当前或历史所有者的读取位置。图片、名称和市场报价放在另一个区域。这样可以让身份与展示内容分开，避免可变元数据影响所有权判断。

如果某笔交易转移两件编号很大的资产，件数仍然是两件。若加工模型把批量或特殊发行展开成多行，还需阅读展开规则。计数方法取决于资产身份与事件语义，不取决于数字看起来有多大，也不取决于浏览器把该行排在第几位。

一件资产的编号即使达到很大整数，仍只识别一件资产。统计件数应依身份与记录语义计量，而不能对编号求和。

![NFT 的 Token ID 为什么不能当作数量相加？的教学图](../../assets/diagrams/nft.svg)

[编辑此图](../../assets/diagrams/nft.drawio)

依据：[ERC-721](https://eips.ethereum.org/EIPS/eip-721)；[ABI Topics](https://docs.soliditylang.org/en/latest/abi-spec.html)；[NFT 标准](https://ethereum.org/developers/docs/standards/tokens/erc-721/)。核验日：2026-10-10。

[上一章](../part-06/22-allowance-approval.md) · [目录](../../SUMMARY.md) · [下一章](../part-06/24-multi-token-nonstandard.md)
