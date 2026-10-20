# SQL静态审查

18条新教学SQL；全部未提交服务端解析或执行。本地检查不等于运行成功。

检查：实际FROM/JOIN表存在当前Schema；显式表别名字段存在；括号、只读语句、时间或VALUES边界、状态标记。另逐条审查未限定列、单位、粒度、连接与经济含义。

- `examples/sql/core-structure/01-daily-blocks-tx.sql`：STATIC_CHECKED；表 polygon.blocks, polygon.transactions。
- `examples/sql/core-structure/02-gas-by-type.sql`：STATIC_CHECKED；表 polygon.transactions。
- `examples/sql/core-structure/03-transaction-grain.sql`：STATIC_CHECKED；表 polygon.logs, polygon.traces, polygon.transactions。
- `examples/sql/core-structure/04-contract-activity.sql`：STATIC_CHECKED；表 polygon.transactions。
- `examples/sql/defi/05-raw-transfer.sql`：STATIC_CHECKED；表 polygon.logs。
- `examples/sql/defi/06-stablecoin-transfers.sql`：STATIC_CHECKED；表 tokens.transfers。
- `examples/sql/defi/07-dex-grain.sql`：STATIC_CHECKED；表 dex.trades。
- `examples/sql/lgns/08-lp-events.sql`：STATIC_CHECKED；表 quickswap_polygon.uniswapv2pair_evt_burn, quickswap_polygon.uniswapv2pair_evt_mint。
- `examples/sql/bridge/09-fx-deposit.sql`：STATIC_CHECKED；表 polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxdepositerc20。
- `examples/sql/bridge/10-fx-withdraw.sql`：STATIC_CHECKED；表 polygon_pos_bridge_ethereum.fxerc20roottunnel_evt_fxwithdrawerc20。
- `examples/sql/core-structure/11-creation.sql`：STATIC_CHECKED；表 polygon.creation_traces。
- `examples/sql/defi/12-upgrade-events.sql`：STATIC_CHECKED；表 polygon.logs。
- `examples/sql/lgns/13-mint-burn.sql`：STATIC_CHECKED；表 polygon.logs。
- `examples/sql/lgns/14-staked.sql`：STATIC_CHECKED；表 polygon.logs。
- `examples/sql/lgns/15-rebase.sql`：STATIC_CHECKED；表 polygon.logs。
- `examples/sql/core-structure/16-join-demo.sql`：STATIC_CHECKED；表 。
- `examples/sql/lgns/17-dai-boundary.sql`：STATIC_CHECKED；表 maker_polygon.dai_evt_transfer。
- `examples/sql/lgns/18-exit-scenario.sql`：STATIC_CHECKED；表 。

特别限制：桥接只读特定Ethereum侧FxTunnel事件，未配对子链；Token0/1历史状态和完整费率变化未重扫；系统交易费用语义需与RPC核对；第16/18条为明确的VALUES演示/历史模型输入；DOUBLE用于近似展示，不冒充整数资产总账。
