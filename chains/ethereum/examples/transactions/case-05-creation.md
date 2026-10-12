# Case 05｜工厂内部创建：顶层To并不为空

主网Hash `0xcaa01f67726fdecf671f8f6a1b0b2cd832f1e8b43571b843100b12a8e5818fca`；区块24523650；2026-02-24 02:04:23 UTC。

[浏览器](https://etherscan.io/tx/0xcaa01f67726fdecf671f8f6a1b0b2cd832f1e8b43571b843100b12a8e5818fca) · [结构化证据](case-05-creation-evidence.json) · [相关作者Query](https://dune.com/queries/8378489) · [教学SQL](../sql/08-contract-creation.sql)

顶层From为`0x6f7ed8e91e03a9418942f24ab0cf61ae03cd8f75`，To为工厂`0xd68f5ce839e1325401a9deab56fa1c14cddb1cea`。调用create(uint32,bytes32,bytes)，状态成功；网页明确展示创建地址`0x5d96788b882eff9b028fdf7fd8fca757838b3c55`，并列出create_0_1_1创建路径。

Log145由工厂发出DisputeGameCreated，解码地址与创建展示一致，类型参数和rootClaim与顶层输入一致。它示范主网内部创建的证据连接，不展开应用对应的L2教程。

状态VALIDATED_INPUT_CREATION_AND_EVENT。未取得完整原始调用树、完整Initcode与最终Runtime Code；不能仅凭浏览器create标签判断具体CREATE/CREATE2 Opcode。旧Uniswap创建索引候选已归档，避免以不足的索引线索代替完整演示。
