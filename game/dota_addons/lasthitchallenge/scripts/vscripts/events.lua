require ( "util")
require ( "timers" )


STORAGEAPI_API_URL_LEADERBOARD = "http://lasthitchallenge-sphexing.rhcloud.com/leaderboard"
--STORAGEAPI_API_URL_LEADERBOARD = "http://lasthitchallengedev-sphexing.rhcloud.com/leaderboard"
--STORAGEAPI_API_URL_LEADERBOARD = "http://localhost:5000/leaderboard"

STORAGEAPI_API_URL_CHEATERS = "http://lasthitchallenge-sphexing.rhcloud.com/cheaters"
--STORAGEAPI_API_URL_CHEATERS = "http://lasthitchallengedev-sphexing.rhcloud.com/cheaters"
--STORAGEAPI_API_URL_CHEATERS = "http://localhost:5000/cheaters"

--detailed stats totals
melee_lh = 0
melee_dn = 0
melee_miss_friendly = 0
melee_miss_foe = 0
ranged_lh = 0
ranged_dn = 0
ranged_miss_friendly = 0
ranged_miss_foe = 0
siege_lh = 0
siege_dn = 0
siege_miss_friendly = 0
siege_miss_foe = 0
--tower_lh = 0
--tower_dn = 0
--tower_miss_friendly = 0
--tower_miss_foe = 0
----------------------
hidehelp = 0
----------------------
iter = 1
----------------------
hero_picked = nil
new_record = false
----------------------
function CLastHitChallenge:OnHeroPicked(hero_param)
	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
	iter = 1
	CLastHitChallenge:SpawnCreeps()
	CLastHitChallenge:Clock()

	hero_picked = hero_param.hero

 	--Spawn the hero in an empty spot
 	CLastHitChallenge:SafeSpawn(PlayerResource:GetSelectedHeroEntity(0))

	local phero = PlayerResource:GetPlayer(0):GetAssignedHero()
	--local nhero = PlayerResource:ReplaceHeroWith( 0, "npc_dota_hero_" .. hero_picked, 0, 0)
	local hero_picked_name = CLastHitChallenge:HeroName(tonumber(hero_picked))
	local nhero = PlayerResource:ReplaceHeroWith( 0, hero_picked_name, 0, 0)
	UTIL_Remove(phero)
  	
	--CLastHitChallenge:GiveZeroGold(PlayerResource:GetSelectedHeroEntity(0))
  	--CLastHitChallenge:GiveBlinkDagger(hero)
end

function CLastHitChallenge:HeroName(hero_picked)
	local hero_name = { [11] = "npc_dota_hero_nevermore",
						[17] = "npc_dota_hero_storm_spirit",
						[46] = "npc_dota_hero_templar_assassin",
						[34] = "npc_dota_hero_tinker",
						[74] = "npc_dota_hero_invoker",
						[76] = "npc_dota_hero_obsidian_destroyer",
						[39] = "npc_dota_hero_queenofpain",
						[13] = "npc_dota_hero_puck",
						[43] = "npc_dota_hero_death_prophet",
						[52] = "npc_dota_hero_leshrac",
						[106] = "npc_dota_hero_ember_spirit",
						[25] = "npc_dota_hero_lina",
						[47] = "npc_dota_hero_viper",
						[97] = "npc_dota_hero_magnataur",
						[35] = "npc_dota_hero_sniper",
						[49] = "npc_dota_hero_dragon_knight",
						[23] = "npc_dota_hero_kunkka",
						[78] = "npc_dota_hero_brewmaster",
						[60] = "npc_dota_hero_night_stalker",
						[59] = "npc_dota_hero_huskar",
						[19] = "npc_dota_hero_tiny",
						[21] = "npc_dota_hero_windrunner",
						[22] = "npc_dota_hero_zuus",
						[64] = "npc_dota_hero_jakiro"
					}
	return hero_name[hero_picked]
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
		if Convars:GetInt("sv_cheats") == 1 and not cheater then
			cheater = true
			Storage:PutCheater( PlayerResource:GetSteamAccountID(0), STORAGEAPI_API_URL_CHEATERS, function( resultTable, successBool )			
		    	if successBool then
					print("Nice try!")
		    	end
			end)
		end
	end

	if GameRules:IsGamePaused() == true then
  		return 1
	end

	if seconds == MAXTIME then
		CLastHitChallenge:EndGame()
	end

	return 1
