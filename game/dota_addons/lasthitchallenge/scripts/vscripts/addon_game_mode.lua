_G.seconds = 0 --600 = 10 minutes
_G.MAXTIME = 600 -- seconds
_G.total_time = 0
_G.shortest_time = MAXTIME
_G.longest_time = 0
_G.current_cs = { lh = 0, dn = 0 }
_G.total_misses = 0
_G.session_cs = 0
_G.misses = 0
_G.restarts = 0
--_G.tower_invulnerable = true
_G.radiant_tower = nil
_G.dire_tower = nil
_G.timer = nil
--_G.particle_aura = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_aura.vpcf"

--good
_G.particle_aura = "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"

--_G.particle_aura = "particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff_glow.vpcf"
--_G.particle_aura = "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf"
--_G.particle_aura = "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_debuff_jewel.vpcf"
--_G.particle_aura = "particles/items2_fx/satanic_buff.vpcf"
--_G.particle_aura = "particles/units/heroes/hero_leshrac/leshrac_ambient_glow.vpcf"

--_G.particle_aura = "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
--_G.particle_aura = "particles/units/heroes/hero_morphling/morphling_morph_agi_ring.vpcf"
--_G.particle_aura = "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
--_G.particle_aura = "particles/units/heroes/hero_morphling/morphling_morph_str_ring.vpcf"


if CLastHitChallenge == nil then
  _G.CLastHitChallenge = class({}) -- put CLastHitChallenge in the global scope
  --refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

require( "util" )
require( "events" )


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheUnitByNameSync( "npc_dota_hero_nevermore", context )
	PrecacheUnitByNameSync( "npc_dota_hero_storm_spirit", context )
	PrecacheUnitByNameSync( "npc_dota_hero_templar_assassin", context )
	PrecacheUnitByNameSync( "npc_dota_hero_tinker", context )
	PrecacheUnitByNameSync( "npc_dota_hero_invoker", context )
	PrecacheUnitByNameSync( "npc_dota_hero_obsidian_destroyer", context )
	PrecacheUnitByNameSync( "npc_dota_hero_queenofpain", context )
	PrecacheUnitByNameSync( "npc_dota_hero_puck", context )
	PrecacheUnitByNameSync( "npc_dota_hero_death_prophet", context )
	PrecacheUnitByNameSync( "npc_dota_hero_leshrac", context )
	PrecacheUnitByNameSync( "npc_dota_hero_ember_spirit", context )
	PrecacheUnitByNameSync( "npc_dota_hero_lina", context )
	PrecacheUnitByNameSync( "npc_dota_hero_viper", context )
	PrecacheUnitByNameSync( "npc_dota_hero_magnataur", context )
	PrecacheUnitByNameSync( "npc_dota_hero_sniper", context )
	PrecacheUnitByNameSync( "npc_dota_hero_dragon_knight", context )
	PrecacheUnitByNameSync( "npc_dota_hero_kunkka", context )
	PrecacheUnitByNameSync( "npc_dota_hero_brewmaster", context )
	PrecacheUnitByNameSync( "npc_dota_hero_night_stalker", context )
	PrecacheUnitByNameSync( "npc_dota_hero_huskar", context )
	PrecacheUnitByNameSync( "npc_dota_hero_tiny", context )
	PrecacheUnitByNameSync( "npc_dota_hero_windrunner", context )
	PrecacheUnitByNameSync( "npc_dota_hero_zuus", context )
	PrecacheUnitByNameSync( "npc_dota_neutral_satyr_soulstealer", context)
	PrecacheResource( "particle", particle_aura, context )

	PrecacheResource("model_folder", "models/items/nevermore", context)
	PrecacheResource("model_folder", "models/items/shadow_fiend", context)
	PrecacheResource("model_folder", "models/items/storm_spirit", context)
	PrecacheResource("model_folder", "models/items/lanaya", context)
	PrecacheResource("model_folder", "models/items/tinker", context)
	PrecacheResource("model_folder", "models/items/invoker", context)
	PrecacheResource("model_folder", "models/items/obsidian_destroyer", context)
	PrecacheResource("model_folder", "models/items/queenofpain", context)
	PrecacheResource("model_folder", "models/items/puck", context)
	PrecacheResource("model_folder", "models/items/death_prophet", context)
	PrecacheResource("model_folder", "models/items/leshrac", context)
	PrecacheResource("model_folder", "models/items/ember_spirit", context)
	PrecacheResource("model_folder", "models/items/lina", context)
	PrecacheResource("model_folder", "models/items/magnataur", context)
	PrecacheResource("model_folder", "models/items/sniper", context)
	PrecacheResource("model_folder", "models/items/dragon_knight", context)
	PrecacheResource("model_folder", "models/items/kunkka", context)
	PrecacheResource("model_folder", "models/items/brewmaster", context)
	PrecacheResource("model_folder", "models/items/night_stalker", context)
	PrecacheResource("model_folder", "models/items/huskar", context)
	PrecacheResource("model_folder", "models/items/tiny", context)
	PrecacheResource("model_folder", "models/items/windrunner", context)
	PrecacheResource("model_folder", "models/items/zeus", context)

	PrecacheResource("particle_folder", "particles/econ/items/nevermore", context)
	PrecacheResource("particle_folder", "particles/econ/items/shadow_fiend", context)
	PrecacheResource("particle_folder", "particles/econ/items/storm_spirit", context)
	PrecacheResource("particle_folder", "particles/econ/items/templar_assassin", context)
	PrecacheResource("particle_folder", "particles/econ/items/tinker", context)
	PrecacheResource("particle_folder", "particles/econ/items/invoker", context)
	PrecacheResource("particle_folder", "particles/econ/items/obsidian_destroyer", context)
	PrecacheResource("particle_folder", "particles/econ/items/outworld_devourer", context)
	PrecacheResource("particle_folder", "particles/econ/items/queenofpain", context)
	PrecacheResource("particle_folder", "particles/econ/items/puck", context)
	PrecacheResource("particle_folder", "particles/econ/items/death_prophet", context)
	PrecacheResource("particle_folder", "particles/econ/items/leshrac", context)
	PrecacheResource("particle_folder", "particles/econ/items/ember_spirit", context)
	PrecacheResource("particle_folder", "particles/econ/items/lina", context)
	PrecacheResource("particle_folder", "particles/econ/items/magnataur", context)
	PrecacheResource("particle_folder", "particles/econ/items/sniper", context)
	PrecacheResource("particle_folder", "particles/econ/items/dragon_knight", context)
	PrecacheResource("particle_folder", "particles/econ/items/kunkka", context)
	PrecacheResource("particle_folder", "particles/econ/items/brewmaster", context)
	PrecacheResource("particle_folder", "particles/econ/items/night_stalker", context)
	PrecacheResource("particle_folder", "particles/econ/items/huskar", context)
	PrecacheResource("particle_folder", "particles/econ/items/tiny", context)
	PrecacheResource("particle_folder", "particles/econ/items/windrunner", context)
	PrecacheResource("particle_folder", "particles/econ/items/zeus", context)
