require ( "util")
require ( "timers" )
require( "cosmeticlib" )

player_stats = {}

XP_TABLE = {0}

----------------------
hidehelp = 0
invulnerable = 0
radiant_creeps_spawned = 0
dire_creeps_spawned = 0
----------------------

function CLastHitChallenge:OnNewPick(params)
	local playerId = nil
	local heroId = nil
	local leveling = nil
	local time = nil

	if params.playerId ~= nil then
		playerId = tonumber(params.playerId)
	end
	if params.heroId ~= nil then
		heroId = params.heroId
	end
	if params.leveling ~= nil then
		leveling = (params.leveling == 0 and "l" or "n")
	end
	if params.time ~= nil then
		time = params.time
	end

	if heroId ~= nil then
		player_stats[playerId].hero_picked = heroId
		player_stats[playerId].leveling = leveling
		local all_picked = true
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayer( nPlayerID ) then
				if player_stats[nPlayerID].hero_picked == nil then
					all_picked = false
					break
				end
			end
		end
		if all_picked then
			for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
				if PlayerResource:IsValidPlayer( nPlayerID ) then
					if MAXTIME == -2 then
						if GameRules:PlayerHasCustomGameHostPrivileges(PlayerResource:GetPlayer(nPlayerID)) then
							CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "time_screen", {})
						end
					else
						CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "start", { time = MAXTIME, heroId = player_stats[nPlayerID].hero_picked, leveling = player_stats[nPlayerID].leveling, playerId = nPlayerID, radiant_creeps_spawned = radiant_creeps_spawned, dire_creeps_spawned = dire_creeps_spawned})
						--CustomGameEventManager:Send_ServerToAllClients("start", { time = MAXTIME, heroId = heroId, leveling = leveling, playerId = playerId})
					end
				end
			end
		end
	end

	if time ~= nil then
		MAXTIME = time
		if MAXTIME > 0 then
			TIMEUP = MAXTIME + 5
		else 
			TIMEUP = MAXTIME
		end

		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayer( nPlayerID ) then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "start", { time = MAXTIME, heroId = player_stats[nPlayerID].hero_picked, leveling = player_stats[nPlayerID].leveling, playerId = nPlayerID, radiant_creeps_spawned = radiant_creeps_spawned, dire_creeps_spawned = dire_creeps_spawned})
				--CustomGameEventManager:Send_ServerToAllClients("start", { time = MAXTIME, heroId = heroId, leveling = leveling, playerId = playerId})
			end
		end
	end
end

function CLastHitChallenge:OnSpawnHeroes(params)
	local heroId = params.heroId
	--local leveling = params.leveling
	local playerId = params.playerId
	--local time = params.time

	--Spawn the hero in an empty spot
 	CLastHitChallenge:SafeSpawn(PlayerResource:GetSelectedHeroEntity(playerId))

	local phero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
	UTIL_Remove(phero)
	--local nhero = PlayerResource:ReplaceHeroWith( 0, "npc_dota_hero_" .. hero_picked, 0, 0)
	local hero_picked_name = CLastHitChallenge:HeroName(heroId)
	local nhero = PlayerResource:ReplaceHeroWith( playerId, hero_picked_name, 0, 0)

	--This removes any cosmetic, to avoid to precache every other item
	if hero_picked_name == "npc_dota_hero_techies" then
		CosmeticLib:RemoveAll(nhero)
		--CosmeticLib:ReplaceDefault(nhero, hero_picked_name)
	end
end

radiant_maxspawns = 0
dire_maxspawns = 0
function CLastHitChallenge:OnStart()
	iter = 1

	CLastHitChallenge:ClearData()

    CLastHitChallenge:SpawnCreeps()
	CLastHitChallenge:Clock()

	--leveling, it is playerid = 0 because it is enough with the host
	if player_stats[0].leveling == "n" then
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
		GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_TABLE)
	else
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(false)
	end

	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
end

function CLastHitChallenge:OnPause(data)
	GameRules:SendCustomMessage("<font color='" .. tostring(data.playerColor) .. "'>" .. tostring(data.playerName) .. "</font>", 0, 0)
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	else
		PauseGame(true)
	end
end

function CLastHitChallenge:HeroName(hero_picked)
	local hero_name = CustomNetTables:GetTableValue("hero_selection", tostring(hero_picked))
	return hero_name.hero
end

function CLastHitChallenge:SafeSpawn(hero)
	local ent_class = hero:GetTeam() == DOTA_TEAM_BADGUYS and "info_player_start_badguys" or "info_player_start_goodguys" 
	local ent = Entities:FindByClassname( nil, ent_class):GetAbsOrigin()
	FindClearSpaceForUnit(hero, ent, true)
end


function CLastHitChallenge:GiveZeroGold (hero)
  	hero:SetGold(0, false)
end

function CLastHitChallenge:GiveBlinkDagger (hero)
   if hero:HasRoomForItem("item_blink", true, true) then
      local dagger = CreateItem("item_rapier", hero, hero)
      dagger:SetPurchaseTime(0)
      hero:AddItem(dagger)
   end
end

-- Evaluate the state of the game
initialize = false
function CLastHitChallenge:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP  and not initialize then
		CLastHitChallenge:InitializeData()
	end

	if GameRules:State_Get() ==  DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if GameRules:IsCheatMode() and not cheater then
			cheater = true
			for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
				if PlayerResource:IsValidPlayer( nPlayerID ) then
					Storage:PutCheater( PlayerResource:GetSteamAccountID(nPlayerID), STORAGEAPI_API_URL_CHEATERS, function( resultTable, successBool )			
			    		if successBool then
							print("Nice try!")
			    		end
					end)
				end
			end
		end

		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayer( nPlayerID ) and PlayerResource:GetConnectionState( nPlayerID ) == DOTA_CONNECTION_STATE_DISCONNECTED then
				player_stats[nPlayerID].disconnected = true;
			end
		end
	end
	

	if GameRules:IsGamePaused() == true then
  		return 1
	end

	if seconds == TIMEUP then
		CLastHitChallenge:EndGame()
	end

	return 1
