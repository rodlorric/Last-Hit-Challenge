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
tower_lh = 0
tower_dn = 0
tower_miss_friendly = 0
tower_miss_foe = 0
----------------------

function CLastHitChallenge:OnHeroPicked (event)
	CLastHitChallenge:Clock()
  	local hero = EntIndexToHScript(event.heroindex)
  	CLastHitChallenge:GiveZeroGold(hero)
  	CLastHitChallenge:GiveBlinkDagger(hero)

  	-- Populating tables
	--Totals
	CustomNetTables:SetTableValue("stats_totals", "stats_total_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_totals", "stats_total_dn", { value = 0} )

	--Records
	CustomNetTables:SetTableValue("stats_records", "stats_record_cs", { value = 0} )
	CustomNetTables:SetTableValue("stats_records", "stats_record_accuracy", { value = 0} )
	CustomNetTables:SetTableValue("stats_records", "stats_record_lh", { value = 0} )
	CustomNetTables:SetTableValue("stats_records", "stats_record_dn", { value = 0} )

  	
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
	
	-- This is to get towers' coordinates
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and radiant_tower == nil and dire_tower == nil then
		radiant_tower = Entities:FindByName(nil, 'dota_goodguys_tower1_mid')
		radiant_tower = radiant_tower:GetOrigin()
		
		dire_tower = Entities:FindByName(nil, 'dota_badguys_tower1_mid')
		dire_tower = dire_tower:GetOrigin()
	end

--[[ Make Towers invulnerable
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and not tower_invulnerable then
		print('if')
		CLastHitChallenge:SetTowerInvunerability('dota_goodguys_tower1_mid')
		CLastHitChallenge:SetTowerInvunerability('dota_badguys_tower1_mid')
		tower_invulnerable = true
	end
]]
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
  		return 1
	end

	if (MAXTIME - seconds) == 10 then
		BroadcastMessage("30 seconds left!", 1)
	end
	if seconds == MAXTIME then
		CLastHitChallenge:EndGame()
		--[[
		GameRules:SetCustomVictoryMessage( "Final" )
		GameRules:SetGameWinner( PlayerResource:GetTeam(0) )
		]]
	end

	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		print("ENDING GAME!")
		return 1
	end

--[[
	if self.countdownEnabled == true then
	    --CountdownTimer()
	    if nCOUNTDOWNTIMER == 30 then
	      BroadcastMessage("30 seconds left!", 1)
	      CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
	      
	    end
	    if nCOUNTDOWNTIMER <= 0 then
			local creep_score = PlayerResource:GetLastHits(0) + PlayerResource:GetDenies(0)			
			GameRules:SetGameWinner( PlayerResource:GetTeam(0) )
			self.countdownEnabled = false
	 	end
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		BroadcastMessage( "Final Creep Score: " .. tostring(creep_score), 5 )
		return 10
	end
	]]
		return 1
end

function CLastHitChallenge:EndGame()
	PauseGame(true)

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
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_lh", { value = tower_lh } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_dn", { value = tower_dn } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_miss_friendly", { value = tower_miss_friendly } )
	CustomNetTables:SetTableValue("stats_totals_details", "stats_totals_details_tower_miss_foe", { value = tower_miss_foe } )


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
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "end_screen", {})
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

function CLastHitChallenge:OnHurt( event )
	
	local hurtUnit = EntIndexToHScript( event.entindex_killed )
	if event.entindex_attacker ~= nil then
	local attacker = EntIndexToHScript( event.entindex_attacker )
		if (hurtUnit:IsCreep() or hurtUnit:IsMechanical()) and attacker:IsHero() then
			local health = hurtUnit:GetHealth()
			local max_health = hurtUnit:GetMaxHealth()
			--local min_dmg = attacker:GetBaseDamageMin()
			--print('max_dmg = ' .. tostring(max_dmg) + ' min_dmg = ' + tostring(min_dmg) )
			local pct = hurtUnit:GetHealth() / hurtUnit:GetMaxHealth()
			if pct ~= 0 then
				--DebugDrawText(hurtUnit:GetAbsOrigin(), "Close!", true, 1.0)
				local origin = hurtUnit:GetOrigin()			
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "overlay", {x = origin.x-128, y = origin.y+64, z = origin.z+90, msg = pct})
			end
		end
	end
	--if hurtUnit:IsTower() then
	--	hurtUnit:SetHealth(1300)
	--end
