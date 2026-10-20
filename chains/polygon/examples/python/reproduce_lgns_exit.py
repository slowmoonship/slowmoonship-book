"""Offline reproduction of captured Query8390372 scenarios; no network calls."""
from pathlib import Path
from decimal import Decimal,getcontext
import json
ROOT=Path(__file__).resolve().parents[2];getcontext().prec=45
def unwrap(r):
 x=r.get('result',r)
 if 'structuredContent' in x:return x['structuredContent']
 for c in x.get('content',[]):
  if c.get('type')=='text':
   try:return json.loads(c['text'])
   except ValueError:pass
 return x
q=unwrap(json.loads((ROOT/'research/dune/8390372.json').read_text()));r=unwrap(json.loads((ROOT/'research/dune'/f'{q["latest_execution_id"]}.json').read_text()))
for x in r['data']['rows']:
 if not x['is_final_date']:continue
 d=lambda key:Decimal(str(x[key]));net=d('simulated_lgns_balance')*(1-d('token_sell_fee_rate'));effective=net*(1-d('amm_fee_rate'));out=d('reserve_dai')*effective/(d('reserve_lgns')+effective)
 print(json.dumps({'cutoff_utc':'2026-08-18T09:28:58Z','initial_dai':x['initial_capital_dai'],'modeled_dai_out':str(out),'old_result_dai':x['fee_adjusted_exit_value_dai'],'absolute_error':str(abs(out-d('fee_adjusted_exit_value_dai'))),'status':'FORMULA_REPRODUCED; INPUTS_NOT_FULLY_REVERIFIED'},ensure_ascii=False))
