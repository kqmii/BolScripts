-------------------------------
--	MalzaharMadness by Kqmii --
-------------------------------
if myHero.charName ~= "Malzahar" then return end

local currentVersion = 1.34

require 'VPrediction'
require 'SxOrbwalk'

local qRange, qWidth, qDelay, qSpeed = 900, 450, 0.6, 1600 
local wRange, wRadius, wDelay, wSpeed = 800, 240, 0.25, math.huge
local eRange = 650
local rRange, rDelay = 700, 0.4
local visionRange = 1800
local Color = ARGB(255, 0, 255, 0)
local gEnemy = GetEnemyHeroes()
local ts
local AlreadyE = false
local UltON = false
local IgniteKey = nil
local IREADY = false
local stunList = {
["katarinarsound"] = true,
["AbsoluteZero"] = true,
["AlZaharNetherGrasp"] = true,
["missfortunebulletsound"] = true, 
["VelkozR"] = true, 
["monkeykingspinknockup"] = true,
["CaitlynAceintheHole"] = true,
["Crowstorm"] = true,
["UrgotSwap2"] = true,
}
local debuffE = { ["AlZaharMaleficVisions"] = true}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	PrintChat("<font color=\"#33CC99\"><b>MalzaharMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat("<b>Report any problem by pm to kqmii on bol</b>")
	EnemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC)
	JungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
	Menu()
	updateScript()
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then IgniteKey = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then IgniteKey = SUMMONER_2 end
end
function OnTick()
	ts:update()
	EnemyMinions:update()
	JungleMinions:update()
	target = ts.target
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	IREADY = (IgniteKey ~= nil and myHero:CanUseSpell(IgniteKey) == READY)
	
	if malzCFG.combo.comboKey and target ~= nil then
		killTarget(target)
	end
	if malzCFG.lc.LcKey then
		Laneclear()
	end
	if malzCFG.harass.harassKey then
		Harass()
	end
	if malzCFG.KS.KSactif then
		KS()
	end
	if malzCFG.combo.rCC then
		rDangerousCC()
	end
	if UltON == true then
		SxOrb:DisableMove()
		SxOrb:DisableAttacks()
	else
		SxOrb:EnableAttacks()
		SxOrb:EnableMove()
	end
	if malzCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
		if myHero.dead then return end
		if malzCFG.draw.qDraw and QREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, Color)
		end
		if malzCFG.draw.wDraw and WREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, Color)
		end
		if malzCFG.draw.eDraw and EREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, Color)
		end
		if malzCFG.draw.rDraw and RREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, Color)
		end
		if ValidTarget(ts.target) then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 120, ARGB(255, 102, 204, 51))
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 125, ARGB(255, 102, 204, 51))
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 130, ARGB(255, 102, 204, 51))
		end
end
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
  radius = radius or 300
  quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
  
  local points = {}
  for theta = 0, 2 * math.pi + quality, quality do
    local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, width or 1, color or 4294967295)
