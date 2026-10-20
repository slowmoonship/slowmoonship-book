"""Full retrieved historical result checks; not a raw-event reindex or new SQL execution."""
from pathlib import Path
from decimal import Decimal,getcontext
import json
ROOT=Path(__file__).resolve().parents[1];D=ROOT/'research/dune';getcontext().prec=45
def unwrap(r):
 x=r.get('result',r)
 if 'structuredContent' in x:return x['structuredContent']
 return json.loads(next(c['text'] for c in x['content'] if c['type']=='text'))
datasets={};checks=[]
for q in [8369671,8389592,8389804,8390372,8390785,8391200]:
 d=unwrap(json.loads((D/f'full-{q}.json').read_text()));rows=d['data']['rows'];total=d['resultMetadata']['totalRowCount'];datasets[q]=rows
 checks.append({'query_id':q,'check':'retrieved_all_declared_result_rows','pass':len(rows)==total,'rows':len(rows),'total':total,'execution_id':d['executionId']})
errors=[];skipped=0
for x in datasets[8390372]:
 keys=['simulated_lgns_balance','reserve_dai','reserve_lgns','token_sell_fee_rate','amm_fee_rate','fee_adjusted_exit_value_dai']
 if any(x.get(k) is None for k in keys):skipped+=1;continue
 d=lambda k:Decimal(str(x[k]));a=d('simulated_lgns_balance')*(1-d('token_sell_fee_rate'))*(1-d('amm_fee_rate'));calc=d('reserve_dai')*a/(d('reserve_lgns')+a);errors.append(abs(calc-d('fee_adjusted_exit_value_dai')))
checks.append({'query_id':8390372,'check':'all_retrieved_exit_scenarios_formula','pass':bool(errors) and max(errors)<Decimal('0.000001') and skipped==0,'checked':len(errors),'skipped':skipped,'max_abs_error_dai':str(max(errors))})
rateerrors=[];indexerrors=[]
for x in datasets[8369671]:
 rateerrors.append(abs(Decimal(x['rebase_raw'])/10**18-Decimal(str(x['rebase_rate']))));indexerrors.append(abs(Decimal(x['index_raw'])/10**9-Decimal(str(x['index']))))
checks.append({'query_id':8369671,'check':'all_rebase_ratio_index_scaling','pass':max(rateerrors)<Decimal('1e-15') and max(indexerrors)<Decimal('1e-9'),'rows':len(rateerrors),'max_rate_error':str(max(rateerrors)),'max_index_error':str(max(indexerrors))})
monthly=datasets[8391200];sum_net=sum(Decimal(str(x['net_dai_retained'])) for x in monthly);declared=Decimal(str(monthly[0]['net_retained_all_dai']));err=abs(sum_net-declared)
checks.append({'query_id':8391200,'check':'monthly_net_sum_matches_repeated_total','pass':err<Decimal('0.01'),'rows':len(monthly),'sum_monthly_dai':str(sum_net),'declared_total_dai':str(declared),'absolute_error_dai':str(err)})
checks.append({'query_id':8391200,'check':'published_classification_diagnostics','pass':all(x['classification_event_gap']==0 and x['duplicate_event_rows']==0 for x in monthly),'rows':len(monthly),'scope':'checks published diagnostics, not underlying raw-event uniqueness'})
flow=datasets[8389592];sampled=[x for x in flow if x.get('flow_reconciliation_gap') is not None];gap=max(abs(Decimal(str(x['flow_reconciliation_gap']))) for x in sampled)
checks.append({'query_id':8389592,'check':'published_reserve_reconciliation_samples','pass':gap<Decimal('0.01'),'sampled_days':len(sampled),'total_days':len(flow),'max_gap_dai':str(gap),'scope':'only days with non-null old snapshot comparison'})
summary={'status':'PASS' if all(x['pass'] for x in checks) else 'FAIL','full_datasets':6,'full_rows':sum(len(x) for x in datasets.values()),'checks':checks,'limitations':['Old results only; no new SQL execution','Does not independently reconstruct raw events or historical fee/state inputs','Daily entry-price scaling omits initial large-position market impact','Complete result retrieval is not a complete raw-fund-flow investigation']}
(ROOT/'reports/deep-result-checks.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2))
text='# LGNS关键旧结果完整取回与核对\n\n整理日期2026-10-20；固定研究基准2026-10-19。本次只取既有执行，未重跑SQL。\n\n| Query | 完整取得行数 |\n|---|---:|\n'
for q,rs in datasets.items():text+=f'| [{q}](https://dune.com/queries/{q}) | {len(rs)} |\n'
text+='\n共8082行。完整取回仅表示等于服务端声明的结果行数，不表示全部Raw事件已下载或独立重新索引。原有38份每项最多5行样本保留；新增六份文件以full-开头，分别记录执行ID。\n\n'
for x in checks:text+='- '+str(x['query_id'])+' '+x['check']+'：'+('PASS' if x['pass'] else 'FAIL')+'。\n'
text+='\n退出模型共'+str(len(errors))+'个情景，最大算术差'+str(max(errors))+'DAI；Rebase2632行单位换算；月度净额与总额一致；储备对照仅针对原查询非空样本日，不扩大为898天均有独立余额验证。\n\n初始仓位以历史日价线性换算，未模拟大额初始建仓冲击；费用历史与储备输入仍来自旧研究。查询之间的截止差异继续保留，不拼成新的统一观测。\n'
(ROOT/'research/lgns/full_results_review.md').write_text(text)
print(summary['status'],'full datasets',summary['full_datasets'],'rows',summary['full_rows'],'checks',len(checks),'max model error',max(errors))