end


last_hit_streak = 0
deny_streak = 0
cs_streak = 0
max_cs_streak = 0
max_deny_streak = 0
max_last_hit_streak = 0

function CLastHitChallenge:OnEntityKilled (event)
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local attacker = EntIndexToHScript( event.entindex_attacker )

	local friendly = (PlayerResource:GetTeam(0) == killedUnit:GetTeam())
	print(friendly)
	if friendly then
		print("Friendly creep")
	else
		print("Foe creep")
	end

	if attacker:IsRealHero() and not killedUnit:IsRealHero() then		

		local lh = PlayerResource:GetLastHits(0) - current_cs["lh"]
		local dn = PlayerResource:GetDenies(0) - current_cs["dn"]
		local cs = lh + dn
		
		--Streaks
		cs_streak = cs_streak + 1 
		if cs_streak > max_cs_streak then
			max_cs_streak = cs_streak
		end

		
		local stats_record_cs = CustomNetTables:GetTableValue( "stats_records", "stats_record_cs")
		
		--Deny
		if friendly then
			local stats_record_dn = CustomNetTables:GetTableValue( "stats_records", "stats_record_dn")
			--streaks
			deny_streak = deny_streak + 1
			if deny_streak > max_deny_streak then
				max_deny_streak = deny_streak
			end

			CustomNetTables:SetTableValue( "stats_totals", "stats_total_dn", { value = PlayerResource:GetDenies(0) - current_cs["dn"] } )

			if dn > stats_record_dn.value or  cs > stats_record_cs.value then
				if dn > stats_record_dn.value then
					stats_record_dn.value = dn
					CustomNetTables:SetTableValue("stats_records", "stats_record_dn", stats_record_dn)
				end
			end


			--Totals Details
			if killedUnit:IsCreep() then
				if killedUnit:IsRangedAttacker() then
					ranged_dn = ranged_dn + 1
				else
					melee_dn = melee_dn + 1
				end
			elseif killedUnit:IsTower() then
				tower_dn = tower_dn + 1
			elseif killedUnit:IsMechanical() then
				siege_dn = siege_dn + 1
			end

		else --LastHit
			local stats_record_lh = CustomNetTables:GetTableValue( "stats_records", "stats_record_lh")
			--streak
			last_hit_streak = last_hit_streak + 1
			if last_hit_streak > max_last_hit_streak then
				max_last_hit_streak = last_hit_streak
			end

			CustomNetTables:SetTableValue( "stats_totals", "stats_total_lh", { value = PlayerResource:GetLastHits(0) - current_cs["lh"]} );
			if lh > stats_record_lh.value or cs > stats_record_cs.value then
				if lh > stats_record_lh.value then
					stats_record_lh.value = lh
					CustomNetTables:SetTableValue("stats_records", "stats_record_lh", stats_record_lh)
				end
			end

			--Totals Details
			if killedUnit:IsCreep() then
				if killedUnit:IsRangedAttacker() then
					ranged_lh = ranged_lh + 1
				else
					melee_lh = melee_lh + 1
				end
			elseif killedUnit:IsTower() then
				tower_lh = tower_lh + 1
			elseif killedUnit:IsMechanical() then
				siege_lh = siege_lh + 1
			end
		end
		CustomNetTables:SetTableValue( "stats_totals", "stats_total_cs", { value = (PlayerResource:GetLastHits(0) - current_cs["lh"]) + (PlayerResource:GetDenies(0) - current_cs["dn"]) } );
		
		--To track all time cs
		session_cs = session_cs + 1

		--Records
		if cs > stats_record_cs.value then
			stats_record_cs.value = cs
			CustomNetTables:SetTableValue("stats_records", "stats_record_cs", stats_record_cs)
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
			if killedUnit:IsCreep() then
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
			elseif killedUnit:IsTower() then
				if friendly then
						melee_miss_friendly = melee_miss_friendly + 1
					else
						melee_miss_foe = melee_miss_foe + 1
					end
			elseif killedUnit:IsMechanical() then
				if friendly then
					melee_miss_friendly = melee_miss_friendly + 1
				else
					melee_miss_foe = melee_miss_foe + 1
				end
			end

			local origin = killedUnit:GetOrigin()
			local bounds = killedUnit:GetUpVector()
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "overlay", {x = origin.x-128, y = origin.y+64, z = origin.z+90, msg = "missed"})
		end
	end