end

function CLastHitChallenge:ClearData()
	restarts = restarts + 1

	if MAXTIME > 0 then
		radiant_maxspawns = ((MAXTIME / 30) * CREEPS_PER_WAVE) + math.floor(MAXTIME / SIEGE_CREEP_INTERVAL)
		dire_maxspawns = radiant_maxspawns
	else 
    	radiant_maxspawns = ">>"
    	dire_maxspawns = ">>"
    end
    --[[
	if (MAXTIME == 150) then 
    	radiant_maxspawns = 20;
    	dire_maxspawns = 20;
    elseif (MAXTIME == 300) then
    	radiant_maxspawns = 41;
    	dire_maxspawns = 41;
    elseif (MAXTIME == 450) then
    	radiant_maxspawns = 62;
    	dire_maxspawns = 62;
    elseif (MAXTIME == 600) then
    	radiant_maxspawns = 82;
    	dire_maxspawns = 82;
    else 
    	radiant_maxspawns = ">>"
    	dire_maxspawns = ">>"
    end
    ]]

	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	total_time = total_time + seconds
	-- clearing time!
	seconds = 0

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			-- clearing creep score
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_lh", { value = 0 } )
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_dn", { value = 0 } )
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_cs", { value = 0 } )
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_accuracy", { value = 100 } )
			CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_lh", { value = 100 })
			CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_dn", { value = 100 })
			CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_cs", { value = 100 })

			player_stats[nPlayerID].history = {}
			CustomNetTables:SetTableValue("stats_misc", tostring(nPlayerID) .. "stats_misc_history", player_stats[nPlayerID][history])

			--clearing particles helper
			hurtunits = {}

			--Totals Details
			--detailed stats totals
			player_stats[nPlayerID].melee_lh = 0
			player_stats[nPlayerID].melee_dn = 0
			player_stats[nPlayerID].melee_miss_friendly = 0
			player_stats[nPlayerID].melee_miss_foe = 0
			player_stats[nPlayerID].ranged_lh = 0
			player_stats[nPlayerID].ranged_dn = 0
			player_stats[nPlayerID].ranged_miss_friendly = 0
			player_stats[nPlayerID].ranged_miss_foe = 0
			player_stats[nPlayerID].siege_lh = 0
			player_stats[nPlayerID].siege_dn = 0
			player_stats[nPlayerID].siege_miss_friendly = 0
			player_stats[nPlayerID].siege_miss_foe = 0
			----------------------
			
			--clearing misses
			player_stats[nPlayerID].misses = 0			
			player_stats[nPlayerID].current_cs = { lh = PlayerResource:GetLastHits(nPlayerID), dn = PlayerResource:GetDenies(nPlayerID) }

			--player_status
			player_stats[nPlayerID].disconnected = false
		end
		--clearing heatmap
		--CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "cleardata", {})
		CustomGameEventManager:Send_ServerToAllClients("cleardata", {})
	end
	
	
end

function CLastHitChallenge:SetGameFrozen( bFreeze )
	Tutorial:SetTimeFrozen( bFreeze )
	local entity = Entities:First()
	while( entity ~= nil ) do
		if ( entity:IsBaseNPC() ) then
			if ( entity:IsAlive() and ( entity:IsCreep() or entity:IsHero() ) ) then
				if ( bFreeze == true ) then
					entity:StartGesture( ACT_DOTA_IDLE )
				else
					entity:RemoveGesture( ACT_DOTA_IDLE )
				end
			end
		end
		entity = Entities:Next( entity )
	end
end


function CLastHitChallenge:IsReconnecting(data)
	local pid = data.playerId
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "reconnect", { value = player_stats[pid].disconnected } )
	if player_stats[pid].disconnected then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "start", { time = MAXTIME, heroId = player_stats[pid].hero_picked, leveling = player_stats[pid].leveling, 
			playerId = pid, radiant_creeps_spawned = radiant_creeps_spawned, dire_creeps_spawned = dire_creeps_spawned})
	end
	player_stats[pid].disconnected = false
end

