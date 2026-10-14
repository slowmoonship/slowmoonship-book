# 协议时间线

时间按官方 Mainnet 激活记录；软件发布日期不当成激活日期。不是全部 Avalanche 升级百科。

| 升级 | 生效位置 | 数据意义 | 证据 |
|---|---|---|---|
| 初始架构 | 创世架构；本轮不重复证明创世日期 | Primary Network 三链，不使用 EVM 单模型解释 | [primary-network](https://build.avax.network/docs/primary-network.md) |
| Banff / v1.9.0 | 2022-10-18 16:00 UTC | 传统许可/无许可型质押相关扩展；与现代 L1 转换分开 | [banff-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.9.0) |
| Cortina / v1.10.0 | 2023-04-25 15:00 UTC | X-Chain 线性化；历史 vertex 与当前 block 分开 | [cortina-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.10.0) |
| Durango / v1.11.0 | 2024-03-06 16:00 UTC | ACP-30 将 AWM 纳入 EVM，及其他已列 ACP | [durango-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.11.0) |
| Etna / v1.12.0 | 2024-12-16 17:00 UTC | ACP-77 现代 L1 管理、连续费；ACP-118 签名接口等 | [etna-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.12.0) |
| Fortuna / v1.13.0 | 2025-04-08 15:00 UTC | ACP-176 动态 EVM Gas 上限与定价，不用永久固定参数 | [fortuna-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.13.0) |
| Granite / v1.14.0 | 2025-11-19 16:00 UTC | ACP-181 epoched P views、ACP-204、ACP-226 | [granite-release](https://api.github.com/repos/ava-labs/avalanchego/releases/tags/v1.14.0) |
| Helicon / v1.15.0 | Mainnet 2026-09-22 15:00 UTC；Fuji 2026-07-28 15:00 UTC | ACP-194/236/267/273/283/285；仅 C 的 CE 与 Primary 质押变化 | [helicon](https://build.avax.network/docs/primary-network/helicon-upgrade.md) |

ACP-99 是依赖 ACP-77 的 Solidity 最佳实践标准，不另编一个未核实主网硬分叉日期。Banff、Durango、Granite 的历史与互操作演进分别处理；当前消息集合按 ACP-181 的 epoch 视图解释。Helicon 的未来功能（加密内存池、VRF 等）未因具备前置架构就写成已实现。
