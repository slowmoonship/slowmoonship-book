# 03.1 | 所有权形式与包装边界

Address-Owned 表达对象由一个地址拥有。Shared 表达不同地址都可以引用它，执行允许哪些动作仍由 Move 代码限制。Immutable 表达对象已经不可变，读取它不意味着能改变所有权或删除它。Party 则把单地址拥有与共识版本机制结合起来，接口可能显示 `ConsensusAddressOwner`。[Party Objects](https://docs.sui.io/develop/objects/object-ownership/party)

对于数据分析，不能只建立 Owned/Shared 二选一分类。当前接口和平台可能保留不同版本的 Owner 变体，分类代码应根据实际值与源定义映射。遇到新值时，先放入“未分类”，不能静默塞进 Shared 或 Address-Owned。

![Ownership 分类及边界](./assets/ownership-paths.svg)

[编辑原图](./assets/ownership-paths.drawio)

Object-Owned 是另一个需要保留的维度。对象被转给父对象的地址以后，子对象的使用受到父对象与接收规则控制。Receiving 输入帮助表达这种关系。知道子对象 ID 不代表用户就能独立调用它，也不意味着父对象的持有人在任何时刻都可以绕过合约规则使用它。[Address-Owned Objects](https://docs.sui.io/develop/objects/object-ownership/address-owned)

Wrapped Object 则作为值嵌入外层对象。它不是普通独立可变输入；需要通过承载结构访问。包装与对象拥有都可能体现层级，但它们的独立查询能力和执行入口不同。把两者统一叫“子对象”而不保留形式，会让历史追踪丢失重要信息。

Immutable 也不等于“本次只读”。前者是对象状态，后者是事务访问方式。Shared Object 可以被不可变借用，却仍然属于共享对象；可变 Owned Object 本次也可以只被读取。用 `mutable=false` 就把对象分类为 Immutable，会把动作属性误作对象属性。[Immutable Objects](https://docs.sui.io/develop/objects/object-ownership/immutable)

Owner 记录还不能直接当作现实受益所有权证明。对象由一个地址拥有，是链上访问事实；地址是否属于某个人、父对象是否为托管结构、资金最终收益归谁，需要另外的业务与身份证据。

实际分类可以保存原始 Owner 变体、Owner Address、是否由共识管理、对象 Type 和本次输入角色，最后再产生分析类别。这样平台字段语义变化时，仍能回到原始记录重新判断，而不是只有一个无法解释的标签。

下一步：[协调与并行](./02-coordination.md) · [模块入口](./index.md)