end

function CLastHitChallenge:OnTimePicked(time_data)
	MAXTIME = time_data.time
end

function CLastHitChallenge:ClearData()
	restarts = restarts + 1

	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	total_time = total_time + seconds
	-- clearing time!
	seconds = 0
	
	-- clearing creep score
	CustomNetTables:SetTableValue("stats_totals", "stats_total_lh", { value = 0 } )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_dn", { value = 0 } )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_cs", { value = 0 } )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_accuracy", { value = 100 } )
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_lh", { value = 100 })
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_dn", { value = 100 })
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_cs", { value = 100 })

	history = {}
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_history", history)

	--clearing particles helper
	hurtunits = {}

	--Totals Details
	--detailed stats totals
	melee_lh = 0
	melee_dn = 0
	melee_miss_friendly = 0
	melee_miss_foe = 0
	ranged_lh = 0
	ranged_dn = 0
	ranged_miss_friendly = 0
	ranged_miss_foe = 0
	siege_lh = 0
	siege_dn = 0
	siege_miss_friendly = 0
	siege_miss_foe = 0
	--tower_lh = 0
	--tower_dn = 0
	tower_miss_friendly = 0
	tower_miss_foe = 0
	----------------------
	
	--clearing misses
	misses = 0
	
	current_cs = { lh = PlayerResource:GetLastHits(0), dn = PlayerResource:GetDenies(0) }
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

