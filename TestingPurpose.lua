---------------------------
--  NamiMadness by Kqmii --
--	                     --
--			V1.1		 --
---------------------------




if myHero.charName ~= "Nami" then return end

--Auto Update info
_G.AUTOUPDATE = true
local version = "1.1.1"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/kqmii/BolScripts/master/TestingPurpose.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("NamiMadness : "..msg..".</font>") end
--Target Selector
local ts
require "VPrediction"
require "SxOrbWalk"
--Info des spells
local qDelay, qRadius, qRange, qSpeed = 0.40, 200, 875, 1750
local wRange = 725
local eRange = 800
local rDelay, rRadius, rRange, rSpeed = 0.5, 210, 2550, 1200

--Auto Update
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/kqmii/BolScripts/master/TestingPurpose.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
local REQUIRED_LIBS = {
	["VPrediction"] = "https://raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua",
	["SxOrbWalk"] = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
}
function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#FF0000\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end
--Au demarrage
function OnLoad()
	Menu() -- Menu Demarrer
	PrintChat ("NamiMadness by Kqmii V0.1 Loaded")
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
	-- local A = {_Q,_W,_E,_Q,_Q,_R,_Q,_E,_Q,_W,_R,_E,_E,_E,_W,_R,_W,_W}
	-- abilitySequenceB = {1,2,3,3,3,4,3,1,3,2,4,1,1,1,2,4,2,2}
	-- abilitySequenceC = {1,2,3,2,2,4,2,3,2,1,4,3,3,3,1,4,1,1}
	-- abilitySequenceD = {1,2,3,3,3,4,3,2,3,1,4,2,2,2,1,4,1,1}
	
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
		-- AutoLvl()
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





