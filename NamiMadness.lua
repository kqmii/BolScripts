--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
--	   NamiMadness by Kqmii      --
--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
if myHero.charName ~= "Nami" then return end

local currentVersion = 1.36

require 'VPrediction'
require "SxOrbwalk"
local ts
local qDelay, qRadius, qRange, qSpeed = 0.40, 200, 875, math.huge
local wRange = 725
local eRange = 800
local rDelay, rRadius, rRange, rSpeed = 0.5, 210, 2550, 1200
local tRange = 900
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
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	PrintChat ("<font color=\"#33CC99\"><b>NamiMadness by Kqmii</b></font>"..currentVersion.."<font color=\"#33CC99\"><b>Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	
	Menu()
	updateScript()
	
			if not FileExist(LIB_PATH.."VPrediction.lua") then
			LuaSocket = require("socket")
			ScriptSocket = LuaSocket.connect("sx-bol.eu", 80)
			ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script=raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
			ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')
			ScriptRaw = string.sub(ScriptReceive, string.find(ScriptReceive, "<bols".."cript>")+11, string.find(ScriptReceive, "</bols".."cript>")-1)
			ScriptFileOpen = io.open(LIB_PATH.."VPrediction.lua", "w+")
			ScriptFileOpen:write(ScriptRaw)
			ScriptFileOpen:close()
	        end
			if not FileExist(LIB_PATH.."SxOrbWalk.lua") then
			LuaSocket = require("socket")
			ScriptSocket = LuaSocket.connect("sx-bol.eu", 80)
			ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script=raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
			ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')
			ScriptRaw = string.sub(ScriptReceive, string.find(ScriptReceive, "<bols".."cript>")+11, string.find(ScriptReceive, "</bols".."cript>")-1)
			ScriptFileOpen = io.open(LIB_PATH.."SxOrbWalk.lua", "w+")
			ScriptFileOpen:write(ScriptRaw)
			ScriptFileOpen:close()
	        end

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
	
	if NamiCFG.Harass.HarassKey then
		MoveToMouse()
		HarassQ()
	end
	
	if NamiCFG.Combo.comboKey then
		Combo()
	end
	
	if NamiCFG.healManager.healNami then
		AutoHealSelf()
	end
	
	if NamiCFG.healManager.healAllies then
		AutoHealAllies()
	end
					
	if NamiCFG.Combo.autoQ then
		autoQ()
	end
	
	if NamiCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if NamiCFG.draw.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(255, 0, 0, 255))
		end
		if NamiCFG.draw.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(255, 0, 51, 255))
		end
		if NamiCFG.draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255, 0, 102, 255))
		end
		if NamiCFG.draw.rangeDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, 675, ARGB(255, 0, 255, 0))
		end
		if ValidTarget(targetSelected) then
				DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 150, ARGB(255, 102, 204, 51))
				DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 175, ARGB(255, 102, 204, 51))
		else if ValidTarget(ts.target) then
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 150, ARGB(255, 102, 204, 51))
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 175, ARGB(255, 102, 204, 51))
			end
		end
		if NamiCFG.draw.tDraw then
			for i, tower in pairs(GetTurrets()) do
				if GetDistance(tower) < 2000 then
					DrawCircle(tower.x, tower.y, tower.z, tRange, ARGB(190,0,255,0))
				end
			end
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
    DrawCircleNextLvl(x, y, z, radius, NamiCFG.draw.Width, color, NamiCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST, 1200)
	VP = VPrediction()
	SxOrb = SxOrbWalk()
	NamiCFG = scriptConfig("NamiMadness", "NMK")
		
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Heal Manager", "healManager")
			NamiCFG.healManager:addParam("healNami", "Auto-Heal Yourself", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.healManager:addParam("selfPercent", "Heal at what life %", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
			NamiCFG.healManager:addParam("healAllies", "Auto-Heal Allies", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.healManager:addParam("allyPercent", "Heal allies at what life %", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Combo", "Combo")
			NamiCFG.Combo:addParam("qUse", "Use Q", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Combo:addParam("autoQ", "Auto use Q on CC'ed Champ", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Combo:addParam("wUse", "Use W", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Combo:addParam("eUse", "Use E", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Combo:addParam("rUse", "Use R", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Combo:addSubMenu("Ultimate Configuration", "ultConf")
				NamiCFG.Combo.ultConf:addParam("mnRange", "Range to ultimate", SCRIPT_PARAM_SLICE, 1000, 0, 2550, 0)
				NamiCFG.Combo.ultConf:addParam("mnChar", "Minimum enemies to ultimate", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
			NamiCFG.Combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Harass", "Harass")
			NamiCFG.Harass:addParam("qHarass", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.Harass:addParam("HarassKey", "Harass key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))			
		
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
			NamiCFG.draw:addParam("qDraw", "Q range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("wDraw", "W range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("eDraw", "E range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("tDraw", "Towers range", SCRIPT_PARAM_ONOFF, false)
			NamiCFG.draw:addParam("rangeDraw", "Auto attack range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			NamiCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			NamiCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
				
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(NamiCFG.SxOrb)
end
function Combo()
	if NamiCFG.Combo.comboKey then
		UseR()
		UseE()
		UseQ()
		UseW()
	end
end
function AutoHealAllies()
	if NamiCFG.healManager.healAllies then
	local allies = GetAllyHeroes() 
		for i, ally in pairs(allies) do
			if not ally.dead then
				if GetDistance(ally) < wRange and HpCheck(ally, NamiCFG.healManager.allyPercent) and WREADY then
					CastSpell(_W, ally)
				end
			end
		end
	end
end
function AutoHealSelf()
	if WREADY and NamiCFG.healManager.healNami and HpCheck(myHero, NamiCFG.healManager.selfPercent) then
		CastSpell(_W, myHero)
	end
end
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
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
---------------------------------------
--			Spells config            --
---------------------------------------
function UseQ()
	if NamiCFG.Combo.qUse then
		for i, target in pairs(GetEnemyHeroes()) do
			if ts.target ~= nil then
				if QREADY then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, qDelay, qRadius, qRange, qSpeed)
						if HitChance >=3 and GetDistance(CastPosition) < qRange then
							CastSpell(_Q, CastPosition.x, CastPosition.z)
						end
				end
			end
		end
	end
end
function autoQ()
	for i, target in pairs(GetEnemyHeroes()) do
		if target ~= nil and QREADY then
			if IsOnCC(target) == true then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, qDelay, qRadius, qRange, qSpeed)
					if HitChance >=2 and GetDistance(CastPosition) < qRange then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	
end

local ADdamage = 0
function UseW()
	if NamiCFG.Combo.wUse then
		if ts.target ~= nil and WREADY then
			CastSpell(_W, ts.target)
		end
	end
end
function UseE()
	if NamiCFG.Combo.eUse then
		-- ADC finder if find use E on him
		for i, ally in pairs(GetAllyHeroes()) do
			if not ally.dead then
				if ally.totalDamage > ADdamage and GetDistance(myHero, ally) < eRange and EREADY then
					ADC = ally
					ADdamage = ally.totalDamage
				end
			end
		end
		if EREADY and ADC ~= nil and GetDistance(myHero, ally) < eRange then
			CastSpell(_E, ADC)
		end
		if EREADY and ValidTarget(ts.target) then
			CastSpell(_E, myHero)
		end
		--if no adc use it on me
			-- if ts.target ~= nil and ValidTarget(ts.target, eRange) and EREADY then
				-- CastSpell(_E, myHero)
			-- end
		
	end
end
function UseR()
	for i, target in pairs(GetEnemyHeroes()) do
		if target ~= nil and ValidTarget(ts.target) then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(ts.target, rDelay, rRadius, NamiCFG.Combo.mnRange, rSpeed, myHero)
			if MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < NamiCFG.Combo.ultConf.mnRange and nTargets >= NamiCFG.Combo.ultConf.mnChar and RREADY then
			CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
			end
		end
	end
end
function HarassQ()
	if NamiCFG.Harass.qHarass then
		for i, target in pairs(GetEnemyHeroes()) do
			if ts.target ~= nil then
				if QREADY then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, qDelay, qRadius, qRange, qSpeed)
						if HitChance >=3 and GetDistance(CastPosition) < qRange then
							CastSpell(_Q, CastPosition.x, CastPosition.z)
						end
				end
			end
		end
	end
end
function MoveToMouse()
	if NamiCFG.Harass.HarassKey then
		myHero:MoveTo(mousePos.x, mousePos.z)
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
--			 ScriptStatus			 --
---------------------------------------
