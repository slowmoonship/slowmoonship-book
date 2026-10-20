# 第08章｜Gas花在了哪里

用户常问“这笔转账花了多少Gas”，真正想知道的通常是付出了多少POL。Gas是资源计量，Gas Price是每单位资源的价格，实际费用才是两者相乘后的金额。把这三者分开，才能比较网络拥堵、合约复杂度和用户成本，也能避免把一个很高的Gas Limit误认为已经支付的费用。

Gas Limit是交易允许消耗的上限；Gas Used是执行实际消耗的数量。对于常见用户交易，实际执行费用可由回执Gas Used乘以有效Gas Price得到，再按原生币的最小单位换算。Max Fee与Max Priority Fee表达费用上界和优先费约束，不是最终全部支付的单价。退款、回退与费用机制的具体表现，还要看对应交易类型和版本。

EIP-1559把费用市场中的Base Fee与优先费分开。Polygon沿用相关结构，同时拥有自己的参数与分配安排。不要把“用户付费”“协议销毁”“生产者收入”“质押奖励”写成同一个数字。它们分别涉及收取、归集、分配或发行，可能发生在不同合约和时间点，不能仅凭交易总费用推算所有接收方收入。

2026年的参数变化尤其值得注意。Lisovo相关PIP-79允许在约束边界内配置费用参数；Giugliano通过PIP-83把报告参数放入区块头。研究历史Base Fee时，不应永远硬编码Ethereum常见的目标比例和变化分母。区块Gas Limit、目标Gas和参数报告值需要带着版本一起读取。

Gas能力也不是固定TPS。一个简单转账、一笔多跳Swap和复杂合约调用消耗的资源相差很大。把每块Gas容量除以某种基准交易的Gas，可以得到该工作负载下的容量估算；真实TPS则来自指定窗口内确认交易数除以经过时间。宣传中的支付处理能力和全链混合交易实测值，不能画成同一条连续曲线。

Polygon还存在协议发出的系统记录。原看板的历史抽查发现type为127的行，PIP-74对应StateSyncTx的规范化表示。费用分析不能把它们无条件当作普通钱包签名交易。教学查询保留type分组，并建议与gas.fees核对，先解释索引表达，再决定是否纳入用户成本指标。

进行费用分解时，还要检查时间选择。一次尖峰可能来自短时需求或特定应用批量操作，日平均会把它抹平；只挑最贵一笔，又不能代表普通用户体验。把完整窗口、中位数和极端样本一起展示，通常比给出单一平均值更有信息。

实际分析时，先选择完整UTC窗口，记录交易类型，再计算费用总额、中位数与分位数。平均费用可能被少数昂贵调用拉高，美元费用又引入价格来源与时点。一个好的结果应让读者同时看到POL金额、统计范围和价格覆盖率。下一部分转向验证者，解释是谁组织这些执行记录成为可信的网络历史。

![Gas花在了哪里](../../assets/diagrams/gas-flow.svg)

[可编辑原图](../../assets/diagrams/gas-flow.drawio)


来源与核对：[eip-1559](https://eips.ethereum.org/EIPS/eip-1559)；[pip-79-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-79.md)；[pip-83-asof](https://raw.githubusercontent.com/0xPolygon/Polygon-Improvement-Proposals/7ca861517bcdcba3e1f2b751762c6c2e786d7caa/PIPs/PIP-83.md)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](07-chapter.md) · [下一章](../part-03/09-chapter.md)
