---------------------------------------
--		ZileanMadness by Kqmii		 --
---------------------------------------

local currentVersion = 1.1

if myHero.charName ~= "Zilean" then return end

require 'VPrediction'
require 'SxOrbwalk'

local ts

local qRange, qDelay, qRadius, qSpeed = 900, 0.5, 180, math.huge
local eRange = 700
local rRange = 900
local tRange = 925
local qColor, eColor, tColor = ARGB(255,0,255,255),ARGB(255,0,153,204),ARGB(190,0,255,0)
---------------------------------------
--			   Updater				 --
---------------------------------------
function updateScript()
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/ZileanMadness.version", "/kqmii/BolScripts/master/ZileanMadness.lua", SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>ZileanMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>ZileanMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
	PrintChat("<font color=\"#33CC99\"><b>ZileanMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	
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
		Menu()
		
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
		
		if zilCFG.combo.comboKey then
			basicCombo()
		end
			autoE()
			autoW()
			autoR()

		if zilCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if zilCFG.draw.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, qColor)
		end
		if zilCFG.draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, eColor)
		end
		if zilCFG.draw.tDraw then
			for i, tower in pairs(GetTurrets()) do
				if GetDistance(tower) < 2000 then
					DrawCircle(tower.x, tower.y, tower.z, tRange, tColor)
				end
			end
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
    DrawCircleNextLvl(x, y, z, radius, zilCFG.draw.Width, color, zilCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST, 1200)
	VP = VPrediction()
	SxOrb = SxOrbWalk()
	zilCFG = scriptConfig("ZileanMadness", "ZKQ")
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
		zilCFG:addSubMenu("--["..myHero.charName.."]-- Combo", "combo")
			zilCFG.combo:addSubMenu("E Combo Config", "basicE")
				zilCFG.combo.basicE:addParam("eEnemyLowHp", "Use E on Enemy low Hp", SCRIPT_PARAM_ONOFF, true)
				zilCFG.combo.basicE:addParam("eEnemyPercent", "% to use E", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
				zilCFG.combo.basicE:addParam("eEnemyAD", "Use E on Enemy most AD", SCRIPT_PARAM_ONOFF, true)
				zilCFG.combo.basicE:addParam("EmyHero", "Use E on my Hero", SCRIPT_PARAM_ONOFF, true)
			zilCFG.combo:addParam("qUse", "Use Q", SCRIPT_PARAM_ONOFF, true)
			zilCFG.combo:addParam("eUse", "Use E", SCRIPT_PARAM_ONOFF, true)
			zilCFG.combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))		
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
		zilCFG:addSubMenu("--["..myHero.charName.."]-- Auto E config", "eConfig")
			zilCFG.eConfig:addParam("autoAllyLowHp", "Auto E ally low Hp", SCRIPT_PARAM_ONOFF, false)
			zilCFG.eConfig:addParam("allyHpPercent", "Ally Hp % for E", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			zilCFG.eConfig:addParam("autoSelfLowHp", "Auto E if my hero low hp", SCRIPT_PARAM_ONOFF, false)
			zilCFG.eConfig:addParam("selfHpPercent", "Self hp % for E", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
		zilCFG:addSubMenu("--["..myHero.charName.."]-- Auto W config", "wConfig")
			zilCFG.wConfig:addParam("qAutoW", "Auto W if Q on CD", SCRIPT_PARAM_ONOFF, false)
			zilCFG.wConfig:addParam("eAutoW", "Auto W if E on CD", SCRIPT_PARAM_ONOFF, false)
			zilCFG.wConfig:addParam("manaW", "Stop auto W at % mana", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
			zilCFG:addSubMenu("--["..myHero.charName.."]-- Auto R config", "autoR")
			zilCFG.autoR:addSubMenu("Use R on wich Champ", "heroR")
				for i, ally in pairs(GetAllyHeroes()) do
					zilCFG.autoR.heroR:addParam(ally.charName, ally.charName, SCRIPT_PARAM_ONOFF, true)
				end
				zilCFG.autoR:addParam("autoRuse", "Use Auto R", SCRIPT_PARAM_ONOFF, true)
				zilCFG.autoR:addParam("rHpPercent", "% of hp left to Auto R", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)				
	-----------------------------------------------------------------------------	
	-----------------------------------------------------------------------------
		zilCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
			zilCFG.draw:addParam("qDraw", "Draw Q-R range", SCRIPT_PARAM_ONOFF, true)
			zilCFG.draw:addParam("eDraw", "Draw E range", SCRIPT_PARAM_ONOFF, true)
			zilCFG.draw:addParam("tDraw", "Draw Tower Range", SCRIPT_PARAM_ONOFF, true)
			zilCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			zilCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			zilCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
	-----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
		zilCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalk", "SxOrb")
			SxOrb:LoadToMenu(zilCFG.SxOrb)
end
function basicCombo()
		qSpell()
		eSpell()
end
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
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
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
---------------------------------------
--			Spells config            --
---------------------------------------
function qSpell()
	if zilCFG.combo.qUse then
		for i, target in pairs(GetEnemyHeroes()) do
			if ts.target ~= nil then
				if QREADY then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, qDelay, qRadius, qRange, qSpeed)
						if HitChance >=2 and GetDistance(CastPosition) < qRange then
							CastSpell(_Q, CastPosition.x, CastPosition.z)
						end
				end
			end
		end
	end
end
local ADdamage = 0
function eSpell()
if zilCFG.combo.eUse then
-- on Enemy most AD
if zilCFG.combo.basicE.eEnemyAD then
	for a, target in pairs(GetEnemyHeroes()) do
		if not target.dead then
			if target.totalDamage > ADdamage and GetDistance(myHero, target) < eRange and EREADY then
				mostADC = target
				ADdamage = target.totalDamage
			end
		end
	end
	if EREADY and mostADC ~= nil and GetDistance(myHero, target) < eRange then
		CastSpell(_E, mostADC)
	end
end
-- on Enemy low HP
if zilCFG.combo.basicE.eEnemyLowHp then
	for e, t in pairs(GetEnemyHeroes()) do
		if not t.dead then
			if GetDistance(myHero, t) < eRange and HpCheck(t, zilCFG.combo.basicE.eEnemyPercent) and EREADY then
				CastSpell(_E, t)
			end
		end
	end
end
-- or on me
if zilCFG.combo.basicE.EmyHero then
	if EREADY then
		CastSpell(_E, myHero)
	end
end
end
end
function autoE()
--ally low hp
if zilCFG.eConfig.autoAllyLowHp then
if not Recalling() then
	for i, ally in pairs(GetAllyHeroes()) do
		if not ally.dead then
			if GetDistance(myHero, ally) < eRange and HpCheck(ally, zilCFG.eConfig.allyHpPercent) and EREADY then
				CastSpell(_E, ally)
			end
		end
end	end
end
--ally too far 
if zilCFG.eConfig.autoSelfLowHp then
		if not Recalling() then
			if EREADY and zilCFG.eConfig.autoSelfLowHp and HpCheck(myHero, zilCFG.eConfig.selfHpPercent) then
				CastSpell(_E, myHero)
			end
		end
	end
end
function autoW()
		if not ManaCheck(myHero, zilCFG.wConfig.manaW) then
			if not Recalling() then
				if zilCFG.wConfig.qAutoW then
					if QREADY == false then
						CastSpell(_W)
					end
				end
				if zilCFG.wConfig.eAutoW then
					if EREADY == false then
						CastSpell(_W)
					end
				end
			end
		end
	end
function autoR()
	if zilCFG.autoR.autoRuse then
	if not Recalling() then
		if RREADY and HpCheck(myHero, zilCFG.autoR.rHpPercent) and EnemyNear(1000, myHero) > 0 then
			CastSpell(_R, myHero)
		end
		for i, ally in pairs(GetAllyHeroes()) do
			if zilCFG.autoR.heroR[ally.charName] then
				if HpCheck(ally, zilCFG.autoR.rHpPercent) and GetDistance(ally) < 900 and EnemyNear(1000, ally) > 0 and RREADY then
					CastSpell(_R, ally)
				end
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
--			 ScriptStatus			 --
---------------------------------------










