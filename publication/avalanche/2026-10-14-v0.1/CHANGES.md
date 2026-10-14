# Avalanche v0.1 机械修改

仅出版副本：补连续上一章/目录/下一章导航；第三方整页缓存引用改为官方原文；源manifest的path改为excluded_local_snapshot并标注不分发；根入口整理；原稿验收报告的本机绝对路径改为公开路径，并注明作者人工审读UNKNOWN。没有改技术命题、SQL逻辑或案例结论。40章正文去除新增导航并逆转来源URL后须与原稿完全相同。

新建本快照6文件；更新全书README、SUMMARY、CHANGELOG、PUBLICATION_STATUS与publication入口/当前清单；旧链正文及历史快照不变。

- `chains/avalanche/README.md`：source_links_or_publication_note
- `chains/avalanche/book/00-preface.md`：reading_navigation
- `chains/avalanche/book/appendix/chain-identifiers.md`：reading_navigation
- `chains/avalanche/book/appendix/data-source-index.md`：reading_navigation
- `chains/avalanche/book/appendix/glossary.md`：reading_navigation
- `chains/avalanche/book/appendix/references.md`：reading_navigation
- `chains/avalanche/book/appendix/transaction-types.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-01/01-one-wallet-many-ledgers.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-01/02-network-and-primary.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-01/03-identities.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-01/04-three-models.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-02/05-consensus-and-vm.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-02/06-snowman.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-02/07-helicon.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-02/08-execution-artifacts.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-03/09-c-transfer.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-03/10-tokens-and-logs.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-03/11-fees.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-03/12-dune-raw.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-04/13-p-chain-role.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-04/14-p-objects.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-04/15-primary-staking.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-04/16-p-transaction-types.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-05/17-x-utxo.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-05/18-x-real-transfer.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-05/19-atomic-transfer.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-05/20-atomic-reconciliation.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-06/21-etna-and-subnets.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-06/22-launch-objects.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-06/23-genesis-and-gas-token.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-06/24-beam-creation.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-07/25-validator-manager.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-07/26-manager-bootstrap.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-07/27-validator-lifecycle.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-07/28-continuous-fees.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-08/29-warp-trust.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-08/30-teleporter.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-08/31-message-stages.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-08/32-asset-messaging.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-09/33-data-sources.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-09/34-decoded-curated.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-09/35-sql-grain.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-09/36-normalize-json.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-10/37-multi-chain-model.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-10/38-whole-network-balance.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-10/39-end-to-end.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/book/part-10/40-observability.md`：reading_navigation, source_links_or_publication_note
- `chains/avalanche/reports/editorial-review.md`：source_links_or_publication_note
- `chains/avalanche/reports/final-acceptance.md`：source_links_or_publication_note
- `chains/avalanche/research/evidence-index.md`：source_links_or_publication_note
- `chains/avalanche/research/protocol-timeline.md`：source_links_or_publication_note
- `chains/avalanche/research/source-manifest.json`：upstream_snapshot_provenance_only
- `chains/avalanche/research/source_catalog.md`：source_links_or_publication_note

- `chains/avalanche/reports/chapter-review.csv`：仅CRLF换行为LF，41行字段内容不变；修复Git diff --check的行尾警告。
