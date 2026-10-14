# WebSocket读取

[capture.json](capture.json)与[capture-hype.json](capture-hype.json)是两次真实会话，分别BTC与已核实HYPE现货@107；每次最多12秒/8条消息，实际各4条。订阅确认不是成交。Trades数组是一笔经济成交一项，包含买卖双方；L2 Book为完整聚合快照，不能按订单Diff叠加。

[仅文档示例](documented-subscriptions.json)含订单更新、用户成交、用户资金费；response=null且DOCUMENTED_NOT_EXECUTED。用户流可能先返回isSnapshot，重连需要处理重复历史与覆盖缺口。没有无限循环、签名或写请求。[有界读取源码](capture.mjs)。
