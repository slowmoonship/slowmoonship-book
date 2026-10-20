# 离线复算

运行`python3 reproduce_lgns_exit.py`读取已保存的旧Query8390372结果，使用标准库Decimal重算四种最终仓位。没有网络请求、不安装依赖、不执行Dune SQL。输入状态与历史费率并未因此获得独立重建，输出是公式复现。
