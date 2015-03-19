------------------------------
--	WukongMadness by Kqmii  --
------------------------------
if myHero.charName ~= "MonkeyKing" then return end

local currentVersion = 1.3

require 'SxOrbwalk'

local ts
local qRange, eRange, rRange = 300, 650, 315
local gEnemy = GetEnemyHeroes()
local SACLoaded, MMALoaded = nil,nil
local slotSmite = nil
local slotIgnite = nil
local smiteDamage = math.max(20*myHero.level+370,30*myHero.level+330,40*myHero.level+240,50*myHero.level+100)
local igniteDamage = 50 + (20*myHero.level)
local qSDmg = nil
local UltON = false
local Sxo = nil
local FixItems = true
Items = {
		BRK = { id = 3153, range = 450 },
		BWC = { id = 3144, range = 400 },
		DFG = { id = 3128, range = 750 },
		HGB = { id = 3146, range = 400 },
		RSH = { id = 3074, range = 350 },
		STD = { id = 3131, range = 350 },
		TMT = { id = 3077, range = 350 },
		YGB = { id = 3142, range = 350 },
		BFT = { id = 3188, range = 750 },
		RND = { id = 3143, range = 275 }
	}
InterruptingSpells = {
		["AbsoluteZero"]				= true,
		["AlZaharNetherGrasp"]			= true,
		["CaitlynAceintheHole"]			= true,
		["Crowstorm"]					= true,
		["DrainChannel"]				= true,
		["FallenOne"]					= true,
		["GalioIdolOfDurand"]			= true,
		["InfiniteDuress"]				= true,
		["KatarinaR"]					= true,
		["MissFortuneBulletTime"]		= true,
		["Teleport"]					= true,
		["Pantheon_GrandSkyfall_Jump"]	= true,
		["ShenStandUnited"]				= true,
		["UrgotSwap2"]					= true
	}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	PrintChat("<font color=\"#33CC99\"><b>WukongMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	updateScript()
	DetectOrbwalker()
	EnemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_DEC)
	JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
	FindSum()
	Menu()
	if heroManager.iCount == 10 then
		arrangeTarget()
	else
		PrintChat("Not enought champion to arrange priority")
	end
