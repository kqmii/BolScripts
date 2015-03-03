---------------------------
--  NamiMadness by Kqmii --
--	                     --
--			V1.1		 --
---------------------------




if myHero.charName ~= "Nami" then return end
--Target Selector
local ts
--Vpred
require 'VPrediction'
--Orbwalker
require "SxOrbwalk"
--Info des spells
local qDelay, qRadius, qRange, qSpeed = 0.8, 200, 875, 1750
local wRange = 725
local eRange = 800
local rDelay, rRadius, rRange, rSpeed = 0.5, 210, 2550, 1200

-------------


--Au demarrage
function OnLoad()
	Menu() -- Menu Demarrer
	PrintChat ("NamiMadness by Kqmii V1.1 Loaded")
	PrintChat ("Report any problem by pm to kqmii on bol")
	
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
		SxUpdate(1.1,
        "raw.githubusercontent.com",
        "/kqmii/BolScripts/master/NamiMadness.version",
        "/kqmii/BolScripts/master/NamiMadness.lua",
        SCRIPT_PATH.."NamiMadness.lua",
        function(NewVersion) if NewVersion > 1.1 then print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") else print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end end)
		

		
	-- local A = {_Q,_W,_E,_Q,_Q,_R,_Q,_E,_Q,_W,_R,_E,_E,_E,_W,_R,_W,_W}
	-- local B = {_Q,_W,_E,_E,_E,_R,_E,_Q,_E,_W,_R,_Q,_Q,_Q,_W,_R,_W,_W}
	-- local C = {_Q,_W,_E,_W,_W,_R,_W,_E,_W,_Q,_R,_E,_E,_E,_Q,_R,_Q,_Q}
	-- local D = {_Q,_W,_E,_E,_E,_R,_E,_W,_E,_Q,_R,_W,_W,_W,_Q,_R,_Q,_Q}
	
end

--Toute les 10 sec
function OnTick()
	ts:update()
	
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	

	
	if NamiCFG.Harass.HarassKey then
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
	
	-- if NamiCFG.aLvl then
		-- AutoLvla()
	-- end
	-- if NamiCFG.bLvl then
		-- AutoLvlb()
	-- end
	-- if NamiCFG.cLvl then
		-- AutoLvlc()
	-- end
	-- if NamiCFG.dLvl then
		-- AutoLvld()
	-- end	
end
--Harass with Q
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
--Menu
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
			
		--NamiCFG:addSubMenu("--["..myHero.charName.."]-- Auto Level Spell", "aLvl")
			--NamiCFG.aLvl:addParam("aSeq", "R > Q > E > W", SCRIPT_PARAM_ONOFF, false)
			-- NamiCFG.aLvl:addParam("bSeq", "R > E > Q > W", SCRIPT_PARAM_ONOFF, false)
			-- NamiCFG.aLvl:addParam("cSeq", "R > W > E > Q", SCRIPT_PARAM_ONOFF, false)
			-- NamiCFG.aLvl:addParam("dSeq", "R > E > W > Q", SCRIPT_PARAM_ONOFF, false)
		
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
			NamiCFG.draw:addParam("qDraw", "Q range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("wDraw", "W range", SCRIPT_PARAM_ONOFF, true)
			NamiCFG.draw:addParam("eDraw", "E range", SCRIPT_PARAM_ONOFF, true)
				
		NamiCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(NamiCFG.SxOrb)
		
end
--Combo
function Combo()
	if NamiCFG.Combo.comboKey then
		UseR()
		UseE()
		UseQ()
		UseW()
	end
end
--Parametre des sorts pour Combo
function UseQ()
	if NamiCFG.Combo.qUse then
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
function UseW()
	if NamiCFG.Combo.wUse then
		if ts.target ~= nil and WREADY then
			CastSpell(_W, ts.target)
		end
	end
end
function UseE()
	if NamiCFG.Combo.eUse then
	local allies = GetAllyHeroes()
		for i, ally in pairs(allies) do
			if not ally.dead then
				if GetDistance(ally) < eRange and EREADY then
					CastSpell(_E, ally)
				else 
					if ts.target ~= nil and ValidTarget(ts.target, 800) then
						CastSpell(_E, myHero)
					end
				end
			end
		end
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
--Drawings
function OnDraw()
	if NamiCFG.draw.qDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x6600FF)
	end
	
	if NamiCFG.draw.wDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0x6666FF)
	end
	
	if NamiCFG.draw.eDraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0x66CCFF)
	end
	
	DrawCircle(myHero.x, myHero.y, myHero.z, 675, ARGB(255, 0, 255, 0))
	
	if not myHero.dead then
		if ValidTarget(ts.target) then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 150, 0xCC0033)
		end
	end
end
--Auto Heal Self
function AutoHealSelf()
	if WREADY and NamiCFG.healManager.healNami and HpCheck(myHero, NamiCFG.healManager.selfPercent) then
		CastSpell(_W, myHero)
	end
end
--Auto Heal Allies
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
--Health Check
function HpCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
		then return true
	else
		return false
	end
end
--auto level spells
--function Autolvla()
--	if not NamiCFG.aLvl.aSeq then return end
--		if myHero.level > GetHeroLeveled() then		
--			LevelSpell(A[GetHeroLeveled() + 1])
--		end
--end
--function Autolvlb()
--	if not NamiCFG.aLvl.bSeq then return end
--		if myHero.level > GetHeroLeveled() then		
--			LevelSpell(B[GetHeroLeveled() + 1])
--		end
--end
--function Autolvlc()
--	if not NamiCFG.aLvl.cSeq then return end
--		if myHero.level > GetHeroLeveled() then		
--			LevelSpell(C[GetHeroLeveled() + 1])
--		end
--end
--function Autolvld()
--	if not NamiCFG.aLvl.dSeq then return end
--		if myHero.level > GetHeroLeveled() then		
--			LevelSpell(D[GetHeroLeveled() + 1])
--		end
--end
-------Auto Updater ----
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



