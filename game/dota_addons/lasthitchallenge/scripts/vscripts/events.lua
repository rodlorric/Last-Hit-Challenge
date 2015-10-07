require ( "util")
require ( "timers" )

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

  	PlayerResource:ReplaceHeroWith( 0, hero_picked, 0, 0)
	CLastHitChallenge:GiveZeroGold(PlayerResource:GetSelectedHeroEntity(0))
  	--CLastHitChallenge:GiveBlinkDagger(hero)
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
function CLastHitChallenge:OnThink()
	-- Stop thinking if game is paused
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

	if seconds < shortest_time then
		shortest_time = seconds
	end

	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	total_time = total_time + seconds
	-- clearing time!
	seconds = 0
	
	-- clearing creep score
	CustomNetTables:SetTableValue("stats_totals", "stats_total_lh", { value = 0 } )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_dn", { value = 0 } )
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_lh", { value = 100 })
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_dn", { value = 100 })
	CustomNetTables:SetTableValue("stats_records", "stats_accuracy_cs", { value = 100 })

	history = {}
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_history", history)

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
	--PauseGame(true)
	CLastHitChallenge:ClearUnits()
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


	misses = 0


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
	local stats_record_accuracy = CustomNetTables:GetTableValue( "stats_records", "stats_record_accuracy")
	if accuracy > stats_record_accuracy.value then
		stats_record_accuracy.value = accuracy
	end
	CustomNetTables:SetTableValue("stats_records", "stats_record_accuracy", stats_record_accuracy)

	--Misc
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_restart", { value = restarts })
	
	local c_lh = PlayerResource:GetLastHits(0) - current_cs["lh"]
	local c_dn = PlayerResource:GetDenies(0) - current_cs["dn"]
	table.insert(history, { lh = c_lh - lh_history, dn = c_dn - dn_history})
	lh_history = c_lh
	dn_history = c_dn
	CustomNetTables:SetTableValue("stats_misc", "stats_misc_history", history)

	
	local session_accuracy = 0
	if session_cs == 0 and total_misses == 0 then
		session_accuracy = 0
	else
		session_accuracy = ( session_cs * 100) / (session_cs + total_misses)
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

	seconds = 0
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "end_screen", {time = MAXTIME, hero = hero_picked})
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
				local origin = hurtUnit:GetOrigin()			
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "overlay", {x = origin.x-128, y = origin.y+64, z = origin.z+90, msg = pct})
			end
		end

		--if (hurtUnit:IsCreep() or hurtUnit:IsMechanical() or hurtUnit:IsTower()) and (hurtUnit:GetHealth() < hurtUnit:GetMaxHealth() * 0.25) and (hidehelp == 0) then
		if hurtUnit:IsCreep() and (hurtUnit:GetHealth() < hurtUnit:GetMaxHealth() * 0.25) and (hidehelp == 0) then
			local index = hurtUnit:entindex()
			if hurtunits[index] == nil then
				hurtunits[index] = ParticleManager:CreateParticle(particle_aura, PATTACH_ABSORIGIN_FOLLOW, hurtUnit)
			end

			if hurtUnit:GetHealth() == 0 then
				ParticleManager:DestroyParticle(hurtunits[index], true)
			end
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

leveling = "lvl"
function CLastHitChallenge:OnDisableLeveling( event )
	if event.disable_leveling == 1 then	
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
		GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)
		leveling = "nolvl"
	else
		GameRules:GetGameModeEntity():SetUseCustomHeroLevels(false)
		leveling = "lvl"
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

			
			local stats_record_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling )
			
			--Deny
			if friendly then
				local stats_record_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling)
				--streaks
				deny_streak = deny_streak + 1
				if deny_streak > max_deny_streak then
					max_deny_streak = deny_streak
				end

				CustomNetTables:SetTableValue( "stats_totals", "stats_total_dn", { value = dn } )

				if dn > stats_record_dn.value or  cs > stats_record_cs.value then
					if dn > stats_record_dn.value then
						stats_record_dn.value = dn
						CustomNetTables:SetTableValue("stats_records", "stats_record_dn_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_dn)
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
				local stats_record_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling)
				--streak
				last_hit_streak = last_hit_streak + 1
				if last_hit_streak > max_last_hit_streak then
					max_last_hit_streak = last_hit_streak
				end

				CustomNetTables:SetTableValue( "stats_totals", "stats_total_lh", { value = lh } );
				if lh > stats_record_lh.value or cs > stats_record_cs.value then
					if lh > stats_record_lh.value then
						stats_record_lh.value = lh
						CustomNetTables:SetTableValue("stats_records", "stats_record_lh_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling, stats_record_lh)
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
				CustomNetTables:SetTableValue("stats_records", "stats_record_cs_" .. hero_picked .. "_" .. tostring(MAXTIME) .. "_" .. leveling , stats_record_cs)
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
		local dn_accuracy = ((dn + melee_miss_friendly + ranged_miss_friendly + siege_miss_friendly) == 0) and 100 or (dn * 100) / (dn + melee_miss_friendly + ranged_miss_friendly + siege_miss_friendly)
		local cs_accuracy = ((lh + dn + misses) == 0) and 100 or ((lh + dn) * 100) / (lh + dn + misses)
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
				table.insert(history, { lh = c_lh - lh_history, dn = c_dn - dn_history})
				lh_history = c_lh
				dn_history = c_dn
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
	CLastHitChallenge:ClearUnits()
	CLastHitChallenge:ClearData()
	CLastHitChallenge:SetGameFrozen(true)
end

function CLastHitChallenge:OnRestart()	
	-- clearing units
	CLastHitChallenge:ClearUnits()
	CLastHitChallenge:ClearData()

	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	Timers:RemoveTimer("spawner")
	Timers:RemoveTimer("clock")

	--respawn the unit in an empty spot
	local player_hero = PlayerResource:GetSelectedHeroEntity(0)
	CLastHitChallenge:SafeSpawn(player_hero)

	PlayerResource:ReplaceHeroWith( 0, hero_picked, 0, 0)
	CLastHitChallenge:GiveZeroGold(player_hero)
	iter = 1
	CLastHitChallenge:SpawnCreeps()
	CLastHitChallenge:Clock()
end

function CLastHitChallenge:OnQuit()
	if Tutorial:GetTimeFrozen() then
		CLastHitChallenge:SetGameFrozen(false)
	end
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
	-- Show the ending scoreboard immediately
	GameRules:SetGameWinner( PlayerResource:GetTeam(0) )
	--SendToServerConsole("disconnect")
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