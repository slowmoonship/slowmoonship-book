# 12｜挂单、撤单和条件订单的生命周期

订单可能被接受，却始终没有成交；也可能成交一部分之后取消。生命周期解释的是交易意图如何从进入系统走向终止。New、Resting、Partial Fill、Filled、Canceled和Rejected是教学上的状态节点，实际API还细分许多拒绝与取消原因，不能将它们简单压成成功或失败。

GTC表示未立即成交的合规余量可以继续挂在簿上。IOC只允许立即成交的部分，剩余数量随后取消。ALO即只挂单规则，意图是成为等待流动性的一侧；如果提交时会立即跨簿成交，就受到相应拒绝规则约束。订单期限与价格条件一起决定余量去向。

教学模拟中，限价101的买单需要4单位，如果只遇到2单位卖量，GTC余下2单位可以继续等待；IOC余下2单位终止；ALO若会吃到卖盘，则不能按普通Taker路径成交。因此，一张订单有没有Fill，取决于簿状态，也取决于TIF，而不是只看限价与数量。

取消是一项新的Action，并不是回溯删除历史。已经成交的部分仍然属于历史事件；可取消的只是尚未执行的意图。在取消与来单同时竞争时，最终共识及批次规则决定哪一步先被执行。客户端发送了撤单请求，不意味着余量在那一瞬间必然消失。

修改订单也会影响后续意图与排队。研究时应读取修改行为及实际订单更新，不把它当作旧订单字段被随意覆盖。只保留最终快照，会丢掉期间价格、数量和优先级变化。订单生命周期历史需要事件来源，不能靠当前Open Orders倒推过去所有修改。

Trigger Order在触发条件满足后才进入相应执行路径。TP/SL可以采用市场式或限价式处理，触发参考使用官方规定的价格。触发成功与最终成交不同：限价不一定遇到对手方，市场式执行也可能受流动性和风险约束影响。图里的“触发”必须保留后续撮合步骤。

Reduce-only限制订单不得按规则增加原有敞口。它表达一种业务约束，不是自动盈利指令。原有仓位已经变化时，订单的可执行数量或状态也可能改变。分析Close Long等字段时，应结合实际前仓位与执行结果，而不是只依据用户提交时的reduceOnly标签。

TWAP将较大的执行意图分成随时间处理的子订单。父级计划、子订单和Fill是三层粒度。统计执行计划时可用TWAP身份，统计成交时仍要使用Fill或Trade。取消TWAP也不能抹去此前已执行的切片。许多小Fill不必然表示许多独立的用户决策。

订单状态表由此比成交表更广：它包含等待、取消、拒绝以及没有成交的订单。案例01取得一张ALO订单的filled状态，说明指定意图最终完成；其他状态需要自己的证据。若研究下单频率、撤单行为或成交率，必须取得生命周期记录，不能只在Fill表里寻找答案。

<!-- BOOK RESOURCES -->

![图12：挂单、撤单和条件订单的生命周期](../../assets/diagrams/orders.svg)

[编辑此图](../../assets/diagrams/orders.drawio)

证据：[案例01](../../examples/cases/case-01.md)。

依据：[trading__order-types](https://hyperliquid.gitbook.io/hyperliquid-docs/trading/order-types.md)；[for-developers__api__exchange-endpoint](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/exchange-endpoint.md)；[hypercore__order-book](https://hyperliquid.gitbook.io/hyperliquid-docs/hypercore/order-book.md)。

[来源目录](../../research/source_catalog.md) · [目录](../../SUMMARY.md) · [上一章](../../book/part-03/11-partial.md) · [下一章](../../book/part-04/13-perpetual.md)
