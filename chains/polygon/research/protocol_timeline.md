# 协议版本时间线

Bor与Heimdall分别编号。精确时间采用公开区块记录；~为官方计划时间，未伪装为精确激活时间。

| 升级 | 客户端 | 激活高度 | UTC时间 | 数据影响 | 证据状态 |
|---|---|---:|---|---|---|
| [Bhilai](https://polygonscan.com/block/73440256) | Bor | 73440256 | 2025-07-01T08:48:33+00:00 | Pectra/EIP-7702、Gas容量与费用参数 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Rio](https://polygonscan.com/block/77414656) | Bor | 77414656 | 2025-10-08T14:23:04+00:00 | VEBloP、单生产者Span、Witness架构 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Madhugiri](https://polygonscan.com/block/80084800) | Bor | 80084800 | 2025-12-09T10:04:13+00:00 | 执行与交易表示；PIP-74相关系统交易背景 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Dandeli](https://polygonscan.com/block/81424000) | Bor | 81424000 | 2026-01-09T14:01:02+00:00 | 目标Gas比例/参数背景；实现细节仍需专门重放核对 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Lisovo](https://polygonscan.com/block/83756500) | Bor | 83756500 | 2026-03-04T14:03:51+00:00 | PIP-79边界验证与可配置费用参数 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Giugliano](https://polygonscan.com/block/85268500) | Bor | 85268500 | 2026-04-08T14:03:57+00:00 | PIP-83头部Gas参数、PIP-66早期公告 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Chicago](https://polygonscan.com/block/87218600) | Bor | 87218600 | 2026-05-21T14:04:18+00:00 | PIP-88操作/预编译Gas重定价 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Valencia](https://polygonscan.com/block/89531000) | Bor | 89531000 | 2026-07-02T14:11:35+00:00 | Bor v2.9.0执行层硬分叉；详细改动未独立穷尽 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Austin](https://polygonscan.com/block/91949700) | Bor | 91949700 | 2026-08-13T13:59:37+00:00 | Bor v2.10.0执行层硬分叉；详细改动未独立穷尽 | CONFIG_HEIGHT_AND_EXPLORER_TIMESTAMP |
| [Heimdall v2](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 未另定本篇高度 | 2025-07-10 | 共识/模块规则；不是Bor高度 | OFFICIAL_RELEASE_DATE_ONLY |
| [Phuket](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 44070000 | 尚未取得 | 共识/模块规则；不是Bor高度 | OFFICIAL_CONFIG_AND_RELEASE_HEIGHT; RAW_TIMESTAMP_UNAVAILABLE |
| [Zurich](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 47880000 | 2026-06-25 ~14:00 UTC | 共识/模块规则；不是Bor高度 | OFFICIAL_SCHEDULE_NOT_RAW_TIMESTAMP |
| [Ithaca](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 50185000 | 2026-07-29 ~14:00 UTC | 共识/模块规则；不是Bor高度 | OFFICIAL_SCHEDULE_NOT_RAW_TIMESTAMP |
| [Kyoto](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 51533000 | 尚未取得 | 共识/模块规则；不是Bor高度 | OFFICIAL_CONFIG_AND_RELEASE_HEIGHT; RAW_TIMESTAMP_UNAVAILABLE |
| [Lugano](https://github.com/0xPolygon/heimdall-v2/releases) | Heimdall | 54627000 | 2026-10-01T16:22:06.133511367Z | 共识/模块规则；不是Bor高度 | OFFICIAL_HEIGHT_AND_HEIMDALL_BLOCK_CAPTURE |

版本冲突：PIP-84写85,245,000；官方Bor配置/发布公告写85,268,500，后者的区块实际时间2026-04-08 14:03:57UTC已取得。书稿采用后者。

Heimdall v2上线官方文章日期为2025-07-10；不强行构造迁移前后同一个高度语义。Heimdall v0.12.2（2026-10-14）、Bor v2.10.3（2026-10-15）已发布，但发布版本不等同于新的硬分叉。Hampi在固定Bor配置中为nil，未列为已激活。PIP-91/92的链上治理执行未核实，不因提案存在即宣布生效。

[固定版本Bor配置](https://raw.githubusercontent.com/0xPolygon/bor/1cdf43c99d97cb9e18860776d8f69a416b49adf4/params/config.go) · [Heimdall配置](https://raw.githubusercontent.com/0xPolygon/heimdall-v2/develop/helper/config.go) · [发布元数据](https://api.github.com/repos/0xPolygon/heimdall-v2/releases?per_page=30)
