# SQL静态审查

18条新增DuneSQL，均STATIC_CHECKED；实际执行BLOCKED_READ_ONLY_ACCOUNT（按用户只读约束，本轮未尝试运行）。[索引](../examples/sql/README.md)提供问题、输入粒度、单位和口径；[机器检查](sql-static-validation.json)记录具体结果。

全部表引用来自本轮20表Catalog，不使用猜出的Order、Funding或Vault表。Oracle表仅有文档Schema，因此未据它伪造SQL输入。18条语句限定日期/分区或当前小注册表，保留UTC边界。

静态程序检查括号/引号、只读语句、实际表名和明确限定的alias.field；作者审查完整投影、行粒度、单位、去重、金融角色与Join。它不是DuneSQL服务端解析器，未声明语法编译或执行PASS。

审查决策：市场交易按Taker与行政过滤；账户参与保留Maker；OI不跨小时加总；Funding用实际结算金额；清算用被处置腿；Book分别展开数组避免笛卡尔积；市场连接coin与元数据唯一性假设；当前维度历史适用边界写明；EVM接口只统计调用；Outcome排除引擎腿。double费用与跨抵押Quote代理明确近似，不称精确财务美元收入。

后续运行还需检查权限、最新Schema、时间类型差异、唯一性、数据覆盖、空值与结果。旧12Query原SQL/2Result独立保存在[既有目录](../research/dune_query_catalog.md)，不用于为新增SQL制造运行结果。