function CLastHitChallenge:EndGame()
	if seconds < shortest_time or shortest_time == TIMEUP then
		shortest_time = seconds
	end

	CLastHitChallenge:SetGameFrozen(true)
	
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			local hero_picked = player_stats[nPlayerID].hero_picked
			--Totals
			local stats_total_cs = CustomNetTables:GetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_cs")
			local stats_total_lh = CustomNetTables:GetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_lh")
			local stats_total_dn = CustomNetTables:GetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_dn")

			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_miss", { value = player_stats[nPlayerID].misses })

			local stats_total_cs = CustomNetTables:GetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_cs")
			local accuracy = 0
			if stats_total_cs.value == 0 and player_stats[nPlayerID].misses == 0 then
				accuracy = 0
			else
				accuracy = ( stats_total_cs.value * 100) / (stats_total_cs.value + player_stats[nPlayerID].misses)
				accuracy = round(accuracy, 0)
			end
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_accuracy", { value = accuracy })

			--Totals Details
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_lh", { value = player_stats[nPlayerID].melee_lh } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_dn", { value = player_stats[nPlayerID].melee_dn } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_miss_friendly", { value = player_stats[nPlayerID].melee_miss_friendly } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_miss_foe", { value = player_stats[nPlayerID].melee_miss_foe } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_lh", { value = player_stats[nPlayerID].ranged_lh } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_dn", { value = player_stats[nPlayerID].ranged_dn } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_miss_friendly", { value = player_stats[nPlayerID].ranged_miss_friendly } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_miss_foe", { value = player_stats[nPlayerID].ranged_miss_foe } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_lh", { value = player_stats[nPlayerID].siege_lh } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_dn", { value = player_stats[nPlayerID].siege_dn } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_miss_friendly", { value = player_stats[nPlayerID].siege_miss_friendly } )
			CustomNetTables:SetTableValue("stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_miss_foe", { value = player_stats[nPlayerID].siege_miss_foe } )

			--Streaks
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_cs", { value = player_stats[nPlayerID].max_cs_streak })
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_lh", { value = player_stats[nPlayerID].max_last_hit_streak })
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_dn", { value = player_stats[nPlayerID].max_deny_streak })
			player_stats[nPlayerID].cs_streak = 0
			player_stats[nPlayerID].last_hit_streak = 0
			player_stats[nPlayerID].deny_streak = 0
			player_stats[nPlayerID].max_deny_streak = 0
			player_stats[nPlayerID].max_cs_streak = 0
			player_stats[nPlayerID].max_last_hit_streak = 0

			--Records
			local stats_record_accuracy = CustomNetTables:GetTableValue( "stats_records", tostring(nPlayerID) .. "a" .. player_stats[nPlayerID].hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling)
			if seconds == TIMEUP then
				if accuracy > stats_record_accuracy.value and MAXTIME ~= -1 then
					stats_record_accuracy.value = accuracy
					CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "a" .. player_stats[nPlayerID].hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling, stats_record_accuracy)
					player_stats[nPlayerID].new_record = true
				end
			end


			--Misc
			CustomNetTables:SetTableValue("stats_misc", tostring(nPlayerID) .. "stats_misc_restart", { value = restarts })
			
			local c_lh = PlayerResource:GetLastHits(nPlayerID) - player_stats[nPlayerID].current_cs["lh"]
			local c_dn = PlayerResource:GetDenies(nPlayerID) - player_stats[nPlayerID].current_cs["dn"]
			table.insert(player_stats[nPlayerID].history, { lh = c_lh - player_stats[nPlayerID].lh_history, dn = c_dn - player_stats[nPlayerID].dn_history, time = seconds})

			CustomNetTables:SetTableValue("stats_misc", tostring(nPlayerID) .. "stats_misc_history", player_stats[nPlayerID].history)
			table.remove(player_stats[nPlayerID].history)
			
			local session_accuracy = 0
			if player_stats[nPlayerID].session_cs == 0 and player_stats[nPlayerID].total_misses == 0 then
				session_accuracy = 0
			else
				session_accuracy = ( player_stats[nPlayerID].session_cs * 100) / (player_stats[nPlayerID].session_cs + player_stats[nPlayerID].total_misses)
				session_accuracy = round(session_accuracy, 0)
			end

			CustomNetTables:SetTableValue("stats_misc", tostring(nPlayerID) .. "stats_misc_session_accuracy", { value = session_accuracy })

			--Time
			total_time = total_time + seconds
			local min = string.format("%.2d", math.floor(total_time/60)%60)
			local sec = string.format("%.2d", total_time%60)
			CustomNetTables:SetTableValue( "stats_time", tostring(nPlayerID) .. "stats_time_spent", { value = tostring(min) .. ":" .. tostring(sec) } );

			min = string.format("%.2d", math.floor(longest_time/60)%60)
			sec = string.format("%.2d", longest_time%60)
			CustomNetTables:SetTableValue( "stats_time", tostring(nPlayerID) .. "stats_time_longest", { value = tostring(min) .. ":" .. tostring(sec) } );

			min = string.format("%.2d", math.floor(shortest_time/60)%60)
			sec = string.format("%.2d", shortest_time%60)
			CustomNetTables:SetTableValue( "stats_time", tostring(nPlayerID) .. "stats_time_shortest", { value = tostring(min) .. ":" .. tostring(sec) } );

			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "end_screen", {time = seconds, hero = player_stats[nPlayerID].hero_picked, level = player_stats[nPlayerID].leveling, maxtime = MAXTIME})
			
			if seconds == TIMEUP then
				seconds = 0	
			end
		end
	end
	
end

--[[ Make Towers invulnerable

function CLastHitChallenge:SetTowerInvunerability( tower_name )
	local tower = Entities:FindByName(nil, tower_name)
	local invulnerable = false
	for i=0,tower:GetModifierCount() do 
		if tower:GetModifierNameByIndex(i) == 'modifier_invulnerable' then
			invulnerable = true
			break
		end
	end
	if not invulnerable then
		tower:AddNewModifier( tower, nil, "modifier_invulnerable", {} )
	end
end

]]

hurtunits = {}
function CLastHitChallenge:OnHurt( event )
	local hurtUnit = EntIndexToHScript( event.entindex_killed )
	if event.entindex_attacker ~= nil then
		local attacker = EntIndexToHScript( event.entindex_attacker )
		if hurtUnit:IsHero() and invulnerable == 1 then
			hurtUnit:SetHealth(hurtUnit:GetMaxHealth())
		end

		if hurtUnit:IsCreep() and attacker:IsHero() then
			local health = hurtUnit:GetHealth()
			local max_health = hurtUnit:GetMaxHealth()
			local pct = hurtUnit:GetHealth() / hurtUnit:GetMaxHealth()
			if pct ~= 0 then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(attacker:GetPlayerID()), "hurt_entity", {index = event.entindex_killed, msg = pct})
			end
		end

		--if (hurtUnit:IsCreep() or hurtUnit:IsMechanical() or hurtUnit:IsTower()) and (hurtUnit:GetHealth() < hurtUnit:GetMaxHealth() * 0.25) and (hidehelp == 0) then
		local index = hurtUnit:entindex()
		local threshold = hurtUnit:GetHealth() < (hurtUnit:GetMaxHealth() * 0.25)
		if hurtUnit:IsCreep() and (threshold) and (hidehelp == 0) and (hurtunits[index] == nil) then
			hurtunits[index] = ParticleManager:CreateParticle(particle_aura, PATTACH_ABSORIGIN_FOLLOW, hurtUnit)
		end
	end
	if hurtUnit:IsTower() then
		hurtUnit:SetHealth(hurtUnit:GetMaxHealth())
	end

