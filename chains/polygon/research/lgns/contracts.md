# LGNS合约身份底表

网络全部为Polygon PoS Mainnet，Chain ID 137。地址由旧Query定位，5份源码捕获和部署页面交叉核对；没有本地重编译匹配。

| 角色 | 地址 | 本轮证据 | 精度 |
|---|---|---|---|
| LGNS | [0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01](https://polygonscan.com/address/0xeb51d9a39ad5eef215dc0bf39a8821ff804a0f01) | 已取对应已验证源码、ABI与部署交易 | 9：构造源码 |
| sLGNS | [0x99a57e6c8558bc6689f894e068733adf83c19725](https://polygonscan.com/address/0x99a57e6c8558bc6689f894e068733adf83c19725) | 已取对应已验证源码、ABI与部署交易 | 9：构造源码 |
| Staking | [0x1964ca90474b11ffd08af387b110ba6c96251bfc](https://polygonscan.com/address/0x1964ca90474b11ffd08af387b110ba6c96251bfc) | 已取对应已验证源码、ABI与部署交易 | 不把角色合约都当Token |
| Treasury | [0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321](https://polygonscan.com/address/0x7b9b7d4f870a38e92c9a181b00f9b33cc8ef5321) | 已取对应已验证源码、ABI与部署交易 | 不把角色合约都当Token |
| Pair | [0x882df4b0fb50a229c3b4124eb18c759911485bfb](https://polygonscan.com/address/0x882df4b0fb50a229c3b4124eb18c759911485bfb) | 已取对应已验证源码、ABI与部署交易 | 不把角色合约都当Token |
| Turbine | [0x07ff4e06865de4934409aa6ecea503b08cc1c78d](https://polygonscan.com/address/0x07ff4e06865de4934409aa6ecea503b08cc1c78d) | 原Query角色候选；对应源码与当前状态未取 | 不把角色合约都当Token |
| DAI | [0x8f3cf7ad23cd3cadbd9735aff958023239c6a063](https://polygonscan.com/address/0x8f3cf7ad23cd3cadbd9735aff958023239c6a063) | 官方Mapped Tokens与原DAI表；精度沿旧元数据18 | 18：旧DAI元数据与标准化转账，未RPC重读 |

## 部署来源

- lgns：创建交易[0x1074b961d4f3b1fb9519f91e18c10d769600a61258affdaeffb5d504168365da](https://polygonscan.com/tx/0x1074b961d4f3b1fb9519f91e18c10d769600a61258affdaeffb5d504168365da)；浏览器创建地址`0x5E4E7CaDB7c3d10E3bC96fb830A724448d9B4351`；[ABI](contracts/lgns/abi.json)。源码文件列表见[提取清单](contracts/manifest.json)。
- slgns：创建交易[0x4a7700fa0b2178dddbc9ca133e43d0e2e05ddf30493e24107acc40bb5a7147f4](https://polygonscan.com/tx/0x4a7700fa0b2178dddbc9ca133e43d0e2e05ddf30493e24107acc40bb5a7147f4)；浏览器创建地址`0x5E4E7CaDB7c3d10E3bC96fb830A724448d9B4351`；[ABI](contracts/slgns/abi.json)。源码文件列表见[提取清单](contracts/manifest.json)。
- staking：创建交易[0xf16fd6c927352bc03663071ecfb638b063b33be1fc385d112f7281cdfdd8521b](https://polygonscan.com/tx/0xf16fd6c927352bc03663071ecfb638b063b33be1fc385d112f7281cdfdd8521b)；浏览器创建地址`0x5E4E7CaDB7c3d10E3bC96fb830A724448d9B4351`；[ABI](contracts/staking/abi.json)。源码文件列表见[提取清单](contracts/manifest.json)。
- treasury：创建交易[0x7366b7fc964af8c0ef54dbb785ef21d4096df571f81226e307cd3707b0bd9185](https://polygonscan.com/tx/0x7366b7fc964af8c0ef54dbb785ef21d4096df571f81226e307cd3707b0bd9185)；浏览器创建地址`0x5E4E7CaDB7c3d10E3bC96fb830A724448d9B4351`；[ABI](contracts/treasury/abi.json)。源码文件列表见[提取清单](contracts/manifest.json)。
- pair：创建交易[0x226a240b5d72abaf9ed611afd2e99efc8fb8b1bfd7d324b82fb1d804d513f2b6](https://polygonscan.com/tx/0x226a240b5d72abaf9ed611afd2e99efc8fb8b1bfd7d324b82fb1d804d513f2b6)；浏览器创建地址`0x5E4E7CaDB7c3d10E3bC96fb830A724448d9B4351`；[ABI](contracts/pair/abi.json)。源码文件列表见[提取清单](contracts/manifest.json)。

## 已取与未取的身份字段

LGNS初始基础ERC20账本在构造路径中没有直接预铸调用；这不等于完整初始化历史已重建。sLGNS初始常量5,000,000×1e9用于内部gons初始化，不是外部资金。

当前totalSupply、历史完整供应、流通定义、MINT与默认管理员成员、Manager现值、Distributor地址、Warmup配置、LP持有者、多签和Timelock当前状态：未取得指定区块原始状态，保持UNKNOWN。不能由部署者或源码初值补填。

源码未见标准EIP-1967代理入口的事实，不等于已穷尽所有间接可变控制；外部回调、角色与关联合约仍可影响行为。Pair的token0=DAI/token1=LGNS沿原研究，未新eth_call重验。

出版注：5份ABI原样保留；完整第三方Solidity不重新分发，提取清单保留浏览器源码URL、原始文件名与SHA256，原有源码分析不变。
