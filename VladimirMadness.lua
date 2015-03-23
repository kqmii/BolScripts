--------------------------------
--	VladimirMadness by Kqmii  --
--------------------------------
if myHero.charName ~= "Vladimir" then return end

local currentVersion = 1

local color = ARGB(255,0,255,0)
local Items = {
	BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
	DFG = { id = 3128, range = 750, reqTarget = true, slot = nil },
	HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
	BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
	BRK = { id = 3153, range = 450, reqTarget = true, slot = nil },
	RSH = { id = 3074, range = 300, reqTarget = false, slot = nil },
	STD = { id = 3131, range = 350, reqTarget = false, slot = nil },
	TMT = { id = 3077, range = 300, reqTarget = false, slot = nil },
	YGB = { id = 3142, range = 350, reqTarget = false, slot = nil },
	RND = { id = 3143, range = 275, reqTarget = false, slot = nil },
}
Champions = {
		["Lux"] = {charName = "Lux", skillshots = {
			["LuxLightBinding"] = {name = "Light Binding", spellName = "LuxLightBinding", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line",  danger = 1},
			["LuxLightStrikeKugel"] = {name = "Lucent Singularity", spellName = "LuxLightStrikeKugel", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "circular",  danger = 0},
			["LuxMaliceCannon"] = {name = "Final Spark", spellName = "LuxMaliceCannon", castDelay = 1375, projectileName = "Enrageweapon_buf_02.troy", projectileSpeed = math.huge, range = 3500, radius = 190, type = "line",  danger = 1},
	}},
	
		["Braum"] = {charName = "Braum", skillshots = {
			["Winters Bite"] = {name = "Winters Bite", spellName = "BraumQMissile", castDelay = 0, projectileName = "Braum_Base_Q_mis.troy", projectileSpeed = 1700, range = 1000, radius = 100, type = "line",  danger = 1},
			["Glacial Fissure"] = {name = "Glacial Fissure", spellName = "BraumRWrapper", castDelay = 510, projectileName = "Braum_Base_R_mis.troy", projectileSpeed = 1438, range = 1250, radius = 100, type = "line",  danger = 1}, 
	}},	
	
		["Nidalee"] = {charName = "Nidalee", skillshots = {
			["JavelinToss"] = {name = "Javelin Toss", spellName = "JavelinToss", castDelay = 125, projectileName = "nidalee_javelinToss_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line",  danger = 1}
	}},
		["Rengar"] = {charName = "Rengar", skillshots = {
			["RengarEFinalMAX"] = {name = "RengarEFinalMAX", spellName = "RengarEFinalMAX", castDelay = 250, projectileName = "Rengar_Base_E_Max_Mis.troy", projectileSpeed = 1500, range = 1000, radius = 60, type = "line",  danger = 1}
	}},	
		["Sion"] = {charName = "Sion", skillshots = {
			["CrypticGaze"] = {name = "Cryptic Gaze", spellName = "CrypticGaze",blockable=true, danger = 0, range=625},
	}},	
		["Bard"] = {charName = "Bard", skillshotsh = {
			["BardQ"] = {name = "Cosmic Binding", spellName = "BardQ", castDelay = 250, projectileSpeed = 1100, range = 850, radius = 108, type="line", danger = 1}
	}},
	
		["Nunu"] = {charName = "Nunu", skillshots = {
			["IceBlast"] = {name = "Ice Blast", spellName="IceBlast", blockable=true, danger = 1, range=550},
	}},	
	
		["Akali"] = {charName = "Akali", skillshots = {
			["AkaliMota"] = {name = "Mark of the assassin", spellName = "AkaliMota", castDelay = 125, projectileName = "AkaliMota_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line",  danger = 1}
	}},
		["Kennen"] = {charName = "Kennen", skillshots = {
			["KennenShurikenHurlMissile1"] = {name = "Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", castDelay = 180, projectileName = "kennen_ts_mis.troy", projectileSpeed = 1700, range = 1050, radius = 50, type = "line",  danger = 0}--could be 4 if you have 2 marks
	}},
		["Amumu"] = {charName = "Amumu", skillshots = {
			["BandageToss"] = {name = "Bandage Toss", spellName = "BandageToss", castDelay = 260, projectileName = "Bandage_beam.troy", projectileSpeed = 2000, range = 1100, radius = 80, type = "line", evasiondanger = true,  danger = 1}
	}},
		["LeeSin"] = {charName = "LeeSin", skillshots = {
			["BlindMonkQOne"] = {name = "Sonic Wave", spellName = "BlindMonkQOne", castDelay = 218, projectileName = "blindMonk_Q_mis_01.troy", projectileSpeed = 1844, range = 1100, radius = 60+10, type = "line",  danger = 1} --if he hit this he will slow you
	}},
		["Morgana"] = {charName = "Morgana", skillshots = {
			["DarkBindingMissile"] = {name = "Dark Binding", spellName = "DarkBindingMissile", castDelay = 250, projectileName = "DarkBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 90, type = "line",  danger = 1},		
			["TormentedSoil"] = {name = "Tormented Soil", spellName = "TormentedSoil", castDelay = 250, projectileName = "", projectileSpeed = 1200, range = 900, radius = 300, type = "circular",  danger = 1},
	}},
		["Ezreal"] = {charName = "Ezreal", skillshots = {
			["EzrealMysticShot"] = {name = "Mystic Shot", spellName = "EzrealMysticShot", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line",  danger = 0},
			["EzrealEssenceFlux"] = {name = "Essence Flux", spellName = "EzrealEssenceFlux", castDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1500, range = 1050, radius = 80, type = "line",  danger = 0},
			["EzrealMysticShotPulse"] = {name = "MysticShot Pulse", spellName = "EzrealMysticShotPulse", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line",  danger = 0},
			["EzrealTrueshotBarrage"] = {name = "Trueshot Barrage", spellName = "EzrealTrueshotBarrage", castDelay = 1000, projectileName = "Ezreal_TrueShot_mis.troy", projectileSpeed = 2000, range = 20000, radius = 160, type = "line",  danger = 0},
	}},
		["Ahri"] = {charName = "Ahri", skillshots = {
			["AhriOrbofDeception"] = {name = "Orb of Deception", spellName = "AhriOrbofDeception", castDelay = 250, projectileName = "Ahri_Orb_mis.troy", projectileSpeed = 1750, range = 900, radius = 100, type = "line",  danger = 0},
			["AhriSeduce"] = {name = "Charm", spellName = "AhriSeduce", castDelay = 250, projectileName = "Ahri_Charm_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line",  danger = 1}
	}},
		["Olaf"] = {charName = "Olaf", skillshots = {
			["OlafAxeThrowCast"] = {name = "Undertow", spellName = "OlafAxeThrowCast", castDelay = 265, projectileName = "olaf_axe_mis.troy", projectileSpeed = 1600, range = 1000, radius = 90, type = "line",  danger = 1}
	}},
		["Leona"] = {charName = "Leona", skillshots = { -- Q+ R+
			["LeonaZenithBlade"] = {name = "Zenith Blade", spellName = "LeonaZenithBlade", castDelay = 250, projectileName = "Leona_ZenithBlade_mis.troy", projectileSpeed = 2000, range = 900, radius = 100, type = "line",  danger = 1},
			["LeonaSolarFlare"] = {name = "Solar Flare", spellName = "LeonaSolarFlare", castDelay = 250, projectileName = "Leona_SolarFlare_cas.troy", projectileSpeed = 650+350, range = 1200, radius = 300, type = "circular",  danger = 1}
	}},
		["Karthus"] = {charName = "Karthus", skillshots = {
			["LayWaste"] = {name = "Lay Waste", spellName = "LayWaste", castDelay = 250, projectileName = "LayWaste_point.troy", projectileSpeed = 1750, range = 875, radius = 140, type = "circular",  danger = 0}
	}},
		["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
			["RocketGrabMissile"] = {name = "Rocket Grab", spellName = "RocketGrabMissile", castDelay = 250, projectileName = "FistGrab_mis.troy", projectileSpeed = 1800, range = 1050, radius = 70, type = "line",  danger = 1}
	}},
		["Anivia"] = {charName = "Anivia", skillshots = {
			["FlashFrostSpell"] = {name = "Flash Frost", spellName = "FlashFrostSpell", castDelay = 250, projectileName = "cryo_FlashFrost_mis.troy", projectileSpeed = 850, range = 1100, radius = 110, type = "line",  danger = 1},
			["FrostBite"] = {name = "Frost Bite", spellName = "FrostBite", castDelay = 250, projectileName = "cryo_FrostBite_mis.troy", projectileSpeed = 1200, range = 1100, radius = 110, type = "line",  danger = 1},
	}},
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140,  danger = 0}
	}},
		["Katarina"] = {charName = "Katarina", skillshots = {
			["KatarinaR"] = {name = "Death Lotus", spellName = "KatarinaR", range = 550,  danger = 1},
			["KatarinaQ"] = {name = "Bouncing Blades", spellName = "KatarinaQ", range = 675,  danger = 1},
	}}, 
		["Zyra"] = {charName = "Zyra", skillshots = {
			-- ["Deadly Bloom"] = {name = "Deadly Bloom", spellName = "ZyraQFissure", castDelay = 250, projectileName = "zyra_Q_cas.troy", projectileSpeed = 1400, range = 825, radius = 220, type = "circular",  danger = 0},
			["ZyraGraspingRoots"] = {name = "Grasping Roots", spellName = "ZyraGraspingRoots", castDelay = 230, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 1150, range = 1150, radius = 70, type = "line",  danger = 1},
			["zyrapassivedeathmanager"] = {name = "Zyra Passive", spellName = "zyrapassivedeathmanager", castDelay = 500, projectileName = "zyra_passive_plant_mis.troy", projectileSpeed = 2000, range = 1474, radius = 60, type = "line",  danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["Barrel Roll"] = {name = "Barrel Roll", spellName = "GragasBarrelRoll", castDelay = 250, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular",  danger = 0},
			["Barrel Roll Missile"] = {name = "Barrel Roll Missile", spellName = "GragasBarrelRollMissile", castDelay = 0, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular",  danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["GragasExplosiveCask"] = {name = "Ult", spellName="GragasExplosiveCask", blockable=true, danger = 0, range=1050},
			["GragasBarrelRoll"] = {name = "BarrelRoll", spellName="GragasBarrelRoll", blockable=true, danger = 0, range=950}
	}},
		["Nautilus"] = {charName = "Nautilus", skillshots = {
			["NautilusAnchorDrag"] = {name = "Dredge Line", spellName = "NautilusAnchorDrag", castDelay = 250, projectileName = "Nautilus_Q_mis.troy", projectileSpeed = 2000, range = 1080, radius = 80, type = "line",  danger = 1},
	}},
		--[[["Urgot"] = {charName = "Urgot", skillshots = {
			["Acid Hunter"] = {name = "Acid Hunter", spellName = "UrgotHeatseekingLineMissile", castDelay = 175, projectileName = "UrgotLineMissile_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line",  danger = 0},
			["Plasma Grenade"] = {name = "Plasma Grenade", spellName = "UrgotPlasmaGrenade", castDelay = 250, projectileName = "UrgotPlasmaGrenade_mis.troy", projectileSpeed = 1750, range = 900, radius = 250, type = "circular",  danger = 1},
	}},]]--
		["Caitlyn"] = {charName = "Caitlyn", skillshots = {
			["CaitlynPiltoverPeacemaker"] = {name = "Piltover Peacemaker", spellName = "CaitlynPiltoverPeacemaker", castDelay = 625, projectileName = "caitlyn_Q_mis.troy", projectileSpeed = 2200, range = 1300, radius = 90, type = "line",  danger = 0},
			["CaitlynEntrapment"] = {name = "Caitlyn Entrapment", spellName = "CaitlynEntrapment", castDelay = 150, projectileName = "caitlyn_entrapment_mis.troy", projectileSpeed = 2000, range = 950, radius = 80, type = "line",  danger = 1},
			["CaitlynAceintheHole"] = {name = "Ace in the Hole", spellName = "CaitlynAceintheHole", range = 3000,  danger = 1, projectileName = "caitlyn_ult_mis.troy"},
	}},
		["DrMundo"] = {charName = "DrMundo", skillshots = {
			["InfectedCleaverMissile"] = {name = "Infected Cleaver", spellName = "InfectedCleaverMissile", castDelay = 250, projectileName = "dr_mundo_infected_cleaver_mis.troy", projectileSpeed = 2000, range = 1050, radius = 75, type = "line",  danger = 1},
	}},
		["Brand"] = {charName = "Brand", skillshots = { -- Q+ W+
			["BrandBlaze"] = {name = "Blaze", spellName = "BrandBlaze", castDelay = 250, projectileName = "BrandBlaze_mis.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line",  danger = 1},
			["BrandWildfire"] = {name = "BrandWildfire", spellName = "BrandWildfire", castDelay = 250, projectileName = "BrandWildfire_mis.troy", projectileSpeed = 1000, range = 1100, radius = 250, type = "circular",  danger = 0}
	}},
		["Corki"] = {charName = "Corki", skillshots = {
			["MissileBarrage"] = {name = "Missile Barrage", spellName = "MissileBarrage", castDelay = 250, projectileName = "corki_MissleBarrage_mis.troy", projectileSpeed = 2000, range = 1300, radius = 40, type = "line",  danger = 0},
	}},
		["TwistedFate"] = {charName = "TwistedFate", skillshots = {
			["WildCards"] = {name = "Loaded Dice", spellName = "WildCards", castDelay = 250, projectileName = "Roulette_mis.troy", projectileSpeed = 1000, range = 1450, radius = 40, type = "line",  danger = 0},
	}},
		["Swain"] = {charName = "Swain", skillshots = {
			["SwainShadowGrasp"] = {name = "Nevermove", spellName = "SwainShadowGrasp", castDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular",  danger = 1},
			["SwainTorment"] = {name = "SwainTorment", spellName = "SwainTorment", castDelay = 250, projectileName = "swain_torment_mis.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular",  danger = 1}
	}},
		["Cassiopeia"] = {charName = "Cassiopeia", skillshots = {
			["CassiopeiaNoxiousBlast"] = {name = "Noxious Blast", spellName = "CassiopeiaNoxiousBlast", castDelay = 250, projectileName = "CassNoxiousSnakePlane_green.troy", projectileSpeed = 500, range = 850, radius = 130, type = "circular",  danger = 0},
	}},
		["Sivir"] = {charName = "Sivir", skillshots = { --hard to measure speed
			["SivirQ"] = {name = "Boomerang Blade", spellName = "SivirQ", castDelay = 250, projectileName = "Sivir_Base_Q_mis.troy", projectileSpeed = 1350, range = 1175, radius = 101, type = "line",  danger = 0},
	}},
		["Ashe"] = {charName = "Ashe", skillshots = {
			["EnchantedCrystalArrow"] = {name = "Enchanted Arrow", spellName = "EnchantedCrystalArrow", castDelay = 250, projectileName = "EnchantedCrystalArrow_mis.troy", projectileSpeed = 1600, range = 25000, radius = 130, type = "line",  danger = 1},
			["Volley"] = {name = "Volley", spellName = "Volley", range = 1200,  danger = 1},
	}},
		["KogMaw"] = {charName = "KogMaw", skillshots = {
			["KogMawQMis"] = {name = "KogMawQMis", spellName = "KogMawQMis", castDelay = 0, projectileName = "KogMawSpit_mis.troy", projectileSpeed = 1650, range = 1000, radius = 80, type = "line",  danger = 1},
			["KogMawVoidOozeMissile"] = {name = "KogMawVoidOozeMissile", spellName = "KogMawVoidOozeMissile", castDelay = 250, projectileName = "KogMawVoidOozeMissile_mis.troy", projectileSpeed = 1433, range = 1280, radius = 150, type = "line",  danger = 1},			
			["KogMawLivingArtillery"] = {name = "Living Artillery", spellName = "KogMawLivingArtillery", castDelay = 250, projectileName = "KogMawLivingArtillery_mis.troy", projectileSpeed = 1050, range = 2200, radius = 225, type = "circular",  danger = 0},
	}},
		["Khazix"] = {charName = "Khazix", skillshots = {
			["KhazixW"] = {name = "KhazixW", spellName = "KhazixW", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line",  danger = 0},
			--["khazixwlong"] = {name = "khazixwlong", spellName = "khazixwlong", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line",  danger = 0},
	}},
		["Zed"] = {charName = "Zed", skillshots = {
			["ZedShuriken"] = {name = "ZedShuriken", spellName = "ZedShuriken", castDelay = 250, projectileName = "Zed_Q_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line",  danger = 0},
			--["ZedShuriken2"] = {name = "ZedShuriken2", spellName = "ZedShuriken!", castDelay = 250, projectileName = "Zed_Q2_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line",  danger = 0},
	}},
		["Leblanc"] = {charName = "Leblanc", skillshots = {
			["LeblancChaosOrb"] = {name = "Ethereal LeblancChaosOrb", spellName = "LeblancChaosOrb", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis.troy", projectileSpeed = 1600, range = 960, radius = 70,  danger = 1},
			["LeblancChaosOrbM"] = {name = "Ethereal LeblancChaosOrbM", spellName = "LeblancChaosOrbM", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70,  danger = 1},
			["LeblancSoulShackle"] = {name = "Ethereal Chains", spellName = "LeblancSoulShackle", castDelay = 250, projectileName = "leBlanc_shackle_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line",  danger = 1},
			["LeblancSoulShackleM"] = {name = "Ethereal Chains R", spellName = "LeblancSoulShackleM", castDelay = 250, projectileName = "leBlanc_shackle_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line",  danger = 1},
			["LeblancMimic"] = {name = "LeblancMimic", spellName="LeblancMimic", blockable="true", danger = 0, range=650}
	}},
		["Draven"] = {charName = "Draven", skillshots = {
			["DravenDoubleShot"] = {name = "Stand Aside", spellName = "DravenDoubleShot", castDelay = 250, projectileName = "Draven_E_mis.troy", projectileSpeed = 1400, range = 1100, radius = 130, type = "line",  danger = 1},
			["DravenRCast"] = {name = "DravenR", spellName = "DravenRCast", castDelay = 500, projectileName = "Draven_R_mis!.troy", projectileSpeed = 2000, range = 25000, radius = 160, type = "line",  danger = 0},
	}},
		["Elise"] = {charName = "Elise", skillshots = {
			["EliseHumanE"] = {name = "Cocoon", spellName = "EliseHumanE", castDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, type = "line",  danger = 1}
	}},
		["Lulu"] = {charName = "Lulu", skillshots = {
			["LuluQ"] = {name = "LuluQ", spellName = "LuluQ", castDelay = 250, projectileName = "Lulu_Q_Mis.troy", projectileSpeed = 1450, range = 1000, radius = 50, type = "line",  danger = 1}
	}},
		["Thresh"] = {charName = "Thresh", skillshots = {
			["ThreshQ"] = {name = "ThreshQ", spellName = "ThreshQ", castDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1900, range = 1100, radius = 65, type = "line",  danger = 1} -- 60 real radius
	}},
		["Shen"] = {charName = "Shen", skillshots = {
			["ShenShadowDash"] = {name = "ShadowDash", spellName = "ShenShadowDash", castDelay = 0, projectileName = "shen_shadowDash_mis.troy", projectileSpeed = 3000, range = 575, radius = 50, type = "line",  danger = 1}
	}},
		["Quinn"] = {charName = "Quinn", skillshots = {
			["QuinnQ"] = {name = "QuinnQ", spellName = "QuinnQ", castDelay = 250, projectileName = "Quinn_Q_missile.troy", projectileSpeed = 1550, range = 1050, radius = 80, type = "line",  danger = 0}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarPrimordialBurst"] = {name = "VeigarPrimordialBurst", spellName="VeigarPrimordialBurst", projectileName = "permission_Shadowbolt_mis.troy",  danger = 0, range = 650},
			["VeigarBalefulStrike"] = {name = "VeigarBalefulStrike", spellName="VeigarBalefulStrike", projectileName = "permission__mana_flare_mis.troy.troy",  danger = 0, range=650}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarDarkMatter"] = {name = "VeigarDarkMatter", spellName = "VeigarDarkMatter", castDelay = 250, projectileName = "!", projectileSpeed = 900, range = 900, radius = 225, type = "circular",  danger = 0}
	}},
	
		["Diana"] = {charName = "Diana", skillshots = {
			["DianaArc"] = {name = "DianaArc", spellName = "DianaArc", castDelay = 250, projectileName = "Diana_Q_trail.troy", projectileSpeed = 1600, range = 1000, radius = 195, type="circular",  danger = 0},
	}},
		["Jayce"] = {charName = "Jayce", skillshots = {
			["jayceshockblast"] = {name = "jayceshockblast", spellName = "jayceshockblast", castDelay = 250, projectileName = "JayceOrbLightning.troy", projectileSpeed = 1450, range = 1050, radius = 70, type = "line",  danger = 0},
			["Q2"] = {name = "Q2", spellName = "JayceShockBlast", castDelay = 250, projectileName = "JayceOrbLightningCharged.troy", projectileSpeed = 2350, range = 1600, radius = 70, type = "line",  danger = 0},
	}},
		["Nami"] = {charName = "Nami", skillshots = {
			["NamiQ"] = {name = "NamiQ", spellName = "NamiQ", castDelay = 250, projectileName = "Nami_Q_mis.troy", projectileSpeed = 800, range = 850, radius = 225, type="circular",  danger = 1},
			["NamiRMissile"] = {name = "NamiRMissile", spellName = "NamiRMissile", castDelay = 484, projectileName = "Nami_R_Mis.troy", projectileSpeed = 846, range = 2735, radius = 210, type = "line",  danger = 1},
	}},
		["Fizz"] = {charName = "Fizz", skillshots = {
			["FizzMarinerDoom"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", castDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "line",  danger = 1},
	}},
		["Varus"] = {charName = "Varus", skillshots = {
			["VarusQ"] = {name = "Varus Q Missile", spellName = "VarusQ", castDelay = 0, projectileName = "VarusQ_mis.troy", projectileSpeed = 1900, range = 1600, radius = 70, type = "line",  danger = 0},
			["VarusE"] = {name = "Varus E", spellName = "VarusE", castDelay = 250, projectileName = "VarusEMissileLong.troy", projectileSpeed = 1500, range = 925, radius = 275, type = "circular",  danger = 1},
			["VarusR"] = {name = "VarusR", spellName = "VarusR", castDelay = 250, projectileName = "VarusRMissile.troy", projectileSpeed = 1950, range = 1250, radius = 100, type = "line",  danger = 1},
	}},
		["Karma"] = {charName = "Karma", skillshots = {
			["KarmaQ"] = {name = "KarmaQ", spellName = "KarmaQ", castDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 1050, radius = 90, type = "line",  danger = 1},
	}},
		["Aatrox"] = {charName = "Aatrox", skillshots = {--Radius starts from 150 and scales down, so I recommend putting half of it, because you won't dodge pointblank skillshots.
			["AatroxE"] = {name = "Blade of Torment", spellName = "AatroxE", castDelay = 250, projectileName = "AatroxBladeofTorment_mis.troy", projectileSpeed = 1200, range = 1075, radius = 75, type = "line",  danger = 1},
			["AatroxQ"] = {name = "AatroxQ", spellName = "AatroxQ", castDelay = 250, projectileName = "AatroxQ.troy", projectileSpeed = 450, range = 650, radius = 145, type = "circular",  danger = 1},
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathArcanopulse"] = {name = "Xerath Arcanopulse", spellName = "XerathArcanopulse", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1025, radius = 100, type = "line",  danger = 0},
			["xeratharcanopulseextended"] = {name = "Xerath Arcanopulse Extended", spellName = "xeratharcanopulseextended", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1625, radius = 100, type = "line",  danger = 0},
			["xeratharcanebarragewrapper"] = {name = "xeratharcanebarragewrapper", spellName = "xeratharcanebarragewrapper", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1100, radius = 265, type = "circular",  danger = 0},
			["xeratharcanebarragewrapperext"] = {name = "xeratharcanebarragewrapperext", spellName = "xeratharcanebarragewrapperext", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1600, radius = 265, type = "circular",  danger = 0}
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathMageSpearMissile"] = {name = "XerathMageSpearMissile", spellName = "XerathMageSpearMissile",castDelay = 0, projectileName = "Xerath_Base_E_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line",  danger = 1},
			["xerathlocuspulse"] = {name = "xerathlocuspulse", spellName = "xerathlocuspulse",castDelay = 0, projectileName = "Xerath_Base_R_mis.troy", projectileSpeed = 1200, range = 5600, radius = 80, type = "line",  danger = 1},
	}},
		["Velkoz"] = {charName = "Velkoz", skillshots = {
			["VelkozQMissile"] = {name = "VelkozQMissile", spellName = "VelkozQMissile", castDelay = 250, projectileName = "Velkoz_Base_Q_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},		
			["VelkozW"] = {name = "VelkozW", spellName = "VelkozW", castDelay = 250, projectileName = "Velkoz_Base_W_Turret.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line",  danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},		
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "FountainHeal.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_beam.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_Lens.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line",  danger = 1},
	}},	
		["Graves"] = {charName = "Graves", skillshots = {
			["GravesClusterShot"] = {name = "Light Binding", spellName = "GravesClusterShot", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line",  danger = 1},
			["GravesChargeShot"] = {name = "LuxLightStrikeKugel", spellName = "GravesChargeShot", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "line",  danger = 1},
			
	}},	
	
	
		["Lucian"] = {charName = "Lucian", skillshots = {
			["LucianQ"] = {name = "LucianQ", spellName = "LucianQ", castDelay = 350, projectileName = "Lucian_Q_laser.troy", projectileSpeed = math.huge, range = 570*2, radius = 65, type = "line",  danger = 0},
			["LucianW"] = {name = "LucianW", spellName = "LucianW", castDelay = 300, projectileName = "Lucian_W_mis.troy", projectileSpeed = 1600, range = 1000, radius = 80, type = "line",  danger = 0},
	}},
		["Rumble"] = {charName = "Rumble", skillshots = {
			["RumbleGrenade"] = {name = "RumbleGrenade", spellName = "RumbleGrenade", castDelay = 250, projectileName = "rumble_taze_mis.troy", projectileSpeed = 2000, range = 950, radius = 90, type = "line",  danger = 1},
	}},
		["Nocturne"] = {charName = "Nocturne", skillshots = {
			["NocturneDuskbringer"] = {name = "NocturneDuskbringer", spellName = "NocturneDuskbringer", castDelay = 250, projectileName = "NocturneDuskbringer_mis.troy", projectileSpeed = 1400, range = 1125, radius = 60, type = "line",  danger = 0},
	}},
		["MissFortune"] = {charName = "MissFortune", skillshots = {
			["MissFortuneScattershot"] = {name = "Scattershot", spellName = "MissFortuneScattershot", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 800, radius = 200, type = "circular",  danger = 0},
			["MissFortuneBulletTime"] = {name = "Bullettime", spellName = "MissFortuneBulletTime", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 1400, radius = 200, type = "line",  danger = 0}
	}},
		["Orianna"] = {charName = "Orianna", skillshots = {
			--["OrianaIzunaCommand"] = {name = "OrianaIzunaCommand", spellName = "OrianaIzunaCommand!", castDelay = 250, projectileName = "Oriana_Ghost_mis.troy", projectileSpeed = 1200, range = 2000, radius = 80, type = "line",  danger = 0},
	}},
		["Ziggs"] = {charName = "Ziggs", skillshots = { -- Q changed to line in 1.10
			["ZiggsQ"] = {name = "ZiggsQ", spellName = "ZiggsQ", castDelay = 1500, projectileName = "ZiggsQ.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  danger = 0},
			["ZiggsW"] = {name = "ZiggsW", spellName = "ZiggsW", castDelay = 250, projectileName = "ZiggsW_mis.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  danger = 0},
			["ZiggsE"] = {name = "ZiggsE", spellName = "ZiggsE", castDelay = 250, projectileName = "ZiggsEMine.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line",  danger = 0},
			["ZiggsR"] = {name = "ZiggsR", spellName = "ZiggsR", projectileName = "ZiggsR_Mis_Nuke.troy", range = 1500, unBlockable = true,  danger = 0}
	}},
		["Galio"] = {charName = "Galio", skillshots = {
			["GalioResoluteSmite"] = {name = "Resolute smite", spellName = "GalioResoluteSmite", castDelay = 250, projectileName = "galio_concussiveBlast_mis.troy", projectileSpeed = 850, range = 2000, radius = 200, type = "circular",  danger = 1},
			["GalioRighteousGust"] = {name = "Righteous gust", spellName = "GalioRighteousGust", castDelay = 0.5, projectileName = "galio_windTunnel_mis_02.troy", projectileSpeed = 1200, range = 1180, radius = 140, type = "line",  danger = 1}
	}},
		["Yasuo"] = {charName = "Yasuo", skillshots = {
			["yasuoq3w"] = {name = "Steel Tempest", spellName = "yasuoq3w", castDelay = 300, projectileName = "Yasuo_Q_wind_mis.troy", projectileSpeed = 1200, range = 900, radius = 375, type = "line",  danger = 1},
	}},
		["Kassadin"] = {charName = "Kassadin", skillshots = {
			["NullLance"] = {name = "Null Sphere", spellName = "NullLance", castDelay = 300, projectileName = "Null_Lance_mis.troy", projectileSpeed = 1400, range = 650, radius = 1, type = "line",  danger = 1},
	}},
		["Jinx"] = {charName = "Jinx", skillshots = { -- R speed and delay increased
			["JinxWMissile"] = {name = "Zap", spellName = "JinxWMissile", castDelay = 600, projectileName = "Jinx_W_mis.troy", projectileSpeed = 3300, range = 1450, radius = 70, type = "line",  danger = 1},
			["JinxRWrapper"] = {name = "Super Mega Death Rocket", spellName = "JinxRWrapper", castDelay = 600+900, projectileName = "Jinx_R_Mis.troy", projectileSpeed = 2500, range = 20000, radius = 120, type = "line",  danger = 0}
	}},
		["Taric"] = {charName = "Taric", skillshots = {
			["Dazzle"] = {name = "Dazzle", spellName="Dazzle", blockable=true, danger = 0, range=625},
	}},
		["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
			["FiddlesticksDarkWind"] = {name = "DarkWind", spellName="FiddlesticksDarkWind", blockable=true, danger = 0, range=750},
	}}, 
		["Syndra"] = {charName = "Syndra", skillshots = { -- Q added in 1.10
			["SyndraQ"] = {name = "Q", spellName = "SyndraQ", castDelay = 250, projectileName = "Syndra_Q_cas.troy", projectileSpeed = 500, range = 800, radius = 175, type = "circular",  danger = 0},
			["SyndraR"] = {name = "SyndraR", spellName="SyndraR", blockable=true, danger = 0, range=675}
	}},
		["Kayle"] = {charName = "Kayle", skillshots = {
			["JudicatorReckoning"] = {name = "JudicatorReckoning", spellName="JudicatorReckoning", castDelay = 100, projectileName = "Reckoning_mis.troy", projectileSpeed = 1500, range = 875, danger = 1, range=650},
	}},
		["Heimerdinger"] = {charName = "Heimerdinger", skillshots = {
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 250, projectileName = "Heimerdinger_Base_w_Mis.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 260, projectileName = "Heimerdinger_Base_W_Mis_Ult.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},		
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "StormGrenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "StormGrenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis_Ult.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},		
	}}, 
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140,  danger = 1}
	}},
		["Janna"] = {charName = "Janna", skillshots = {
			["HowlingGale"] = {name = "HowlingGale", spellName = "HowlingGale", castDelay = 250, projectileName = "HowlingGale_mis.troy", projectileSpeed = 1200, range = 1500, radius = 140,  danger = 1}
	}},
		["Lissandra"] = {charName = "Lissandra", skillshots = {
			["LissandraQMissile"] = {name = "LissandraQMissile", spellName = "LissandraQMissile", castDelay = 250, projectileName = "Lissandra_Q_mis.troy", projectileSpeed = 2160, range = 1300, radius = 80, type = "line",  danger = 1},
			["LissandraEMissile"] = {name = "LissandraEMissile", spellName = "LissandraEMissile", castDelay = 250, projectileName = "Lissandra_E_mis.troy", projectileSpeed = 850, range = 1000, radius = 275, type = "line",  danger = 1},
			["LissandraW"] = {name = "LissandraW", spellName = "LissandraW", castDelay = 10, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 3850, range = 430, radius = 275, type = "line",  danger = 1},
			
	}},	
	
		["Riven"] = {charName = "Riven", skillshots = {
			["rivenizunablade"] = {name = "rivenizunablade", spellName = "rivenizunablade", castDelay = 234, projectileName = "Riven_Base_R_Mis_Middle.troy", projectileSpeed = 2210, range = 1000, radius = 180, type = "line",  danger = 1}
	}},		
	
		["Pantheon"] = {charName = "Pantheon", skillshots = {
			["Pantheon_Throw"] = {name = "Pantheon_Throw", spellName = "Pantheon_Throw", castDelay = 250, projectileName = "pantheon_spear_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  danger = 1}
	}},
	
		["Sejuani"] = {charName = "Sejuani", skillshots = {
			["SejuaniGlacialPrisonCast"] = {name = "SejuaniGlacialPrisonCast", spellName = "SejuaniGlacialPrisonCast", castDelay = 249, projectileName = "Sejuani_R_mis.troy", projectileSpeed = 1628, range = 1100, radius = 250, type = "line",  danger = 1}
	}},	
		["Ryze"] = {charName = "Ryze", skillshots = {
			["Overload"] = {name = "Overload", spellName = "Overload", castDelay = 250, projectileName = "Overload_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  danger = 1},
			["SpellFlux"] = {name = "SpellFlux", spellName = "SpellFlux", castDelay = 250, projectileName = "SpellFlux_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  danger = 1}
	}},
		["Malphite"] = {charName = "Malphite", skillshots = {
			["SeismicShard"] = {name = "SeismicShard", spellName = "SeismicShard", castDelay = 250, projectileName = "SeismicShard_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140,  danger = 1}
	}},
		["Sona"] = {charName = "Sona", skillshots = {
			["SonaHymnofValor"] = {name = "SonaHymnofValor", spellName = "SonaHymnofValor", castDelay = 250, projectileName = "SonaHymnofValor_beam.troy", projectileSpeed = 1500, range = 1500, radius = 140,  danger = 1},
			["SonaCrescendo"] = {name = "SonaCrescendo", spellName = "SonaCrescendo", castDelay = 250, projectileName = "SonaCrescendo_mis.troy", projectileSpeed = 1500, range = 1500, radius = 500,  danger = 1}
	}},
		["Teemo"] = {charName = "Teemo", skillshots = {
			["BlindingDart"] = {name = "BlindingDart", spellName = "BlindingDart", castDelay = 250, projectileName = "BlindShot_mis.troy", projectileSpeed = 1500, range = 680, radius = 450,  danger = 1}
	}},
		["Vayne"] = {charName = "Vayne", skillshots = {
			["VayneCondemn"] = {name = "VayneCondemn", spellName = "VayneCondemn", castDelay = 250, projectileName = "vayne_E_mis.troy", projectileSpeed = 1200, range = 550, radius = 450,  danger = 1}
	}},
}
---------------------------------------
--			  Callbacks			     --
---------------------------------------
function OnLoad()
	Vars()
	updateScript()
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
	if vladCFG.combo.comboKey then
		Combo(target)
	end
	if vladCFG.harass.harassToggle then
		Harass(target)
	end
	if vladCFG.laneclear.lcKey then
		Laneclear()
	end
	if vladCFG.KS.ksToggle then
		Ks()
	end
	if vladCFG.autoE.eAutoKey then
		eAuto()
	end
	if vladCFG.draw.Lfc then _G.DrawCircle = DrawCircle2 else _G.DrawCircle = _G.oldDrawCircle end
end
---------------------------------------
--			   Drawings				 --
---------------------------------------
function OnDraw()
	if not myHero.dead then
		if QSpell.ready and vladCFG.draw.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, QSpell.range, color)
		end
		if RSpell.ready and vladCFG.draw.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, RSpell.range, color)
		end
		if vladCFG.draw.cTarget then
			if ValidTarget(target) and not target.dead then
				DrawCircle(target.x, target.y, target.z, 90, 0xF0FFFF)
				DrawCircle(target.x, target.y, target.z, 100, 0xF0FFFF)
				DrawCircle(target.x, target.y, target.z, 110, 0xF0FFFF)
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
    DrawCircleNextLvl(x, y, z, radius, vladCFG.draw.Width, color, vladCFG.draw.CL) 
  end
end
---------------------------------------
--			  Functions				 --
---------------------------------------
function Menu()
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 700, DAMAGE_MAGIC)
	vladCFG = scriptConfig("VladimirMadness", "VKQ")
	VP = VPrediction()
	SxOrb = SxOrbWalk(VP)
	
		vladCFG:addSubMenu(myHero.charName.." - Combo", "combo")
			vladCFG.combo:addSubMenu("Q Config", "qConfig")
				vladCFG.combo.qConfig:addParam("qUse", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			vladCFG.combo:addSubMenu("E Config", "eConfig")
				vladCFG.combo.eConfig:addParam("eUse", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			vladCFG.combo:addSubMenu("R Config", "rConfig")
				vladCFG.combo.rConfig:addParam("rUse", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
				vladCFG.combo.rConfig:addParam("mnChamp", "Min. Champ to use R", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
			vladCFG.combo:addParam("useItem", "Use Items in combo", SCRIPT_PARAM_ONOFF, true)
			vladCFG.combo:addParam("comboKey", "Combo key (space)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
			
		vladCFG:addSubMenu(myHero.charName.." - Harass", "harass")
			vladCFG.harass:addParam("qHarass", "Use Q in harass", SCRIPT_PARAM_ONOFF, true)
			vladCFG.harass:addParam("eHarass", "Use E in harass", SCRIPT_PARAM_ONOFF, true)
			vladCFG.harass:addParam("manaHarass", "Min. mana to harass", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			vladCFG.harass:addParam("harassToggle", "Harass toggle key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			
		vladCFG:addSubMenu(myHero.charName.." - Laneclear", "laneclear")
			vladCFG.laneclear:addParam("qLc", "Use Q in laneclear", SCRIPT_PARAM_ONOFF, true)
			vladCFG.laneclear:addParam("eLc", "Use E in laneclear", SCRIPT_PARAM_ONOFF, true)
			vladCFG.laneclear:addParam("manaClear", "Min. mana to laneclear", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
			vladCFG.laneclear:addParam("lcKey", "Laneclear key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		
		vladCFG:addSubMenu(myHero.charName.." - KS", "KS")
			vladCFG.KS:addParam("qKS", "KS with Q", SCRIPT_PARAM_ONOFF, true)
			vladCFG.KS:addParam("eKS", "KS with E", SCRIPT_PARAM_ONOFF, true)
			if Ignite.slot ~= nil then
				vladCFG.KS:addParam("iKS", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)
			end
			vladCFG.KS:addParam("ksToggle", "KS toggle key(H)", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("H"))
		
		vladCFG:addSubMenu(myHero.charName.." - Auto W", "autoW")
			vladCFG.autoW:addSubMenu("When skillshot incoming", "skillInc")
				vladCFG.autoW.skillInc:addParam("wSkillInc", "W when skillshot incoming", SCRIPT_PARAM_ONOFF, true)
				vladCFG.autoW.skillInc:addParam("wSkillIncHp", "% hp left to W skillshot", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
				vladCFG.autoW.skillInc:addParam("qqq","--- Hero Skillshot to dodge ---", SCRIPT_PARAM_INFO, "")
				for i, hero in pairs(GetEnemyHeroes()) do
					if Champions[hero.charName] ~= nil then
						for index, skillshot in pairs(Champions[hero.charName].skillshots) do
							vladCFG.autoW.skillInc:addParam(skillshot.spellName, hero.charName.." - "..skillshot.name, SCRIPT_PARAM_ONOFF, true)
						end
					end
				end
				vladCFG.autoW:addParam("autoWkey", "Auto W key toggle(T)", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("T"))
		
		vladCFG:addSubMenu(myHero.charName.." - Auto E", "autoE")
			vladCFG.autoE:addParam("eAutoUse", "Auto E to keep 4 stacks", SCRIPT_PARAM_ONOFF, true)
			vladCFG.autoE:addParam("eAutoKey", "Auto E toggle key(G)", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("G"))
		
		vladCFG:addSubMenu(myHero.charName.." - Drawings", "draw")
			vladCFG.draw:addParam("qDraw", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
			vladCFG.draw:addParam("rDraw", "Draw R range", SCRIPT_PARAM_ONOFF, true)
			vladCFG.draw:addParam("cTarget", "Draw Target", SCRIPT_PARAM_ONOFF, true)
			vladCFG.draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
			vladCFG.draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
			vladCFG.draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
			
		vladCFG:addTS(ts)
			ts.name = "Vladimir -"
			
		if SACLoaded then
			vladCFG:addParam("qqq","SAC Detected", SCRIPT_PARAM_INFO, "")
		elseif MMALOADED then
			vladCFG:addParam("qqq","MMA Detected", SCRIPT_PARAM_INFO, "")
		else
			vladCFG:addSubMenu(myHero.charName.." - Orbwalker", "SxOrb")
				SxOrb:LoadToMenu(vladCFG.SxOrb)
		end	
		vladCFG.combo:permaShow("comboKey")
		vladCFG.laneclear:permaShow("lcKey")
		vladCFG.harass:permaShow("harassToggle")
		vladCFG.KS:permaShow("ksToggle")
		vladCFG.autoW:permaShow("autoWkey")
		vladCFG.autoE:permaShow("eAutoKey")
end
function Vars()
	QSpell = { name = "Transfusion", range = 600, delay = nil, speed = nil, radius = nil, ready = false, }
	WSpell = { name = "Sanguine Pool", range = nil, delay = nil, speed = nil, radius = 150, ready = false }
	ESpell = { name = "Tides of Blood", range = 600, delay = nil, speed = nil, radius = nil, ready = false }
	RSpell = { name = "Hemoplague", range = 620, delay = 0, speed = math.huge, radius = 165, ready = false }
	Ignite = { name = "summonerdot", range = 600, slot = nil, ready = false }
	
	EnemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_HEALTH_ASC)
	JungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
	
	PrintChat ("<font color=\"#33CC99\"><b>VladimirMadness by Kqmii</b></font>"..currentVersion.."<font color=\"#33CC99\"><b>Loaded</b></font>")
	PrintChat ("<b>Report any problem by pm to kqmii on bol</b>")
	
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then Ignite.slot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then Ignite.slot = SUMMONER_2 end
	
	local ts
	local SACLoaded, MMALOADED = nil, nil
	local target = nil
	require 'SxOrbwalk'
	require 'VPrediction'
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end
function DetectOrbwalker()
	if _G.MMA_LOADED then
		PrintChat("VladimirMadness : MMA Detected")
		MMALoaded = true
	elseif _G.Reborn_Loaded then
		PrintChat("VladimirMadness : SAC Detected")
		SACLoaded = true
	else
		PrintChat("VladimirMadness : SxOrb Loaded")
		Sxo = true
	end	
end
function Checks()
	QSpell.ready = (myHero:CanUseSpell(_Q) == READY)
	WSpell.ready = (myHero:CanUseSpell(_W) == READY)
	ESpell.ready = (myHero:CanUseSpell(_E) == READY)
	RSpell.ready = (myHero:CanUseSpell(_R) == READY)
	Ignite.ready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	EnemyMinions:update()
	JungleMinions:update()
end
function CustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 900) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
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
		local minD = 200
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and not unit.dead then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
				end
			end
		end
		if target and minD < 200 then
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
				print("Target unselected")
			else
				SelectedTarget = target
				print("Target Selected: "..SelectedTarget.charName)
			end
		end
	end
end
function UseItems(target)
	if target ~= nil and not UltON then
		for _, item in pairs(Items) do
			item.slot = GetInventorySlotItem(item.id)
			if item.slot ~= nil then
				if item.reqTarget and GetDistance(target) < item.range then
					CastSpell(item.slot, target)
				elseif not item.reqTarget then
					if GetDistance(target) < item.range then
						CastSpell(item.slot)
					end
				end
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
function OnProcessSpell(object, spellProc)
	if myHero.dead then return end
	if vladCFG.autoW.autoWkey then
		if object.team ~= player.team and string.find(spellProc.name, "Basic") == nil then
			if Champions[object.charName] ~= nil then
				skillshot = Champions[object.charName].skillshots[spellProc.name]
				if skillshot ~= nil then
					range = skillshot.range
					if not spellProc.startPos then
						spellProc.startPos.x = object.x
						spellProc.startPos.z = object.z
					end
					if GetDistance(spellProc.startPos) <= range then
						if vladCFG.autoW.skillInc[spellProc.name] then
							if WSpell.ready then
								if spellProc.endPos.x ~= myHero.x+20 and spellProc.endPos.z ~= myHero.z+20 and vladCFG.autoW.skillInc.wSkillInc and HpCheck(myHero, vladCFG.autoW.skillInc.wSkillIncHp) then
									CastSpell(_W)
								end
							end
						end
					end
				end
			end
		end
	end
end
function Combo(target)
	if vladCFG.combo.useItem then
		UseItems(target)
	end
	if vladCFG.combo.qConfig.qUse then
		qSpell(target)
	end
	if vladCFG.combo.eConfig.eUse then
		eSpell(target)
	end
	if vladCFG.combo.rConfig.rUse then
		rSpell(target)
	end
end
function Harass(target)
	if not ManaCheck(myHero, vladCFG.harass.manaHarass) then
		if vladCFG.harass.qHarass then
			qSpell(target)
		end
		if vladCFG.harass.eHarass then
			eSpell(target)
		end
	end
end
function Laneclear()
	if not ManaCheck(myHero, vladCFG.laneclear.manaClear) then
		if vladCFG.laneclear.qLc then
			qFarm()
		end
		if vladCFG.laneclear.eLc then
			eFarm()
		end
	end
end
function Ks()
	if vladCFG.KS.qKS then
		qKs()
	end
	if vladCFG.KS.eKS then
		eKs()
	end
	if Ignite.slot ~= nil and vladCFG.KS.iKS then
		iKs()
	end
end
---------------------------------------
--			Spells config            --
---------------------------------------
function qSpell(target)
	if ValidTarget(target) and target.visible and not target.dead then
		if GetDistance(target) < QSpell.range and QSpell.ready then
			CastSpell(_Q, target)
		end
	end
end
function eSpell(target)
	if ValidTarget(target) and target.visible and not target.dead then
		if GetDistance(target) < ESpell.range and ESpell.ready then
			CastSpell(_E)
		end
	end
end
function rSpell(target)
	if ValidTarget(target) and target.visible and not target.dead then
		if RSpell.ready then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, RSpell.delay, RSpell.radius, RSpell.range, RSpell.speed, myHero)
			if MainTargetHitChance >= 2 and GetDistance(AOECastPosition) < RSpell.range and nTargets >= vladCFG.combo.rConfig.mnChamp then
				CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
			end
		end
	end	
end
---------
function qFarm()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and minion.visible and not minion.dead then
			if GetDistance(minion) < QSpell.range and QSpell.ready then
				CastSpell(_Q, minion)
			end
		end
	end
	for i, minions in pairs(JungleMinions.objects) do
		if minions ~= nil and minions.visible and not minions.dead then
			if GetDistance(minions) < QSpell.range and QSpell.ready  then
				CastSpell(_Q, minions)
			end
		end
	end
end
function eFarm()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and minion.visible and not minion.dead then
			if GetDistance(minion) < ESpell.range and ESpell.ready then
				CastSpell(_E, minion)
			end
		end
	end
	for i, minions in pairs(JungleMinions.objects) do
		if minions ~= nil and minions.visible and not minions.dead then
			if GetDistance(minions) < ESpell.range and ESpell.ready then
				CastSpell(_E, minions)
			end
		end
	end
end
---------
function qKs()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		local qDmg = getDmg("Q", enemy, myHero)
		if enemy ~= nil and enemy.team ~= myHero.team and enemy.visible and not enemy.dead then
			if QSpell.ready and GetDistance(enemy) < QSpell.range and ValidTarget(enemy) then
				if enemy.health < qDmg then
					CastSpell(_Q, enemy)
				end
			end
		end
	end
end
function eKs()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		local eDmg = getDmg("E", enemy, myHero)
		if enemy ~= nil and enemy.team ~= myHero.team and enemy.visible and not enemy.dead then
			if ESpell.ready and GetDistance(enemy) < ESpell.range and ValidTarget(enemy) then
				if enemy.health < eDmg then
					CastSpell(_E, enemy)
				end
			end
		end
	end		
end
function iKs()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		local iDmg = 50 + (20 * myHero.level)
		if enemy ~= nil and enemy.visible and enemy.team ~= myHero.team and not enemy.dead then
			if Ignite.slot ~= nil and Ignite.ready and ValidTarget(enemy) and GetDistance(enemy) < Ignite.range then
				if enemy.health < iDmg then
					CastSpell(Ignite.slot, enemy)
				end
			end
		end
	end
end
--------
function eAuto()
	if vladCFG.autoE.eAutoUse then
		if ESpell.ready then
			CastSpell(_E)
		end
	end
end
---------------------------------------
--		 Custom target arranger      --
---------------------------------------
TargetTable ={
				AP = {"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus", "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"},
				Support = {"Alistar", "Blitzcrank","Bard", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"},
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
	SxUpdate(currentVersion, "raw.githubusercontent.com", "/kqmii/BolScripts/master/VladimirMadness.version", "/kqmii/BolScripts/master/VladimirMadness.lua", SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
		function(NewVersion) 
			if NewVersion > currentVersion then 
				print("<font color=\"#F0Ff8d\"><b>VladimirMadness: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") 
			else 
				print("<font color=\"#F0Ff8d\"><b>VladimirMadness: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") 
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
