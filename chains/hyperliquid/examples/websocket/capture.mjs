// Bounded public read subscriptions. Node's built-in WebSocket; no auth/signing.
import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const dir=path.dirname(fileURLToPath(import.meta.url));
const coin=process.argv[2]||'BTC';const filename=process.argv[3]||'capture.json';
if(!['BTC','@107'].includes(coin)||!['capture.json','capture-hype.json'].includes(filename))throw Error('Finite public market allowlist');
const requests=['trades','l2Book'].map(type=>({method:'subscribe',subscription:{type,coin}}));
const messages=[];const seen=new Set();let done=false;
const ws=new WebSocket('wss://api.hyperliquid.xyz/ws');
function finish(status,error){if(done)return;done=true;clearTimeout(timer);ws.close();fs.writeFileSync(path.join(dir,filename),JSON.stringify({network:'Mainnet',endpoint:'wss://api.hyperliquid.xyz/ws',requests,retrieved_at:new Date().toISOString(),status,error,messages,limits:{seconds:12,messages:8},grain:'trades: economic matches; l2Book: full aggregated snapshots'},null,2));console.log(status,messages.length);}
const timer=setTimeout(()=>finish('BOUNDED_TIMEOUT'),12000);
ws.addEventListener('open',()=>requests.forEach(x=>ws.send(JSON.stringify(x))));
ws.addEventListener('message',e=>{try{const x=JSON.parse(e.data);messages.push(x);if(['trades','l2Book'].includes(x.channel))seen.add(x.channel);if(seen.size===2||messages.length>=8)finish('OBSERVED');}catch(err){finish('PARSE_ERROR',String(err));}});
ws.addEventListener('error',()=>finish('BLOCKED','WebSocket transport error'));
