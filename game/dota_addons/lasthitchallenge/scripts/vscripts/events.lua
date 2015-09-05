require ( "util")
require ( "timers" )

function CLastHitChallenge:OnHeroPicked (event)
  tprint(event, 0)
  local hero = EntIndexToHScript(event.heroindex)
  self.countdownEnabled = true
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
	print('Thinking!!!')
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
  		return 1
	end
	print('countdownEnabled: ' .. tostring(self.countdownEnabled))
	print('GameState: ' .. tostring(GameRules:State_Get()))
	if self.countdownEnabled == true then
	    CountdownTimer()
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

function CLastHitChallenge:OnLastHit (event)
	print("OnLastHit current_cs: ")
	tprint(current_cs)
  	local creep_score = {
		lh = (PlayerResource:GetLastHits(0) - current_cs["lh"]) + 1,
		dn = PlayerResource:GetDenies(0) - current_cs["dn"]
	}
	creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
	print("creep_score: ")
	tprint(creep_score)
	local custom_table_creep_score = CustomNetTables:GetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)))
	print(custom_table_creep_score)
	if custom_table_creep_score == nil then
		print("EmptyTable!")
		creep_score["anim"] = {lh = true, dn = false, cs = true}
		creep_score["cs"] = creep_score["lh"] + creep_score["dn"]
		CustomNetTables:SetTableValue( "custom_creep_score_records", tostring(PlayerResource:GetSteamAccountID(0)), creep_score );
		Timers:CreateTimer({
			endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			callback = function()
			 CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_records_animation", {})
			end
		})
	else
		print("Must check for records!")
		tprint(custom_table_creep_score)
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
			Timers:CreateTimer({
			    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
			    callback = function()
			    	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_records_animation", {})
			    end
		  	})
		end
	end
  	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = true, cs = creep_score})
  	Timers:CreateTimer({
	    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	    	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_animation", {lh = true})
	    end
  	})
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
			Timers:CreateTimer({
				endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
				callback = function()
			 		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_records_animation", creep_score)
				end
			})
		else
			print("Must check for records!")
			tprint(custom_table_creep_score)
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
				Timers:CreateTimer({
					endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
					callback = function()
						CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_records_animation", {})
					end
				})
			end
		end
  		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = false, cs = creep_score})
  		Timers:CreateTimer({
		    endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		    callback = function()
		    	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_animation", {lh = false})
	    	end
  		})
	end	 	
end

function CLastHitChallenge:OnRestart()
	print("Restart!!!")
	local hero = PlayerResource:GetSelectedHeroEntity(0)

	hero:ForceKill(true)

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, 
											Vector( 0, 0, 0 ), 
											nil, 
											FIND_UNITS_EVERYWHERE, 
											DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
											DOTA_UNIT_TARGET_ALL, 
											DOTA_UNIT_TARGET_FLAG_NONE, 
											FIND_ANY_ORDER, false )) do
		if not unit:IsTower() then
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
		if not unit:IsTower() then
			UTIL_Remove( unit )
		end
	end	

	current_cs = { lh = 0, dn = 0 }
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = false, cs = current_cs})
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "last_hit", {lh = true, cs = current_cs})
	
	Timers:CreateTimer({
		endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = function()
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_animation", {lh = true})
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(0), "reset_animation", {lh = false})
			hero:RespawnHero(true, false, false)
			CLastHitChallenge:GiveZeroGold(hero)
	 	end
	})
	
	current_cs = { lh = PlayerResource:GetLastHits(0), dn = PlayerResource:GetDenies(0) }
	print('current_cs on restart')
	tprint(current_cs)
end