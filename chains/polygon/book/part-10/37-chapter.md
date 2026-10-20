# 第37章｜LGNS到底是哪组合约

作者看板的标题是“LGNS是诈骗盘吗”。它提供了一个调查问题，而不是已经完成的法律判断。本轮从看板进入，取得14张图表关联的6条不同Query，并补充16条辅助研究Query。真正需要研究的，是Polygon上这一组合约怎样发行、质押、交易和管理资产，以及这些机制留下什么证据。

目标Token为Longinus，符号LGNS，合约地址0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01。其已验证源码中，OriginERC20Token构造函数明确使用9位精度。源码与浏览器页面还定位了部署交易0x1074b961d4f3b1fb9519f91e18c10d769600a61258affdaeffb5d504168365da，区块54,339,832，时间为2024年3月6日16:34:26 UTC。

围绕Token，旧SQL识别了sLGNS、Staking、Treasury、Turbine和LGNS/DAI Pair。本轮取得前述Token之外的sLGNS、Staking、Treasury及Pair源码与ABI，Turbine角色仍主要来自原研究。五份源码页面均给出同一创建地址，但“同一部署来源”只支持合约关联线索，不直接证明现实身份或每个时点的实际控制者。

sLGNS地址为0x99a57e6c8558bc6689f894e068733adf83c19725，Staking为0x1964ca90474b11ffd08af387b110ba6c96251bfc，Treasury为0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321。Pair为0x882df4b0fb50a229c3b4124eb18c759911485bfb。完整地址表与来源单独保留，正文图不靠缩写承担身份确认。

源码中的角色很具体。LGNS的MINT角色控制增发，默认管理员可以调整主交易对和费用比例；Staking管理质押与Warmup；sLGNS用gons换算显示余额；Treasury按批准角色处理储备存入、提取、管理和奖励铸造。变量仍可能沿用OHM、USDT等模板名称，不能因此把它们当成实际部署资产，关联状态仍需核对。

尤其值得注意的是Treasury.withdraw要求调用者具有储备支出资格。源码存在赎回函数，不等于每个普通持币人都能随时按固定价值直接赎回Treasury资产。管理权限、资格映射、支持资产和实际余额共同决定可用路径；用“有金库”三个字代替这些条件，会夸大储备与用户权利的联系。

当前供应、管理员成员、角色历史、Distributor地址和全量LP持有人，本轮没有取得指定区块的完整状态。源码初始设置与旧Query注释不能替代这些数据。专题因此把已验证源码能力、旧结果观察和待补状态分别列示，不把合约关系图画成所有当前控制关系都已确认。

部署身份与运行状态在这里有实际区别。取得的源码显示LGNS继承AccessControl，sLGNS与Staking使用Manager式管理，Pair保存自己的储备和LP份额规则。这些结构已经足以形成能力图；但角色成员、Manager现值和构造后初始化调用仍需指定高度证据。研究不能因为五个合约共享部署来源，就把所有管理箭头都连接到该创建地址。对尚未取得源码的Turbine，图中使用候选关系并保留原Query来源，避免让一个旧标签在图里变成新的独立事实。

这份身份底表为后面两章提供清楚起点：用户质押的是LGNS，取得和增长的是sLGNS计量关系；退出市场则还要面对DAI储备与交易费用。把这些对象分开后，研究才能从“币越来越多”走向“用户实际能够得到什么”。

![LGNS到底是哪组合约](../../assets/diagrams/lgns-contracts.svg)

[可编辑原图](../../assets/diagrams/lgns-contracts.drawio)

延伸核对：[合约底表](../../research/lgns/contracts.md)。


来源与核对：[lgns-code-scan](https://polygonscan.com/address/0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01#code)；[slgns-code-scan](https://polygonscan.com/address/0x99a57e6c8558bc6689f894e068733adf83c19725#code)；[staking-code-scan](https://polygonscan.com/address/0x1964ca90474b11ffd08af387b110ba6c96251bfc#code)；[treasury-code-scan](https://polygonscan.com/address/0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321#code)。研究基准：2026-10-19；资料获取：2026-10-19—20。

[返回目录](../../SUMMARY.md)


[上一章](../part-09/36-chapter.md) · [下一章](38-chapter.md)
