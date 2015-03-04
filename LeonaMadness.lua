--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
--	   LeonaMadness by Kqmii     --
--*******************************--
--|||||||||||||||||||||||||||||||--
--*******************************--
if myHero.charName ~= "Leona" then return end

require 'VPrediction'
require 'SxOrbwalk'
local ts

local qReady = false
local wRange = 450
local eDelay, eWidth, eRange, eSpeed = 0.2, 40, 875, 2000
local rDelay, rRadius, rRange, rSpeed = 0.625, 220, 1200, math.huge

local wColor, eColor, rColor = ARGB(255, 204, 153, 0), ARGB(255, 204, 102, 0), ARGB(255, 204, 51, 0)

local targetSelected = nil

local tRange = 900

---------------------------------------
--			   Updater				 --
---------------------------------------
local currentVersion = 1.1
function updateScript()
	SxUpdate(1.1, "raw.githubusercontent.com", "/kqmii/BolScripts/master/LeonaMadness.version", "/kqmii/BolScripts/master/LeonaMadness.lua", SCRIPT_PATH.."LeonaMadness.lua",
		function(NewVersion) 
			if NewVersion > 1.1 then 
				print("<font color=\"#F0Ff8d\"><b>LeonaMadness : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>LeonaMadness : </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
	PrintChat("<font color=\"#33CC99\"><b>LeonaMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat("<b>Report any problem by pm to kqmii on bol</b>")
	PrintChat("<font color=\"#0066FF\"><b>v 1.2 - Added tower range indicator under drawings settings</b></font>")
	PrintChat("<font color=\"#0066FF\"><b>     - Added Select target with Left click</b></font>")
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
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	if leoCFG.Combo.comboKey then
		Combo()
	end
	if leoCFG.uEngage then
		ultiEngage()
		MoveToMouse()
	end
	
	if leoCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if ValidTarget(targetSelected) then
				DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 150, ARGB(255, 102, 204, 51))
				DrawCircle(targetSelected.x, targetSelected.y, targetSelected.z, 175, ARGB(255, 102, 204, 51))
		else if ValidTarget(ts.target) then
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 150, ARGB(255, 102, 204, 51))
				DrawCircle(ts.target.x, ts.target.y, ts.target.z, 175, ARGB(255, 102, 204, 51))
			end
		end
		if leoCFG.draw.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, wColor)
		end
		if leoCFG.draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, eColor)
		end
		if leoCFG.draw.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, rColor)
		end	
		if leoCFG.draw.tDraw then
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
    DrawCircleNextLvl(x, y, z, radius, leoCFG.draw.Width, color, leoCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST, 1200)
	VP = VPrediction()
	SxOrb = SxOrbWalk()
	leoCFG = scriptConfig("LeonaMadness", "LKQ")
	
		leoCFG:addSubMenu("--["..myHero.charName.."]-- Combo", "Combo")
			leoCFG.Combo:addParam("qUse", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			leoCFG.Combo:addParam("wUse", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
		    leoCFG.Combo:addParam("eUse", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
			leoCFG.Combo:addParam("rUse", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
			leoCFG.Combo:addSubMenu("Ultimate Configuration", "uConfig")
				leoCFG.Combo.uConfig:addParam("mnRange", "Mini Range to ultimate", SCRIPT_PARAM_SLICE, 600, 0, 1200, 0)
				leoCFG.Combo.uConfig:addParam("noEnemy", "Mini enemies to ultimate on", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
			leoCFG.Combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		
		leoCFG:addParam("uErange", "Minimal range to engage with ult", SCRIPT_PARAM_SLICE, 600, 0, 1200, 0)
		leoCFG:addParam("uEnumber", "How many enemies to engage ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
		leoCFG:addParam("uEngage", "Engage with ult key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
			
		leoCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
			leoCFG.draw:addParam("wDraw", "W range", SCRIPT_PARAM_ONOFF, true)
			leoCFG.draw:addParam("eDraw", "E range", SCRIPT_PARAM_ONOFF, true)
			leoCFG.draw:addParam("rDraw", "R range", SCRIPT_PARAM_ONOFF, true)
			leoCFG.draw:addParam("tDraw", "Turret range", SCRIPT_PARAM_ONOFF, false)
			leoCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			leoCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			leoCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
		
		leoCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(leoCFG.SxOrb)
end
function Combo()
	if leoCFG.Combo.eUse then
		useE()
	end
	if leoCFG.Combo.wUse then
		useW()
	end
	if leoCFG.Combo.qUse then
		useQ()
	end
	if leoCFG.Combo.rUse then
		DelayAction(function() ulti() end, 1.65)
	end

end
function MoveToMouse()
	if leoCFG.uEngage then
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

---------------------------------------
--			Spells config            --
---------------------------------------
function useQ()
	if leoCFG.Combo.qUse then
		if ts.target ~= nil and GetDistance(ts.target) <= 200 and QREADY then
			CastSpell(_Q)
		end
	end
end
function useW()
	if leoCFG.Combo.wUse then
		if ts.target ~= nil and GetDistance(ts.target) <= wRange and WREADY then
			CastSpell(_W)
		end
	end
end
function useE()
	if leoCFG.Combo.eUse then
		for i, target in pairs(GetEnemyHeroes()) do
			if ts.target ~= nil and EREADY then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, eDelay, eWidth, eRange, eSpeed, myHero, false)
					if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < eRange then
						CastSpell(_E, CastPosition.x, CastPosition.z)
					end
			end
		end
	end
end
function ulti()
	if leoCFG.Combo.rUse then
		for i, target in pairs(GetEnemyHeroes()) do
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, rDelay, rRadius, leoCFG.Combo.uConfig.mnRange, rSpeed, myHero)
				if MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < leoCFG.Combo.uConfig.mnRange and nTargets >= leoCFG.Combo.uConfig.noEnemy and RREADY then
					CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
				end
		end
	end
end
function ultiEngage()
	for i, target in pairs(GetEnemyHeroes()) do
		local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, rDelay, rRadius, leoCFG.uErange, rSpeed, myHero)
			if MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < leoCFG.uErange and nTargets >= leoCFG.uEnumber and RREADY then
				CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
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
--		 Custom target arranger      --
---------------------------------------
TargetTable ={
				AP = {"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"},
				Support = {"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"},
				Tank = {"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear", "Warwick", "Yorick", "Zac", "Renekton"},
				AD_Carry = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Quinn", "Shaco", "Sivir", "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"},
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

