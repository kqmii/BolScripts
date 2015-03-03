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
local qDelay, qRadius, qRange, qSpeed = 0.40, 200, 875, 1750
local wRange = 725
local eRange = 800
local rDelay, rRadius, rRange, rSpeed = 0.5, 210, 2550, 1200


-------------
class "ScriptUpdate"
function ScriptUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath, SavePath, CallbackUpdate, CallbackNoUpdate, CallbackNewVersion)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SavePath
    self.CallbackUpdate = CallbackUpdate
    self.CallbackNoUpdate = CallbackNoUpdate
    self.CallbackNewVersion = CallbackNewVersion
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.connect('sx-bol.eu', 80)
    self.Socket:send("GET "..self.VersionPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.LastPrint = ""
    self.File = ""
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function ScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function ScriptUpdate:GetOnlineVersion()
    if self.Status == 'closed' then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)

    if self.Receive then
        if self.LastPrint ~= self.Receive then
            self.LastPrint = self.Receive
            self.File = self.File .. self.Receive
        end
    end

    if self.Snipped ~= "" and self.Snipped then
        self.File = self.File .. self.Snipped
    end
    if self.Status == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            self.OnlineVersion = tonumber(self.File:sub(ContentStart + 1))
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self.DownloadSocket = self.LuaSocket.connect('sx-bol.eu', 80)
                self.DownloadSocket:send("GET "..self.ScriptPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
                self.DownloadSocket:settimeout(0, 'b')
                self.DownloadSocket:settimeout(99999999, 't')
                self.LastPrint = ""
                self.File = ""
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        else
            print('Error: Could not get end of Header')
        end
    end
end

function ScriptUpdate:DownloadUpdate()
    if self.DownloadStatus == 'closed' then return end
    self.DownloadReceive, self.DownloadStatus, self.DownloadSnipped = self.DownloadSocket:receive(1024)

    if self.DownloadReceive then
        if self.LastPrint ~= self.DownloadReceive then
            self.LastPrint = self.DownloadReceive
            self.File = self.File .. self.DownloadReceive
        end
    end

    if self.DownloadSnipped ~= "" and self.DownloadSnipped then
        self.File = self.File .. self.DownloadSnipped
    end

    if self.DownloadStatus == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            local ScriptFileOpen = io.open(self.SavePath, "w+")
            ScriptFileOpen:write(self.File:sub(ContentStart + 1))
            ScriptFileOpen:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
            end
        end
    end
end------------

class 'TestingPurpose'
function TestingPurpose:_init()
    self.version = 1.1
    print('<font color=\'#F0Ff8d\'><b>NamiMadness:</b></font> <font color=\'#FF0F0F\'>Version '..self.version..' loaded</font>')
    local ToUpdate = {}
    ToUpdate.Version = self.version
    ToUpdate.Host = "raw.githubusercontent.com"
    ToUpdate.VersionPath = "/kqmii/BolScripts/master/TestingPurpose.lua"
    ToUpdate.ScriptPath = "/kqmii/BolScripts/master/TestingPurpose.version"
    ToUpdate.SavePath = SCRIPT_PATH.."TestingPurpose.lua"
    ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") end
    ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">No Updates Found</b></font>") end
    ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
    ScriptUpdate(ToUpdate.Version, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion)

end
--Au demarrage
function OnLoad()
	Menu() -- Menu Demarrer
	update()
	PrintChat ("NamiMadness by Kqmii V1.2 Loaded")
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
		

		
	-- local A = {_Q,_W,_E,_Q,_Q,_R,_Q,_E,_Q,_W,_R,_E,_E,_E,_W,_R,_W,_W}
	-- abilitySequenceB = {1,2,3,3,3,4,3,1,3,2,4,1,1,1,2,4,2,2}
	-- abilitySequenceC = {1,2,3,2,2,4,2,3,2,1,4,3,3,3,1,4,1,1}
	-- abilitySequenceD = {1,2,3,3,3,4,3,2,3,1,4,2,2,2,1,4,1,1}
	
end

function update()
		self.version = 1.2
		print('<font color=\'#F0Ff8d\'><b>NamiMadness:</b></font> <font color=\'#FF0F0F\'>Version '..self.version..' loaded</font>')
		local ToUpdate = {}
		ToUpdate.Version = self.version
		ToUpdate.Host = "raw.githubusercontent.com"
		ToUpdate.VersionPath = "/kqmii/BolScripts/master/TestingPurpose.lua"
		ToUpdate.ScriptPath = "/kqmii/BolScripts/master/TestingPurpose.version"
		ToUpdate.SavePath = SCRIPT_PATH.."TestingPurpose.lua"
		ToUpdate.CallbackUpdate = function(NewVersion,OldVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") end
		ToUpdate.CallbackNoUpdate = function(OldVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">No Updates Found</b></font>") end
		ToUpdate.CallbackNewVersion = function(NewVersion) print("<font color=\"#F0Ff8d\"><b>NamiMadness: </b></font> <font color=\"#FF0F0F\">New Version found ("..NewVersion.."). Please wait until its downloaded</b></font>") end
		ScriptUpdate(ToUpdate.Version, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath, ToUpdate.SavePath, ToUpdate.CallbackUpdate,ToUpdate.CallbackNoUpdate, ToUpdate.CallbackNewVersion)
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




