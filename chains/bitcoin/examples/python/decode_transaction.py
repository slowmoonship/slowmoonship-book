"""Structural Bitcoin decoder. No signature/PoW/consensus validation."""
import hashlib,struct,json
from pathlib import Path
def double_sha(x):return hashlib.sha256(hashlib.sha256(x).digest()).digest()[::-1].hex()
def decode(raw):
 b=bytes.fromhex(raw);pos=0
 def take(n):
  nonlocal pos
  if n<0 or pos+n>len(b):raise ValueError('Truncated transaction')
  v=b[pos:pos+n];pos+=n;return v
 def count():
  x=take(1)[0]
  if x<253:return x
  return int.from_bytes(take({253:2,254:4,255:8}[x]),'little')
 def blob():return take(count())
 version=take(4);has_witness=b[pos:pos+2]==b'\x00\x01'
 if has_witness:take(2)
 base_start=pos;nvin=count();vin=[]
 for _ in range(nvin):
  prev=take(32)[::-1].hex();vout=int.from_bytes(take(4),'little');sig=blob().hex();seq=int.from_bytes(take(4),'little')
  vin.append({'txid':prev,'vout':vout,'script_sig':sig,'sequence':seq})
 nvout=count();vout=[]
 for i in range(nvout):vout.append({'index':i,'value_sat':int.from_bytes(take(8),'little'),'script_hex':blob().hex()})
 base_end=pos
 if has_witness:
  for x in vin:x['witness']=[blob().hex() for _ in range(count())]
 lock=take(4)
 if pos!=len(b):raise ValueError('Trailing bytes')
 base=version+b[base_start:base_end]+lock;weight=3*len(base)+len(b)
 return {'txid':double_sha(base),'wtxid':double_sha(b),'version':int.from_bytes(version,'little',signed=True),'locktime':int.from_bytes(lock,'little'),'size':len(b),'base_size':len(base),'weight':weight,'vsize':(weight+3)//4,'vin':vin,'vout':vout,'has_witness':has_witness}
if __name__=='__main__':
 import sys
 d=json.load(open(sys.argv[1]));raw=d.get('data',d)
 print(json.dumps(decode(raw),indent=2))
