# Sui 术语对照

| 术语 | 中文及本书用法 |
|---|---|
| Object | 对象；状态身份及内容，不等于普通数据库行 |
| Object ID | 对象身份；沿生命周期追踪 |
| Version | 对象历史位置；严格递增但不必加一 |
| Object Digest | 对象状态内容及元数据承诺 |
| Object Reference | ID、Version、Digest 的精确引用 |
| Transaction / Transaction Digest | 事务请求 / 完整事务标识 |
| PTB | 可编程交易块；Inputs、Commands 与结果流 |
| Command / Argument / Result | 操作命令 / 对值的引用 / 中间结果 |
| MoveCall | PTB 的 Move 调用命令，不等于完整事务 |
| Sender / Gas Owner | 发起地址 / 费用承担地址，可能不同 |
| Ownership | 归属与访问形式，不等于本次读写方式 |
| Shared / Immutable / Party | 共享 / 不可变 / 单地址归属且共识版本 |
| Object-Owned / Wrapped | 父对象控制的独立状态 / 嵌套包装值 |
| Package / Module / Function | 代码发布单位 / 命名空间 / 逻辑入口 |
| Type / Struct / Generic | 类型 / 结构定义 / 泛型身份 |
| Dynamic Field | 动态字段，经父对象管理的扩展状态 |
| Coin<T> / Balance<T> | 带身份资金容器 / 类型化数值 |
| Address Balance | 地址与币种的协议累加器值 |
| MIST | SUI 最小单位，十亿 MIST 为一 SUI |
| Effects | 执行状态与协议结果 |
| Object Changes | 对象变化表达；须区分原始结果与平台派生 |
| Move Event | 程序显式发出的业务记录 |
| Checkpoint / Epoch | 认证历史组织 / 网络周期背景 |
| Grain / Candidate Key | 行粒度 / 需验证的唯一标识组合 |
| VERIFIED / STATIC_CHECKED / UNVERIFIED | 已执行并核验 / 静态核对未执行 / 尚未核验 |

具体来源与版本边界见 [技术来源](./official-sources.md)。