end

function CLastHitChallenge:OnInvulnerability( event )
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if ( PlayerResource:IsValidPlayer( nPlayerID ) and event.invulnerability == 1) then
			local hero  = PlayerResource:GetPlayer( nPlayerID ):GetAssignedHero()
			hero:SetHealth(hero:GetMaxHealth())
		end
	end
	if event.invulnerability == 1 then
		invulnerable = 1
	else
		invulnerable = 0
	end
	CustomGameEventManager:Send_ServerToAllClients("invulnerable", {})
end

function CLastHitChallenge:OnHideHelp( event )
	if event.hidehelp == 1 then		
		hidehelp = 1
		for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
			if hurtunits[unit:entindex()] ~= nil then
				ParticleManager:DestroyParticle(hurtunits[unit:entindex()], true)
				hurtunits[unit:entindex()] = nil
			end
		end

		for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
			if hurtunits[unit:entindex()] ~= nil then
				ParticleManager:DestroyParticle(hurtunits[unit:entindex()], true)
				hurtunits[unit:entindex()] = nil
			end
		end
	else
		hidehelp = 0
		for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
			--if (unit:IsCreep() or unit:IsMechanical() or unit:IsTower()) and (unit:GetHealth() < unit:GetMaxHealth() * 0.25) then
			if unit:IsCreep() and (unit:GetHealth() < unit:GetMaxHealth() * 0.25) then
				hurtunits[unit:entindex()] = ParticleManager:CreateParticle(particle_aura, PATTACH_ABSORIGIN_FOLLOW, unit)
			end
		end

		for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
			--if (unit:IsCreep() or unit:IsMechanical() or unit:IsTower()) and (unit:GetHealth() < unit:GetMaxHealth() * 0.25) then
			if unit:IsCreep() and (unit:GetHealth() < unit:GetMaxHealth() * 0.25) then
				hurtunits[unit:entindex()] = ParticleManager:CreateParticle(particle_aura, PATTACH_ABSORIGIN_FOLLOW, unit)
			end
		end

	end
end

--[[
leveling = "l"
function CLastHitChallenge:OnDisableLeveling( event )
	print("1 OnDisableLeveling leveling = " .. leveling)
	if event.disable_leveling == 1 then	
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
		GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_TABLE)
		leveling = "n"
	else
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(false)
		leveling = "l"
	end
	print("2 OnDisableLeveling leveling = " .. leveling)
end
]]