function CLastHitChallenge:EndGame()

	if seconds < shortest_time or shortest_time == MAXTIME then
		shortest_time = seconds
	end

	--PauseGame(true)
	CLastHitChallenge:SetGameFrozen(true)
	--Totals
	local stats_total_cs = CustomNetTables:GetTableValue( "stats_totals", "stats_total_cs")
	local stats_total_lh = CustomNetTables:GetTableValue( "stats_totals", "stats_total_lh")
	local stats_total_dn = CustomNetTables:GetTableValue( "stats_totals", "stats_total_dn")

	CustomNetTables:SetTableValue("stats_totals", "stats_total_miss", { value = misses })
	
	local stats_total_cs = CustomNetTables:GetTableValue( "stats_totals", "stats_total_cs")
	local accuracy = 0
	if stats_total_cs.value == 0 and misses == 0 then
		accuracy = 0
	else
		accuracy = ( stats_total_cs.value * 100) / (stats_total_cs.value + misses)
		accuracy = round(accuracy, 0)
	end
	CustomNetTables:SetTableValue("stats_totals", "stats_total_accuracy", { value = accuracy })

	--Totals Details
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_melee_lh", { value = melee_lh } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_melee_dn", { value = melee_dn } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_melee_miss_friendly", { value = melee_miss_friendly } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_melee_miss_foe", { value = melee_miss_foe } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_ranged_lh", { value = ranged_lh } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_ranged_dn", { value = ranged_dn } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_ranged_miss_friendly", { value = ranged_miss_friendly } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_ranged_miss_foe", { value = ranged_miss_foe } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_siege_lh", { value = siege_lh } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_siege_dn", { value = siege_dn } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_siege_miss_friendly", { value = siege_miss_friendly } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_siege_miss_foe", { value = siege_miss_foe } )
	--CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_lh", { value = tower_lh } )
	--CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_dn", { value = tower_dn } )
	--CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_miss_friendly", { value = tower_miss_friendly } )
	--CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_miss_foe", { value = tower_miss_foe } )

	--Streaks
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_cs", { value = max_cs_streak })
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_lh", { value = max_last_hit_streak })
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_dn", { value = max_deny_streak })
	cs_streak = 0
	last_hit_streak = 0
	deny_streak = 0
	max_deny_streak = 0
	max_cs_streak = 0
	max_last_hit_streak = 0

	--Records
	--local stats_record_accuracy = CustomNetTables:GetTableValue( "stats_records", "stats_record_ac_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling)
	local stats_record_accuracy = CustomNetTables:GetTableValue( "stats_records", "a" .. hero_picked .. tostring(MAXTIME) .. leveling)
	if seconds == MAXTIME then
		if accuracy > stats_record_accuracy.value then
			stats_record_accuracy.value = accuracy
			--CustomNetTables:SetTableValue("stats_records", "stats_record_ac_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_accuracy)
			CustomNetTables:SetTableValue("stats_records", "a" .. hero_picked .. tostring(MAXTIME) .. leveling, stats_record_accuracy)
			new_record = true
		end
	end


	--Misc
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_restart", { value = restarts })
	
	local c_lh = PlayerResource:GetLastHits(0) - current_cs["lh"]
	local c_dn = PlayerResource:GetDenies(0) - current_cs["dn"]
	table.insert(history, { lh = c_lh - lh_history, dn = c_dn - dn_history, time = seconds})
	--lh_history = c_lh
	--dn_history = c_dn
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_history", history)
	table.remove(history)
	
	local session_accuracy = 0
	if session_cs == 0 and total_misses == 0 then
		session_accuracy = 0
	else
		session_accuracy = ( session_cs * 100) / (session_cs + total_misses)
		session_accuracy = round(session_accuracy, 0)
	end

	CustomNetTables:SetTableValue("stats_misc", "stats_misc_session_accuracy", { value = session_accuracy })


	--Time
	total_time = total_time + seconds
	local min = string.format("%.2d", math.floor(total_time/60)%60)
	local sec = string.format("%.2d", total_time%60)
	CustomNetTables:SetTableValue( "stats_time", "stats_time_spent", { value = tostring(min) .. ":" .. tostring(sec) } );

	min = string.format("%.2d", math.floor(longest_time/60)%60)
	sec = string.format("%.2d", longest_time%60)
	CustomNetTables:SetTableValue( "stats_time", "stats_time_longest", { value = tostring(min) .. ":" .. tostring(sec) } );

	min = string.format("%.2d", math.floor(shortest_time/60)%60)
	sec = string.format("%.2d", shortest_time%60)
	CustomNetTables:SetTableValue( "stats_time", "stats_time_shortest", { value = tostring(min) .. ":" .. tostring(sec) } );

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "end_screen", {time = seconds, hero = hero_picked, level = leveling, maxtime = MAXTIME})
	
	if seconds == MAXTIME then
		seconds = 0	
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
		if hurtUnit:IsCreep() and attacker:IsHero() then
			local health = hurtUnit:GetHealth()
			local max_health = hurtUnit:GetMaxHealth()
			local pct = hurtUnit:GetHealth() / hurtUnit:GetMaxHealth()
			if pct ~= 0 then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "hurt_entity", {index = event.entindex_killed, msg = pct})
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

leveling = "l"
function CLastHitChallenge:OnDisableLeveling( event )
	if event.disable_leveling == 1 then	
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
		GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)
		leveling = "n"
	else
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(false)
		leveling = "l"
	end
