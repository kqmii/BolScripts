----------------------------
--	NamiMadness by Kqmii  --
----------------------------
if myHero.charName ~= "Nami" then return end

local currentVersion = 1.41

require 'VPrediction'
require 'SxOrbwalk'

local ts
local qDelay, qWidth, qRange, qSpeed = 0.875, 160, 875, math.huge
local wRange = 725
local eRange = 800
local rDelay, rWidth, rRange, rSpeed = 0.5, 180, 2200, math.huge
local namiAA = 675
local Color1, Color2, Color3, Color4 = ARGB(255, 0, 0, 255), ARGB(255, 0, 51, 255), ARGB(255, 0, 122, 255), ARGB(255, 0, 255, 0)
local gEnemy = GetEnemyHeroes()
local gAlly = GetAllyHeroes()
local bounce = 500
local EnemyADdamage = 0
local AllyADdamage = 0
local stunList = {
["ahriseducedoom"] = true,
["caitlynyordletrapdebuff"] = true,
["aatroxqknockup"] = true,
["rupturetarget"] = true,
["EliseHumanE"] = true,
["HowlingGaleSpell"] = true,
["jarvanivdragonstrikeph2"] = true,
["braumstundebuff"] = true,
["karmaspiritbindroot"] = true, 
["LuxLightBindingMis"] = true,
["lissandrawfrozen"] = true,
["maokaiunstablegrowthroot"] = true,
["DarkBindingMissile"] = true,
["nautilusanchordragroot"] = true,
["RunePrison"] = true,
["Taunt"] = true,
["Stun"] = true,
["swainshadowgrasproot"] = true,
["threshqfakeknockup"] = true,
["velkozestun"] = true,
["virdunkstun"] = true,
["viktorgravitonfieldstun"] = true,
["supression"] = true,
["yasuoq3mis"] = true,
["zyragraspingrootshold"] = true,
["CurseoftheSadMummy"] = true,
["braumpulselineknockup"] = true,
["lissandraenemy2"] = true,
["sejuaniglacialprison"] = true,
["SonaR"] = true,
["zyrabramblezoneknockup"] = true,
["infiniteduresssound"] = true,
["chronorevive"] = true,
["katarinarsound"] = true,
["AbsoluteZero"] = true,
["Meditate"] = true,
["pantheonesound"] = true,
["zhonyasringshield"] = true,
["fearmonger_marker"] = true,
["AlZaharNetherGrasp"] = true,
["missfortunebulletsound"] = true, 
["VelkozR"] = true, 
["monkeykingspinknockup"] = true,
["unstoppableforceestun"] = true,
["lissandrarself"] = true,
}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	PrintChat ("<font color=\"#33CC99\"><b>NamiMadness by Kqmii</b></font>"..currentVersion.."<font color=\"#33CC99\"><b>Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	Menu()
	
		_G.oldDrawCircle = rawget(_G, 'DrawCircle')
		_G.DrawCircle = DrawCircle2
		
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
end
function OnTick()
	ts:update()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	if namiCFG.combo.comboKey then
		Combo()
	end
	if namiCFG.combo.qConfig.autoQ then
		qAuto()
	end
	if namiCFG.harass.harassKey then
		Harass()
	end
	if namiCFG.aHeal.healKey then
		AutoHeal()
	end
	if namiCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
function OnDraw()
	if QREADY and namiCFG.draw.qDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, Color1)
	end
	if WREADY and namiCFG.draw.wDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, wRange, Color2)
	end
	if EREADY and namiCFG.draw.wDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, eRange, Color3)
	end
	if namiCFG.draw.AArange then
		DrawCircle(myHero.x, myHero.y, myHero.z, namiAA, Color4)
	end
	if namiCFG.draw.tCurrent and ValidTarget(ts.target) then
		DrawCircle(ts.target.x, ts.target.y, ts.target.z, 130, Color1)
		DrawCircle(ts.target.x, ts.target.y, ts.target.z, 135, Color2)
		DrawCircle(ts.target.x, ts.target.y, ts.target.z, 140, Color3)
	elseif ValidTarget(targetSelected) then
		DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 130, Color1)
		DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 135, Color2)
		DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 140, Color3)
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
    DrawCircleNextLvl(x, y, z, radius, namiCFG.draw.Width, color, namiCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	VP = VPrediction()
	SxOrb = SxOrbWalk()
	ts = TargetSelector(TARGET_MOST_AD, 1200, DAMAGE_MAGIC)
	namiCFG = scriptConfig("NamiMadness", "NKQ")
		
		namiCFG:addSubMenu(myHero.charName.." - Combo", "combo")
			namiCFG.combo:addSubMenu("Q Spell Config", "qConfig")
				namiCFG.combo.qConfig:addParam("qUse", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
				namiCFG.combo.qConfig:addParam("autoQ", "Auto Q target on CC", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
			namiCFG.combo:addSubMenu("W Spell Config", "wConfig")
				namiCFG.combo.wConfig:addParam("wUse", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
			namiCFG.combo:addSubMenu("E Spell Config", "eConfig")
				namiCFG.combo.eConfig:addParam("eUse", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
			namiCFG.combo:addSubMenu("R Spell Config", "rConfig")
				namiCFG.combo.rConfig:addParam("rUse", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
				namiCFG.combo.rConfig:addParam("mnRange", "Range to ultimate", SCRIPT_PARAM_SLICE, 1000, 0, 2550, 0)
				namiCFG.combo.rConfig:addParam("rEnemy", "R if x Enemy in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
			namiCFG.combo:addParam("comboKey", "Combo key = ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
			
		namiCFG:addSubMenu(myHero.charName.." - Harass", "harass")
			namiCFG.harass:addParam("qHarass", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
			namiCFG.harass:addParam("wHarass", "Harass with W", SCRIPT_PARAM_ONOFF, true)
			namiCFG.harass:addParam("stopHarass", "Stop harass at % mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			namiCFG.harass:addParam("harassKey", "Harass toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
		
		namiCFG:addSubMenu(myHero.charName.." - Auto heal", "aHeal")
			namiCFG.aHeal:addParam("allyHeal", "Auto Heal ally", SCRIPT_PARAM_ONOFF, false)
			namiCFG.aHeal:addParam("allyPercent", "Ally % life", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			namiCFG.aHeal:addParam("selfHeal", "Auto Self heal", SCRIPT_PARAM_ONOFF, false)
			namiCFG.aHeal:addParam("selfPercent", "Self % life", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			namiCFG.aHeal:addParam("stopHeal", "Stop auto heal at % mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			namiCFG.aHeal:addParam("healKey", "Auto heal toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("H"))
		
		namiCFG:addSubMenu(myHero.charName.." - Drawings", "draw")
			namiCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
			namiCFG.draw:addParam("wDraw", "Draw W range", SCRIPT_PARAM_ONOFF, true)
			namiCFG.draw:addParam("eDraw", "Draw E range", SCRIPT_PARAM_ONOFF, true)
			namiCFG.draw:addParam("tCurrent", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
			namiCFG.draw:addParam("AArange", "Draw AA range", SCRIPT_PARAM_ONOFF, true)
			namiCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			namiCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			namiCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
		
		namiCFG:addSubMenu(myHero.charName.." - Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(namiCFG.SxOrb)
			
		namiCFG:addTS(ts)
			ts.name = "Nami - "

	namiCFG.combo:permaShow("comboKey")
	namiCFG.combo.qConfig:permaShow("autoQ")
	namiCFG.aHeal:permaShow("healKey")
	namiCFG.harass:permaShow("harassKey")
		
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
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
		then return true
	else
		return false
	end
end
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
function EnemyNear(range, unit)
    local Enemies = 0
    for _, enemy in ipairs(gEnemy) do
        if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
end
function AllyNear(range, unit)
    local Allies = 0
    for _, ally in ipairs(gAlly) do
        if ValidTarget(ally) and GetDistance(ally, unit) < (range or math.huge) then
            Allies = Allies + 1
        end
    end
    return Allies
end
function Combo()
	if namiCFG.combo.qConfig.qUse then
		qSpell()
	end
	if namiCFG.combo.wConfig.wUse then
		wSpell()
	end
	if namiCFG.combo.eConfig.eUse then
		eSpell()
	end
	if namiCFG.combo.rConfig.rUse then
		rSpell()
	end
end
function Harass()
	if not ManaCheck(myHero, namiCFG.harass.stopHarass) then
		if namiCFG.harass.qHarass then
			qHarass()
		end
		if namiCFG.harass.wHarass then
			wHarass()
		end
	end
end
function AutoHeal()
	if not ManaCheck(myHero, namiCFG.aHeal.stopHeal) then
		if namiCFG.aHeal.allyHeal then
			for i, ally in pairs(gAlly) do
				if GetDistance(ally) < wRange and WREADY and not ally.dead then
					if HpCheck(ally, namiCFG.aHeal.allyPercent) then
						CastSpell(_W, ally)
					end
				end
			end
		end
		if namiCFG.aHeal.selfHeal then
			if WREADY and HpCheck(myHero, namiCFG.aHeal.selfPercent) then
				CastSpell(_W, myHero)
			end
		end
	end
end
function OnWndMsg(msg, key)
	if msg == WM_LBUTTONDOWN then
		local enemyDistance, enemySelected = 0, nil
		for i, enemy in pairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and GetDistance(enemy, mousePos) < 200 then 
				if GetDistance(enemy, mousePos) <= enemyDistance or not enemySelected then
					enemyDistance = GetDistance(enemy, mousePos)
					enemySelected = enemy
				end
			end
		end
		if enemySelected then
			if not targetSelected or targetSelected.hash ~= enemySelected.hash then
				targetSelected = enemySelected
				print('Target selected: '..targetSelected.charName)
			else
				targetSelected = nil
				print('Target unselected!')
			end
		end
		
	end
end
---------------------------------------
--			Spells config            --
---------------------------------------
function qSpell()
	for i, target in ipairs(gEnemy) do
		if target.totalDamage > EnemyADdamage and GetDistance(myHero, target) < 900 then
			eADC = target
			EnemyADdamage = target.totalDamage
		end
		if ValidTarget(target) and not target.dead and QREADY then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, false)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < qRange then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end
function qAuto()
	for i, target in ipairs(gEnemy) do
		if ValidTarget(target) and not target.dead and QREADY and IsOnCC(target) == true then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, false)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < qRange then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end
function qHarass()
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead and QREADY then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, false)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < qRange then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end
function wSpell()
	for t, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead and WREADY then
			if GetDistance(myHero, target) < wRange then
				CastSpell(_W, target)
			end
		end
	end
end
function wHarass()
	for i, target in ipairs(gEnemy) do
		if ValidTarget(target) and not target.dead and WREADY then
			if GetDistance(target) < wRange then
				CastSpell(_W, target)
			end
		end
	end
end
function eSpell()
	for i, target in ipairs(gEnemy) do
		for i, ally in pairs(gAlly) do
			if ally.totalDamage > AllyADdamage and GetDistance(myHero, ally) < 900 then
				aADC = ally
				AllyADdamage = target.totalDamage
			end
			if ValidTarget(target) and ValidTarget(ally) and not target.dead or not ally.dead and EREADY then
				if aADC ~= nil and GetDistance(aADC) < eRange and EnemyNear(1000, aADC) > 0then
					CastSpell(_E, aADC)
				end
				if EnemyNear(1000, myHero) > 0 then
					CastSpell(_E, myHero)
				end
			end
		end
	end
end
function rSpell()
	for i, target in ipairs(gEnemy) do
		for i, ally in pairs(gAlly) do
			if ValidTarget(target) and not target.dead then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, rDelay, rWidth, namiCFG.combo.rConfig.mnRange, rSpeed, myHero)
				if MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < 1900 and nTargets >= namiCFG.combo.rConfig.rEnemy and RREADY then
					CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
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
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/NamiMadness.version", "/kqmii/BolScripts/master/NamiMadness.lua", SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBECGDACBFD") 