last_hit_streak = 0
deny_streak = 0
cs_streak = 0
max_cs_streak = 0
max_deny_streak = 0
max_last_hit_streak = 0
function CLastHitChallenge:OnEntityKilled (event)

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedUnitName = killedUnit:GetUnitName()
	local killedTeam = killedUnit:GetTeam()
	local attacker = EntIndexToHScript( event.entindex_attacker )


	if attacker:entindex() ~= killedUnit:entindex() then --UTIL_removed units count as killed by self
		--remove particles only from killed units
		local index = killedUnit:entindex()
		if hurtunits[index] ~= nil then
			ParticleManager:DestroyParticle(hurtunits[index], true)
			hurtunits[index] = nil
		end
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayer( nPlayerID ) then

				local friendly = (PlayerResource:GetTeam(nPlayerID) == killedUnit:GetTeam())

				local lh = PlayerResource:GetLastHits(nPlayerID) - player_stats[nPlayerID].current_cs["lh"]
				local dn = PlayerResource:GetDenies(nPlayerID) - player_stats[nPlayerID].current_cs["dn"]
				local cs = lh + dn

				if not killedUnit:IsHero() then					
					if attacker:IsRealHero() then
						local playerId = attacker:GetPlayerID()
						if playerId == nPlayerID then
							local hero_picked = player_stats[nPlayerID].hero_picked
							--heatmap
							local xy = killedUnit:GetOrigin()
							CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "heatmap", {x = xy.x, y = xy.y})
							
							--Streaks
							player_stats[nPlayerID].cs_streak = player_stats[nPlayerID].cs_streak + 1 
							if player_stats[nPlayerID].cs_streak > player_stats[nPlayerID].max_cs_streak then
								player_stats[nPlayerID].max_cs_streak = player_stats[nPlayerID].cs_streak
							end

							local stats_record_cs = CustomNetTables:GetTableValue( "stats_records", tostring(nPlayerID) .. "c" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling )
							
							--Deny
							if friendly then
								local stats_record_dn = CustomNetTables:GetTableValue( "stats_records", tostring(nPlayerID) .. "d" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling)
								--streaks
								player_stats[nPlayerID].deny_streak = player_stats[nPlayerID].deny_streak + 1
								if player_stats[nPlayerID].deny_streak > player_stats[nPlayerID].max_deny_streak then
									player_stats[nPlayerID].max_deny_streak = player_stats[nPlayerID].deny_streak
								end

								CustomNetTables:SetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_dn", { value = dn } )

								if (dn > stats_record_dn.value or cs > stats_record_cs.value) and (dn <= (PlayerResource:GetTeam(nPlayerID) == 0 and dire_creeps_spawned or radiant_creeps_spawned)) then
									if dn > stats_record_dn.value and MAXTIME ~= -1 then
										stats_record_dn.value = dn
										--CustomNetTables:SetTableValue("stats_records", "stats_record_dn_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_dn)
										CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "d" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling, stats_record_dn)
										player_stats[nPlayerID].new_record = true
									end
								end


								--Totals Details
								if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
									if killedUnit:IsRangedAttacker() then
										player_stats[nPlayerID].ranged_dn = player_stats[nPlayerID].ranged_dn + 1
									else
										player_stats[nPlayerID].melee_dn = player_stats[nPlayerID].melee_dn + 1
									end
								--elseif killedUnit:IsTower() then
								--	tower_dn = tower_dn + 1
								else
									player_stats[nPlayerID].siege_dn = player_stats[nPlayerID].siege_dn + 1
								end

							else --LastHit
								local stats_record_lh = CustomNetTables:GetTableValue( "stats_records", tostring(nPlayerID) .. "l" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling)
								--streak
								player_stats[nPlayerID].last_hit_streak = player_stats[nPlayerID].last_hit_streak + 1
								if player_stats[nPlayerID].last_hit_streak > player_stats[nPlayerID].max_last_hit_streak then
									player_stats[nPlayerID].max_last_hit_streak = player_stats[nPlayerID].last_hit_streak
								end

								CustomNetTables:SetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_lh", { value = lh } );
								if (lh > stats_record_lh.value or cs > stats_record_cs.value) and (lh <= (PlayerResource:GetTeam(nPlayerID) == 0 and radiant_creeps_spawned or dire_creeps_spawned)) then
									if lh > stats_record_lh.value and MAXTIME ~= -1 then
										stats_record_lh.value = lh
										CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "l" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling, stats_record_lh)
										player_stats[nPlayerID].new_record = true
									end
								end

								--Totals Details
								if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
									if killedUnit:IsRangedAttacker() then
										player_stats[nPlayerID].ranged_lh = player_stats[nPlayerID].ranged_lh + 1
									else
										player_stats[nPlayerID].melee_lh = player_stats[nPlayerID].melee_lh + 1
									end
								--elseif killedUnit:IsTower() then
								--	tower_lh = tower_lh + 1
								else
									player_stats[nPlayerID].siege_lh = player_stats[nPlayerID].siege_lh + 1
								end
							end
							CustomNetTables:SetTableValue( "stats_totals", tostring(nPlayerID) .. "stats_total_cs", { value = lh + dn } );
							
							--To track all time cs
							session_cs = session_cs + 1

							--Records
							if cs > stats_record_cs.value and MAXTIME ~= -1 and cs <= (dire_creeps_spawned + radiant_creeps_spawned) then
								stats_record_cs.value = cs
								CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "c" .. hero_picked .. tostring(MAXTIME) .. player_stats[nPlayerID].leveling , stats_record_cs)
								player_stats[nPlayerID].new_record = true
							end
						end
					else -- misses
						--if not killedUnit:IsHero() then
						--streaks
						player_stats[nPlayerID].cs_streak = 0

						if friendly then
							player_stats[nPlayerID].deny_streak = 0
						else
							player_stats[nPlayerID].last_hit_streak = 0
						end
						player_stats[nPlayerID].total_misses = player_stats[nPlayerID].total_misses + 1
						player_stats[nPlayerID].misses = player_stats[nPlayerID].misses + 1

						--Totals Details
						if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
							if killedUnit:IsRangedAttacker() then
								if friendly then
									player_stats[nPlayerID].ranged_miss_friendly = player_stats[nPlayerID].ranged_miss_friendly + 1
								else
									player_stats[nPlayerID].ranged_miss_foe = player_stats[nPlayerID].ranged_miss_foe + 1
								end
							else
								if friendly then
									player_stats[nPlayerID].melee_miss_friendly = player_stats[nPlayerID].melee_miss_friendly + 1
								else
									player_stats[nPlayerID].melee_miss_foe = player_stats[nPlayerID].melee_miss_foe + 1
								end
							end
						--elseif killedUnit:IsTower() then
						--	if friendly then
						--			melee_miss_friendly = melee_miss_friendly + 1
						--		else
						--			melee_miss_foe = melee_miss_foe + 1
						--		end
						else
							if friendly then
								player_stats[nPlayerID].siege_miss_friendly = player_stats[nPlayerID].siege_miss_friendly + 1
							else
								player_stats[nPlayerID].siege_miss_foe = player_stats[nPlayerID].siege_miss_foe + 1
							end
						end

						local origin = killedUnit:GetOrigin()
						for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
							if PlayerResource:IsValidPlayer( nPlayerID ) then
								CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(nPlayerID), "hurt_entity", {index = event.entindex_killed, msg = "missed"})
							end
						end
						end
					if MAXTIME ~= -1 then
						if killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
							radiant_maxspawns = radiant_maxspawns - 1
						else 
							dire_maxspawns = dire_maxspawns - 1
						end
						CustomGameEventManager:Send_ServerToAllClients("creepdeath", { friendly = friendly, radiant_maxspawns = radiant_maxspawns, dire_maxspawns = dire_maxspawns })
					end
				end

				local lh_accuracy = ((lh + player_stats[nPlayerID].melee_miss_foe + player_stats[nPlayerID].ranged_miss_foe + player_stats[nPlayerID].siege_miss_foe) == 0) and 100 or (lh * 100) / ( lh + player_stats[nPlayerID].melee_miss_foe + player_stats[nPlayerID].ranged_miss_foe + player_stats[nPlayerID].siege_miss_foe)
				lh_accuracy = round(lh_accuracy)
				local dn_accuracy = ((dn + player_stats[nPlayerID].melee_miss_friendly + player_stats[nPlayerID].ranged_miss_friendly + player_stats[nPlayerID].siege_miss_friendly) == 0) and 100 or (dn * 100) / (dn + player_stats[nPlayerID].melee_miss_friendly + player_stats[nPlayerID].ranged_miss_friendly + player_stats[nPlayerID].siege_miss_friendly)
				dn_accuracy = round(dn_accuracy)
				local cs_accuracy = ((lh + dn + player_stats[nPlayerID].misses) == 0) and 100 or ((lh + dn) * 100) / (lh + dn + player_stats[nPlayerID].misses)
				cs_accuracy = round(cs_accuracy)
				CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_lh", { value = lh_accuracy })
				CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_dn", { value = dn_accuracy })
				CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. "stats_accuracy_cs", { value = cs_accuracy })
			end
		end
	end
