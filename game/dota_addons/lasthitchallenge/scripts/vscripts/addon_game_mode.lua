_G.SECONDS = 0 --600 = 10 minutes
_G.current_cs = { lh = 0, dn = 0 }
--_G.tower_invulnerable = true
_G.radiant_tower = nil
_G.dire_tower = nil
_G.timer = nil

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
	PrecacheUnitByNameSync( "npc_dota_radiant_tower1_mid", context )
	PrecacheUnitByNameSync( "npc_dota_dire_tower1_mid", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CLastHitChallenge()
	GameRules.AddonTemplate:InitGameMode()
end

function CLastHitChallenge:InitGameMode()
	print( "Template addon is loaded." )
	
	GameRules:SetPreGameTime( 0 )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )
	
	GameRules:SetUseUniversalShopMode( false )
	

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_SCOREBOARD, false )
	--[[
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
	countdownEnabled = false

	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(CLastHitChallenge, 'OnHeroPicked' ), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap(CLastHitChallenge, 'OnLastHit'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CLastHitChallenge, 'OnDeny'), self)
	ListenToGameEvent("entity_hurt", Dynamic_Wrap(CLastHitChallenge, 'OnHurt'), self) -- Listener for detecting tower damage.
	CustomGameEventManager:RegisterListener("restart", Dynamic_Wrap(CLastHitChallenge, 'OnRestart'))
end