end
function round(num) 
  if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  
  if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
    DrawCircleNextLvl(x, y, z, radius, malzCFG.draw.Width, color, malzCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGIC)
	malzCFG = scriptConfig("MalzaharMadness", "MKQ")
	VP = VPrediction()
	SxOrb = SxOrbWalk(VP)
	
		malzCFG:addSubMenu(myHero.charName.." - Combo", "combo")
			malzCFG.combo:addParam("iUse", "Use Ignite if killable", SCRIPT_PARAM_ONOFF, true)
			malzCFG.combo:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			malzCFG.combo:addParam("wUse", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
			malzCFG.combo:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			malzCFG.combo:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
			malzCFG.combo:addParam("rCC", "Auto R dangerous spells", SCRIPT_PARAM_ONOFF, false)
			malzCFG.combo:addSubMenu("R on wich champ =>", "rTarget")
				for i, target in pairs(gEnemy) do
					malzCFG.combo.rTarget:addParam(target.charName, target.charName, SCRIPT_PARAM_ONOFF, true)
				end
			malzCFG.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))

		malzCFG:addSubMenu(myHero.charName.." - Harass", "harass")
			malzCFG.harass:addParam("qHarass", "Use Q in harass", SCRIPT_PARAM_ONOFF, true)
			malzCFG.harass:addParam("eHarass", "Use E in harass", SCRIPT_PARAM_ONOFF, true)
			malzCFG.harass:addParam("manaCheck", "Stop harass at % mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			malzCFG.harass:addParam("harassKey", "Harass Key toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
			
		malzCFG:addSubMenu(myHero.charName.." - Auto KS", "KS")
			malzCFG.KS:addParam("qKs", "KS with Q", SCRIPT_PARAM_ONOFF, true)
			malzCFG.KS:addParam("eKs", "KS with E", SCRIPT_PARAM_ONOFF, true)
			malzCFG.KS:addParam("rKs", "KS with R", SCRIPT_PARAM_ONOFF, true)
			malzCFG.KS:addParam("iKs", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)
			malzCFG.KS:addParam("KSactif", "KS key toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
			
		malzCFG:addSubMenu(myHero.charName.." - Laneclear", "lc")
			malzCFG.lc:addParam("qLc", "Q in laneclear", SCRIPT_PARAM_ONOFF, true)
			malzCFG.lc:addParam("wLc", "W in laneclear", SCRIPT_PARAM_ONOFF, true)
			malzCFG.lc:addParam("eLc", "E in laneclear", SCRIPT_PARAM_ONOFF, true)
			malzCFG.lc:addParam("manaStop", "Stop using spell at % mana", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			malzCFG.lc:addParam("LcKey", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			
		malzCFG:addSubMenu(myHero.charName.." - Drawings", "draw")
			malzCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
			malzCFG.draw:addParam("wDraw", "Draw W range", SCRIPT_PARAM_ONOFF, true)
			malzCFG.draw:addParam("eDraw", "Draw E range", SCRIPT_PARAM_ONOFF, true)
			malzCFG.draw:addParam("rDraw", "Draw R range", SCRIPT_PARAM_ONOFF, true)
			malzCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			malzCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			malzCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
		
		malzCFG:addSubMenu(myHero.charName.." - Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(malzCFG.SxOrb)
			
		malzCFG:addTS(ts)
			ts.name = myHero.charName
		
		malzCFG.combo:permaShow("comboKey")
		malzCFG.harass:permaShow("harassKey")
		malzCFG.KS:permaShow("KSactif")
		malzCFG.lc:permaShow("LcKey")
end
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
function IsOnCC(target)
	assert(type(target) == 'userdata', "IsOnCC: Wrong type. Expected userdata got: "..tostring(type(target)))
	for i  =  1, target.buffCount do
		tBuff = target:getBuff(i)
		if BuffIsValid(tBuff) and stunList[tBuff.name] then
			return true
		end	
	end
	return false
end
function Laneclear()
	if UltON == true then return end
	if not ManaCheck(myHero, malzCFG.lc.manaStop) then
		if malzCFG.lc.qLc then
			qFarm()
		end
		if malzCFG.lc.wLc then
			wFarm()
		end
		if malzCFG.lc.eLc then
			eFarm()
		end
	end
end
function Harass()
	if UltON == true then return end
	if not ManaCheck(myHero, malzCFG.harass.manaCheck) then
		if malzCFG.harass.qHarass then
			qHarass()
		end
		if malzCFG.harass.eHarass then
			eHarass()
		end
	end
end
function KS()
	if UltON == true then return end
	if malzCFG.KS.iKs then
		for i, target in pairs(gEnemy) do
			iCast(target)
		end
	end
	if malzCFG.KS.eKs then
		eKs()
	end
	if malzCFG.KS.qKs then
		qKs()
	end
	if malzCFG.KS.rKs then
		rKs()
	end
end
function killTarget(target)
		if malzCFG.combo.iUse and IgniteKey ~= nil then
			iCast(target)
		end
		if malzCFG.combo.qUse then
			qCombo(target)
		end
		if malzCFG.combo.wUse then
			wCombo(target)
		end
		if malzCFG.combo.eUse then
			eCombo(target)
		end
		if malzCFG.combo.rUse then
			DelayAction(function() rCombo(target) end, 0.870)
		end		
end
---------------------------------------
--			Spells config            --
---------------------------------------
function iCast(target)
	if UltON == true then return end
		local iDmg = 50 + (20 * myHero.level)
		if target ~= nil and target.team ~= myHero.team and target.visible and not target.dead then
			if IgniteKey ~= nil and IREADY and ValidTarget(target) and GetDistance(target) < 600 then
				if target.health < iDmg then
					CastSpell(IgniteKey, target)
				end
			end
		end
	end
function qCombo(target)
if UltON == true then return end
		if target ~= nil and ValidTarget(target) and not target.dead then
			if GetDistance(target) < qRange and QREADY then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero)
				if AOECastPosition and MainTargetHitChance >= 2 and nTargets >= 1 then
					CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
				end
			end
		end
end
function qHarass()
if UltON == true then return end
	for i, target in pairs(gEnemy) do
		if target ~= nil and ValidTarget(target) and not target.dead then
			if GetDistance(target) < qRange and QREADY then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero)
				if AOECastPosition and MainTargetHitChance >= 2 and nTargets >= 1 then
					CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
				end
			end
		end
	end
end
function qFarm()
if UltON == true then return end
	for i, minion in pairs(EnemyMinions.objects) do
		if minion~= nil and not minion.dead then
			if GetDistance(minion) < qRange and QREADY then
				CastSpell(_Q, minion.x, minion.z)
			end
		end
	end
	for i, minions in pairs(JungleMinions.objects) do
		if minions~= nil and not minions.dead then
			if GetDistance(minions) < qRange and QREADY then
				CastSpell(_Q, minions.x, minions.z)
			end
		end
	end
end
function qKs()
if UltON == true then return end
	for i, target in ipairs(gEnemy) do
		local qDmg = getDmg("Q", target, myHero)
		if target ~= nil and ValidTarget(target) and not target.dead then
			if GetDistance(target) < qRange and QREADY then
				if target.health < qDmg then
					local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, false)
					if CastPosition and HitChance >= 2 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end
function wCombo(target)
if UltON == true then return end
		if ValidTarget(target) and not target.dead then
			if GetDistance(target) < wRange and WREADY then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, wDelay, wRadius, wRange, wSpeed, myHero)
				if CastPosition and HitChance >= 2 then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
			end
		end		
end
function wFarm()
if UltON == true then return end
	for i, minion in pairs(EnemyMinions.objects) do
		if minion~= nil and not minion.dead then
			if GetDistance(minion) < wRange and WREADY then
				CastSpell(_W, minion.x, minion.z)
			end
		end
	end
	for i, minions in pairs(JungleMinions.objects) do
		if minions~= nil and not minions.dead then
			if GetDistance(minions) < wRange and WREADY then
				CastSpell(_W, minions.x, minions.z)
			end
		end
	end
end
function eCombo(target)
if UltON == true then return end
		if GetDistance(target) < eRange and ValidTarget(target) and not target.dead then
			if EREADY then 
				CastSpell(_E, target)
			end
		end
	
end
function eHarass()
if UltON == true then return end
	for i, target in pairs(gEnemy) do
		if GetDistance(target) < eRange and ValidTarget(target) and not target.dead then
			if EREADY then 
				CastSpell(_E, target)
			end
		end
	end
end
function eFarm()
if UltON == true then return end
	for i, minion in ipairs(EnemyMinions.objects) do
		if ValidTarget(minion) and not minion.dead then
			if GetDistance(minion) < eRange then
				if minion.health < minion.maxHealth/2 and EREADY and not AlreadyE then
					CastSpell(_E, minion)
				end
			end
		end
	end
	for i, minions in ipairs(JungleMinions.objects) do
		if ValidTarget(minions) and not minions.dead then
			if GetDistance(minions) < eRange then
				if minions.health < minions.maxHealth/2 and EREADY and not AlreadyE then
					CastSpell(_E, minions)
				end
			end
		end
	end
end
function eKs()
	if UltON == true then return end
	for i, target in ipairs(gEnemy) do
		local eDmg = getDmg("E", target, myHero)
		if ValidTarget(target) and GetDistance(target) < eRange and not target.dead then
			if target.health < eDmg and EREADY then
				CastSpell(_E, target)
			end
		end
	end
end
function rCombo(target)
		if ValidTarget(target) and not target.dead then
			if GetDistance(target) < rRange and RREADY then
				if malzCFG.combo.rTarget[target.charName] then
					CastSpell(_R, target)
					UltON = true
					DelayAction(function() UltON = false end, 2.6)
				end
			end
		end
end
function rKs()
	if UltON == true then return end
	for i, target in ipairs(gEnemy) do
		local rDmg = getDmg("R", target, myHero)
		if ValidTarget(target) and not target.dead then
			if GetDistance(target) < rRange and RREADY and target.health < rDmg then
				CastSpell(_R, target)
			end
		end
	end
end
function rDangerousCC()
	if UltON == true then return end
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead then
			if GetDistance(target) < rRange and RREADY then
				if IsOnCC(target) == true then
					CastSpell(_R, target)
				end
			end
		end
	end
end
---------------------------------------
--		 Custom target arranger      --
---------------------------------------
TargetTable ={
				AP = {"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"},
				Support = {"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"},
				Tank = {"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear", "Warwick", "Yorick", "Zac", "Renekton"},
				AD_Carry = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Kalista", "Lucian", "MasterYi", "MissFortune", "Quinn", "Shaco", "Sivir", "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"},
				Bruiser = {"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy", "Pantheon", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"}
			 }	
function arrangeTarget()
		for i, enemy in ipairs(GetEnemyHeroes()) do
			SetPriority(TargetTable.AD_Carry, enemy, 1)
			SetPriority(TargetTable.AP, enemy, 1)
			SetPriority(TargetTable.Support, enemy, 2)
			SetPriority(TargetTable.Bruiser, enemy, 3)
			SetPriority(TargetTable.Tank, enemy, 4)
		end
end
function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
---------------------------------------
--			   Updater				 --
---------------------------------------
function updateScript()
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/MalzaharMadness.version", "/kqmii/BolScripts/master/MalzaharMadness.lua", 
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>MalzaharMadness : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>MalzaharMadness : </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
			end 
		end)
end
class "SxUpdate"
function SxUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath, SavePath, Callback)
    self.Callback = Callback
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = VersionPath
    self.ScriptPath = ScriptPath
    self.SavePath = SavePath
    self.LuaSocket = require("socket")
    AddTickCallback(function() self:GetOnlineVersion() end)
    DelayAction(function() self.UpdateDone = true end, 2)