end

function end_game_func()
	CLastHitChallenge:EndGame()
end

function quit_game_func()
	SendToServerConsole("disconnect")
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CLastHitChallenge()
	GameRules.AddonTemplate:InitGameMode()
end

function CLastHitChallenge:InitGameMode()
	GameRules:SetPreGameTime(0.0)
	GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_nevermore" )

	CLastHitChallenge:InitilizeData()

	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetPostGameTime( 1.0 )
	GameRules:SetCustomVictoryMessageDuration( 1.0 )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )
	
	GameRules:SetUseUniversalShopMode( false )
	
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( true )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_HEROES, false )
	--[[
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_SCOREBOARD, false )	
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_ACTION_PANEL, true )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_ACTION_MINIMAP, true )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_PANEL, true )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_ITEMS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_SHOP, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_GOLD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_PROTECT, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_COURIER, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS, false )
	]]

	Convars:RegisterCommand( "endgame", end_game_func, "Ends the game", FCVAR_CHEAT)
	Convars:RegisterCommand( "quitgame", quit_game_func, "Quit the game", FCVAR_CHEAT)


	--ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(CLastHitChallenge, 'OnHeroPicked' ), self)
	--ListenToGameEvent("last_hit", Dynamic_Wrap(CLastHitChallenge, 'OnLastHit'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CLastHitChallenge, 'OnEntityKilled'), self)
	ListenToGameEvent("entity_hurt", Dynamic_Wrap(CLastHitChallenge, 'OnHurt'), self) -- Listener for detecting tower damage.
	CustomGameEventManager:RegisterListener("restart", Dynamic_Wrap(CLastHitChallenge, 'OnRestart'))
	CustomGameEventManager:RegisterListener("hidehelp", Dynamic_Wrap(CLastHitChallenge, 'OnHideHelp'))
	CustomGameEventManager:RegisterListener("disable_leveling", Dynamic_Wrap(CLastHitChallenge, 'OnDisableLeveling'))
	CustomGameEventManager:RegisterListener("hero_picked", Dynamic_Wrap(CLastHitChallenge, 'OnHeroPicked'))
	CustomGameEventManager:RegisterListener("time_picked", Dynamic_Wrap(CLastHitChallenge, 'OnTimePicked'))
	CustomGameEventManager:RegisterListener("quit", Dynamic_Wrap(CLastHitChallenge, 'OnQuit'))
	CustomGameEventManager:RegisterListener("repick", Dynamic_Wrap(CLastHitChallenge, 'OnRepick'))
