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

--Thanks to https://github.com/Elinea/dota2-StorageAPI
require('storageapi/json')
require('storageapi/storage')


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

function giffpower()
	 CLastHitChallenge:GiveBlinkDagger(PlayerResource:GetPlayer(0):GetAssignedHero())
end

function pause()
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	else
		PauseGame(true)
	end
end

function getrecords()
	Storage:Get("58169609", function( resultTable, successBool )
	    if successBool then
	    	DeepPrintTable(resultTable)
	        --for k,v in pairs(resultTable) do
	        --	CustomNetTables:SetTableValue("stats_records", v.k, { value = v.v} )
	        --end
	    end
	end)
end

function setrecords()
	local hero_list = {"11"}
	local time_list = {"150"}
	local type_list = {"c", "l", "d", "a"}
	local level_list = {"l"}

	local data = {}

	for i, typescore in pairs(type_list) do
		for j, time in pairs(time_list) do
			for k, hero in pairs(hero_list) do
				for l, level in pairs(level_list) do
					local table_name = typescore ..  hero ..  time .. level
					table.insert(data, {hero = hero, time = time, leveling = level, typescore = typescore, value = "score"})
				end
			end
		end
	end
	DeepPrintTable(data)

	Storage:Put("58169609", data, function( resultTable, successBool )
	    if successBool then
	        print("Successfully put data in storage")
	    end
	end)
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CLastHitChallenge()
	GameRules.AddonTemplate:InitGameMode()
end

function CLastHitChallenge:InitGameMode()

	Storage:SetApiKey("25f356916a73fe41e366e800f5f5c558c5eb7dd4")

	local data = { key = "value"}

--[[
	Storage:Put( "76561198018435337", data, function( resultTable, successBool )
    	if successBool then
        	print("Successfully put data in storage")
    	end
	end)

	Storage:Get( "76561198018435337", function( resultTable, successBool )
	    if successBool then
	        DeepPrintTable(resultTable)
	    end
	end)
]]

	GameRules:SetPreGameTime(0.0)
	GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_nevermore" )

	--CLastHitChallenge:InitilizeData()

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
	Convars:RegisterCommand( "CustomGamePause", pause, "Pause", 0)
	Convars:RegisterCommand( "getrecords", getrecords, "Get Records", FCVAR_CHEAT)
	Convars:RegisterCommand( "setrecords", setrecords, "Set Records", FCVAR_CHEAT)
	Convars:RegisterCommand( "giffpower", giffpower, "Give Damage", FCVAR_CHEAT)
	Convars:RegisterCommand( "setrecord", function(cmnname, steamid, hero, time, leveling, typescore, value)
										local data = {}
										table.insert(data, {hero = tostring(hero), time = tostring(time), leveling = leveling, typescore = tostring(typescore), value = tostring(value)})
										Storage:Put( tostring(steamid), data, 
										function( resultTable, successBool )
									    	if successBool then
									        	print("Successfully put data in storage")
									    	end
										end)
									end, "Set a particular record", 0)



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
	CustomGameEventManager:RegisterListener("quit_control_panel", Dynamic_Wrap(CLastHitChallenge, 'EndGame'))
	CustomGameEventManager:RegisterListener("cancel", Dynamic_Wrap(CLastHitChallenge, 'Resume'))
	CustomGameEventManager:RegisterListener("repick", Dynamic_Wrap(CLastHitChallenge, 'OnRepick'))
	CustomGameEventManager:RegisterListener("leaderboard", Dynamic_Wrap(CLastHitChallenge, 'OnLeaderboard'))
end