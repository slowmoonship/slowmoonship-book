# 15｜Transfer Event 为什么不是另一笔交易？

合约完成一个操作后，可以向外留下事件记录。浏览器把它显示成 Transfer，容易使人以为“又发送了一笔交易”。其实，事件（Event）是程序层面的声明，日志（Log）是声明在执行结果中的字节记录。它不需要新增一份用户签名请求。

标准的非匿名事件把事件签名摘要放在 Topic0。ERC-20 的 `Transfer(address,address,uint256)` 对应一个 32 字节摘要；这里不包含参数名，也不把 `indexed` 写入签名。注意，它与函数选择器长度不同：函数选择器通常是四字节，Topic0 的事件摘要则是完整的 32 字节。

Topics 保存可索引参数，Data 保存其余编码内容。普通 ERC-20 Transfer 把 From 与 To 放进 Topic1、Topic2，把数量放进 Data。地址在 32 字节字中左侧补零。解码要按 ABI 类型与位置进行，而不是直接把 Topic 的整段文本视作人类可读地址。

非匿名事件通常最多使用三个 indexed 参数，因为 Topic0 占用一个位置；匿名事件不使用这个签名位置，可以有四个 indexed 参数。indexed 动态类型可能保存摘要，不能把 Topic 中的摘要还原成原始字符串。最初的“Topic0 就是事件名”只适合限定后的常见形式。

`ethereum.logs.contract_address` 表示发出日志的执行上下文地址，不等于顶层 To，更不等于日志参数中的发送人。`tx_hash` 回到所属顶层交易，`index` 表示日志在区块中的位置，`tx_index` 表示交易在块内的位置。Index 在不同块会重复，连接时应带上区块或交易范围。

Case 04 中四条保留日志依次是输出代币 Transfer、WETH Deposit、WETH Transfer、Pool Swap。它们属于同一顶层交易。Pool 的 Swap 描述带符号结算数量；WETH 的 Deposit 说明包装动作。事件类型的差别，恰好解释为什么不能把四条记录统一叫作“四次代币转账”。

日志由合约代码显式发出，并不是 EVM 对一切资产变化自动产生的通用凭证。普通 ETH 转账没有 ERC-20 Transfer；非标准代币也可能改变余额却没有预期的标准日志。反过来，任意代码可以声明一条名为 Transfer 的事件，名称本身不能证明它符合可信资产规则。

验证一条事件，需要检查发出地址、ABI、交易状态与业务规则。查询时只按 Topic0 搜索而不限制合约，会把许多不同资产放在一起。事件能帮助定位事实，但可信结论仍要由具体程序与执行上下文支持。

日志也不一定自带准确的人类单位。原事件通常保存整数，代币小数位来自合约或可信元数据。一个日志的数量很大，可能只是精度较高，不能直接解释为很高的市场价值。

保存证据时，可以同时写下事件签名、发出地址、原始数据与解码结果。以后发现接口版本或精度错误，还能重新读取原字节。只留下格式化后的金额与代币符号，虽然便于展示，却会使复核者无法判断原字段究竟如何转换。

检索同签名事件时，应保留发出合约与资产规则。多个合约共享事件接口非常正常，名称相同不能证明经济身份相同。

![Transfer Event 为什么不是另一笔交易？的教学图](../../assets/diagrams/logs.svg)

[编辑此图](../../assets/diagrams/logs.drawio)

[完整 SQL：03-usdt-transfer](../../examples/sql/03-usdt-transfer.sql)（STATIC_CHECKED；未在 Dune 执行）。

依据：[ABI 事件编码](https://docs.soliditylang.org/en/latest/abi-spec.html)；[Dune Logs](https://docs.dune.com/data-catalog/evm/ethereum/raw/logs)；[ERC-20 Transfer](https://eips.ethereum.org/EIPS/eip-20)。核验日：2026-10-10。

[上一章](../part-04/14-traces-call-tree.md) · [目录](../../SUMMARY.md) · [下一章](../part-04/16-success-revert.md)
