# 第38章｜sLGNS增加时，用户究竟得到了什么

把一枚LGNS放进质押系统，之后sLGNS显示数量增加，是否意味着用户已经赚到同等比例的财富？先看合约怎样记账。sLGNS内部使用gons，显示余额由内部份额除以换算系数得到。Rebase改变总供应和换算关系，持有人余额可以一起变化，不需要逐个账户收到一条普通转账。

sLGNS构造函数使用9位精度，初始总量常量为五百万乘十的九次方；初始化会把相应gons分配给Staking。这个初始记账总量不能直接称为公开流通供应，更不能当作项目收到五百万单位外部资产。circulatingSupply还会扣除质押合约持有的显示余额，体现其特定会计定义。

LogRebase包含epoch、rebase与index。源码把rebase比率按1e18记录，而index返回的是显示余额单位，按9位缩放。同一事件里两个数字使用不同单位，是本案例最容易出错的细节。旧Query 8369671正确区分它们，并明确不伪造事件没有直接发出的实际增发数量。

2024年3月6日16:40:22 UTC的交易0x772e9ccfe8fd6e142140bb1c34d3fd428a6e39f9e83a405785581c2688fc74ce，同时出现在原Staked与LogRebase样本。其Rebase事件索引17，epoch为0，比率为0，index_raw为1,000,000,000；Staked事件索引24，样本金额为一LGNS。它具体展示了同一交易内不同事件的独立身份。

Staking.stake先触发rebase，再接收LGNS并记录Warmup信息；claim与forfeit处理等待期相关路径，unstake则交换sLGNS与LGNS。源码没有专门Unstaked事件，作者因此没有把不完整的替代扫描结果冒充完整退出统计。旧Staked结果能说明已记录的质押活动，不能推出净质押、实际独立用户数或全部赎回量。

奖励来源要继续追到Distributor、Treasury和Token铸造路径。Staking根据自身LGNS余额与已质押供应计算后续分配，Treasury又存在受角色和excessReserves约束的奖励铸造能力。源码支持分析这种代币分配机制，但不能单独证明外部经营收入，也不能证明全部奖励仅来自新增外部现金。

旧静态持有模型以2024年3月6日投入一千DAI为起点，结合价格和sLGNS index推演到固定截止。模型余额增长属于在既定假设下的计算，并不是某个真实用户钱包已经实现的收益。现实用户还可能改变仓位、承担费用、错过分配或不能按模型价格退出，需要实际交易历史才能判断。

真实样本还说明事件金额不等于新增外部资金：这一笔Staked记录一LGNS，同时触发的epoch零Rebase比率为零。若把两条事件都转换成资金流入，会凭空增加一笔经济活动。事件先按机制解释，再判断是否需要进入DAI边界账，才不会把质押记账与稳定币收款混在一起。

因此，本章能明确说明余额增长怎样发生、事件怎样换算，以及哪些数据还没有覆盖。它既不预设“数量增加必然被稀释成损失”，也不把增长数字当成确定利润。下一章用同一截止时点的Pair储备与退出曲线，检查数量增长怎样接到可交换的DAI上。

![sLGNS增加时，用户究竟得到了什么](../../assets/diagrams/lgns-rebase.svg)

[可编辑原图](../../assets/diagrams/lgns-rebase.drawio)

延伸核对：[Staked样本](../../examples/transactions/case-10.md) · [Rebase样本](../../examples/transactions/case-11.md)。


来源与核对：[slgns-code-scan](https://polygonscan.com/address/0x99a57e6c8558bc6689f894e068733adf83c19725#code)；[staking-code-scan](https://polygonscan.com/address/0x1964ca90474b11ffd08af387b110ba6c96251bfc#code)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](37-chapter.md) · [下一章](39-chapter.md)
