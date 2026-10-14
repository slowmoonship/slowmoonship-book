"""Offline evidence identity and Decimal checks. No network or chain replay."""
from pathlib import Path
from decimal import Decimal as D
import json,re
ROOT=Path(__file__).resolve().parents[1]
def load(p):return json.loads((ROOT/p).read_text())
def api(n):return load('examples/api/'+n+'.json')['response']
checks=[]
def check(name,ok,details=''):checks.append({'check':name,'pass':bool(ok),'details':details})
def run():
 a=api('17-fills-0');b=api('17-fills-1');ws=load('examples/websocket/capture.json');t=next(x['data'][-1] for x in ws['messages'] if x['channel']=='trades');key=lambda x:(x['coin'],x['time'],x['tid']);legs=[next(f for f in fs if key(f)==key(t)) for fs in [a,b]]
 for i,f in enumerate(legs):
  for fld in ['coin','time','tid','hash','px','sz']:check(f'trade-leg-{i}-{fld}',f[fld]==t[fld])
 check('buyer-seller-users',len(t['users'])==2 and all(re.fullmatch('0x[0-9a-f]{40}',x) for x in t['users']))
 check('opposite-sides',legs[0]['side']=='B' and legs[1]['side']=='A')
 check('opposite-maker-taker',not legs[0]['crossed'] and legs[1]['crossed'])
 check('buyer-closes-short',D(legs[0]['startPosition'])<0 and legs[0]['dir']=='Close Short')
 check('seller-closes-long',D(legs[1]['startPosition'])>0 and legs[1]['dir']=='Close Long')
 check('single-notional',D(t['px'])*D(t['sz'])==D('10.03104'))
 check('double-legs',sum((D(f['px'])*D(f['sz']) for f in legs),D(0))==D('20.06208'))
 check('net-fee',sum((D(f['fee']) for f in legs),D(0))==D('0.004213'))
 check('local-buyer-after',D(legs[0]['startPosition'])+D(legs[0]['sz'])==D('-7.53675'))
 check('local-seller-after',D(legs[1]['startPosition'])-D(legs[1]['sz'])==D('0.00295'))
 o=api('24-order-status')['order'];oid=o['order']['oid'];f=next(x for x in a if x['oid']==oid)
 for field in ['coin','cloid']:check('order-fill-'+field,o['order'][field]==f[field])
 check('order-status-filled',o['status']=='filled')
 check('order-size',D(o['order']['origSz'])==D(f['sz']) and D(o['order']['sz'])==0)
 c=load('examples/cases/case-02.json')['data'];fs=c['fills']
 check('multiple-same-order',len(fs)>1 and len(set(f['oid'] for f in fs))==1)
 check('multiple-distinct-trades',len(set(f['tid'] for f in fs))==len(fs))
 check('multiple-decimal-sum',sum((D(f['sz']) for f in fs),D(0))==D('0.19898'))
 check('multiple-before-after-continuity',D(fs[0]['startPosition'])-D(fs[0]['sz'])==D(fs[1]['startPosition']))
 check('unknown-order-not-fabricated',api('27-multiple-fill-order')=={'status':'unknownOid'})
 fund=api('20-user-funding');hist=api('06-btc-funding');rates={x['time']//3600000:D(x['fundingRate']) for x in hist}
 check('funding-hourly-history',len(hist)>0 and all(x['coin']=='BTC' for x in hist))
 matches=0
 for x in fund:
  if x['time']//3600000 in rates:
   matches+=1;check('funding-rate-match-'+str(x['time']),D(x['delta']['fundingRate'])==rates[x['time']//3600000])
 check('funding-rate-cross-source-coverage',matches>0,str(matches)+' matching rounds; exact payment not independently recalculated')
 check('funding-account-direction',all(D(x['delta']['szi'])*D(x['delta']['fundingRate'])*D(x['delta']['usdc'])<=0 for x in fund))
 check('funding-zero-hash-preserved',any(x['hash']=='0x'+'0'*64 for x in fund))
 spot=api('03-spot-meta');hype=next(x for x in spot['tokens'] if x['name']=='HYPE');pair=next(x for x in spot['universe'] if x['index']==107)
 check('HYPE-token-identity',hype['index']==150 and hype['weiDecimals']==8 and hype['szDecimals']==2)
 check('HYPE-pair-identity',pair['tokens']==[150,0])
 hws=load('examples/websocket/capture-hype.json');htr=next(x['data'][0] for x in hws['messages'] if x['channel']=='trades');check('HYPE-spot-trade-market',htr['coin']=='@107')
 dx=api('04-perp-dexs');md=api('09-hip3-meta');reg=load('examples/cases/case-09.json')['data'];check('HIP3-dex-identity',dx[reg['dex_index']]['name']=='xyz');check('HIP3-market-identity',md[0]['universe'][reg['market_index']]['name']=='xyz:TSLA');check('HIP3-asset-formula',reg['asset_id']==100000+reg['dex_index']*10000+reg['market_index'])
 out=api('08-settled-outcome');check('outcome-identity',out['spec']['outcome']==95);check('outcome-settle-bounds',0<=D(out['settleFraction'])<=1);check('outcome-settlement-price',D(out['details'].split(':')[1])<D('77363') and D(out['settleFraction'])==0)
 om=api('05-outcome-meta');check('mainnet-outcome-and-question-observed',len(om['outcomes'])==327 and len(om['questions'])==35)
 check('mainnet-chain-id',int(api('12-evm-chain')['result'],16)==999)
 block=api('14-evm-block')['result'];receipt=api('16-evm-receipt')['result'];check('receipt-block-hash',block['hash']==receipt['blockHash']);check('receipt-block-number',block['number']==receipt['blockNumber']);check('receipt-transaction-membership',receipt['transactionHash'] in [x['hash'] for x in block['transactions']]);check('receipt-log-ownership',all(x['transactionHash']==receipt['transactionHash'] and x['blockHash']==block['hash'] for x in receipt.get('logs',[])))
 check('precompile-read-nonerror','result' in api('25-read-oracle') and int(api('25-read-oracle')['result'],16)>0)
 check('corewriter-code-nonempty',len(api('28-corewriter-code')['result'])>2)
 check('bounded-empty-transfer-sample',api('26-hype-transfer-logs')['result']==[])
 check('HLP-identity',api('29-hlp-vault')['name']=='Hyperliquidity Provider (HLP)' and api('29-hlp-vault')['vaultAddress']=='0xdfc24b077bc1425ad1dea75bcb6f8158e10df303')
 check('HLP-liquidator-parent-child',api('30-hlp-child')['name']=='HLP Liquidator' and api('30-hlp-child')['vaultAddress'] in api('29-hlp-vault')['relationship']['data']['childAddresses'])
 check('empty-liquidator-window-not-fabricated',api('31-liquidator-fills')==[])
 check('ledger-subaccount-type',api('21-user-ledger')[0]['delta']['type']=='subAccountTransfer')
 check('simulated-book-arithmetic',(D(3)*D(100)+D(1)*D(101))/D(4)==D('100.25'),'teaching simulation, not case evidence')
 result={'status':'PASS' if all(x['pass'] for x in checks) else 'FAIL','count':len(checks),'checks':checks,'scope':'offline identities, source-linked fields, Decimal arithmetic; not independent consensus, signing, full financial replay'}
 (ROOT/'reports/case-evidence-validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2));print(result['status'],len(checks),'evidence checks')
 for x in checks:
  if not x['pass']:print('FAIL',x['check'],x['details'])
 return result
if __name__=='__main__':
 result=run();raise SystemExit(0 if result['status']=='PASS' else 1)
