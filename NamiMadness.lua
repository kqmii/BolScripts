--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
--	   NamiMadness by Kqmii      --
--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
if myHero.charName ~= "Nami" then return end

local currentVersion = 1.7

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
["lissandrarself"] = true
}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	Vars()
	updateScript()
	PrintChat ("<font color=\"#33CC99\"><b>NamiMadness by Kqmii</b></font>"..currentVersion.."<font color=\"#33CC99\"><b>Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	DetectOrbwalker()
	Menu()
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
end
function OnTick()
	Checks()
	ts:update()
	target = CustomTarget()
	if namiCfg.combo.comboKey then
		Combo(target)
	end
	if namiCfg.harass.harassKey then
		Harass(target)
	end
	if namiCfg.aHeal.healKey then
		AutoHeal()
	end
	if namiCfg.combo.qConfig.qAuto then
		autoQ()
	end
	if namiCfg.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if namiCfg.draw.qDraw and QSpell.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, QSpell.range, ARGB(255,0,0,255))
		end
		if namiCfg.draw.wDraw and WSpell.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, WSpell.range, ARGB(255,0,0,255))
		end
		if namiCfg.draw.eDraw and ESpell.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, ESpell.range, ARGB(255,0,0,255))
		end
		if namiCfg.draw.rDraw and RSpell.ready then
			DrawCircle(myHero.x, myHero.y, myHero.z, namiCfg.combo.rConfig.mnRange, ARGB(255,0,0,255))
		end
		if ValidTarget(ts.target) and not ts.target.dead and GetDistance(ts.target) <= 1000 then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 90, 0xF0FFFF)
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 100, 0xF0FFFF)
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 110, 0xF0FFFF)
		elseif ValidTarget(SelectedTarget) and not SelectedTarget.dead then
			DrawCircle(SelectedTarget.x, SelectedTarget.y, SelectedTarget.z, 90, 0xF0FFFF)
			DrawCircle(SelectedTarget.x, SelectedTarget.y, SelectedTarget.z, 100, 0xF0FFFF)
			DrawCircle(SelectedTarget.x, SelectedTarget.y, SelectedTarget.z, 110, 0xF0FFFF)
		end
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
    DrawCircleNextLvl(x, y, z, radius, namiCfg.draw.Width, color, namiCfg.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000)
	VP = VPrediction()
	SxOrb = SxOrbWalk(VP)
	namiCfg = scriptConfig("NamiMadness", "NMK")
	
		namiCfg:addSubMenu(myHero.charName.." - Combo", "combo")
			namiCfg.combo:addSubMenu("Q Config", "qConfig")
				namiCfg.combo.qConfig:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
				namiCfg.combo.qConfig:addParam("qAuto", "Auto Q on CC'ed Champ", SCRIPT_PARAM_ONOFF, true)
			namiCfg.combo:addSubMenu("W Config", "wConfig")
				namiCfg.combo.wConfig:addParam("wUse", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
			namiCfg.combo:addSubMenu("E Config", "eConfig")
				namiCfg.combo.eConfig:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			namiCfg.combo:addSubMenu("R Config", "rConfig")
				namiCfg.combo.rConfig:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
				namiCfg.combo.rConfig:addParam("mnRange", "Max range to ultimate", SCRIPT_PARAM_SLICE, 1600, 0, 2500, 0)
				namiCfg.combo.rConfig:addParam("mnChamp", "Min enemies in R range", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
			namiCfg.combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		
		namiCfg:addSubMenu(myHero.charName.." - Harass", "harass")
			namiCfg.harass:addParam("qHarass", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
			namiCfg.harass:addParam("wHarass", "Harass with W", SCRIPT_PARAM_ONOFF, true)
			namiCfg.harass:addParam("manaHarass", "Min. mana to harass", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			namiCfg.harass:addParam("harassKey", "Harass toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
		
		namiCfg:addSubMenu(myHero.charName.." - Auto Heal", "aHeal")
			namiCfg.aHeal:addSubMenu("Auto heal ally settings", "allyHeal")
				namiCfg.aHeal.allyHeal:addParam("aUse", "Auto Heal ally", SCRIPT_PARAM_ONOFF, true)
				namiCfg.aHeal.allyHeal:addParam("aHpLeft", "Ally Hp left", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			namiCfg.aHeal:addSubMenu("Auto heal self settings", "selfHeal")
				namiCfg.aHeal.selfHeal:addParam("sUse", "Auto Heal self", SCRIPT_PARAM_ONOFF, true)
				namiCfg.aHeal.selfHeal:addParam("sHpLeft", "Self Hp left", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			namiCfg.aHeal:addParam("manaHeal", "Min. mana to auto heal", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			namiCfg.aHeal:addParam("healKey", "Auto heal toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
		
		namiCfg:addSubMenu(myHero.charName.." - Drawings", "draw")
			namiCfg.draw:addParam("qDraw", "Q Range", SCRIPT_PARAM_ONOFF, true)
			namiCfg.draw:addParam("wDraw", "W Range", SCRIPT_PARAM_ONOFF, true)
			namiCfg.draw:addParam("eDraw", "E Range", SCRIPT_PARAM_ONOFF, true)
			namiCfg.draw:addParam("rDraw", "R Range", SCRIPT_PARAM_ONOFF, true)
			namiCfg.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			namiCfg.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			namiCfg.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
		namiCfg:addTS(ts)
			ts.name = "Nami -"
		
		if SACLoaded then
			namiCfg:addParam("qqq", "- SAC Detected -", SCRIPT_PARAM_INFO, "")
		elseif MMALoaded then
			namiCfg:addParam("qqq", "- MMA Detected -", SCRIPT_PARAM_INFO, "")
		else
			namiCfg:addSubMenu(myHero.charName.." - Orbwalker", "SxOrb")
				SxOrb:LoadToMenu(namiCfg.SxOrb)
		end
		
		namiCfg.combo:permaShow("comboKey")
		namiCfg.harass:permaShow("harassKey")
		namiCfg.aHeal:permaShow("healKey")
end
function Vars()
	QSpell = { name = "Aqua Prison", range = 875, delay = 0.50, speed = 1600, radius = 165, ready = false }
	WSpell = { name = "Ebb and Flow", range = 725, delay = nil, speed = nil, radius = nil, ready = false }
	ESpell = { name = "Tidecaller's Blessing", range = 800, delay = nil, speed = nil, radius = nil, ready = false }
	RSpell = { name = "Tidal Wave", range = 2500, delay = 0.2, speed = 800, radius = 400, ready = false }
	
	local SACLoaded, MMALoaded = nil, nil
	local ts
	local target = nil
	
	require 'SxOrbwalk'
	require 'VPrediction'
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end
function Checks()
	QSpell.ready = (myHero:CanUseSpell(_Q) == READY)
	WSpell.ready = (myHero:CanUseSpell(_W) == READY)
	ESpell.ready = (myHero:CanUseSpell(_E) == READY)
	RSpell.ready = (myHero:CanUseSpell(_R) == READY)
end
function DetectOrbwalker()
	if _G.MMA_LOADED then
		PrintChat("NamiMadness : MMA Detected")
		MMALoaded = true
	elseif _G.Reborn_Loaded then
		PrintChat("NamiMadness : SAC Detected")
		SACLoaded = true
	else
		PrintChat("NamiMadness : SxOrb Loaded")
		Sxo = true
	end	
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
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
end
function Recalling()
  for i = 1, myHero.buffCount do
    local recallBuff = myHero:getBuff(i)
    if recallBuff.valid and recallBuff.name:lower():find('recall') then
      return true
    end	
  end
  return false
end
function Combo(target)
	if namiCfg.combo.qConfig.qUse then
		if TargetHaveBuff("namieslow") then
			qSpell(target)
		else
			qSpell(target)
		end
	end
	if namiCfg.combo.wConfig.wUse then
		wSpell(target)
	end
	if namiCfg.combo.eConfig.eUse then
		eSpell(target)
	end
	if namiCfg.combo.rConfig.rUse then
		rSpell(target)
	end
end
function Harass(target)
	if not ManaCheck(myHero, namiCfg.harass.manaHarass) then
		if namiCfg.harass.qHarass then
			qSpell(target)
		end
		if namiCfg.harass.wHarass then
			wSpell(target)
		end
	end
end
function AutoHeal()
	if Recalling() then return end
	if not ManaCheck(myHero, namiCfg.aHeal.manaHeal) then
		for i, ally in pairs(GetAllyHeroes()) do
			if namiCfg.aHeal.allyHeal.aUse then
				if not ally.dead then
					if HpCheck(ally, namiCfg.aHeal.allyHeal.aHpLeft) and GetDistance(ally) < WSpell.range and WSpell.ready then
						CastSpell(_W, ally)
					end
				end
			end
		end
		if namiCfg.aHeal.selfHeal.sUse then
			if not myHero.dead and WSpell.ready and HpCheck(myHero, namiCfg.aHeal.selfHeal.sHpLeft) then
				CastSpell(_W, myHero)
			end
		end
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
function CustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1100) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	if ts.target and not ts.target.dead and ts.target.type == myHero.type then
		return ts.target
	else
		return nil
	end
end
function OnWndMsg(msg, key)
	if msg == WM_LBUTTONDOWN then
		local minD = 0
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and not unit.dead then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
				end
			end
		end
		if target and minD < 100 then
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = target
			end
		end
	end
end
---------------------------------------
--			Spells config            --
---------------------------------------
function qSpell(target)
	if target ~= nil and ValidTarget(target) and not target.dead and target.visible then
		if QSpell.ready then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, QSpell.delay, QSpell.radius, QSpell.range, QSpell.speed, myHero, false)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) <= QSpell.range then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end
function wSpell(target)
	if target ~= nil and target.visible and ValidTarget(target) and not target.dead then
		if WSpell.ready then
			CastSpell(_W, target)
		end
	end
end
function eSpell(target)
	local ADdamage = 0
	for i, ally in pairs(GetAllyHeroes()) do
		if ally ~= nil and ally.visible and not ally.dead and ESpell.ready then
			if ally.totalDamage > ADdamage and GetDistance(ally) < ESpell.range then
				ADC = ally
				ADdamage = ally.totalDamage
			end
		end
	end
	if ESpell.ready and ADC ~= nil and GetDistance(ADC) < ESpell.range and EnemyNear(700, ADC) and not ADC.dead then
		CastSpell(_E, ADC)
	elseif ESpell.ready and EnemyNear(700, myHero) then
		CastSpell(_E, myHero)
	end
end
function rSpell(target)
	if target ~= nil and ValidTarget(target) and not target.dead then
		local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, RSpell.delay, RSpell.radius, namiCfg.combo.rConfig.mnRange, RSpell.speed, myHero)
		if AOECastPosition ~= nil and MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < namiCfg.combo.rConfig.mnRange and nTargets >= namiCfg.combo.rConfig.mnChamp and RSpell.ready then
			CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
		end
	end
end
--
function autoQ()
	for i, unit in ipairs(GetEnemyHeroes()) do
		if unit ~= nil and unit.visible and not unit.dead and GetDistance(unit) < QSpell.range then
			if IsOnCC(unit) == true then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(unit, QSpell.delay, QSpell.radius, QSpell.range, QSpell.speed, myHero, false)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) <= QSpell.range then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
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