end

function CLastHitChallenge:SpawnCreeps()
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			player_stats[nPlayerID].lh_history = PlayerResource:GetLastHits(nPlayerID) - player_stats[nPlayerID].current_cs["lh"]
			player_stats[nPlayerID].dn_history = PlayerResource:GetDenies(nPlayerID) - player_stats[nPlayerID].current_cs["dn"]
		end
	end
	local point = nil
	local waypoint = nil
	Timers:CreateTimer("spawner", {
			useGameTime = true,
    		endTime = 0,
			callback = function()
				CLastHitChallenge:Spawner()
				for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
					if PlayerResource:IsValidPlayer( nPlayerID ) then
						local c_lh = PlayerResource:GetLastHits(nPlayerID) - player_stats[nPlayerID].current_cs["lh"]
						local c_dn = PlayerResource:GetDenies(nPlayerID) - player_stats[nPlayerID].current_cs["dn"]
						if seconds > 1 then
							table.insert(player_stats[nPlayerID].history, { lh = c_lh - player_stats[nPlayerID].lh_history, dn = c_dn - player_stats[nPlayerID].dn_history, time = seconds-1})
							player_stats[nPlayerID].lh_history = c_lh
							player_stats[nPlayerID].dn_history = c_dn
						end
					end
				end
				return 30.0
			end
		})
end

function CLastHitChallenge:Spawner()
	local point = nil
	local waypoint = nil
	if seconds < MAXTIME or MAXTIME < 0 then
		for i=1,2 do
		    point = Entities:FindByName( nil, "npc_dota_spawner_" .. (i == 1 and "good" or "bad") .. "_mid_staging"):GetAbsOrigin()			
		    waypoint = Entities:FindByName(nil, "lane_mid_pathcorner_" .. (i == 1 and "good" or "bad") .. "guys_1")
			if waypoint then
				for j=1,CREEPS_PER_WAVE do		
					unit = CreateUnitByName("npc_dota_creep_" .. (i == 1 and "good" or "bad") .. "guys_" .. (j < CREEPS_PER_WAVE and "melee" or "ranged"), point, true, nil, nil, (i == 1 and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS))
					if seconds >= 450 then -- after 7:30 min creeps gain 10 health and 2/1 Dmg ranged/melee
						if unit:IsCreep() and unit:IsRangedAttacker() then
							unit:SetBaseDamageMin(unit:GetBaseDamageMin() + 2)
							unit:SetBaseDamageMax(unit:GetBaseDamageMin() + 2)
						else
							unit:SetBaseDamageMin(unit:GetBaseDamageMin() + 1)
							unit:SetBaseDamageMax(unit:GetBaseDamageMin() + 1)
						end
						unit:SetMaxHealth(unit:GetMaxHealth() + 10)
						unit:SetHealth(unit:GetMaxHealth())
					end
					unit:SetInitialGoalEntity(waypoint)
					if i == 1 then
						radiant_creeps_spawned = radiant_creeps_spawned + 1
					else
						dire_creeps_spawned = dire_creeps_spawned + 1
					end
				end
				-- spawn siege creep every 10th wave
				if iter % 10 == 0 then
					unit = CreateUnitByName("npc_dota_" .. (i == 1 and "good" or "bad") .. "guys_siege", point, true, nil, nil, (i == 1 and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS))
					unit:SetInitialGoalEntity(waypoint)
					if i == 1 then
						radiant_creeps_spawned = radiant_creeps_spawned + 1
					else
						dire_creeps_spawned = dire_creeps_spawned + 1
					end
				end
			end
		end
		iter = iter + 1
	end
end

function CLastHitChallenge:OnSync(params)
	if params.value ~= "stats" then
		Timers:RemoveTimer("spawner")
		Timers:RemoveTimer("clock")
		CLastHitChallenge:ClearUnits()
		CLastHitChallenge:ClearData()
	end
	CLastHitChallenge:SetGameFrozen(true)
	if params.value == "hero" then
		for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
			if PlayerResource:IsValidPlayer( nPlayerID ) then
				player_stats[nPlayerID].hero_picked = nil
				player_stats[nPlayerID].leveling = nil
			end
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("sync", { value = params.value})
	CustomGameEventManager:Send_ServerToAllClients("cancel", {})
end