end
function OnTick()
	checkSpells()
	ts:update()
	EnemyMinions:update()
	JungleMinions:update()
	if wuCFG.combo.comboKey then
		Combo()
	end
	if wuCFG.harass.harassKey then
		Harass()
	end
	if wuCFG.smite.smiteKey then
		useSmite()
	end
	if wuCFG.KS.KsToggle then
		KS()
	end
	if wuCFG.laneclear.lKey then
		Laneclear()
	end
	if wuCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not wuCFG.draw.disable then
		if wuCFG.draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255,0,255,0))
		end
		if wuCFG.draw.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, ARGB(255,0,255,0))
		end
		if wuCFG.draw.sDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, 565, ARGB(255,0,255,150))
		end
		if wuCFG.draw.tDraw and ValidTarget(ts.target) then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 120, ARGB(255,100,250,0))
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 130, ARGB(255,100,250,0))
		end
	end
	if not myHero.dead  then
		for i, monster in pairs (JungleMinions.objects) do
			if monster ~= nil and monster.valid and not monster.dead and monster.visible and monster.x ~= nil and monster.health > 0 then
				MonsterDraw(monster)
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
    DrawCircleNextLvl(x, y, z, radius, wuCFG.draw.Width, color, wuCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	wuCFG = scriptConfig("WukongMadness", "WKQ")
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000)
	SxOrb = SxOrbWalk()
	
	wuCFG:addSubMenu("Wukong - Combo settings", "combo")
		wuCFG.combo:addParam("useItem", "Use Item in combo", SCRIPT_PARAM_ONOFF, true)
		wuCFG.combo:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
		wuCFG.combo:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
		wuCFG.combo:addParam("sUse", "Use Smite in combo", SCRIPT_PARAM_ONOFF, true)
			wuCFG.combo:addSubMenu("--R Config--", "rConfig")
			wuCFG.combo.rConfig:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
			wuCFG.combo.rConfig:addParam("rEnemy", "Min Enemy to Ult", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
			wuCFG.combo.rConfig:addParam("rCC", "Cancel Channeling spells w/ ult", SCRIPT_PARAM_ONOFF, true)
		wuCFG.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
		---------------------------------------------------
		---------------------------------------------------
	wuCFG:addSubMenu("Wukong - Laneclear/jungle settings", "laneclear")
		wuCFG.laneclear:addParam("qJClear", "Use Q", SCRIPT_PARAM_ONOFF, true)
		wuCFG.laneclear:addParam("eJClear", "Use E", SCRIPT_PARAM_ONOFF, true)
		wuCFG.laneclear:addParam("lKey", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		---------------------------------------------------
		---------------------------------------------------
	wuCFG:addSubMenu("Wukong - Auto Smite settings", "smite")
		wuCFG.smite:addParam("redSmite", "Smite Red Buff", SCRIPT_PARAM_ONOFF, true)
		wuCFG.smite:addParam("blueSmite", "Smite Blue Buff", SCRIPT_PARAM_ONOFF, true)
		wuCFG.smite:addParam("razorSmite", "Smite Razorbeaks", SCRIPT_PARAM_ONOFF, false)
		wuCFG.smite:addParam("krugSmite", "Smite Krug", SCRIPT_PARAM_ONOFF, false)
		wuCFG.smite:addParam("grompSmite", "Smite Gromp", SCRIPT_PARAM_ONOFF, true)
		wuCFG.smite:addParam("wolveSmite", "Smite Wolves", SCRIPT_PARAM_ONOFF, false)
		wuCFG.smite:addParam("drakeSmite", "Smite Drake", SCRIPT_PARAM_ONOFF, true)
		wuCFG.smite:addParam("nashorSmite", "Smite Nashor", SCRIPT_PARAM_ONOFF, true)
		wuCFG.smite:addParam("smiteKey", "Auto Smite toggle key", SCRIPT_PARAM_ONKEYTOGGLE,true, GetKey("G"))
		---------------------------------------------------
		---------------------------------------------------
	wuCFG:addSubMenu("Wukong - Harass settings", "harass")
		wuCFG.harass:addParam("qHarass", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
		wuCFG.harass:addParam("eHarass", "Harass with E", SCRIPT_PARAM_ONOFF, true)
		wuCFG.harass:addParam("manaHarass", "min. Mana to Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		wuCFG.harass:addParam("harassKey", "Harass key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		-----------------------------------------------------
		-----------------------------------------------------
	wuCFG:addSubMenu("Wukong - Ks settings", "KS")
	if slotIgnite ~= nil then
		wuCFG.KS:addParam("iKS", "Ks with Ignite", SCRIPT_PARAM_ONOFF, true)
	end
	if slotSmite ~= nil then
		wuCFG.KS:addParam("sKS", "KS with Smite", SCRIPT_PARAM_ONOFF, true)
	end
		wuCFG.KS:addParam("eKS", "Ks with E", SCRIPT_PARAM_ONOFF, true)
		wuCFG.KS:addParam("rKS", "Ks with R", SCRIPT_PARAM_ONOFF, false)
		wuCFG.KS:addParam("KsToggle", "KS toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
		-----------------------------------------------------	
		-----------------------------------------------------
	wuCFG:addSubMenu("Wukong - Drawings settings", "draw")
		wuCFG.draw:addParam("disable", "Disable all drawings", SCRIPT_PARAM_ONOFF, false)
		wuCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
		wuCFG.draw:addParam("eDraw", "Draw E range", SCRIPT_PARAM_ONOFF, true)
		wuCFG.draw:addParam("rDraw", "Draw R range", SCRIPT_PARAM_ONOFF, true)
		wuCFG.draw:addParam("sDraw", "Draw Smite range", SCRIPT_PARAM_ONOFF, true)
		wuCFG.draw:addParam("tDraw", "Draw Target", SCRIPT_PARAM_ONOFF, true)
		wuCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
		wuCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
		wuCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
		---------------------------------------------------
		---------------------------------------------------
	if SACLoaded == true then
		wuCFG:addParam("qqq", "SAC Detected", SCRIPT_PARAM_INFO, "")
	elseif MMALoaded == true then
		wuCFG:addParam("qqq", "MMA Detected", SCRIPT_PARAM_INFO, "")
	else 
		wuCFG:addSubMenu("Wukong - Orbwalker settings", "SxOrb")
			SxOrb:LoadToMenu(wuCFG.SxOrb)
	end
		-----------------------------------------------------
		-----------------------------------------------------
	wuCFG:addTS(ts)
		ts.name = "Wukong -"
		
	-- permashow
		wuCFG.smite:permaShow("smiteKey")
		wuCFG.KS:permaShow("KsToggle")
end
function DetectOrbwalker()
	if _G.MMA_LOADED then
		PrintChat("WukongMadness : MMA Detected")
		MMALoaded = true
	elseif _G.Reborn_Loaded then
		PrintChat("WukongMadness : SAC Detected")
		SACLoaded = true
	else
		PrintChat("WukongMadness : SxOrb Loaded")
		Sxo = true
	end	
end
function checkSpells()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	SREADY = (slotSmite ~= nil and myHero:CanUseSpell(slotSmite) == READY)
	IREADY = (slotIgnite ~= nil and myHero:CanUseSpell(slotIgnite) == READY)
end
function FindSum()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmiteQuick") or myHero:GetSpellData(SUMMONER_1).name:find("ItemSmiteAoE") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmitePlayerGanker") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmiteDuel") then
		slotSmite = SUMMONER_1
		--print("smite 1")
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmiteQuick") or myHero:GetSpellData(SUMMONER_1).name:find("ItemSmiteAoE") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmitePlayerGanker") or myHero:GetSpellData(SUMMONER_1).name:find("S5_SummonerSmiteDuel") then
		slotSmite = SUMMONER_2
		--print("smite 2")
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then 
		slotIgnite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
		slotIgnite = SUMMONER_2 
	end
end
function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
		then return true
	else
		return false
	end
end
function KS()
	if wuCFG.KS.sKS then
		ksSmite()
	end
	if wuCFG.KS.iKS then
		iKS()
	end
	if wuCFG.KS.eKS then
		eKs()
	end
	if wuCFG.KS.rKS then
		rKs()
	end
end
function Laneclear()
		if wuCFG.laneclear.qJClear then
			qFarm()
		end
		if wuCFG.laneclear.eJClear then
			eFarm()
		end
		for i, minion in pairs(JungleMinions.objects) do
			if ValidTarget(minion) and not minion.dead then
				if GetDistance(minion) <= Items.TMT.range then CastItem(3074) end
				if GetDistance(minion) <= Items.TMT.range then CastItem(3077) end
			end
		end
		for i, minion in pairs(EnemyMinions.objects) do
			if ValidTarget(minion) and not minion.dead then
				if GetDistance(minion) <= Items.TMT.range then CastItem(3074) end
				if GetDistance(minion) <= Items.TMT.range then CastItem(3077) end
			end
		end
end
function OnProcessSpell(unit, spell)
	if wuCFG.combo.rConfig.rCC then
		if GetDistance(unit) <= rRange and RREADY then
			if InterruptingSpells[spell.name] then
				CastSpell(_R)
			end
		end	
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
function Combo()
		if wuCFG.combo.useItem then
			UseItems()
		end
		if wuCFG.combo.sUse then
			comboSmite()
		end
		if wuCFG.combo.qUse then
			SxOrb:RegisterAfterAttackCallback(qSpell())
		end
		if wuCFG.combo.eUse then
			eSpell()
		end
			rSpell()
end
function Harass()
	if not ManaCheck(myHero, wuCFG.harass.manaHarass) then
		if wuCFG.harass.qHarass then
			qSpell()
		end
		if wuCFG.harass.qHarass then
			eSpell()
		end
	end
end
-- start credits Extragoz
function MonsterDraw(minion)
	local isEpicMonster = minion.charName == "Dragon" or minion.charName == "Nashor" 
	local barPos = GetUnitHPBarPos(minion)
	barPos.y = math.floor(barPos.y)
	local maxDistance = 100
	local height = 7
	if minion.charName == "SRU_Baron" then
		barPos.x, barPos.y, maxDistance, height = barPos.x - 97, barPos.y - 6, 192, 15
	elseif minion.charName == "SRU_Dragon" then
		barPos.x, barPos.y, maxDistance, height = barPos.x - 72, barPos.y - 4, 142, 12
	elseif minion.charName == "SRU_Blue" or minion.charName == "SRU_Red" then
		barPos.x, barPos.y, maxDistance, height = barPos.x - 72, barPos.y - 3, 142, 12
	elseif minion.charName == "SRU_Gromp" then
		barPos.x, barPos.y, maxDistance = barPos.x - 45, barPos.y - 3, 88
	elseif minion.charName == "SRU_Murkwolf" or minion.charName == "SRU_Razorbeak" then
		barPos.x, barPos.y, maxDistance = barPos.x - 39, barPos.y - 3, 76
	elseif minion.charName == "SRU_Krug" then
		barPos.x, barPos.y, maxDistance = barPos.x - 42, barPos.y - 3, 82
	elseif minion.charName == "Sru_Crab" then
		barPos.x, barPos.y, maxDistance = barPos.x - 33, barPos.y - 9, 63
	elseif minion.charName == "SRU_BlueMini" then
		barPos.x, barPos.y, maxDistance = barPos.x - 26, barPos.y - 4, 51
	elseif minion.charName == "SRU_BlueMini2" or minion.charName == "SRU_RedMini" or minion.charName == "SRU_RazorbeakMini" then
		barPos.x, barPos.y, maxDistance = barPos.x - 26.3, barPos.y - 3, 51
	elseif minion.charName == "SRU_MurkwolfMini" then
		barPos.x, barPos.y, maxDistance = barPos.x - 29.3, barPos.y - 3, 57
	elseif minion.charName == "SRU_KrugMini" then
		barPos.x, barPos.y, maxDistance = barPos.x - 29, barPos.y - 3, 56
	end
	if isEpicMonster then
		DrawText(tostring(math.floor(minion.health)), 12, barPos.x + 60, barPos.y - 12, ARGB(255, 255, 255, 255))
	end
	local SmiteDistance = smiteDamage / minion.maxHealth * maxDistance
	if minion.health >= smiteDamage then
		DrawLine(barPos.x + SmiteDistance, barPos.y + 1, barPos.x + SmiteDistance, barPos.y + height-2, 1, ARGB(255,0,252,255))
	end
	DrawOutline(barPos.x-1, barPos.y-1, maxDistance+2, height, ARGB(150,0,252,255))
end
function DrawOutline(x, y, width, height, color)
	DrawLine(x, 		y, 			x + width + 1, y, 1, color)
	DrawLine(x, 		y, 			x, 				y + height, 1, color)
	DrawLine(x + width, y, 			x + width, 		y + height, 1, color)
	DrawLine(x, 		y + height, x + width + 1, y + height, 1, color)
end
-- end credits Extragoz
function UseItems()
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead then
				if GetDistance(target) < Items.BRK.range then CastItem(3153, target) end
				if GetDistance(target) < Items.BWC.range then CastItem(3144, target) end
				if GetDistance(target) < Items.DFG.range then CastItem(3128, target) end
				if GetDistance(target) < Items.HGB.range then CastItem(3146, target) end
				if GetDistance(target) < Items.RSH.range then CastItem(3074) end
				if GetDistance(target) < Items.STD.range then CastItem(3131) end
				if GetDistance(target) < Items.TMT.range then CastItem(3077) end	
				if GetDistance(target) < Items.YGB.range then CastItem(3142) end
				if GetDistance(target) < Items.BFT.range then CastItem(3188, target) end
				if GetDistance(target) < Items.RND.range then CastItem(3143) end
		end
	end
end

---------------------------------------
--			Spells config            --
---------------------------------------
function useSmite()
	for i, minion in pairs(JungleMinions.objects) do
		smite = math.max(20*myHero.level+370,30*myHero.level+330,40*myHero.level+240,50*myHero.level+100)
		if ValidTarget(minion) and minion.visible and not minion.dead then
			if SREADY then
				if GetDistance(minion) <= qRange then
					if wuCFG.smite.wolveSmite then
						if minion.name == "SRU_Murkwolf8.1.1" or minion.name == "SRU_Murkwolf2.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.grompSmite then
						if minion.name == "SRU_Gromp14.1.1" or minion.name == "SRU_Gromp13.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.redSmite then
						if minion.name == "SRU_Red4.1.1" or minion.name == "SRU_Red10.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.blueSmite then
						if minion.name == "SRU_Blue1.1.1" or minion.name == "SRU_Blue7.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.razorSmite then
						if minion.name == "SRU_Razorbeak3.1.1" or minion.name == "SRU_Razorbeak9.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.krugSmite then
						if minion.name == "SRU_Krug5.1.2" or minion.name == "SRU_Krug11.1.2" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.drakeSmite then
						if minion.name == "SRU_Dragon6.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
					if wuCFG.smite.baronSmite then
						if minion.name == "SRU_Baron12.1.1" then
							if minion.health <= smite then
								CastSpell(slotSmite, minion)
							end
						end
					end
				end
			end
		end
	end
end				
function qFarm()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and not minion.dead and minion.visible then
			if GetDistance(minion) < qRange and QREADY then
				CastSpell(_Q)
			end
		end
	end
	for i, minion in pairs(JungleMinions.objects) do
		if minion ~= nil and not minion.dead and minion.visible then
			if GetDistance(minion) < qRange and QREADY then
				CastSpell(_Q)
			end
		end
	end
end
function eFarm()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and not minion.dead and minion.visible then
			if GetDistance(minion) < eRange and EREADY then
				CastSpell(_E, minion)
			end
		end
	end
	for i, minion in pairs(JungleMinions.objects) do
		if minion ~= nil and not minion.dead and minion.visible then
			if GetDistance(minion) < eRange and EREADY then
				CastSpell(_E, minion)
			end
		end
	end
end
function qSpell()
if UltOn == true then return end
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead and QREADY then
			if GetDistance(target) < qRange then
				CastSpell(_Q)
			end
		end
	end	
end
function eSpell()
if UltOn == true then return end
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead and EREADY then
			if GetDistance(target) <= eRange then
				CastSpell(_E, target)
			end
		end
	end
end
function rSpell()
	for i, target in pairs(gEnemy) do	
		if wuCFG.combo.rConfig.rUse then
			if ValidTarget(target) and RREADY and not target.dead then
				if EnemyNear(rRange, myHero) >= wuCFG.combo.rConfig.rEnemy then
					CastSpell(_R)
				end
			end
		end
	end
end
function comboSmite()
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and not target.dead then
			if SREADY and GetDistance(target) < 560 then
				CastSpell(slotSmite, target)
			end
		end
	end
end
function eKs()
if UltOn == true then return end
	for i, target in pairs(gEnemy) do
		local eDmg = getDmg("E", target, myHero)
		if ValidTarget(target) and not target.dead then
			if EREADY and GetDistance(target) <= eRange then
				if target.health <= eDmg then
					CastSpell(_E, target)
				end
			end
		end
	end		
end
function rKs()
	for i, target in pairs(gEnemy) do
		local rDmg = getDmg("R", target, myHero) 
		if ValidTarget(target) and not target.dead then
			if RREADY and GetDistance(target) <= rRange then
				if target.health <= rDmg then
					CastSpell(_R)
				end
			end
		end
	end
end
function iKs()
	for i, target in pairs(gEnemy) do
		if ValidTarget(target) and GetDistance(target) <= 600 and not target.dead then
			if IREADY and target.health <= igniteDamage then
				CastSpell(slotIgnite, target)
			end
		end
	end
end
function ksSmite()
	for i, target in pairs(gEnemy) do
		DmgOnChamp = 20+(8*myHero.level)
		if target.health < DmgOnChamp*0.95 and ValidTarget(target) and GetDistance(target) <= 560 and SREADY and not target.dead then
			CastSpell(slotSmite, target)
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
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/WukongMadness.version", "/kqmii/BolScripts/master/WukongMadness.lua", SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>WukongMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>WukongMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBECGHIBIFG") 
