from pathlib import Path
import json,sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'examples/python'))
from decode_transaction import decode
checks=[]
def check(name,ok):
 checks.append({'check':name,'pass':bool(ok)})
 if not ok:print('FAIL',name)
out=ROOT/'examples/transactions';cases=json.load(open(out/'case-index.json'))
decodes={}
for c in cases:
 tid=c['txid'];t=json.load(open(out/f'tx-{tid}.json'))['data'];raw=json.load(open(out/f'hex-{tid}.json'))['data'];d=decode(raw);decodes[tid]=d
 check(c['case_id']+' txid',d['txid']==tid)
 check(c['case_id']+' raw metadata',(d['size'],d['weight'],d['version'],d['locktime'])==(t['size'],t['weight'],t['version'],t['locktime']))
 check(c['case_id']+' output bytes',[(v['value_sat'],v['script_hex']) for v in d['vout']]==[(v['value'],v['scriptpubkey']) for v in t['vout']])
 check(c['case_id']+' block location',c['block_hash']==t['status']['block_hash'] and c['block_height']==t['status']['block_height'] and t['status']['confirmed'])
 if not t['vin'][0]['is_coinbase']:
  check(c['case_id']+' prevout references',[(v['txid'],v['vout']) for v in d['vin']]==[(v['txid'],v['vout']) for v in t['vin']])
  check(c['case_id']+' integer fee',sum(v['prevout']['value'] for v in t['vin'])-sum(v['value'] for v in t['vout'])==t['fee']==c['fee_sat'])
 else:check(c['case_id']+' special coinbase input',d['vin'][0]['txid']=='0'*64 and d['vin'][0]['vout']==4294967295)
for e in json.load(open(out/'spend-graph.json')):
 prev=json.load(open(out/f"tx-{e['from_txid']}.json"))['data'];next_=json.load(open(out/f"tx-{e['to_txid']}.json"))['data'];v=next_['vin'][e['vin']]
 check('spend edge '+str(e['depth']),v['txid']==e['from_txid'] and v['vout']==e['vout'] and v['prevout']['value']==prev['vout'][e['vout']]['value'] and v['prevout']['scriptpubkey']==prev['vout'][e['vout']]['scriptpubkey'])
first=cases[0]['txid'];cross=json.load(open(out/f'cross-{first}.json'))['data'];local=json.load(open(out/f'tx-{first}.json'))['data']
fields=['txid','version','locktime','vin','vout','size','weight','fee','status']
check('cross-provider seed core fields',all(cross[k]==local[k] for k in fields))
# mempool.space additionally returns sigops=8; this is an enrichment, not a conflict.
ex=next(x for x in cases if x['case_id']=='case-08');t=json.load(open(out/f"tx-{ex['txid']}.json"))['data'];check('exchange address prevout',any(v.get('prevout',{}).get('scriptpubkey_address')==ex['attribution_address'] for v in t['vin']))
rune=next(x for x in cases if x['case_id']=='case-10');t=json.load(open(out/f"tx-{rune['txid']}.json"))['data'];check('runestone candidate marker',any(v['scriptpubkey'].startswith('6a5d') for v in t['vout']))
report={'scope':'Local structure, hashes, integer amounts, indexer prevouts and spend edges. Not signature/PoW/full-node consensus verification or Dune execution.','checks':checks,'passed':sum(x['pass'] for x in checks),'total':len(checks),'distinct_primary_txids':len(decodes)}
(ROOT/'reports/case-validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
(out/'decoded-transactions.json').write_text(json.dumps(decodes,indent=2));print(report['passed'],'/',report['total']);sys.exit(0 if all(x['pass'] for x in checks) else 1)