end


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

		local friendly = (PlayerResource:GetTeam(0) == killedUnit:GetTeam())

		local lh = PlayerResource:GetLastHits(0) - current_cs["lh"]
		local dn = PlayerResource:GetDenies(0) - current_cs["dn"]
		local cs = lh + dn

		if attacker:IsRealHero() and not killedUnit:IsRealHero() then
			
			--Streaks
			cs_streak = cs_streak + 1 
			if cs_streak > max_cs_streak then
				max_cs_streak = cs_streak
			end

			
			--local stats_record_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling )
			local stats_record_cs = CustomNetTables:GetTableValue( "stats_records", "c" .. hero_picked .. tostring(MAXTIME) .. leveling )
			
			--Deny
			if friendly then
				--local stats_record_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling)
				local stats_record_dn = CustomNetTables:GetTableValue( "stats_records", "d" .. hero_picked .. tostring(MAXTIME) .. leveling)
				--streaks
				deny_streak = deny_streak + 1
				if deny_streak > max_deny_streak then
					max_deny_streak = deny_streak
				end

				CustomNetTables:SetTableValue( "stats_totals", "stats_total_dn", { value = dn } )

				if dn > stats_record_dn.value or  cs > stats_record_cs.value then
					if dn > stats_record_dn.value then
						stats_record_dn.value = dn
						--CustomNetTables:SetTableValue("stats_records", "stats_record_dn_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_dn)
						CustomNetTables:SetTableValue("stats_records", "d" .. hero_picked .. tostring(MAXTIME) .. leveling, stats_record_dn)
						new_record = true
					end
				end


				--Totals Details
				if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
					if killedUnit:IsRangedAttacker() then
						ranged_dn = ranged_dn + 1
					else
						melee_dn = melee_dn + 1
					end
				--elseif killedUnit:IsTower() then
				--	tower_dn = tower_dn + 1
				else
					siege_dn = siege_dn + 1
				end

			else --LastHit
				--local stats_record_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling)
				local stats_record_lh = CustomNetTables:GetTableValue( "stats_records", "l" .. hero_picked .. tostring(MAXTIME) .. leveling)
				--streak
				last_hit_streak = last_hit_streak + 1
				if last_hit_streak > max_last_hit_streak then
					max_last_hit_streak = last_hit_streak
				end

				CustomNetTables:SetTableValue( "stats_totals", "stats_total_lh", { value = lh } );
				if lh > stats_record_lh.value or cs > stats_record_cs.value then
					if lh > stats_record_lh.value then
						stats_record_lh.value = lh
						--CustomNetTables:SetTableValue("stats_records", "stats_record_lh_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_lh)
						CustomNetTables:SetTableValue("stats_records", "l" .. hero_picked .. tostring(MAXTIME) .. leveling, stats_record_lh)
						new_record = true
					end
				end

				--Totals Details
				if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
					if killedUnit:IsRangedAttacker() then
						ranged_lh = ranged_lh + 1
					else
						melee_lh = melee_lh + 1
					end
				--elseif killedUnit:IsTower() then
				--	tower_lh = tower_lh + 1
				else
					siege_lh = siege_lh + 1
				end
			end
			CustomNetTables:SetTableValue( "stats_totals", "stats_total_cs", { value = lh + dn } );
			
			--To track all time cs
			session_cs = session_cs + 1

			--Records
			if cs > stats_record_cs.value then
				stats_record_cs.value = cs
				--CustomNetTables:SetTableValue("stats_records", "stats_record_cs_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling , stats_record_cs)
				CustomNetTables:SetTableValue("stats_records", "c" .. hero_picked .. tostring(MAXTIME) .. leveling , stats_record_cs)
				new_record = true
			end
		else -- misses
			if not killedUnit:IsHero() then
				--streaks
				cs_streak = 0

				if friendly then
					deny_streak = 0
				else
					last_hit_streak = 0
				end
				total_misses = total_misses + 1
				misses = misses + 1


				--Totals Details
				if killedUnit:IsCreep() and killedUnitName ~= "npc_dota_badguys_siege" and killedUnitName ~= "npc_dota_goodguys_siege" then
					if killedUnit:IsRangedAttacker() then
						if friendly then
							ranged_miss_friendly = ranged_miss_friendly + 1
						else
							ranged_miss_foe = ranged_miss_foe + 1
						end
					else
						if friendly then
							melee_miss_friendly = melee_miss_friendly + 1
						else
							melee_miss_foe = melee_miss_foe + 1
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
						siege_miss_friendly = siege_miss_friendly + 1
					else
						siege_miss_foe = siege_miss_foe + 1
					end
				end

				local origin = killedUnit:GetOrigin()
				local bounds = killedUnit:GetUpVector()
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "overlay", {x = origin.x-128, y = origin.y+64, z = origin.z+90, msg = "missed"})
			end
		end

		local lh_accuracy = ((lh + melee_miss_foe + ranged_miss_foe + siege_miss_foe) == 0) and 100 or (lh * 100) / ( lh + melee_miss_foe + ranged_miss_foe + siege_miss_foe)
		lh_accuracy = round(lh_accuracy)
		local dn_accuracy = ((dn + melee_miss_friendly + ranged_miss_friendly + siege_miss_friendly) == 0) and 100 or (dn * 100) / (dn + melee_miss_friendly + ranged_miss_friendly + siege_miss_friendly)
		dn_accuracy = round(dn_accuracy)
		local cs_accuracy = ((lh + dn + misses) == 0) and 100 or ((lh + dn) * 100) / (lh + dn + misses)
		cs_accuracy = round(cs_accuracy)
		CustomNetTables:SetTableValue("stats_records", "stats_accuracy_lh", { value = lh_accuracy })
		CustomNetTables:SetTableValue("stats_records", "stats_accuracy_dn", { value = dn_accuracy })
		CustomNetTables:SetTableValue("stats_records", "stats_accuracy_cs", { value = cs_accuracy })
	end
end

history = {}
lh_history = 0
dn_history = 0
function CLastHitChallenge:SpawnCreeps()
	lh_history = PlayerResource:GetLastHits(0) - current_cs["lh"]
	dn_history = PlayerResource:GetDenies(0) - current_cs["dn"]
	local point = nil
	local waypoint = nil
	Timers:CreateTimer("spawner", {
			useGameTime = true,
    		endTime = 0,
			callback = function()
				CLastHitChallenge:Spawner()
				local c_lh = PlayerResource:GetLastHits(0) - current_cs["lh"]
				local c_dn = PlayerResource:GetDenies(0) - current_cs["dn"]
				if seconds > 1 then
					table.insert(history, { lh = c_lh - lh_history, dn = c_dn - dn_history, time = seconds-1})
					lh_history = c_lh
					dn_history = c_dn
				end
				return 30.0
			end
		})
end

function CLastHitChallenge:Spawner()
	local point = nil
	local waypoint = nil
	for i=1,2 do
	    point = Entities:FindByName( nil, "npc_dota_spawner_" .. (i == 1 and "good" or "bad") .. "_mid_staging"):GetAbsOrigin()			
	    waypoint = Entities:FindByName(nil, "lane_mid_pathcorner_" .. (i == 1 and "good" or "bad") .. "guys_1")
		if waypoint then
			for j=1,4 do		
				unit = CreateUnitByName("npc_dota_creep_" .. (i == 1 and "good" or "bad") .. "guys_" .. (j < 4 and "melee" or "ranged"), point, true, nil, nil, (i == 1 and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS))
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
			end
			-- spawn siege creep every 7th wave
			if iter % 7 == 0 then
				unit = CreateUnitByName("npc_dota_" .. (i == 1 and "good" or "bad") .. "guys_siege", point, true, nil, nil, (i == 1 and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS))
				unit:SetInitialGoalEntity(waypoint)
			end
		end
	end
	iter = iter + 1
end

function CLastHitChallenge:OnRepick()
	Timers:RemoveTimer("spawner")
	Timers:RemoveTimer("clock")
	CLastHitChallenge:SetGameFrozen(true)
	CLastHitChallenge:ClearUnits()
	CLastHitChallenge:ClearData()
end

function CLastHitChallenge:OnRestart()
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	if seconds < shortest_time or shortest_time == MAXTIME then
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

	--respawn the unit in an empty spot
	local player_hero = PlayerResource:GetSelectedHeroEntity(0)
	CLastHitChallenge:SafeSpawn(player_hero)

	local phero = PlayerResource:GetPlayer(0):GetAssignedHero()
	local hero_picked_name = CLastHitChallenge:HeroName(tonumber(hero_picked))
	local nhero = PlayerResource:ReplaceHeroWith( 0, hero_picked_name, 0, 0)
	UTIL_Remove(phero)

	--CLastHitChallenge:GiveZeroGold(player_hero)
	iter = 1
	CLastHitChallenge:SpawnCreeps()
	CLastHitChallenge:Clock()
end

function CLastHitChallenge:OnQuit()
	CLastHitChallenge:UploadRecords()
	CLastHitChallenge:Resume()
	-- Show the ending scoreboard immediately
	GameRules:SetGameWinner( PlayerResource:GetTeam(0) )
end

function CLastHitChallenge:OnLeaderboard(query)
	local steamid = PlayerResource:GetSteamAccountID(0)
	leader_list = {}
	if cheater then
		Storage:GetCheater(STORAGEAPI_API_URL_CHEATERS, function( resultTable, successBool )
		    if successBool then
		    	if resultTable ~= nil then
			        for k,v in pairs(resultTable) do
						table.insert(leader_list, 1, {steam_id = v.steam_id, value = "sv_cheats 1 :)"})
			        end
		       	end
		    end
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "leaderboard", {leader_list = leader_list, cheater = true})
		end)
	else
		if (query.refresh ~= nil and query.refresh == 1) then
			Storage:InvalidateLeaderboard(steamid, query.hero, query.time, query.leveling, query.typescore)
			CLastHitChallenge:UploadRecords()
		end
		local table_name = query.typescore .. query.hero .. query.time .. query.leveling
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
	        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "leaderboard", leader_list)
		end)
	end
