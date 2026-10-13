# 04.1 | Package、Module、Function、Type 与升级

同一个名称可以出现在不同的结构中。MoveCall 的目标使用 Package、Module 和 Function；一个对象 Type 使用定义来源、Module、Struct 名称和泛型参数。前者告诉我们逻辑入口，后者告诉我们数据是什么。不要把类型末尾的名字误当作被调用函数。

Package 发布后保存不可变代码。一次升级不是原地擦掉旧代码，而是在升级规则下形成后续 Package。旧 Package 仍然存在，调用方也不会因为某个依赖升级就自动切换到最新代码。研究一个协议时需要保留版本谱系与调用范围。[Package Versioning](https://docs.sui.io/develop/publish-upgrade-packages/versioning)

![调用、类型和实例的层次](./assets/move-structure.svg)

[编辑原图](./assets/move-structure.drawio)

一个对象的业务字段里也可能有名为 `version` 的数值。它表示应用自己的版本规则，与协议 Object Version 不一定相同。类似地，Package Version 表示包的演化，Checkpoint Sequence 表示历史位置。字段名字接近，不应直接比较大小来解释谁更新得更多。

对于 Type，泛型参数属于身份。`Coin<T>` 中的 T 通常是资产标识，不能只用 `coin` 模块或 Symbol 区分币种。分析某池时，也需要读懂资产参数顺序；A→B 与 B→A 的方向不能单看函数后缀猜测，仍须核对输入、输出及事件定义。

对 MoveCall，函数名是研究线索，不是完整业务证明。名为 `swap` 的调用可能失败，也可能只是路由中的一步；名为 `quote` 的调用可能计算结果而不完成资金兑换。Package 的验证来源、参数、执行成功状态与余额变化应组合使用。

代码可以比作处理数据的规则，但不能简单等同于数据库存储过程。它要遵守 Move 值的能力、对象授权与事务原子性，处理的状态也可能分布在多个对象和动态字段。数据库只给出加工后的表结构，不能自动替我们解释全部调用语义。

实用的协议登记表应保留网络、原始 Package ID、升级 Package ID、适用时间或 Checkpoint 范围、函数集合、Type 来源与核验链接。Dune 的 `move_package` 可提供谱系线索，但分析标签仍需官方代码或部署资料支持。

下一步：[动态字段](./02-dynamic-fields.md) · [模块入口](./index.md)