end
function SxUpdate:GetOnlineVersion()
    if self.UpdateDone then return end
    if not self.OnlineVersion and not self.VersionSocket then
        self.VersionSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.VersionSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.VersionPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
    end

    if not self.OnlineVersion and self.VersionSocket then
        self.VersionSocket:settimeout(0, 'b')
        self.VersionSocket:settimeout(99999999, 't')
        self.VersionReceive, self.VersionStatus = self.VersionSocket:receive('*a')
    end

    if not self.OnlineVersion and self.VersionSocket and self.VersionStatus ~= 'timeout' then
        if self.VersionReceive then
            self.OnlineVersion = tonumber(string.sub(self.VersionReceive, string.find(self.VersionReceive, "<bols".."cript>")+11, string.find(self.VersionReceive, "</bols".."cript>")-1))
            if not self.OnlineVersion then print(self.VersionReceive) end
        else
            print('AutoUpdate Failed')
            self.OnlineVersion = 0
        end
        self:DownloadUpdate()
    end
end
function SxUpdate:DownloadUpdate()
    if self.OnlineVersion > self.LocalVersion then
        self.ScriptSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.ScriptPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
        self.ScriptReceive, self.ScriptStatus = self.ScriptSocket:receive('*a')
        self.ScriptRAW = string.sub(self.ScriptReceive, string.find(self.ScriptReceive, "<bols".."cript>")+11, string.find(self.ScriptReceive, "</bols".."cript>")-1)
        local ScriptFileOpen = io.open(self.SavePath, "w+")
        ScriptFileOpen:write(self.ScriptRAW)
        ScriptFileOpen:close()
    end

    if type(self.Callback) == 'function' then
        self.Callback(self.OnlineVersion)
    end

    self.UpdateDone = true
end
---------------------------------------
--			 ScriptStatus			 --
---------------------------------------
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBECGEDECDJ") 


















