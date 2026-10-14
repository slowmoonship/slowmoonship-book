# Mainnet交易案例索引

2026-10-13取得，10个教学主题、8个不同主交易；主题复用不重复计数。API原始包装与hex均见examples/transactions。

## case-01｜单输入双输出：支付结构，找零未证实

网络：Bitcoin Mainnet。TxID：`f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16`。

高度：170；Block Hash：`00000000d1145790a8694403d4063f323d499e655c83426834d4ce2f8dd4a2ee`；块时间：2009-01-12T03:30:25+00:00。输入/输出：1/2；费用字段：0 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16) · [API](https://blockstream.info/api/tx/f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16) · [完整数据](../examples/transactions/tx-f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-02｜多输入单输出：整合候选，所有权未证实

网络：Bitcoin Mainnet。TxID：`d0a11ea1df62e05fb76a7b9e19cc0e63d39ac1e20097f6171b92be00bf1a6510`。

高度：481824；Block Hash：`0000000000000000001c8018d9cb3b742ef25114f27563e3fc4a1902167f9893`；块时间：2017-08-24T01:57:37+00:00。输入/输出：11/1；费用字段：0 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/d0a11ea1df62e05fb76a7b9e19cc0e63d39ac1e20097f6171b92be00bf1a6510) · [API](https://blockstream.info/api/tx/d0a11ea1df62e05fb76a7b9e19cc0e63d39ac1e20097f6171b92be00bf1a6510) · [完整数据](../examples/transactions/tx-d0a11ea1df62e05fb76a7b9e19cc0e63d39ac1e20097f6171b92be00bf1a6510.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-03｜P2PKH花费

网络：Bitcoin Mainnet。TxID：`c2bfb6f1bf791308c6b8f73f5d4181be9aa490da6e73c188f9ebd0723e8531b6`。

高度：481824；Block Hash：`0000000000000000001c8018d9cb3b742ef25114f27563e3fc4a1902167f9893`；块时间：2017-08-24T01:57:37+00:00。输入/输出：1/2；费用字段：96236 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/c2bfb6f1bf791308c6b8f73f5d4181be9aa490da6e73c188f9ebd0723e8531b6) · [API](https://blockstream.info/api/tx/c2bfb6f1bf791308c6b8f73f5d4181be9aa490da6e73c188f9ebd0723e8531b6) · [完整数据](../examples/transactions/tx-c2bfb6f1bf791308c6b8f73f5d4181be9aa490da6e73c188f9ebd0723e8531b6.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-04｜SegWit花费

网络：Bitcoin Mainnet。TxID：`777c998695de4b7ecec54c058c73b2cab71184cf1655840935cd9388923dc288`。

高度：709632；Block Hash：`0000000000000000000687bca986194dc2c1f949318629b44bb54ec0a94d8244`；块时间：2021-11-14T05:15:27+00:00。输入/输出：1/2；费用字段：369604 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/777c998695de4b7ecec54c058c73b2cab71184cf1655840935cd9388923dc288) · [API](https://blockstream.info/api/tx/777c998695de4b7ecec54c058c73b2cab71184cf1655840935cd9388923dc288) · [完整数据](../examples/transactions/tx-777c998695de4b7ecec54c058c73b2cab71184cf1655840935cd9388923dc288.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-05｜Taproot花费

网络：Bitcoin Mainnet。TxID：`2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e`。

高度：840000；Block Hash：`0000000000000000000320283a032748cef8227873ff4872689bf23f1cda83a5`；块时间：2024-04-20T00:09:27+00:00。输入/输出：1/2；费用字段：673200000 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e) · [API](https://blockstream.info/api/tx/2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e) · [完整数据](../examples/transactions/tx-2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-06｜840000 Coinbase

网络：Bitcoin Mainnet。TxID：`a0db149ace545beabbd87a8d6b20ffd6aa3b5a50e58add49a3d435f898c272cf`。

高度：840000；Block Hash：`0000000000000000000320283a032748cef8227873ff4872689bf23f1cda83a5`；块时间：2024-04-20T00:09:27+00:00。输入/输出：1/3；费用字段：0 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/a0db149ace545beabbd87a8d6b20ffd6aa3b5a50e58add49a3d435f898c272cf) · [API](https://blockstream.info/api/tx/a0db149ace545beabbd87a8d6b20ffd6aa3b5a50e58add49a3d435f898c272cf) · [完整数据](../examples/transactions/tx-a0db149ace545beabbd87a8d6b20ffd6aa3b5a50e58add49a3d435f898c272cf.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; special coinbase input; vout integer value/script; output total; witness commitment prefix structure。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification; full block fee sum independently reconstructed; normal fee formula not applicable; full block fee sum independently reconstructed; normal fee formula not applicable。

## case-07｜早期交易的三层花费依赖

网络：Bitcoin Mainnet。TxID：`f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16`。

高度：170；Block Hash：`00000000d1145790a8694403d4063f323d499e655c83426834d4ce2f8dd4a2ee`；块时间：2009-01-12T03:30:25+00:00。输入/输出：1/2；费用字段：0 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16) · [API](https://blockstream.info/api/tx/f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16) · [完整数据](../examples/transactions/tx-f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-08｜Bitfinex公开披露BTC热钱包参与的确认交易

网络：Bitcoin Mainnet。TxID：`04bf3fd6f4baf459608ec7ef80fe091d19a727e9c0fe41a499fec66ed2678568`。

高度：971171；Block Hash：`00000000000000000002010defb848531e4ad3b00b446f4046230906b3b18606`；块时间：2026-10-13T02:18:07+00:00。输入/输出：2/2；费用字段：1376 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/04bf3fd6f4baf459608ec7ef80fe091d19a727e9c0fe41a499fec66ed2678568) · [API](https://blockstream.info/api/tx/04bf3fd6f4baf459608ec7ef80fe091d19a727e9c0fe41a499fec66ed2678568) · [完整数据](../examples/transactions/tx-04bf3fd6f4baf459608ec7ef80fe091d19a727e9c0fe41a499fec66ed2678568.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; integer values; fee identity; address appears in prevout; official file labels address BTC hot wallet。未核验：beneficial owners; customer payments; full wallet cluster; current independent key control; same-transaction Dune result。

外部归因：[官方固定版本](https://github.com/bitfinexcom/pub/blob/83d06bdb5f5a2ce05d5ba2db5a426dd44c9f5128/wallets.txt)；EXTERNAL_ATTRIBUTION; official self-disclosure; not independent key-control proof。

## case-09｜复杂多输入多输出；不认定CoinJoin

网络：Bitcoin Mainnet。TxID：`4e99434f63a13b659cd94f4eb3b3811f1d88eb2ef9080840549ec50a0641a422`。

高度：481824；Block Hash：`0000000000000000001c8018d9cb3b742ef25114f27563e3fc4a1902167f9893`；块时间：2017-08-24T01:57:37+00:00。输入/输出：176/11；费用字段：16133806 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/4e99434f63a13b659cd94f4eb3b3811f1d88eb2ef9080840549ec50a0641a422) · [API](https://blockstream.info/api/tx/4e99434f63a13b659cd94f4eb3b3811f1d88eb2ef9080840549ec50a0641a422) · [完整数据](../examples/transactions/tx-4e99434f63a13b659cd94f4eb3b3811f1d88eb2ef9080840549ec50a0641a422.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## case-10｜Runestone标记候选；资产状态未索引

网络：Bitcoin Mainnet。TxID：`2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e`。

高度：840000；Block Hash：`0000000000000000000320283a032748cef8227873ff4872689bf23f1cda83a5`；块时间：2024-04-20T00:09:27+00:00。输入/输出：1/2；费用字段：673200000 sat（Coinbase不适用普通费用公式）。

[Explorer](https://blockstream.info/tx/2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e) · [API](https://blockstream.info/api/tx/2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e) · [完整数据](../examples/transactions/tx-2bb85f4b004be6da54f766c17c1e855187327112c231ef2ff35ebad0ea67c69e.json)。Dune Query：未取得同笔执行结果，不虚构URL。

已核验：txid; confirmed block location; vin previous outpoint; prevout value (indexer enriched); vout value/script; fee from integer totals。未核验：real identities; payment purpose; change ownership; Dune same-transaction result; independent local full-node consensus verification。

## 跨交易追踪

[三条花费边](../examples/transactions/spend-graph.json)已按实际vin及旧vout核对。种子输出零10BTC在2010-11-16高度92240被花费，后两层为92241与92640；窗口不是2009年一月。种子输出一40BTC另在高度181花费，分支未作为三层种子。

Case09选择复杂多输入替代缺少业务证据的CoinJoin；Case10仅Runestone标记与原字节已取得，未验证完整附加资产状态。