function CLastHitChallenge:OnRestart(playerId)
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	if seconds < shortest_time or shortest_time == TIMEUP then
		shortest_time = seconds
	end

	-- clearing units
	CLastHitChallenge:ClearUnits()
	CLastHitChallenge:ClearData()

	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end

	Timers:RemoveTimer("spawner")
	Timers:RemoveTimer("clock")

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			CLastHitChallenge:OnSpawnHeroes({heroId = player_stats[nPlayerID].hero_picked, playerId = nPlayerID})
		end
	end

	--respawn the unit in an empty spot
	--[[
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			local player_hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
			CLastHitChallenge:SafeSpawn(player_hero)

			local hero_picked = player_stats[nPlayerID].hero_picked

			local phero = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
			UTIL_Remove(phero)
			local hero_picked_name = CLastHitChallenge:HeroName(hero_picked)
			local nhero = PlayerResource:ReplaceHeroWith( nPlayerID, hero_picked_name, 0, 0)

			--This removes any cosmetic, to avoid to precache every other item
			CosmeticLib:RemoveAll(nhero)
			if hero_picked_name ~= "npc_dota_hero_techies" then
				CosmeticLib:ReplaceDefault(nhero, hero_picked_name)
			end

		end
	end
	]]
	--CLastHitChallenge:GiveZeroGold(player_hero)
	CustomGameEventManager:Send_ServerToAllClients("creepdeath", { friendly = friendly, radiant_maxspawns = radiant_maxspawns, dire_maxspawns = dire_maxspawns })

	iter = 1
	CLastHitChallenge:SpawnCreeps()
	CLastHitChallenge:Clock()
	CustomGameEventManager:Send_ServerToAllClients("cancel", {})
end


function CLastHitChallenge:OnQuit()
	local uploaded = CLastHitChallenge:UploadRecords()
	Timers:CreateTimer({
    	useGameTime = false,
    	endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    	callback = function()
			SendToServerConsole( "disconnect" )
    	end
  })
end

function CLastHitChallenge:OnLeaderboard(query)
	local playerId = query.PlayerID
	local steamid = PlayerResource:GetSteamAccountID(playerId)
	leader_list = {}
	if cheater then
		Storage:GetCheater(STORAGEAPI_API_URL_CHEATERS, function( resultTable, successBool )
		    if successBool then
		    	if resultTable ~= nil then
			        for k,v in pairs(resultTable) do
						table.insert(leader_list, 1, {steam_id = v.steam_id, value = "Busted!"})
			        end
		       	end
		    end
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerId), "leaderboard", {leader_list = leader_list, cheater = true})
		end)
	else
		if (query.refresh ~= nil and query.refresh == 1) then
			Storage:InvalidateLeaderboard(steamid, query.hero, query.time, query.leveling, query.typescore)
			CLastHitChallenge:UploadRecords()
		end
		local table_name = tostring(playerId) .. query.typescore .. query.hero .. query.time .. query.leveling
	    local localrec = CustomNetTables:GetTableValue("stats_records", table_name)
	    table.insert(leader_list, 1, {steam_id = tostring(steamid), value = localrec.value})
	    local index = 1
		
		Storage:GetURL(steamid, query.hero, query.time, query.leveling, query.typescore, STORAGEAPI_API_URL_LEADERBOARD, function( resultTable, successBool )
		    if successBool then
		    	if resultTable ~= nil then
			        for k,v in pairs(resultTable) do
			        	if localrec.value > v.value then
			        		if tostring(steamid) ~= v.steam_id then
			        			table.insert(leader_list, {steam_id = v.steam_id, value = v.value})
			        		end
			        	else
			        		if tostring(steamid) ~= v.steam_id then
			        			table.insert(leader_list, index, {steam_id = v.steam_id, value = v.value})
			        			index = index + 1
			        		else
			        			CustomNetTables:SetTableValue("stats_records", table_name, {value = v.value})
			        		end
			        	end

			        end
		       	end
		    end
	        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerId), "leaderboard", leader_list)
		end)
	end
end

function CLastHitChallenge:OnHeroLevelUp(event)

  local player = PlayerInstanceFromIndex( event.player )
  local hero = player:GetAssignedHero()
  local level = hero:GetLevel()
  CustomGameEventManager:Send_ServerToPlayer(player,"hidetalenttree", {})
end

function CLastHitChallenge:OnPlayerChat(event)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(event.playerid), "chat", {})
end

function CLastHitChallenge:Resume()
	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
	CustomGameEventManager:Send_ServerToAllClients("cancel", {})
end

function CLastHitChallenge:Pause()
	if not Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(true)
	end
end


function CLastHitChallenge:UploadRecords()
	local num_players = 0
	local playerId = nil
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			playerId = nPlayerID
			num_players = num_players + 1
		end
	end
	if player_stats[playerId].new_record and not cheater and MAXTIME ~= -1 and num_players == 1 then
		--local hero_list = {"11","17","46","34","74","76","39","13","43","52","106","25","47","97","35","49","23","78","60","59","19","21","22","64"}
		local time_list = {"150", "300", "450", "600"}
		local type_list = {"c", "l", "d", "a"}
		local level_list = {"l", "n"}

		local data = {}

		for i, typescore in pairs(type_list) do
			for j, time in pairs(time_list) do
				for hero, enabled in pairs(HERO_SELECTION) do
					if enabled == 1 then
						local kvhero = KVHEROES[hero]
						for l, level in pairs(level_list) do
							--Since records will upload only for single player sessions, the table name must be 0, local player ID
							local table_name = tostring(playerId) .. typescore ..  tostring(kvhero.HeroID) ..  time .. level
							local record = CustomNetTables:GetTableValue( "stats_records", table_name )
							if record.value > 0 then
								--table.insert(data, {k = table_name, v = record.value})
								table.insert(data, {hero = tostring(kvhero.HeroID), time = time, leveling = level, typescore = typescore, value = record.value})
							end
						end
					end
				end
			end
		end

		local steamid = PlayerResource:GetSteamAccountID(playerId)
		Storage:Put( steamid, data, function( resultTable, successBool )
	    	if successBool then
	        	print("Successfully put data in storage")
	        	player_stats[playerId].new_record = false
	    	end
		end)
	end
