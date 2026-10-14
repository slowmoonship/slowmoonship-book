"""Offline, exact-integer evidence checks for saved official JSON."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[2]
def response(slug):return json.loads((ROOT/'research/raw'/(slug+'.json')).read_text())['response']
def amount(u):return int(u.get('amount',u['asset']['amount']))
def verify():
 checks=[]
 def check(name,condition,detail):
  checks.append({'name':name,'passed':bool(condition),'detail':detail})
 exp=response('data-c-chain-latest')['transactions'][0];imp=response('atomic-p-import');follow=response('atomic-p-followup')
 u=exp['emittedUtxos'][0];v=next(x for x in imp['consumedUtxos'] if x['utxoId']==u['utxoId'])
 check('atomic_identity_asset_amount',u['utxoId']==v['utxoId'] and u['asset']['assetId']==v['assetId'] and amount(u)==amount(v),{'utxo':u['utxoId'],'raw_amount':amount(u)})
 check('atomic_direction',exp['sourceChain']==imp['sourceChain'] and exp['destinationChain']==imp['destinationChain'],{'source':exp['sourceChain'],'destination':exp['destinationChain']})
 out=imp['emittedUtxos'][0];check('import_to_delegation',any(x['utxoId']==out['utxoId'] for x in follow['consumedUtxos']),{'utxo':out['utxoId'],'followup':follow['txHash']})
 xt=response('data-x-chain-latest')['transactions'][0]
 total_in=sum(amount(x) for x in xt['consumedUtxos']);total_out=sum(amount(x) for x in xt['emittedUtxos']);unlocked=sum(int(x['amount']) for x in xt['amountUnlocked']);created=sum(int(x['amount']) for x in xt['amountCreated'])
 check('x_detail_to_indexed_totals',total_in==unlocked and total_out==created and total_in>=total_out,{'input':total_in,'output':total_out,'difference':total_in-total_out,'fee_field':'not returned; difference not independently verified as fee'})
 beam=json.loads((ROOT/'examples/transactions/beam-identity.json').read_text())
 cr=response('beam-create-chain');cfg=cr['blockchainInfo']['genesisData']['config'];rpc=int(response('beam-chain-id')['result'],16)
 check('beam_chain_id',int(beam['chainId'])==cfg['chainId']==rpc,{'directory':beam['chainId'],'genesis':cfg['chainId'],'rpc':rpc})
 check('beam_p_chain_mapping',cr['txHash']==beam['platformChainId'] and cr['subnetId']==beam['subnetId'],{'blockchain':cr['txHash'],'subnet':cr['subnetId']})
 h=response('beam-validator-history')['transactions'][0]['l1ValidatorDetails'][0];snapshot=response('beam-l1-validators')['validators'][0]
 check('beam_registration_identity',h['validationId']==snapshot['validationId'] and h['nodeId']==snapshot['nodeId'],{'validation_id':h['validationId'],'node_id':h['nodeId'],'observed_balance_difference':int(h['remainingBalance'])-int(snapshot['remainingBalance'])})
 block=response('beam-block')['result'];receipt=response('beam-receipt')['result']
 check('beam_receipt_link',receipt['transactionHash']==block['transactions'][0]['hash'] and receipt['blockHash']==block['hash'] and receipt['status']=='0x1',{'transaction':receipt['transactionHash'],'height':int(block['number'],16)})
 erc=response('c-erc20-detail');t=erc['erc20Transfers'][0]
 check('erc20_indexed_asset',t['erc20Token']['address'].lower()==erc['nativeTransaction']['to']['address'].lower() and t['erc20Token']['decimals']==6,{'raw':t['value'],'display_units':str(int(t['value'])//10**6),'log_index':t['logIndex']})
 report={'checks':checks,'passed':all(x['passed'] for x in checks),'scope':'saved finite sample only; no live or whole-network inference'}
 (ROOT/'reports/case-checks.json').write_text(json.dumps(report,ensure_ascii=False,indent=2));return report
if __name__=='__main__':
 report=verify();print(json.dumps(report,ensure_ascii=False,indent=2));raise SystemExit(0 if report['passed'] else 1)