end

function CLastHitChallenge:OnRestart()
	restarts = restarts + 1

	if seconds < shortest_time then
		shortest_time = seconds
	end

	--Unpause the game if is paused on restart
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end

	local hero = PlayerResource:ReplaceHeroWith( 0, "npc_dota_hero_nevermore", 0, 0)
	hero = PlayerResource:GetSelectedHeroEntity(0)

	hero:ForceKill(true)

	total_time = total_time + seconds
	-- clearing time!
	seconds = 0

	-- clearing units
	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
		--if not unit:IsTower() then
		UTIL_Remove( unit )
		--end
	end

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, 
										Vector( 0, 0, 0 ), 
										nil, 
										FIND_UNITS_EVERYWHERE, 
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
										DOTA_UNIT_TARGET_ALL, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, false )) do
		--if not unit:IsTower() then
		UTIL_Remove( unit )
		--end
	end	


	-- clearing creep score
	current_cs = { lh = 0, dn = 0 }

	-- Totals
	CustomNetTables:SetTableValue( "stats_totals", "stats_total_cs", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals", "stats_total_lh", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals", "stats_total_dn", { value = 0 } )

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
	tower_lh = 0
	tower_dn = 0
	tower_miss_friendly = 0
	tower_miss_foe = 0
	----------------------

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
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_lh", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_dn", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_friendly", { value = 0 } )
	CustomNetTables:SetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_foe", { value = 0 } )
	
	--clearing misses
	misses = 0

	hero:RespawnHero(true, false, false)
	CLastHitChallenge:GiveZeroGold(hero)
	
	current_cs = { lh = PlayerResource:GetLastHits(0), dn = PlayerResource:GetDenies(0) }	

	local radiant_t = CreateUnitByName("npc_dota_radiant_tower1_mid", radiant_tower, false, nil, nil, DOTA_TEAM_GOODGUYS)
	radiant_t:RemoveModifierByName("modifier_invulnerable")
	radiant_t:SetRenderColor(206, 204, 192)

	local dire_t = CreateUnitByName("npc_dota_dire_tower1_mid", dire_tower, false, nil, nil, DOTA_TEAM_BADGUYS)
	dire_t:RemoveModifierByName("modifier_invulnerable")
	dire_t:SetRenderColor(63, 71, 62)
	
end

function CLastHitChallenge:OnQuit()
	--Unpause the game if is paused on restart
	if GameRules:IsGamePaused() == true then
  		PauseGame(false)
	end
	GameRules:SetGameWinner( PlayerResource:GetTeam(0) )
end

function CLastHitChallenge:Clock()
	if timer == nil then
		timer = Timers:CreateTimer(function()

		      	seconds = seconds + 1

				if seconds > longest_time then
					longest_time = seconds
				end

		      	local min = string.format("%.2d", math.floor(seconds/60)%60)
		      	local sec = string.format("%.2d", seconds%60)
		 	      	
		      	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "clock", {min = min, sec = sec})
		      	return 1.0
		end)
	end
end