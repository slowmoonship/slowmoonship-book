# LGNS资金边界模型

集合S沿原Query8389682：LGNS、sLGNS、Staking、Treasury、Turbine、Pair。集合角色证据强度不一致，Turbine仍为候选。资产固定Polygon DAI，不与其他链DAI合并。

事件分类：外部→S是external_in；S→外部是external_out；S内互转另列并从净外部流量抵消。净额是in-out，不叫利润。

Query8391200固定截止2026-08-18 09:28:58UTC返回累计来源6,089,024,225.653134DAI、累计去向6,004,320,441.147899DAI、净留存84,703,784.50523621DAI。流动性添加563,474,768.4979389DAI、移除292,165,096.48801816DAI是分类结果，不能与全边界总额重复相加。

Query8389682原结果覆盖到2026-08-20，不与固定截止直接拼接。事件去重通过不证明是独立新增资金；同一DAI可反复周转。Query8390785第一跳是时间窗后续移动模型，不是唯一资金血缘，不能识别最终受益人。

![资金模型](../../assets/diagrams/fund-boundary.svg)

[可编辑原图](../../assets/diagrams/fund-boundary.drawio)