end

function CLastHitChallenge:InitilizeData()
	  	-- Populating tables
	--Totals
	CustomNetTables:SetTableValue("stats_totals", "stats_total_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_dn", { value = 0} )

	--Streaks
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_dn", { value = 0} )

	--Records
	local records_acc = CustomNetTables:GetTableValue( "stats_records", "stats_record_accuracy")
	if (records_acc == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_accuracy", { value = 0} )
	end
	--230

	local hero_list = {"npc_dota_hero_nevermore",
						"npc_dota_hero_storm_spirit",
						"npc_dota_hero_templar_assassin",
						"npc_dota_hero_tinker",
						"npc_dota_hero_invoker",
						"npc_dota_hero_obsidian_destroyer",
						"npc_dota_hero_queenofpain",
						"npc_dota_hero_puck",
						"npc_dota_hero_death_prophet",
						"npc_dota_hero_leshrac",
						"npc_dota_hero_ember_spirit",
						"npc_dota_hero_lina",
						"npc_dota_hero_viper",
						"npc_dota_hero_magnataur",
						"npc_dota_hero_sniper",
						"npc_dota_hero_dragon_knight",
						"npc_dota_hero_kunkka",
						"npc_dota_hero_brewmaster",
						"npc_dota_hero_night_stalker",
						"npc_dota_hero_huskar",
						"npc_dota_hero_tiny",
						"npc_dota_hero_windrunner",
						"npc_dota_hero_zuus",
						"npc_dota_hero_jakiro"
					}
	local time_list = {"150", "300", "450", "600"}
	local type_list = {"cs", "lh", "dn"}
	local level_list = {"lvl", "nolvl"}

	for i, typescore in pairs(type_list) do
		for j, time in pairs(time_list) do
			for k, hero in pairs(hero_list) do
				for l, level in pairs(level_list) do
					local record = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_150")
					if (record == nil) then
						CustomNetTables:SetTableValue("stats_records", "stats_record_" .. typescore .. "_" .. hero .. "_" .. time  .. "_" .. level, { value = 0} )
					end
				end
			end
		end
	end

	--[[
	local records_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_150")
	if (records_cs == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_cs_150", { value = 0} )
	end
	local records_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_150")
	if (records_lh == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_lh_150", { value = 0} )
	end
	local records_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_150")
	if (records_dn == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_dn_150", { value = 0} )
	end
	--500
	local records_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_300")
	if (records_cs == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_cs_300", { value = 0} )
	end
	local records_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_300")
	if (records_lh == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_lh_300", { value = 0} )
	end
	local records_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_300")
	if (records_dn == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_dn_300", { value = 0} )
	end
	--730
	local records_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_450")
	if (records_cs == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_cs_450", { value = 0} )
	end
	local records_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_450")
	if (records_lh == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_lh_450", { value = 0} )
	end
	local records_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_450")
	if (records_dn == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_dn_450", { value = 0} )
	end
	--1000
	local records_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_600")
	if (records_cs == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_cs_600", { value = 0} )
	end
	local records_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_600")
	if (records_lh == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_lh_600", { value = 0} )
	end
	local records_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_600")
	if (records_dn == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_dn_600", { value = 0} )
	end
	]]


	CustomNetTables:SetTableValue( "stats_records", "stats_accuracy_cs", { value = 100 } )
	CustomNetTables:SetTableValue( "stats_records", "stats_accuracy_lh", { value = 100 } )
	CustomNetTables:SetTableValue( "stats_records", "stats_accuracy_dn", { value = 100 } )	

	-- Total Details
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_melee_lh", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_melee_dn", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_melee_miss_friendly", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_melee_miss_foe", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_ranged_lh", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_ranged_dn", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_ranged_miss_friendly", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_ranged_miss_foe", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_siege_lh", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_siege_dn", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_siege_miss_friendly", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_siege_miss_foe", { value = 0 } )
	--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_lh", { value = 0 } )
	--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_dn", { value = 0 } )
	--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_friendly", { value = 0 } )
	--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_foe", { value = 0 } )
end