end

function CLastHitChallenge:Resume()
	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
end


function CLastHitChallenge:UploadRecords()
	if new_record and not cheater then
		local hero_list = {"11","17","46","34","74","76","39","13","43","52","106","25","47","97","35","49","23","78","60","59","19","21","22","64"}
		local time_list = {"150", "300", "450", "600"}
		local type_list = {"c", "l", "d", "a"}
		local level_list = {"l", "n"}

		local data = {}

		for i, typescore in pairs(type_list) do
			for j, time in pairs(time_list) do
				for k, hero in pairs(hero_list) do
					for l, level in pairs(level_list) do
						local table_name = typescore ..  hero ..  time .. level
						local record = CustomNetTables:GetTableValue( "stats_records", table_name )
						if record.value > 0 then
							--table.insert(data, {k = table_name, v = record.value})
							table.insert(data, {hero = hero, time = time, leveling = level, typescore = typescore, value = record.value})
						end
					end
				end
			end
		end

		local steamid = PlayerResource:GetSteamAccountID(0)
		Storage:Put( steamid, data, function( resultTable, successBool )
	    	if successBool then
	        	print("Successfully put data in storage")
	        	new_record = false
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
	 	      	
	      	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "clock", {min = min, sec = sec, bTimeLeft = bTimeLeft})
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
end