end

function CLastHitChallenge:Clock()
	Timers:CreateTimer("clock", {
		useGameTime = true,
   		endTime = 0,
		callback = function()
	      	seconds = seconds + 1

			if seconds > longest_time then
				longest_time = seconds
			end

	      	local min = string.format("%.2d", math.floor(seconds/60)%60)
	      	local sec = string.format("%.2d", seconds%60)
	      	
	      	local bTimeLeft = false
	      	if MAXTIME-seconds <= 30 then
	      		bTimeLeft = true
	      	end
	 	    
			CustomGameEventManager:Send_ServerToAllClients("clock", {min = min, sec = sec, bTimeLeft = bTimeLeft})
	      	return 1.0
		end
		})
end

function CLastHitChallenge:ClearUnits()
	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, 
										Vector( 0, 0, 0 ), 
										nil, 
										FIND_UNITS_EVERYWHERE, 
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_ALL, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, false )) do
		if not unit:IsTower() and not unit:IsHero() then
			UTIL_Remove( unit )
		end
	end

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, 
									Vector( 0, 0, 0 ), 
									nil, 
									FIND_UNITS_EVERYWHERE, 
									DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
									DOTA_UNIT_TARGET_ALL, 
									DOTA_UNIT_TARGET_FLAG_NONE, 
									FIND_ANY_ORDER, false )) do
		if not unit:IsTower() and not unit:IsHero() then
			UTIL_Remove( unit )
		end
	end
	radiant_creeps_spawned = 0
	dire_creeps_spawned = 0
end

function CLastHitChallenge:InitializeData()
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			player_stats[nPlayerID] = {	melee_lh = 0, 
										melee_dn = 0, 
										melee_miss_friendly = 0, 
										melee_miss_foe = 0, 
										ranged_lh = 0, 
										ranged_dn = 0, 
										ranged_miss_friendly = 0, 
										ranged_miss_foe = 0, 
										siege_lh = 0, 
										siege_dn = 0, 
										siege_miss_friendly = 0, 
										siege_miss_foe = 0,
										new_record = false,
										hero_picked = nil,
										misses = 0,
										current_cs = { lh = 0, dn = 0},
										history = {},
										lh_history = 0,
										dn_history = 0,
										last_hit_streak = 0,
										deny_streak = 0,
										cs_streak = 0,
										max_cs_streak = 0,
										max_deny_streak = 0,
										max_last_hit_streak = 0,
										session_cs = 0,
										total_misses = 0,
										disconnected = false
									}

			--Totals
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_cs", { value = 0} )
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_lh", { value = 0} )
			CustomNetTables:SetTableValue("stats_totals", tostring(nPlayerID) .. "stats_total_dn", { value = 0} )

			--Streaks
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_cs", { value = 0} )
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_lh", { value = 0} )
			CustomNetTables:SetTableValue("stats_streaks", tostring(nPlayerID) .. "stats_streak_dn", { value = 0} )

			local time_list = {"150", "300", "450", "600", "-1"}
			local type_list = {"c", "l", "d","a"}
			local level_list = {"l", "n"}

			for i, typescore in pairs(type_list) do
				for j, time in pairs(time_list) do
					for hero, enabled in pairs(HERO_SELECTION) do
						if enabled == 1 then
							local kvhero = KVHEROES[hero]
							for l, level in pairs(level_list) do
							--local val = CustomNetTables:GetTableValue("stats_records", "stats_record_" .. typescore .. "_" .. hero .. "_" .. time  .. "_" .. level)
								local val = CustomNetTables:GetTableValue("stats_records", tostring(nPlayerID) .. typescore .. tostring(kvhero.HeroID) .. time .. level)
								if val == nil then
									--CustomNetTables:SetTableValue("stats_records", "stats_record_" .. typescore .. "_" .. hero .. "_" .. time  .. "_" .. level, { value = 0} )
									CustomNetTables:SetTableValue("stats_records", tostring(nPlayerID) .. typescore .. tostring(kvhero.HeroID) .. time .. level, { value = 0} )
								end
							end
						end
					end
				end
			end
			
			local steamid = PlayerResource:GetSteamAccountID(nPlayerID)

			local result = nil
			Storage:Get(steamid, function( resultTable, successBool )
			    if successBool then
			    	if resultTable ~= nil then
				        for k,v in pairs(resultTable) do
				        	local table_name = tostring(nPlayerID) .. v.typescore .. v.hero .. v.time .. v.leveling
				        	CustomNetTables:SetTableValue("stats_records", table_name, { value = v.value} )
				        end
			       	end
			    end

			end)


			CustomNetTables:SetTableValue( "stats_records", tostring(nPlayerID) .. "stats_accuracy_cs", { value = 100 } )
			CustomNetTables:SetTableValue( "stats_records", tostring(nPlayerID) .. "stats_accuracy_lh", { value = 100 } )
			CustomNetTables:SetTableValue( "stats_records", tostring(nPlayerID) .. "stats_accuracy_dn", { value = 100 } )	

			-- Total Details
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_lh", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_dn", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_miss_friendly", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_melee_miss_foe", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_lh", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_dn", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_miss_friendly", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_ranged_miss_foe", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_lh", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_dn", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_miss_friendly", { value = 0 } )
			CustomNetTables:SetTableValue( "stats_totals_details", tostring(nPlayerID) .. "stats_totals_details_siege_miss_foe", { value = 0 } )
			--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_lh", { value = 0 } )
			--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_dn", { value = 0 } )
			--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_friendly", { value = 0 } )
			--CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_foe", { value = 0 } )
		end
		initialize = true
	end
end