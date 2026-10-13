# 08.2 | Object、Move Call 与 Event 分支

sui.transaction_objects 保存事务与对象版本的关系，包括输入类别和对象状态等线索。它不等于资产转移表，也不能把每行都叫一次修改。相同对象可能承担输入、输出或其他角色；唯一键要结合实际展开方式验证。[Transaction Objects](https://docs.dune.com/data-catalog/sui/transaction_objects)

sui.objects 保存平台记录的对象状态或操作，包含 ID、Version、Type、Owner 与状态列。coin_type、coin_balance 和 object_json 等字段帮助解释内容。它不是只包含当前存活对象的简单快照，历史版本需要先确定时点和存活性再用于余额统计。

![分支各自有自己的粒度](./assets/warehouse-grains.svg)

[编辑原图](./assets/warehouse-grains.drawio)

对象关系按 ID 与 Version 连接状态表，是需要覆盖检查的可选查找。删除标记和未变化输入未必对应新对象内容；一个不匹配行不必然是脏数据。保留关系行，再解释缺失原因，通常比先 INNER JOIN 更可靠。

sui.move_call 使用 transaction_digest、package、module、function 与 cmd_idx 等列。它记录平台抽取的调用，不应直接当成所有运行时内部函数调用的完整树。cmd_idx 可作为 Command 定位线索，但候选键是否为 Digest 与索引，需要实际检查与 PTB 比对。[Move Call](https://docs.dune.com/data-catalog/sui/move_call)

sui.events 包含事务内 event_index、Event Type 与 event_json 等信息。Digest 与 Event Index 是需要验证的候选标识。Package、Module 与 Sender 的具体语义应依平台抽取和事件定义理解，不能把事件主体直接替换为资金接收者。[Events](https://docs.dune.com/data-catalog/sui/events)

这三类分支都有自己的零或多条关系。没有调用、没有事件、没有某种对象输出，可能符合真实业务；数据延迟或转换覆盖也可能产生缺口。区分两者需要回看完整事务与结果，而不是自动填一条零值明细。

扩展表同样跟着问题选择。研究 Package 升级可以使用 move_package 的 original_package_id 与 package_version；研究包装对象可以考虑 wrapped_object。新增表之前，先确定它补充什么证据，而不是为了让关系图显得更丰富。

下一步：[质量与 JOIN 放大](./03-quality.md) · [模块入口](./index.md)
