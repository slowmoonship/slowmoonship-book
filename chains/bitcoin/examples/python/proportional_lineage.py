"""RESEARCH_MODEL: fully proportional mixing; fees are an explicit sink."""
from fractions import Fraction
import json
INPUTS={'A':40000000,'B':60000000}
OUTPUTS={'output_0':30000000,'output_1':69900000,'fee_sink':100000}
def allocate(inputs,outputs):
 total=sum(inputs.values())
 if total<=0 or sum(outputs.values())!=total:raise ValueError('Conservation failure')
 result={s:{d:Fraction(v*a,total) for d,a in outputs.items()} for s,v in inputs.items()}
 for s,v in inputs.items():assert sum(result[s].values())==v
 for d,v in outputs.items():assert sum(result[s][d] for s in inputs)==v
 return result
if __name__=='__main__':
 out=allocate(INPUTS,OUTPUTS)
 assert out['A']=={'output_0':12000000,'output_1':27960000,'fee_sink':40000}
 print(json.dumps({'evidence_level':'RESEARCH_MODEL','assumption':'Fully proportional value mixing; not identity probability; Fraction values are model shares, not fractional protocol outputs','unit':'satoshi share','allocations':{s:{d:str(v) for d,v in row.items()} for s,row in out.items()}},indent=2))
