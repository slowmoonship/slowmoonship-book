# 证据索引

四层分开：DIRECT 直接取得；DERIVED 根据响应计算；PROTOCOL 官方规范；MODEL 教学抽象。缺口和执行限制另列，不互相冒充。

| 事实 | 命题 | 层级 | 状态 | 来源 |
|---|---|---|---|---|
| F01 | Avalanche 主网包含 Primary 与其他 L1 | PROTOCOL | COMPLETE | [primary-network](https://build.avax.network/docs/primary-network.md) |
| F02 | 一个 L1 可验证多条 Blockchain，每条归属一个 L1 | PROTOCOL | COMPLETE | [l1s](https://build.avax.network/docs/avalanche-l1s.md) |
| F03 | P/C/X 的 VM 与数据模型不同 | PROTOCOL | COMPLETE | [primary-network](https://build.avax.network/docs/primary-network.md) |
| F04 | Helicon 主网/Fuji 激活时间分别确认 | PROTOCOL | COMPLETE | [helicon](https://build.avax.network/docs/primary-network/helicon-upgrade.md) |
| F05 | 现行 C VM 为 saevm/cchain，Coreth 描述须分历史 | PROTOCOL | COMPLETE | [continuous-execution](https://build.avax.network/docs/nodes/architecture/execution/continuous-execution.md) |
| F06 | Subnet-EVM 不自动采用 C 的 CE | PROTOCOL | COMPLETE | [continuous-execution](https://build.avax.network/docs/nodes/architecture/execution/continuous-execution.md) |
| F07 | 接受、执行、结果承诺分开；效果在执行时确定 | PROTOCOL | COMPLETE | [acp-194](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/194-continuous-execution/README.md) |
| F08 | CE 计费受 gL/λ 约束，λ=2 | PROTOCOL | COMPLETE | [acp-194](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/194-continuous-execution/README.md) |
| F09 | Dune Helicon 后字段未做逐笔收据对账 | GAP | VALIDATED | [缺口](unresolved.md) |
| F10 | Cortina X 线性化日期确认 | PROTOCOL | COMPLETE | [cortina-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.10.0) |
| F11 | Etna 改现代 L1 验证者与 Primary 关系 | PROTOCOL | COMPLETE | [acp-77](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/77-reinventing-subnets/README.md) |
| F12 | 2,000 AVAX 门槛不能套全部现代 L1 | PROTOCOL | COMPLETE | [primary-network](https://build.avax.network/docs/primary-network.md) |
| F13 | Validator Manager 定位为链 ID + 地址 | PROTOCOL | COMPLETE | [acp-77](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/77-reinventing-subnets/README.md) |
| F14 | ACP-99 与 bootstrap 初始化职责 | PROTOCOL | COMPLETE | [manager-readme](https://raw.githubusercontent.com/ava-labs/icm-contracts/main/contracts/validator-manager/README.md) |
| F15 | Disable 非完全移除；零权重移除有约束 | PROTOCOL | COMPLETE | [acp-77](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/77-reinventing-subnets/README.md) |
| F16 | 费用余额与权重、抵押分开 | PROTOCOL | COMPLETE | [acp-77](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/77-reinventing-subnets/README.md) |
| F17 | Primary 验证最短 48h，委托仍两周 | PROTOCOL | COMPLETE | [helicon](https://build.avax.network/docs/primary-network/helicon-upgrade.md) |
| F18 | 自动续期周期不可误数为新注册 | PROTOCOL | COMPLETE | [helicon](https://build.avax.network/docs/primary-network/helicon-upgrade.md) |
| F19 | Warp 门槛按权重；C/X 来源有配置例外 | PROTOCOL | COMPLETE | [icm-overview](https://build.avax.network/docs/cross-chain/avalanche-warp-messaging/overview.md) |
| F20 | Granite epoch P views 修正当前高度假设 | PROTOCOL | COMPLETE | [acp-181](https://raw.githubusercontent.com/avalanche-foundation/ACPs/main/ACPs/181-p-chain-epoched-views/README.md) |
| F21 | Relayer 运输与消息认证分工 | PROTOCOL | COMPLETE | [icm-overview](https://build.avax.network/docs/cross-chain/avalanche-warp-messaging/overview.md) |
| F22 | Teleporter receive、execute、failure 分开 | PROTOCOL | COMPLETE | [teleporter-interface](https://raw.githubusercontent.com/ava-labs/icm-contracts/main/contracts/teleporter/ITeleporterMessenger.sol) |
| F23 | 三链身份由本轮实际官方 RPC 取得 | DIRECT | COMPLETE | [身份](../book/appendix/chain-identifiers.md) |
| F24 | C native 与 ERC20 为真实索引样本 | DIRECT | VALIDATED | [Case 01/02](../examples/transactions/README.md) |
| F25 | Atomic 两侧共同 UTXO 与后续委托消费 | DERIVED | COMPLETE | [离线校验](../reports/case-checks.json) |
| F26 | X 输入输出明细与索引汇总一致；差额未独立证实为费用 | DERIVED | VALIDATED | [Case 05](../examples/transactions/case-05.json) |
| F27 | Beam 创建/转换/管理位置与身份映射 | DIRECT | VALIDATED | [Case 06](../examples/transactions/case-06.json) |
| F28 | Beam 注册与后续快照；没有完整退出路径 | DIRECT | VALIDATED | [Case 07](../examples/transactions/case-07.json) |
| F29 | Beam 本次块与成功收据关联 | DIRECT | COMPLETE | [Case 09](../examples/transactions/case-09.json) |
| F30 | ICM 只取得真实源侧旧执行事件 | DIRECT | VALIDATED | [Case 08](../examples/transactions/case-08.json) |
| F31 | Raw/Curated/Teleporter 字段为实际 Catalog | DIRECT | COMPLETE | [Schema](schema-manifest.json) |
| F32 | 新 SQL 仅静态检查、没有新执行 | EXECUTION_LIMIT | BLOCKED | [SQL](../examples/sql/README.md) |
| F33 | 所有图是核实模型的教学简化，不伪装历史 | MODEL | COMPLETE | [图索引](../assets/diagrams/DIAGRAM_INDEX.md) |
