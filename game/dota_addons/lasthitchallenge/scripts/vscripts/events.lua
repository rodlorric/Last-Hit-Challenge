require ( "util")
require ( "timers" )

function CLastHitChallenge:OnHeroPicked (event)
	CLastHitChallenge:Clock()
  	tprint(event, 0)
  	local hero = EntIndexToHScript(event.heroindex)
  	CLastHitChallenge:GiveZeroGold(hero)
  	CLastHitChallenge:GiveBlinkDagger(hero)
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
	
	-- This is to get towers coordinates
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
		return 1
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
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "overlay", {x = origin.x, y = origin.y, z = origin.z, pct = pct})
			end
		end
	end
	--if hurtUnit:IsTower() then
	--	hurtUnit:SetHealth(1300)
	--end
end


function CLastHitChallenge:OnLastHit (event)
	print("OnLastHit current_cs: ")
	tprint(current_cs, 0)
  	local creep_score = {
		lh = (PlayerResource:GetLastHits(0) - current_cs["lh"]) + 1,
		dn = PlayerResource:GetDenies(0) - current_cs["dn"]
	}
	creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
	print("creep_score: ")
	tprint(creep_score, 0)
	local custom_table_creep_score = CustomNetTables:GetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)))
	print(custom_table_creep_score)
	if custom_table_creep_score == nil then
		print("EmptyTable!")
		creep_score["anim"] = {lh = true, dn = false, cs = true}
		creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
		CustomNetTables:SetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)), creep_score );
	else
		print("Must check for records!")
		tprint(custom_table_creep_score, 0)
		local rec_lh = custom_table_creep_score["lh"]
		local rec_dn = custom_table_creep_score["dn"]
		local rec_cs = custom_table_creep_score["cs"]
		local rec_creep_score = {
			lh = rec_lh,
			dn = rec_dn,
			cs = rec_cs
		}
		if creep_score["lh"] > rec_lh or (creep_score["lh"] + creep_score["dn"]) > rec_cs then
			print("New Record! " .. tostring(creep_score["lh"] + creep_score["dn"]))
			if creep_score["lh"] > rec_lh then
				creep_score["anim"] = {lh = true, dn = false, cs = false}
				rec_creep_score["lh"] = creep_score["lh"]
				rec_creep_score["anim"] = creep_score["anim"]
			end
			if (creep_score["lh"] + creep_score["dn"]) > rec_cs then
				creep_score["anim"] = {lh = false, dn = false, cs = true}
				rec_creep_score = creep_score
			end
			if creep_score["lh"] > rec_lh and (creep_score["lh"] + creep_score["dn"]) > rec_cs then
				creep_score["anim"] = {lh = true, dn = false, cs = true}
				rec_creep_score = creep_score
			end
			CustomNetTables:SetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)), rec_creep_score );
		end
	end
  	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = true, cs = creep_score})
end

function CLastHitChallenge:OnDeny (event)
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	if hero:IsRealHero() and heroTeam == killedTeam then
		print("Deny?")
		local creep_score = {
			lh = PlayerResource:GetLastHits(0) - current_cs["lh"],
			dn = PlayerResource:GetDenies(0) - current_cs["dn"]
		}
		creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
		local custom_table_creep_score = CustomNetTables:GetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)))
		if custom_table_creep_score == nil then
			print("EmptyTable!")
			creep_score["anim"] = {lh = true, dn = false, cs = true}
			creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
			CustomNetTables:SetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)), creep_score );
		else
			print("Must check for records!")
			tprint(custom_table_creep_score,0 )
			local rec_lh = custom_table_creep_score["lh"]
			local rec_dn = custom_table_creep_score["dn"]
			local rec_cs = custom_table_creep_score["cs"]
			local rec_creep_score = {
				lh = rec_lh,
				dn = rec_dn,
				cs = rec_cs
			}
			if creep_score["dn"] > rec_dn or (creep_score["lh"] + creep_score["dn"]) > rec_cs then
				if creep_score["dn"] > rec_dn then
					creep_score["anim"] = {lh = false, dn = true, cs = false}
					rec_creep_score["dn"] = creep_score["dn"]
					rec_creep_score["anim"] = creep_score["anim"]
				end
				if (creep_score["lh"] + creep_score["dn"]) > rec_cs then
					creep_score["anim"] = {lh = false, dn = false, cs = true}
					rec_creep_score = creep_score									
				end
				if creep_score["dn"] > rec_dn and (creep_score["lh"] + creep_score["dn"]) > rec_cs then
					creep_score["anim"] = {lh = false, dn = true, cs = true}
					rec_creep_score = creep_score
				end
				print("New Record! " .. tostring(creep_score["lh"] + creep_score["dn"]))
				CustomNetTables:SetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)), rec_creep_score );
			end
		end
  		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = false, cs = creep_score})
	end	 	
end

function CLastHitChallenge:OnRestart()
	print("Restart!!!")

	local hero = PlayerResource:ReplaceHeroWith( 0, "npc_dota_hero_nevermore", 0, 0)
	hero = PlayerResource:GetSelectedHeroEntity(0)

	hero:ForceKill(true)

	-- clearing time!
	SECONDS = 0

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
		if unit:IsTower() then
				print(unit:GetClassname())
				print(unit:GetName())
				print(unit:GetEntityIndex())
				local tower = EntIndexToHScript(unit:GetEntityIndex())
				print(tower:GetName())
			end
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
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = false, cs = current_cs})
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = true, cs = current_cs})
	

	hero:RespawnHero(true, false, false)
	CLastHitChallenge:GiveZeroGold(hero)
	
	current_cs = { lh = PlayerResource:GetLastHits(0), dn = PlayerResource:GetDenies(0) }
	print('current_cs on restart')
	tprint(current_cs, 1)
	

	local radiant_t = CreateUnitByName("npc_dota_radiant_tower1_mid", radiant_tower, false, nil, nil, DOTA_TEAM_GOODGUYS)
	radiant_t:RemoveModifierByName("modifier_invulnerable")
	radiant_t:SetRenderColor(206, 204, 192)

	local dire_t = CreateUnitByName("npc_dota_dire_tower1_mid", dire_tower, false, nil, nil, DOTA_TEAM_BADGUYS)
	dire_t:RemoveModifierByName("modifier_invulnerable")
	dire_t:SetRenderColor(63, 71, 62)
	
end

function CLastHitChallenge:Clock()
	if timer == nil then
		timer = Timers:CreateTimer(function()
			      SECONDS = SECONDS + 1
			      local min = string.format("%.2d", SECONDS/60%60)
			      local sec = string.format("%.2d", SECONDS%60)
			      CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "clock", {min = min, sec = sec})
			      return 1.0
			    end)
	end
end