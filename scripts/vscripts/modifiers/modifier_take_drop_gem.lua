modifier_take_drop_gem = class({})

function modifier_take_drop_gem:IsHidden()
	return true
end

function modifier_take_drop_gem:IsPurgable()
	return false
end

function modifier_take_drop_gem:RemoveOnDeath()
	return false
end

function modifier_take_drop_gem:OnCreated( kv )
	self:StartIntervalThink(0.1)
end

function modifier_take_drop_gem:OnIntervalThink()
if not IsServer() then return end
	-- if not GameRules:IsCheatMode() then
	local point = self:GetParent():GetOrigin()
	if self:GetParent():GetModelName() ~= "models/development/invisiblebox.vmdl" then
		local items_on_the_ground = Entities:FindAllByClassnameWithin("dota_item_drop",point,700)
			for _,item in pairs(items_on_the_ground) do
				local containedItem = item:GetContainedItem()	
				local item_name = containedItem:GetAbilityName()		
				local name = string.sub(item_name, 0, 9)
				if name == 'item_bag_' then
					if containedItem ~= nil then
					self:GetParent():MoveToPosition(item:GetAbsOrigin())
						if (point - item:GetAbsOrigin()):Length2D() < 10 then
							if item ~= nil then
								for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
									if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
										if PlayerResource:HasSelectedHero( nPlayerID ) then
											local unit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
											gold = 2500 / PlayersInGameCount()
											unit:ModifyGold( gold, true, 0 )
											SendOverheadEventMessage(unit, OVERHEAD_ALERT_GOLD, unit, gold, nil)
											UTIL_RemoveImmediate(item)	
										end
									end
								end	
							end
						end
					end	
				end
				if name == "item_gems" then
					local number = tonumber(string.sub(item_name, -1))
					if containedItem ~= nil then
						if (number % 2 == 0) then  
							self:GetParent():MoveToPosition(item:GetAbsOrigin())
							if (point - item:GetAbsOrigin()):Length2D() < 10 then
								if item ~= nil then
									self:GetParent():GetOwner():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
									local pid = self:GetParent():GetOwner():GetPlayerID()
									Smithy:add_gems({PlayerID = pid, type = number, value = RandomInt(60,120)})	
									UTIL_RemoveImmediate(item)	
								end
							end
						else
							self:GetParent():MoveToPosition(item:GetAbsOrigin())
							if (point - item:GetAbsOrigin()):Length2D() < 10 then
								if item ~= nil then
									self:GetParent():GetOwner():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
									local pid = self:GetParent():GetOwner():GetPlayerID()
									Smithy:add_gems({PlayerID = pid, type = number, value = RandomInt(40,80)})	
									UTIL_RemoveImmediate(item)	
								end
							end
						end	
					end
				end
			end	
		end
	-- end	
end	

function PlayersInGameCount()
	count = 0
	for nPlayerID = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayer(nPlayerID) then
		local connectState = PlayerResource:GetConnectionState(nPlayerID)	
			if bot(nPlayerID) or connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN then print("player leave") else
				count = count + 1
			end
		end
	end
	return count
end