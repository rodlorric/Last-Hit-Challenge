_G.nCOUNTDOWNTIMER = 600 --600 = 10 minutes
_G.current_cs = { lh = 0, dn = 0 }


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
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CLastHitChallenge()
	GameRules.AddonTemplate:InitGameMode()
end

function CLastHitChallenge:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )
	GameRules:SetPreGameTime( 10 )
	GameRules:SetUseUniversalShopMode( false )

	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )

	countdownEnabled = false
	
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap(CLastHitChallenge, 'OnHeroPicked' ), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap(CLastHitChallenge, 'OnLastHit'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CLastHitChallenge, 'OnDeny'), self)
	CustomGameEventManager:RegisterListener("restart", Dynamic_Wrap(CLastHitChallenge, 'OnRestart'))

end
