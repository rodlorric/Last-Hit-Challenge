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
	PrecacheUnitByNameSync( "npc_dota_neutral_satyr_soulstealer", context)
	PrecacheResource( "particle", particle_aura, context )
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
	CustomGameEventManager:RegisterListener("hero_picked", Dynamic_Wrap(CLastHitChallenge, 'OnHeroPicked'))
	CustomGameEventManager:RegisterListener("time_picked", Dynamic_Wrap(CLastHitChallenge, 'OnTimePicked'))
	CustomGameEventManager:RegisterListener("quit", Dynamic_Wrap(CLastHitChallenge, 'OnQuit'))
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
	local records_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs")
	if (records_cs == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_cs", { value = 0} )
	end
	local records_acc = CustomNetTables:GetTableValue( "stats_records", "stats_record_accuracy")
	if (records_acc == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_accuracy", { value = 0} )
	end
	local records_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh")
	if (records_lh == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_lh", { value = 0} )
	end
	local records_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn")
	if (records_dn == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_dn", { value = 0} )
	end
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