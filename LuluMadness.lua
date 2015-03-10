--------------------------------------
--	Open Beta LuluMadness by Kqmii	--
--------------------------------------
if myHero.charName ~= "Lulu" then return end
require 'VPrediction'
require 'SxOrbwalk'

local currentVersion = 1

local qDelay, qWidth, qRange, qSpeed = 0.2, 50, 900, 1600
local eRange, eDelay = 650, 0.2
local wRange, wDelay = 650, 0.2
local rRange, rDelay, rRadius = 900, 0.2, 200
local qExtended = 1550
local Color = ARGB(255,0,255,0)
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
}
---------------------------------------
--			   Updater				 --
---------------------------------------
function updateScript()
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/LuluMadness.version", "/kqmii/BolScripts/master/LuluMadness.lua", 
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>LuluMadness : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>LuluMadness : </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
	PrintChat("<font color=\"#33CC99\"><b>LuluMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat("<b>Report any problem by pm to kqmii on bol</b>")

	minionAlly = minionManager(MINION_ALLY, 925, ally, MINION_SORT_HEALTH_ASC)
	minionEnemy = minionManager(MINION_ENEMY, 1100, myHero, MINION_SORT_HEALTH_ASC)
	Menu()
	updateScript()
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end
function OnTick()
	ts:update()
	minionAlly:update()
	minionEnemy:update()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	if luluCFG.combo.comboKey then
		Combo()
			if luluCFG.combo.wConfig.wUse then
				UseW()
			end
	end
	if luluCFG.combo.eConfig.autoE then
		autoE()
	end
	if luluCFG.harass.qeHarass then
			UseQ()
	end
	if luluCFG.combo.rConfig.autoUlt then
		autoR()
	end
	if luluCFG.combo.wConfig.autoW then
		AutoW()
	end
	if luluCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if QREADY or RREADY and luluCFG.draw.qDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, Color)
	end
	if EREADY or WREADY and luluCFG.draw.eDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, eRange, Color)
	end
	if ValidTarget(targetSelected) then
		DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 150, ARGB(255, 102, 204, 51))
		DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 175, ARGB(255, 102, 204, 51))
	else if ValidTarget(ts.target) then
		DrawCircle(ts.target.x, ts.target.y, ts.target.z, 150, ARGB(255, 102, 204, 51))
		DrawCircle(ts.target.x, ts.target.y, ts.target.z, 175, ARGB(255, 102, 204, 51))
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
    DrawCircleNextLvl(x, y, z, radius, luluCFG.draw.Width, color, luluCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST, 1000)
	VP = VPrediction()
	SxOrb = SxOrbWalk(VP)
	luluCFG = scriptConfig("LuluMadness", "LKQ")
	
		luluCFG:addSubMenu("--["..myHero.charName.."]-- Combo", "combo")
			luluCFG.combo:addSubMenu("Q Spell config", "qConfig")
				luluCFG.combo.qConfig:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			luluCFG.combo:addSubMenu("W Spell config", "wConfig")
				luluCFG.combo.wConfig:addParam("wUse", "W in combo", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("W"))
				luluCFG.combo.wConfig:addParam("autoW", "Auto W CC'ed Champ", SCRIPT_PARAM_ONOFF, true) 
			luluCFG.combo:addSubMenu("E Spell config", "eConfig")
				luluCFG.combo.eConfig:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
				luluCFG.combo.eConfig:addParam("qExtendedE", "Q-E Combo", SCRIPT_PARAM_ONOFF, true)
				luluCFG.combo.eConfig:addParam("autoE", "Auto E low hp", SCRIPT_PARAM_ONOFF, false)
				luluCFG.combo.eConfig:addParam("hpPercent", "% hp for auto E", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			luluCFG.combo:addSubMenu("R Spell config", "rConfig")
				luluCFG.combo.rConfig:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
				for i ,ally in pairs (GetAllyHeroes()) do
					luluCFG.combo.rConfig:addParam(ally.charName, ally.charName, SCRIPT_PARAM_ONOFF, true)
				end
				luluCFG.combo.rConfig:addParam("EnemyNo", "Min enemy in range", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
				luluCFG.combo.rConfig:addParam("autoUlt", "Auto Ult ally/self low hp", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
				luluCFG.combo.rConfig:addParam("hpPercent", "% hp left", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			luluCFG.combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		
			luluCFG:addSubMenu("--["..myHero.charName.."]-- Harass", "harass")
				luluCFG.harass:addParam("qHarass", "Harass with Q", SCRIPT_PARAM_ONOFF, false)
				luluCFG.harass:addParam("qeHarass", "Harass with Q-E", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
				
			luluCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
				luluCFG.draw:addParam("qDraw", "Draw Q-R range", SCRIPT_PARAM_ONOFF, true)
				luluCFG.draw:addParam("eDraw", "Draw E-W range", SCRIPT_PARAM_ONOFF, true)
				luluCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
				luluCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
				luluCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
			
			luluCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalker", "SxOrb")
				SxOrb:LoadToMenu(luluCFG.SxOrb)
			
			luluCFG:addTS(ts)
				ts.name = "--["..myHero.charName.."]-- Lulu"
		
			luluCFG.combo.wConfig:permaShow("wUse")
			luluCFG.combo.rConfig:permaShow("autoUlt")
			luluCFG.combo:permaShow("comboKey")
			luluCFG.harass:permaShow("qeHarass")
end
function Combo()
	if luluCFG.combo.qConfig.qUse or luluCFG.combo.eConfig.qExtendedE then
		UseQ()
	end
	if luluCFG.combo.eConfig.eUse then	
		UseEcombo()
	end
	if luluCFG.combo.rConfig.rUse then
		UseR()
	end
end
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
		then return true
	else
		return false
	end
end
function MoveToMouse()
		myHero:MoveTo(mousePos.x, mousePos.z)
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
function UseQ()
	for i, target in pairs (GetEnemyHeroes()) do
		if luluCFG.combo.qConfig.qUse or luluCFG.harass.qHarass then
			if not target.dead and QREADY and ValidTarget(target) then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, false)
				if CastPosition and HitChance >= 2 and GetDistance(target, myHero) < qRange then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
		if luluCFG.combo.eConfig.qExtendedE or luluCFG.harass.qeHarass then
			if not target.dead and EREADY and QREADY and ValidTarget(target) then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, qDelay, qWidth, qExtended, qSpeed, myHero, false)
					if CastPosition and HitChance >= 2 and GetDistance(target, myHero) > 200 then
						UseE()
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
			end
		end
	end
end
function UseE()
	for e, target in pairs(GetEnemyHeroes()) do
		for m, minion in pairs(minionEnemy.objects) do
			if not minion.dead then
				if GetDistance(minion, myHero) < eRange and GetDistance(target, minion) < 600 and GetDistance(target, myHero) > eRange and EREADY then
					CastSpell(_E, minion)
				end
			end
		end
		for i, minions in ipairs(minionAlly.objects) do
			if not minions.dead then
				if GetDistance(minions, myHero) < eRange and GetDistance(target, minions) < 600 and GetDistance(target, myHero) > eRange and EREADY then
					CastSpell(_E, minions)
				end
			end
		end
		for a, ally in pairs(GetAllyHeroes()) do
			if not ally.dead then
				if GetDistance(ally, myHero) < eRange and GetDistance(target, ally) < 600 and GetDistance(target, myHero) > eRange and EREADY then
					CastSpell(_E, ally)
				end
			end
		end
		if not target.dead then
			if GetDistance(target, myHero) < eRange and EREADY and ValidTarget(target) then
				CastSpell(_E, target)
			end
		end
	end
end
function UseEcombo()
	for e, target in pairs(GetEnemyHeroes()) do
		if not target.dead and ValidTarget(target) then
			if GetDistance(target, myHero) < eRange and EREADY then
				CastSpell(_E, target)
			end
		end
	end
end
function autoE()
	for i, ally in pairs(GetAllyHeroes()) do
		if not ally.dead then	
			if GetDistance(ally, myHero) < eRange and HpCheck(ally, luluCFG.combo.eConfig.hpPercent) then
				CastSpell(_E, ally)
			end
		end
	end
end
function UseR()
	for i, ally in pairs(GetAllyHeroes()) do
		if luluCFG.combo.rConfig[ally.charName] then
			if GetDistance(ally) < rRange and EnemyNear(rRadius, ally) >= luluCFG.combo.rConfig.EnemyNo and RREADY then
				CastSpell(_R, ally)
			end
		end
	end
	if RREADY and EnemyNear(rRadius, myHero) >= luluCFG.combo.rConfig.EnemyNo then
		CastSpell(_R, myHero)
	end
end
function autoR()
	for i, ally in ipairs(GetAllyHeroes()) do
		if luluCFG.combo.rConfig[ally.charName] then
			if ally.team ~= myHero.team then
			if GetDistance(ally) < rRange and EnemyNear(800, ally) > 0 and RREADY and HpCheck(ally, luluCFG.combo.rConfig.hpPercent) then
				CastSpell(_R, ally)
			end
			end
		end
	end
	if EnemyNear(800, myHero) > 0 and RREADY and HpCheck(myHero, luluCFG.combo.rConfig.hpPercent) then
		CastSpell(_R, myHero)
	end
end
function UseW()
	for e, target in pairs(GetEnemyHeroes()) do	
		if not target.dead and ValidTarget(target) then
			if GetDistance(myHero, target) < wRange and WREADY then
				CastSpell(_W, target)
			end
		end
		if target ~= nil and target ~= nil and GetDistance(target) < wRange and ValidTarget(target) then
			CastSpell(_W, target)
		end
	end
end
function AutoW()
	for i, target in pairs(GetEnemyHeroes()) do
		if target ~= nil and WREADY and ValidTarget(target) and GetDistance(myHero, target) < eRange then
			if IsOnCC(target) == true then
				CastSpell(_W, target)
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
