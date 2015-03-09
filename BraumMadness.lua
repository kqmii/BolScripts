------------------------------
--	BraumMadness by Kqmii	--
------------------------------
if myHero.charName ~= "Braum" then return end

local currentVersion = 1.4

require 'VPrediction'
require 'SxOrbwalk'

local qRange, qWidth, qSpeed, qDelay = 1000, 120, math.huge, 0.2
local wRange = 650
local eRange, eWidth = 1200, 120
local rRange, rWidth, rSpeed, rDelay = 1250, 210, math.huge, 0.5
local ts
local gEnemy = GetEnemyHeroes()
local gAlly = GetAllyHeroes()
local minion = nil
local braumAA = 125

---------------------------------------
--			  Skillshot				 --
---------------------------------------
Champions = {
		["Lux"] = {charName = "Lux", skillshots = {
			["LuxLightBinding"] = {name = "Light Binding", spellName = "LuxLightBinding", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LuxLightStrikeKugel"] = {name = "Lucent Singularity", spellName = "LuxLightStrikeKugel", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "circular", unBlockable = false, blockable = true, danger = 0},
			["LuxMaliceCannon"] = {name = "Final Spark", spellName = "LuxMaliceCannon", castDelay = 1375, projectileName = "Enrageweapon_buf_02.troy", projectileSpeed = math.huge, range = 3500, radius = 190, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
	
		["Braum"] = {charName = "Braum", skillshots = {
			["Winters Bite"] = {name = "Winters Bite", spellName = "BraumQMissile", castDelay = 0, projectileName = "Braum_Base_Q_mis.troy", projectileSpeed = 1700, range = 1000, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 1},
			["Glacial Fissure"] = {name = "Glacial Fissure", spellName = "BraumRWrapper", castDelay = 510, projectileName = "Braum_Base_R_mis.troy", projectileSpeed = 1438, range = 1250, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 1}, 
	}},	
	
		["Nidalee"] = {charName = "Nidalee", skillshots = {
			["JavelinToss"] = {name = "Javelin Toss", spellName = "JavelinToss", castDelay = 125, projectileName = "nidalee_javelinToss_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Rengar"] = {charName = "Rengar", skillshots = {
			["RengarEFinalMAX"] = {name = "RengarEFinalMAX", spellName = "RengarEFinalMAX", castDelay = 250, projectileName = "Rengar_Base_E_Max_Mis.troy", projectileSpeed = 1500, range = 1000, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},	
		["Sion"] = {charName = "Sion", skillshots = {
			["CrypticGaze"] = {name = "Cryptic Gaze", spellName = "CrypticGaze",blockable=true, danger = 0, range=625},
	}},	
	
	
		["Nunu"] = {charName = "Nunu", skillshots = {
			["IceBlast"] = {name = "Ice Blast", spellName="IceBlast", blockable=true, danger = 1, range=550},
	}},	
	
		["Akali"] = {charName = "Akali", skillshots = {
			["AkaliMota"] = {name = "Mark of the assassin", spellName = "AkaliMota", castDelay = 125, projectileName = "AkaliMota_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Kennen"] = {charName = "Kennen", skillshots = {
			["KennenShurikenHurlMissile1"] = {name = "Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", castDelay = 180, projectileName = "kennen_ts_mis.troy", projectileSpeed = 1700, range = 1050, radius = 50, type = "line", unBlockable = false, blockable = true, danger = 0}--could be 4 if you have 2 marks
	}},
		["Amumu"] = {charName = "Amumu", skillshots = {
			["BandageToss"] = {name = "Bandage Toss", spellName = "BandageToss", castDelay = 260, projectileName = "Bandage_beam.troy", projectileSpeed = 2000, range = 1100, radius = 80, type = "line", evasiondanger = true, unBlockable = false, blockable = true, danger = 1}
	}},
		["LeeSin"] = {charName = "LeeSin", skillshots = {
			["BlindMonkQOne"] = {name = "Sonic Wave", spellName = "BlindMonkQOne", castDelay = 218, projectileName = "blindMonk_Q_mis_01.troy", projectileSpeed = 1844, range = 1100, radius = 60+10, type = "line", unBlockable = false, blockable = true, danger = 1} --if he hit this he will slow you
	}},
		["Morgana"] = {charName = "Morgana", skillshots = {
			["DarkBindingMissile"] = {name = "Dark Binding", spellName = "DarkBindingMissile", castDelay = 250, projectileName = "DarkBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 90, type = "line", unBlockable = false, blockable = true, danger = 1},		
			["TormentedSoil"] = {name = "Tormented Soil", spellName = "TormentedSoil", castDelay = 250, projectileName = "", projectileSpeed = 1200, range = 900, radius = 300, type = "circular", blockable = false, danger = 1},
	}},
		["Ezreal"] = {charName = "Ezreal", skillshots = {
			["EzrealMysticShot"] = {name = "Mystic Shot", spellName = "EzrealMysticShot", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0},
			["EzrealEssenceFlux"] = {name = "Essence Flux", spellName = "EzrealEssenceFlux", castDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1500, range = 1050, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0},
			["EzrealMysticShotPulse"] = {name = "MysticShot Pulse", spellName = "EzrealMysticShotPulse", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0},
			["EzrealTrueshotBarrage"] = {name = "Trueshot Barrage", spellName = "EzrealTrueshotBarrage", castDelay = 1000, projectileName = "Ezreal_TrueShot_mis.troy", projectileSpeed = 2000, range = 20000, radius = 160, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Ahri"] = {charName = "Ahri", skillshots = {
			["AhriOrbofDeception"] = {name = "Orb of Deception", spellName = "AhriOrbofDeception", castDelay = 250, projectileName = "Ahri_Orb_mis.troy", projectileSpeed = 1750, range = 900, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["AhriSeduce"] = {name = "Charm", spellName = "AhriSeduce", castDelay = 250, projectileName = "Ahri_Charm_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Olaf"] = {charName = "Olaf", skillshots = {
			["OlafAxeThrowCast"] = {name = "Undertow", spellName = "OlafAxeThrowCast", castDelay = 265, projectileName = "olaf_axe_mis.troy", projectileSpeed = 1600, range = 1000, radius = 90, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Leona"] = {charName = "Leona", skillshots = { -- Q+ R+
			["LeonaZenithBlade"] = {name = "Zenith Blade", spellName = "LeonaZenithBlade", castDelay = 250, projectileName = "Leona_ZenithBlade_mis.troy", projectileSpeed = 2000, range = 900, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LeonaSolarFlare"] = {name = "Solar Flare", spellName = "LeonaSolarFlare", castDelay = 250, projectileName = "Leona_SolarFlare_cas.troy", projectileSpeed = 650+350, range = 1200, radius = 300, type = "circular", unBlockable = false, blockable = true, danger = 1}
	}},
		["Karthus"] = {charName = "Karthus", skillshots = {
			["LayWaste"] = {name = "Lay Waste", spellName = "LayWaste", castDelay = 250, projectileName = "LayWaste_point.troy", projectileSpeed = 1750, range = 875, radius = 140, type = "circular", blockable = false, danger = 0}
	}},
		["Chogath"] = {charName = "Chogath", skillshots = {
			["Rupture"] = {name = "Rupture", spellName = "Rupture", castDelay = 0, projectileName = "rupture_cas_01_red_team.troy", projectileSpeed = 950, range = 950, radius = 250, type = "circular", blockable = false, danger = 1}
	}},
		["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
			["RocketGrabMissile"] = {name = "Rocket Grab", spellName = "RocketGrabMissile", castDelay = 250, projectileName = "FistGrab_mis.troy", projectileSpeed = 1800, range = 1050, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Anivia"] = {charName = "Anivia", skillshots = {
			["FlashFrostSpell"] = {name = "Flash Frost", spellName = "FlashFrostSpell", castDelay = 250, projectileName = "cryo_FlashFrost_mis.troy", projectileSpeed = 850, range = 1100, radius = 110, type = "line", unBlockable = false, blockable = true, danger = 1},
			["FrostBite"] = {name = "Frost Bite", spellName = "FrostBite", castDelay = 250, projectileName = "cryo_FrostBite_mis.troy", projectileSpeed = 1200, range = 1100, radius = 110, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140, unBlockable = false, blockable = true, danger = 0}
	}},
		["Katarina"] = {charName = "Katarina", skillshots = {
			["KatarinaR"] = {name = "Death Lotus", spellName = "KatarinaR", range = 550, unBlockable = true, blockable = true, danger = 1},
			["KatarinaQ"] = {name = "Bouncing Blades", spellName = "KatarinaQ", range = 675, unBlockable = false, blockable = true, danger = 1},
	}}, 
		["Zyra"] = {charName = "Zyra", skillshots = {
			-- ["Deadly Bloom"] = {name = "Deadly Bloom", spellName = "ZyraQFissure", castDelay = 250, projectileName = "zyra_Q_cas.troy", projectileSpeed = 1400, range = 825, radius = 220, type = "circular", unBlockable = false, blockable = true, danger = 0},
			["ZyraGraspingRoots"] = {name = "Grasping Roots", spellName = "ZyraGraspingRoots", castDelay = 230, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 1150, range = 1150, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1},
			["zyrapassivedeathmanager"] = {name = "Zyra Passive", spellName = "zyrapassivedeathmanager", castDelay = 500, projectileName = "zyra_passive_plant_mis.troy", projectileSpeed = 2000, range = 1474, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["Barrel Roll"] = {name = "Barrel Roll", spellName = "GragasBarrelRoll", castDelay = 250, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular", unBlockable = false, blockable = true, danger = 0},
			["Barrel Roll Missile"] = {name = "Barrel Roll Missile", spellName = "GragasBarrelRollMissile", castDelay = 0, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular", unBlockable = false, blockable = true, danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["GragasExplosiveCask"] = {name = "Ult", spellName="GragasExplosiveCask", blockable=true, danger = 0, range=1050},
			["GragasBarrelRoll"] = {name = "BarrelRoll", spellName="GragasBarrelRoll", blockable=true, danger = 0, range=950}
	}},
		["Nautilus"] = {charName = "Nautilus", skillshots = {
			["NautilusAnchorDrag"] = {name = "Dredge Line", spellName = "NautilusAnchorDrag", castDelay = 250, projectileName = "Nautilus_Q_mis.troy", projectileSpeed = 2000, range = 1080, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		--[[["Urgot"] = {charName = "Urgot", skillshots = {
			["Acid Hunter"] = {name = "Acid Hunter", spellName = "UrgotHeatseekingLineMissile", castDelay = 175, projectileName = "UrgotLineMissile_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 0},
			["Plasma Grenade"] = {name = "Plasma Grenade", spellName = "UrgotPlasmaGrenade", castDelay = 250, projectileName = "UrgotPlasmaGrenade_mis.troy", projectileSpeed = 1750, range = 900, radius = 250, type = "circular", unBlockable = false, blockable = true, danger = 1},
	}},]]--
		["Caitlyn"] = {charName = "Caitlyn", skillshots = {
			["CaitlynPiltoverPeacemaker"] = {name = "Piltover Peacemaker", spellName = "CaitlynPiltoverPeacemaker", castDelay = 625, projectileName = "caitlyn_Q_mis.troy", projectileSpeed = 2200, range = 1300, radius = 90, type = "line", unBlockable = false, blockable = true, danger = 0},
			["CaitlynEntrapment"] = {name = "Caitlyn Entrapment", spellName = "CaitlynEntrapment", castDelay = 150, projectileName = "caitlyn_entrapment_mis.troy", projectileSpeed = 2000, range = 950, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["CaitlynAceintheHole"] = {name = "Ace in the Hole", spellName = "CaitlynAceintheHole", range = 3000, unBlockable = false, blockable = true, danger = 1, projectileName = "caitlyn_ult_mis.troy"},
	}},
		["DrMundo"] = {charName = "DrMundo", skillshots = {
			["InfectedCleaverMissile"] = {name = "Infected Cleaver", spellName = "InfectedCleaverMissile", castDelay = 250, projectileName = "dr_mundo_infected_cleaver_mis.troy", projectileSpeed = 2000, range = 1050, radius = 75, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Brand"] = {charName = "Brand", skillshots = { -- Q+ W+
			["BrandBlaze"] = {name = "Blaze", spellName = "BrandBlaze", castDelay = 250, projectileName = "BrandBlaze_mis.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["BrandWildfire"] = {name = "BrandWildfire", spellName = "BrandWildfire", castDelay = 250, projectileName = "BrandWildfire_mis.troy", projectileSpeed = 1000, range = 1100, radius = 250, type = "circular", unBlockable = false, blockable = true, danger = 0}
	}},
		["Corki"] = {charName = "Corki", skillshots = {
			["MissileBarrage"] = {name = "Missile Barrage", spellName = "MissileBarrage", castDelay = 250, projectileName = "corki_MissleBarrage_mis.troy", projectileSpeed = 2000, range = 1300, radius = 40, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["TwistedFate"] = {charName = "TwistedFate", skillshots = {
			["WildCards"] = {name = "Loaded Dice", spellName = "WildCards", castDelay = 250, projectileName = "Roulette_mis.troy", projectileSpeed = 1000, range = 1450, radius = 40, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Swain"] = {charName = "Swain", skillshots = {
			["SwainShadowGrasp"] = {name = "Nevermove", spellName = "SwainShadowGrasp", castDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular", unBlockable = false, blockable = true, danger = 1},
			["SwainTorment"] = {name = "SwainTorment", spellName = "SwainTorment", castDelay = 250, projectileName = "swain_torment_mis.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular", unBlockable = false, blockable = true, danger = 1}
	}},
		["Cassiopeia"] = {charName = "Cassiopeia", skillshots = {
			["CassiopeiaNoxiousBlast"] = {name = "Noxious Blast", spellName = "CassiopeiaNoxiousBlast", castDelay = 250, projectileName = "CassNoxiousSnakePlane_green.troy", projectileSpeed = 500, range = 850, radius = 130, type = "circular", blockable = false, danger = 0},
	}},
		["Sivir"] = {charName = "Sivir", skillshots = { --hard to measure speed
			["SivirQ"] = {name = "Boomerang Blade", spellName = "SivirQ", castDelay = 250, projectileName = "Sivir_Base_Q_mis.troy", projectileSpeed = 1350, range = 1175, radius = 101, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Ashe"] = {charName = "Ashe", skillshots = {
			["EnchantedCrystalArrow"] = {name = "Enchanted Arrow", spellName = "EnchantedCrystalArrow", castDelay = 250, projectileName = "EnchantedCrystalArrow_mis.troy", projectileSpeed = 1600, range = 25000, radius = 130, type = "line", unBlockable = false, blockable = true, danger = 1},
			["Volley"] = {name = "Volley", spellName = "Volley", range = 1200, unBlockable = false, blockable = true, danger = 1},
	}},
		["KogMaw"] = {charName = "KogMaw", skillshots = {
			["KogMawQMis"] = {name = "KogMawQMis", spellName = "KogMawQMis", castDelay = 0, projectileName = "KogMawSpit_mis.troy", projectileSpeed = 1650, range = 1000, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["KogMawVoidOozeMissile"] = {name = "KogMawVoidOozeMissile", spellName = "KogMawVoidOozeMissile", castDelay = 250, projectileName = "KogMawVoidOozeMissile_mis.troy", projectileSpeed = 1433, range = 1280, radius = 150, type = "line", unBlockable = false, blockable = true, danger = 1},			
			["KogMawLivingArtillery"] = {name = "Living Artillery", spellName = "KogMawLivingArtillery", castDelay = 250, projectileName = "KogMawLivingArtillery_mis.troy", projectileSpeed = 1050, range = 2200, radius = 225, type = "circular", blockable = false, danger = 0},
	}},
		["Khazix"] = {charName = "Khazix", skillshots = {
			["KhazixW"] = {name = "KhazixW", spellName = "KhazixW", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 0},
			--["khazixwlong"] = {name = "khazixwlong", spellName = "khazixwlong", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Zed"] = {charName = "Zed", skillshots = {
			["ZedShuriken"] = {name = "ZedShuriken", spellName = "ZedShuriken", castDelay = 250, projectileName = "Zed_Q_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line", unBlockable = false, blockable = true, danger = 0},
			--["ZedShuriken2"] = {name = "ZedShuriken2", spellName = "ZedShuriken!", castDelay = 250, projectileName = "Zed_Q2_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Leblanc"] = {charName = "Leblanc", skillshots = {
			["LeblancChaosOrb"] = {name = "Ethereal LeblancChaosOrb", spellName = "LeblancChaosOrb", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, unBlockable = false, blockable = true, danger = 1},
			["LeblancChaosOrbM"] = {name = "Ethereal LeblancChaosOrbM", spellName = "LeblancChaosOrbM", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, unBlockable = false, blockable = true, danger = 1},
			["LeblancSoulShackle"] = {name = "Ethereal Chains", spellName = "LeblancSoulShackle", castDelay = 250, projectileName = "leBlanc_shackle_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LeblancSoulShackleM"] = {name = "Ethereal Chains R", spellName = "LeblancSoulShackleM", castDelay = 250, projectileName = "leBlanc_shackle_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LeblancMimic"] = {name = "LeblancMimic", spellName="LeblancMimic", blockable="true", danger = 0, range=650}
	}},
		["Draven"] = {charName = "Draven", skillshots = {
			["DravenDoubleShot"] = {name = "Stand Aside", spellName = "DravenDoubleShot", castDelay = 250, projectileName = "Draven_E_mis.troy", projectileSpeed = 1400, range = 1100, radius = 130, type = "line", unBlockable = false, blockable = true, danger = 1},
			["DravenRCast"] = {name = "DravenR", spellName = "DravenRCast", castDelay = 500, projectileName = "Draven_R_mis!.troy", projectileSpeed = 2000, range = 25000, radius = 160, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Elise"] = {charName = "Elise", skillshots = {
			["EliseHumanE"] = {name = "Cocoon", spellName = "EliseHumanE", castDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Lulu"] = {charName = "Lulu", skillshots = {
			["LuluQ"] = {name = "LuluQ", spellName = "LuluQ", castDelay = 250, projectileName = "Lulu_Q_Mis.troy", projectileSpeed = 1450, range = 1000, radius = 50, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},
		["Thresh"] = {charName = "Thresh", skillshots = {
			["ThreshQ"] = {name = "ThreshQ", spellName = "ThreshQ", castDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1900, range = 1100, radius = 65, type = "line", unBlockable = false, blockable = true, danger = 1} -- 60 real radius
	}},
		["Shen"] = {charName = "Shen", skillshots = {
			["ShenShadowDash"] = {name = "ShadowDash", spellName = "ShenShadowDash", castDelay = 0, projectileName = "shen_shadowDash_mis.troy", projectileSpeed = 3000, range = 575, radius = 50, type = "line", blockable = false, danger = 1}
	}},
		["Quinn"] = {charName = "Quinn", skillshots = {
			["QuinnQ"] = {name = "QuinnQ", spellName = "QuinnQ", castDelay = 250, projectileName = "Quinn_Q_missile.troy", projectileSpeed = 1550, range = 1050, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarPrimordialBurst"] = {name = "VeigarPrimordialBurst", spellName="VeigarPrimordialBurst", projectileName = "permission_Shadowbolt_mis.troy", unBlockable = false, blockable= true, danger = 0, range = 650},
			["VeigarBalefulStrike"] = {name = "VeigarBalefulStrike", spellName="VeigarBalefulStrike", projectileName = "permission__mana_flare_mis.troy.troy", unBlockable = false, blockable= true, danger = 0, range=650}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarDarkMatter"] = {name = "VeigarDarkMatter", spellName = "VeigarDarkMatter", castDelay = 250, projectileName = "!", projectileSpeed = 900, range = 900, radius = 225, type = "circular", unBlockable = false, blockable = true, danger = 0}
	}},
	
		["Diana"] = {charName = "Diana", skillshots = {
			["DianaArc"] = {name = "DianaArc", spellName = "DianaArc", castDelay = 250, projectileName = "Diana_Q_trail.troy", projectileSpeed = 1600, range = 1000, radius = 195, type="circular", unBlockable = false, blockable = true, danger = 0},
	}},
		["Jayce"] = {charName = "Jayce", skillshots = {
			["jayceshockblast"] = {name = "jayceshockblast", spellName = "jayceshockblast", castDelay = 250, projectileName = "JayceOrbLightning.troy", projectileSpeed = 1450, range = 1050, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 0},
			["Q2"] = {name = "Q2", spellName = "JayceShockBlast", castDelay = 250, projectileName = "JayceOrbLightningCharged.troy", projectileSpeed = 2350, range = 1600, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Nami"] = {charName = "Nami", skillshots = {
			["NamiQ"] = {name = "NamiQ", spellName = "NamiQ", castDelay = 250, projectileName = "Nami_Q_mis.troy", projectileSpeed = 800, range = 850, radius = 225, type="circular", unBlockable = false, blockable = true, danger = 1},
			["NamiRMissile"] = {name = "NamiRMissile", spellName = "NamiRMissile", castDelay = 484, projectileName = "Nami_R_Mis.troy", projectileSpeed = 846, range = 2735, radius = 210, type = "line", unBlockable = true, blockable = true, danger = 1},
	}},
		["Fizz"] = {charName = "Fizz", skillshots = {
			["FizzMarinerDoom"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", castDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Varus"] = {charName = "Varus", skillshots = {
			["VarusQ"] = {name = "Varus Q Missile", spellName = "VarusQ", castDelay = 0, projectileName = "VarusQ_mis.troy", projectileSpeed = 1900, range = 1600, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 0},
			["VarusE"] = {name = "Varus E", spellName = "VarusE", castDelay = 250, projectileName = "VarusEMissileLong.troy", projectileSpeed = 1500, range = 925, radius = 275, type = "circular", unBlockable = false, blockable = true, danger = 1},
			["VarusR"] = {name = "VarusR", spellName = "VarusR", castDelay = 250, projectileName = "VarusRMissile.troy", projectileSpeed = 1950, range = 1250, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Karma"] = {charName = "Karma", skillshots = {
			["KarmaQ"] = {name = "KarmaQ", spellName = "KarmaQ", castDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 1050, radius = 90, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Aatrox"] = {charName = "Aatrox", skillshots = {--Radius starts from 150 and scales down, so I recommend putting half of it, because you won't dodge pointblank skillshots.
			["AatroxE"] = {name = "Blade of Torment", spellName = "AatroxE", castDelay = 250, projectileName = "AatroxBladeofTorment_mis.troy", projectileSpeed = 1200, range = 1075, radius = 75, type = "line", unBlockable = false, blockable = true, danger = 1},
			["AatroxQ"] = {name = "AatroxQ", spellName = "AatroxQ", castDelay = 250, projectileName = "AatroxQ.troy", projectileSpeed = 450, range = 650, radius = 145, type = "circular", unBlockable = false, blockable = true, danger = 1},
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathArcanopulse"] = {name = "Xerath Arcanopulse", spellName = "XerathArcanopulse", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1025, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["xeratharcanopulseextended"] = {name = "Xerath Arcanopulse Extended", spellName = "xeratharcanopulseextended", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1625, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["xeratharcanebarragewrapper"] = {name = "xeratharcanebarragewrapper", spellName = "xeratharcanebarragewrapper", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1100, radius = 265, type = "circular", unBlockable = false, blockable = true, danger = 0},
			["xeratharcanebarragewrapperext"] = {name = "xeratharcanebarragewrapperext", spellName = "xeratharcanebarragewrapperext", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1600, radius = 265, type = "circular", unBlockable = false, blockable = true, danger = 0}
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathMageSpearMissile"] = {name = "XerathMageSpearMissile", spellName = "XerathMageSpearMissile",castDelay = 0, projectileName = "Xerath_Base_E_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["xerathlocuspulse"] = {name = "xerathlocuspulse", spellName = "xerathlocuspulse",castDelay = 0, projectileName = "Xerath_Base_R_mis.troy", projectileSpeed = 1200, range = 5600, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Velkoz"] = {charName = "Velkoz", skillshots = {
			["VelkozQMissile"] = {name = "VelkozQMissile", spellName = "VelkozQMissile", castDelay = 250, projectileName = "Velkoz_Base_Q_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},		
			["VelkozW"] = {name = "VelkozW", spellName = "VelkozW", castDelay = 250, projectileName = "Velkoz_Base_W_Turret.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},		
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "FountainHeal.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_beam.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_Lens.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},	
		["Graves"] = {charName = "Graves", skillshots = {
			["GravesClusterShot"] = {name = "Light Binding", spellName = "GravesClusterShot", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["GravesChargeShot"] = {name = "LuxLightStrikeKugel", spellName = "GravesChargeShot", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "line", unBlockable = false, blockable = true, danger = 1},
			
	}},	
	
	
		["Lucian"] = {charName = "Lucian", skillshots = {
			["LucianQ"] = {name = "LucianQ", spellName = "LucianQ", castDelay = 350, projectileName = "Lucian_Q_laser.troy", projectileSpeed = math.huge, range = 570*2, radius = 65, type = "line", unBlockable = false, blockable = true, danger = 0},
			["LucianW"] = {name = "LucianW", spellName = "LucianW", castDelay = 300, projectileName = "Lucian_W_mis.troy", projectileSpeed = 1600, range = 1000, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Rumble"] = {charName = "Rumble", skillshots = {
			["RumbleGrenade"] = {name = "RumbleGrenade", spellName = "RumbleGrenade", castDelay = 250, projectileName = "rumble_taze_mis.troy", projectileSpeed = 2000, range = 950, radius = 90, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Nocturne"] = {charName = "Nocturne", skillshots = {
			["NocturneDuskbringer"] = {name = "NocturneDuskbringer", spellName = "NocturneDuskbringer", castDelay = 250, projectileName = "NocturneDuskbringer_mis.troy", projectileSpeed = 1400, range = 1125, radius = 60, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["MissFortune"] = {charName = "MissFortune", skillshots = {
			["MissFortuneScattershot"] = {name = "Scattershot", spellName = "MissFortuneScattershot", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 800, radius = 200, type = "circular", blockable = false, danger = 0},
			["MissFortuneBulletTime"] = {name = "Bullettime", spellName = "MissFortuneBulletTime", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 1400, radius = 200, type = "line", unBlockable = false, blockable = true, danger = 0}
	}},
		["Orianna"] = {charName = "Orianna", skillshots = {
			--["OrianaIzunaCommand"] = {name = "OrianaIzunaCommand", spellName = "OrianaIzunaCommand!", castDelay = 250, projectileName = "Oriana_Ghost_mis.troy", projectileSpeed = 1200, range = 2000, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 0},
	}},
		["Ziggs"] = {charName = "Ziggs", skillshots = { -- Q changed to line in 1.10
			["ZiggsQ"] = {name = "ZiggsQ", spellName = "ZiggsQ", castDelay = 1500, projectileName = "ZiggsQ.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["ZiggsW"] = {name = "ZiggsW", spellName = "ZiggsW", castDelay = 250, projectileName = "ZiggsW_mis.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["ZiggsE"] = {name = "ZiggsE", spellName = "ZiggsE", castDelay = 250, projectileName = "ZiggsEMine.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", unBlockable = false, blockable = true, danger = 0},
			["ZiggsR"] = {name = "ZiggsR", spellName = "ZiggsR", projectileName = "ZiggsR_Mis_Nuke.troy", range = 1500, unBlockable = true, blockable = false, danger = 0}
	}},
		["Galio"] = {charName = "Galio", skillshots = {
			["GalioResoluteSmite"] = {name = "GalioResoluteSmite", spellName = "GalioResoluteSmite", castDelay = 250, projectileName = "galio_concussiveBlast_mis.troy", projectileSpeed = 850, range = 2000, radius = 200, type = "circular", unBlockable = false, blockable = true, danger = 1},
	}},
		["Yasuo"] = {charName = "Yasuo", skillshots = {
			["yasuoq3w"] = {name = "Steel Tempest", spellName = "yasuoq3w", castDelay = 300, projectileName = "Yasuo_Q_wind_mis.troy", projectileSpeed = 1200, range = 900, radius = 375, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Kassadin"] = {charName = "Kassadin", skillshots = {
			["NullLance"] = {name = "Null Sphere", spellName = "NullLance", castDelay = 300, projectileName = "Null_Lance_mis.troy", projectileSpeed = 1400, range = 650, radius = 1, type = "line", unBlockable = false, blockable = true, danger = 1},
	}},
		["Jinx"] = {charName = "Jinx", skillshots = { -- R speed and delay increased
			["JinxWMissile"] = {name = "Zap", spellName = "JinxWMissile", castDelay = 600, projectileName = "Jinx_W_mis.troy", projectileSpeed = 3300, range = 1450, radius = 70, type = "line", unBlockable = false, blockable = true, danger = 1},
			["JinxRWrapper"] = {name = "Super Mega Death Rocket", spellName = "JinxRWrapper", castDelay = 600+900, projectileName = "Jinx_R_Mis.troy", projectileSpeed = 2500, range = 20000, radius = 120, type = "line", unBlockable = false, blockable = true, danger = 0}
	}},
		["Taric"] = {charName = "Taric", skillshots = {
			["Dazzle"] = {name = "Dazzle", spellName="Dazzle", blockable=true, danger = 0, range=625},
	}},
		["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
			["FiddlesticksDarkWind"] = {name = "DarkWind", spellName="FiddlesticksDarkWind", blockable=true, danger = 0, range=750},
	}}, 
		["Syndra"] = {charName = "Syndra", skillshots = { -- Q added in 1.10
			["SyndraQ"] = {name = "Q", spellName = "SyndraQ", castDelay = 250, projectileName = "Syndra_Q_cas.troy", projectileSpeed = 500, range = 800, radius = 175, type = "circular", blockable = false, danger = 0},
			["SyndraR"] = {name = "SyndraR", spellName="SyndraR", blockable=true, danger = 0, range=675}
	}},
		["Kayle"] = {charName = "Kayle", skillshots = {
			["JudicatorReckoning"] = {name = "JudicatorReckoning", spellName="JudicatorReckoning", castDelay = 100, projectileName = "Reckoning_mis.troy", projectileSpeed = 1500, range = 875, unBlockable = false, blockable=true, danger = 1, range=650},
	}},
		["Heimerdinger"] = {charName = "Heimerdinger", skillshots = {
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 250, projectileName = "Heimerdinger_Base_w_Mis.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 260, projectileName = "Heimerdinger_Base_W_Mis_Ult.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},		
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "StormGrenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "StormGrenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis_Ult.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},		
	}}, 
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140, unBlockable = false, blockable = true, danger = 1}
	}},
		["Janna"] = {charName = "Janna", skillshots = {
			["HowlingGale"] = {name = "HowlingGale", spellName = "HowlingGale", castDelay = 250, projectileName = "HowlingGale_mis.troy", projectileSpeed = 1200, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1}
	}},
		["Lissandra"] = {charName = "Lissandra", skillshots = {
			["LissandraQMissile"] = {name = "LissandraQMissile", spellName = "LissandraQMissile", castDelay = 250, projectileName = "Lissandra_Q_mis.troy", projectileSpeed = 2160, range = 1300, radius = 80, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LissandraEMissile"] = {name = "LissandraEMissile", spellName = "LissandraEMissile", castDelay = 250, projectileName = "Lissandra_E_mis.troy", projectileSpeed = 850, range = 1000, radius = 275, type = "line", unBlockable = false, blockable = true, danger = 1},
			["LissandraW"] = {name = "LissandraW", spellName = "LissandraW", castDelay = 10, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 3850, range = 430, radius = 275, type = "line", unBlockable = false, blockable = true, danger = 1},
			
	}},	
	
		["Riven"] = {charName = "Riven", skillshots = {
			["rivenizunablade"] = {name = "rivenizunablade", spellName = "rivenizunablade", castDelay = 234, projectileName = "Riven_Base_R_Mis_Middle.troy", projectileSpeed = 2210, range = 1000, radius = 180, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},		
	
		["Pantheon"] = {charName = "Pantheon", skillshots = {
			["Pantheon_Throw"] = {name = "Pantheon_Throw", spellName = "Pantheon_Throw", castDelay = 250, projectileName = "pantheon_spear_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1}
	}},
	
		["Sejuani"] = {charName = "Sejuani", skillshots = {
			["SejuaniGlacialPrisonCast"] = {name = "SejuaniGlacialPrisonCast", spellName = "SejuaniGlacialPrisonCast", castDelay = 249, projectileName = "Sejuani_R_mis.troy", projectileSpeed = 1628, range = 1100, radius = 250, type = "line", unBlockable = false, blockable = true, danger = 1}
	}},	
		["Ryze"] = {charName = "Ryze", skillshots = {
			["Overload"] = {name = "Overload", spellName = "Overload", castDelay = 250, projectileName = "Overload_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1},
			["SpellFlux"] = {name = "SpellFlux", spellName = "SpellFlux", castDelay = 250, projectileName = "SpellFlux_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1}
	}},
		["Malphite"] = {charName = "Malphite", skillshots = {
			["SeismicShard"] = {name = "SeismicShard", spellName = "SeismicShard", castDelay = 250, projectileName = "SeismicShard_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1}
	}},
		["Sona"] = {charName = "Sona", skillshots = {
			["SonaHymnofValor"] = {name = "SonaHymnofValor", spellName = "SonaHymnofValor", castDelay = 250, projectileName = "SonaHymnofValor_beam.troy", projectileSpeed = 1500, range = 1500, radius = 140, unBlockable = false, blockable = true, danger = 1},
			["SonaCrescendo"] = {name = "SonaCrescendo", spellName = "SonaCrescendo", castDelay = 250, projectileName = "SonaCrescendo_mis.troy", projectileSpeed = 1500, range = 1500, radius = 500, unBlockable = false, blockable = true, danger = 1}
	}},
		["Teemo"] = {charName = "Teemo", skillshots = {
			["BlindingDart"] = {name = "BlindingDart", spellName = "BlindingDart", castDelay = 250, projectileName = "BlindShot_mis.troy", projectileSpeed = 1500, range = 680, radius = 450, unBlockable = false, blockable = true, danger = 1}
	}},
		["Vayne"] = {charName = "Vayne", skillshots = {
			["VayneCondemn"] = {name = "VayneCondemn", spellName = "VayneCondemn", castDelay = 250, projectileName = "vayne_E_mis.troy", projectileSpeed = 1200, range = 550, radius = 450, unBlockable = false, blockable = true, danger = 1}
	}},
}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	PrintChat("<font color=\"#33CC99\"><b>BraumMadness by Kqmii </b></font>"..currentVersion.."<font color=\"#33CC99\"><b> Loaded</b></font>")
	PrintChat("<b>Report any problem by pm to kqmii on bol</b>")
	minion = minionManager(MINION_ALLY, 1000, myHero, MINION_SORT_HEALTH_ASC)
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
	minion:update()
	
		QREADY = (myHero:CanUseSpell(_Q) == READY)
		WREADY = (myHero:CanUseSpell(_W) == READY)
		EREADY = (myHero:CanUseSpell(_E) == READY)
		RREADY = (myHero:CanUseSpell(_R) == READY)
		
	if braumCFG.combo.comboKey then
		Combo()
	end
	if braumCFG.harass.qHarassToggle then
		MoveToMouse()
		harassQ()
	end
	if braumCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if braumCFG.draw.qDraw and QREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(255, 0, 0, 255))
		end
		if braumCFG.draw.wDraw and WREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(255, 0, 51, 255))
		end
		if braumCFG.draw.rDraw and RREADY then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255, 0, 102, 255))
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
    DrawCircleNextLvl(x, y, z, radius, braumCFG.draw.Width, color, braumCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	VP = VPrediction()
	SxO = SxOrbWalk(VP)
	braumCFG = scriptConfig("BraumMadness", "BKQ")
	ts = TargetSelector(TARGET_LESS_CAST, 1300, DAMAGE_PHYSICAL)
	
		braumCFG:addSubMenu("--["..myHero.charName.."]-- Combo", "combo")
			braumCFG.combo:addParam("qUse", "Use Q", SCRIPT_PARAM_ONOFF, true)
			
				braumCFG.combo:addSubMenu("W Settings", "wSettings")
					braumCFG.combo.wSettings:addParam("wGapCloser", "W Gapcloser on combo", SCRIPT_PARAM_ONOFF, true)
					
				braumCFG.combo:addSubMenu("R Settings", "rSettings")
					braumCFG.combo.rSettings:addParam("rUse", "Use R", SCRIPT_PARAM_ONOFF, true)
					braumCFG.combo.rSettings:addParam("minR", "Min Enemies to R", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
					braumCFG.combo.rSettings:addParam("rHitChance", "R Hitchance 1/low, 2/high..", SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
			braumCFG.combo:addParam("qCD", "If Q is on CD, don't combo", SCRIPT_PARAM_ONOFF, true)	
			braumCFG.combo:addParam("comboKey", "Combo key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
			
		braumCFG:addSubMenu("--["..myHero.charName.."]-- Harass", "harass")
			braumCFG.harass:addParam("qHarassToggle", "Harass toggle key", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
			braumCFG.harass:addParam("manaHarass", "Stop harass below % mana", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
		
		braumCFG:addParam("wSaveAlly", "W-E ally if incoming Skillshot", SCRIPT_PARAM_ONOFF, true)
		braumCFG:addParam("autoE", "Auto E incoming skillshot/ults", SCRIPT_PARAM_ONOFF, true)
		braumCFG:addSubMenu("--["..myHero.charName.."]-- Auto E spells", "eSpells")
		for i, hero in pairs(GetEnemyHeroes()) do
				if Champions[hero.charName] ~= nil then
					for index, skillshot in pairs(Champions[hero.charName].skillshots) do
						if skillshot.blockable == true then
							braumCFG.eSpells:addParam(skillshot.spellName, hero.charName.." - "..skillshot.name, SCRIPT_PARAM_ONOFF, true)
						end
					end
				end
		end
		braumCFG:addSubMenu("--["..myHero.charName.."]-- Drawings", "draw")
			braumCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
			braumCFG.draw:addParam("wDraw", "Draw W range", SCRIPT_PARAM_ONOFF, true)		
			braumCFG.draw:addParam("rDraw", "Draw R range", SCRIPT_PARAM_ONOFF, true)
			braumCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			braumCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			braumCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
			
		braumCFG:addSubMenu("--["..myHero.charName.."]-- Orbwalker", "SxOrb")
			SxOrb:LoadToMenu(braumCFG.SxOrb)
		
		braumCFG:addTS(ts)
			ts.name = "--["..myHero.charName.."]-- Braum"
		
		braumCFG.combo:permaShow("comboKey")
		braumCFG.harass:permaShow("qHarassToggle")
		braumCFG:permaShow("autoE")
		
	
end
--Auto E
function OnProcessSpell(object, spellProc)
		if myHero.dead then return end
		for i, ally in pairs(GetAllyHeroes()) do
			if object.team ~= player.team and string.find(spellProc.name, "Basic") == nil then
				if Champions[object.charName] ~= nil then
					skillshot = Champions[object.charName].skillshots[spellProc.name]
					if skillshot ~= nil and skillshot.blockable == true and not skillshot.unBlockable then
						range = skillshot.range
						if not spellProc.startPos then
							spellProc.startPos.x = object.x
							spellProc.startPos.z = object.z
						end
						if GetDistance(spellProc.startPos) <= range and GetDistance(spellProc.endPos) <= eRange then
							if braumCFG.eSpells[spellProc.name] then
								if EREADY then
									if spellProc.endPos.x ~= myHero.x+20 and spellProc.endPos.z ~= myHero.z+20 and braumCFG.autoE then
										CastSpell(_E, object.x, object.z)
									end
									if spellProc.endPos.x ~= ally.x+20 and spellProc.endPos.z ~= ally.z+20 and GetDistance(ally, myHero) < wRange and braumCFG.wSaveAlly and WREADY then
										CastSpell(_W, ally)
										CastSpell(_E, object.x, object.z)
									end
								end
							end
						end
						if skillshot ~= nil and skillshot.unBlockable then
							if unBlockable == nil then
								unBlockableSpell = skillshot
								unBlockableObject = object
							end
						end
					end
				end
			end
		end 
end

function unBlockableSpells()
	if unBlockableSpell.spellName == "KatarinaR" and unBlockableObject.charName == "Katarina" then
		local object = unBlockableObject
		if GetDistance(unBlockableObject)-eRange < unBlockableSpell.range then
			if EREADY and braumCFG.autoE[unBlockableSpell.spellName] then
				unBlockableSpell = nil
				unBlockableObject = nil
				CastSpell(_E, object.x, object.z)
			end
		end
	elseif unBlockableParticle ~= nil and GetDistance(unBlockableParticle) < eRange and (unBlockableSpell.spellName ==  "ZiggsR") then
		if EREADY and braumCFG.autoE[unBlockableSpell.spellName] and unBlockableParticle.x > 0 and unBlockableParticle.z > 0 then
			unBlockableSpell = nil
			unBlockableObject = nil
			object = unBlockableParticle
			--PrintChat("unBlockableParticle: "..unBlockableParticle.x.."/"..unBlockableParticle.z.." myHero: "..myHero.x.."/"..myHero.z)
			unBlockableParticle = nil
			CastSpell(_E, object.x, object.z)
		end 
	end
end
function Combo()
	if braumCFG.combo.qCD then
		qOnCd()
	end
	if not braumCFG.combo.qCD then
		if braumCFG.combo.qUse then
			UseQ()
		end
		if braumCFG.combo.wSettings.wGapCloser then
			GapcloserW()
		end
		if braumCFG.combo.rSettings.rUse then
			UseR()
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
function qOnCd()
	if QREADY == false then
	return end
	if QREADY == true then
		if braumCFG.combo.qUse then
			UseQ()
		end
		if braumCFG.combo.wSettings.wGapCloser then
			GapcloserW()
		end
		if braumCFG.combo.rSettings.rUse then
			UseR()
		end
	end
end
---------------------------------------
--			Spells config            --
---------------------------------------
function harassQ()
	if not ManaCheck(myHero, braumCFG.harass.manaHarass) then
		for i, target in pairs(gEnemy) do
			if not target.dead then
				if target ~= nil and QREADY and ValidTarget(target) then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, true)
					if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < qRange then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end
function UseQ()
	for i, target in pairs(gEnemy) do
		if not target.dead then
			if target ~= nil and QREADY and ValidTarget(target) then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, true)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < qRange then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end
function GapcloserW()
	for t, target in pairs(gEnemy) do
		for i, ally in ipairs(gAlly) do
				if ally ~= nil and not ally.dead then
						if GetDistance(ally, myHero) < wRange and WREADY and GetDistance(ally, target) <= 300 then
							CastSpell(_W, ally)
						end
				end
		end
		for m, minion in pairs(minion.objects) do
				if minion ~= nil and not minion.dead and minion.team == myHero.team then
					if GetDistance(minion, myHero) < wRange and WREADY and GetDistance(minion, target) <= 300 then
						CastSpell(_W, minion)
					end
				end
		end
	end
end
function UseR()
	for i, target in pairs(gEnemy) do
		if target ~= nil and ValidTarget(target) then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, rDelay, rWidth, rRange, rSpeed, myHero, false)
			if MainTargetHitChance >= braumCFG.combo.rSettings.rHitChance and GetDistance(AOECastPosition) < rRange and nTargets >= braumCFG.combo.rSettings.minR and RREADY then
				CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
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
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/BraumMadness.version", "/kqmii/BolScripts/master/BraumMadness.lua", 
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>BraumMadness : </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>BraumMadness : </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