function CLastHitChallenge:InitializeData()
	  	-- Populating tables
	--Totals
	CustomNetTables:SetTableValue("stats_totals", "stats_total_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_dn", { value = 0} )

	--Streaks
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_streaks", "stats_streak_dn", { value = 0} )

	--[[Records
	local records_acc = CustomNetTables:GetTableValue( "stats_records", "stats_record_accuracy")
	if (records_acc == nil) then
		CustomNetTables:SetTableValue("stats_records", "stats_record_accuracy", { value = 0} )
	end
	]]

	local hero_list = {"11","17","46","34","74","76","39","13","43","52","106","25","47","97","35","49","23","78","60","59","19","21","22","64"}
	local time_list = {"150", "300", "450", "600"}
	local type_list = {"c", "l", "d","a"}
	local level_list = {"l", "n"}

	for i, typescore in pairs(type_list) do
		for j, time in pairs(time_list) do
			for k, hero in pairs(hero_list) do
				for l, level in pairs(level_list) do
					--local val = CustomNetTables:GetTableValue("stats_records", "stats_record_" .. typescore .. "_" .. hero .. "_" .. time  .. "_" .. level)
					local val = CustomNetTables:GetTableValue("stats_records", typescore .. hero .. time .. level)
					if val == nil then
						--CustomNetTables:SetTableValue("stats_records", "stats_record_" .. typescore .. "_" .. hero .. "_" .. time  .. "_" .. level, { value = 0} )
						CustomNetTables:SetTableValue("stats_records", typescore .. hero .. time .. level, { value = 0} )
					end
				end
			end
		end
	end
	
	local steamid = PlayerResource:GetSteamAccountID(0)
	local result = nil
	Storage:Get(steamid, function( resultTable, successBool )
	    if successBool then
	    	if resultTable ~= nil then
		        for k,v in pairs(resultTable) do
		        	local table_name = v.typescore .. v.hero .. v.time .. v.leveling
		        	--CustomNetTables:SetTableValue("stats_records", v.k, { value = v.v} )
		        	CustomNetTables:SetTableValue("stats_records", table_name, { value = v.value} )
		        end
	       	end
	    end

	end)


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
	initialize = true
end