item_mjollnir_lua1_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua2_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua3_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua4_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua5_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua6_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua7_gem1 = item_mjollnir_lua1_gem1 or class({})
item_mjollnir_lua8_gem1 = item_mjollnir_lua1_gem1 or class({})

item_mjollnir_lua1_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua2_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua3_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua4_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua5_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua6_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua7_gem2 = item_mjollnir_lua1_gem2 or class({})
item_mjollnir_lua8_gem2 = item_mjollnir_lua1_gem2 or class({})

item_mjollnir_lua1_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua2_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua3_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua4_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua5_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua6_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua7_gem3 = item_mjollnir_lua1_gem3 or class({})
item_mjollnir_lua8_gem3 = item_mjollnir_lua1_gem3 or class({})

item_mjollnir_lua1_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua2_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua3_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua4_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua5_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua6_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua7_gem4 = item_mjollnir_lua1_gem4 or class({})
item_mjollnir_lua8_gem4 = item_mjollnir_lua1_gem4 or class({})

item_mjollnir_lua1_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua2_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua3_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua4_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua5_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua6_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua7_gem5 = item_mjollnir_lua1_gem5 or class({})
item_mjollnir_lua8_gem5 = item_mjollnir_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_mjollnir1", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir2", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir3", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir4", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir5", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_lua_strike", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_lua_active", 'items/items_gems/item_mjollnir_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_mjollnir_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_mjollnir1"
end

function item_mjollnir_lua1_gem1:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_lua_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end
--item_mjollnir_lua1_gem2
function item_mjollnir_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_mjollnir2"
end

function item_mjollnir_lua1_gem2:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_lua_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end
--item_mjollnir_lua1_gem3
function item_mjollnir_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_mjollnir3"
end

function item_mjollnir_lua1_gem3:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_lua_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end
--item_mjollnir_lua1_gem4
function item_mjollnir_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_mjollnir4"
end

function item_mjollnir_lua1_gem4:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_lua_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end
--item_mjollnir_lua1_gem5
function item_mjollnir_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_mjollnir5"
end

function item_mjollnir_lua1_gem5:OnSpellStart()
	local target = self:GetCursorTarget()
		if self:GetCaster():GetTeamNumber() == self:GetCursorTarget():GetTeam() and not target:IsBuilding() == true then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_mjollnir_lua_active", {duration = 15})
			self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
		end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
modifier_item_mjollnir_lua_active = class({})

function modifier_item_mjollnir_lua_active:GetTexture()
	return item_mjollnir
end

function modifier_item_mjollnir_lua_active:OnCreated()
	self.shield_particle = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.shield_particle, false, false, -1, false, false)
	self.static_chance	 	= self:GetAbility():GetSpecialValueFor("static_chance")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("static_radius")
	self.static_cooldown	= self:GetAbility():GetSpecialValueFor("static_cooldown")
	self.prock = true
end

function modifier_item_mjollnir_lua_active:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_mjollnir_lua_active:OnIntervalThink()
	self.prock = true
	self:StartIntervalThink(-1)
end

function modifier_item_mjollnir_lua_active:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and self.prock == true and keys.damage >= 5 and RandomInt(1,100) < self.static_chance then
	 self.prock = false
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
		if (keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.static_radius and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			
			local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))

			ParticleManager:ReleaseParticleIndex(head_particle)
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {starting_unit_entindex = keys.attacker:entindex()})
			self:StartIntervalThink(self.static_cooldown)
		end
	end	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_item_mjollnir_lua_strike = class({})

function modifier_item_mjollnir_lua_strike:IsHidden()		return true end
function modifier_item_mjollnir_lua_strike:IsPurgable()		return false end
function modifier_item_mjollnir_lua_strike:RemoveOnDeath()	return false end

function modifier_item_mjollnir_lua_strike:OnCreated(keys)
	self.static_damage	 	= self:GetAbility():GetSpecialValueFor("static_damage")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("static_radius")
	self.static_strikes		= self:GetAbility():GetSpecialValueFor("static_strikes") - 1
	self.jump_delay			= 0.1

	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	self.units_affected			= {}
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.static_damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= damage_flags,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
	else
		self:Destroy()
		return
	end
	
	self.unit_counter			= 0
	
	self:StartIntervalThink(self.jump_delay)
end

function modifier_item_mjollnir_lua_strike:OnIntervalThink()
	self.zapped = false
	
	if (self.unit_counter >= self.static_strikes and self.static_strikes > 0) or not self.zapped then

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
			if not self.units_affected[enemy] and enemy ~= self.current_unit and enemy ~= self.previous_unit then
				enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
				
				self.lightning_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(2, 0, 2))
				ParticleManager:ReleaseParticleIndex(self.lightning_particle)
				
				self.unit_counter						= self.unit_counter + 1
				self.previous_unit						= self.current_unit
				self.current_unit						= enemy
				
				if self.units_affected[self.current_unit] then
					self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
				else
					self.units_affected[self.current_unit]	= 1
				end
				
				self.zapped								= true
				
				damage_flags = DOTA_DAMAGE_FLAG_NONE
								
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.static_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= damage_flags,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
				
				break
			end
		end
		
		if (self.unit_counter >= self.static_strikes and self.static_strikes > 0) or not self.zapped then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
modifier_item_mjollnir1 = class({})

function modifier_item_mjollnir1:IsHidden()
	return true
end

function modifier_item_mjollnir1:IsPurgable()
	return false
end

function modifier_item_mjollnir1:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir1:OnCreated()

	self.bonus_damage		 = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.chain_chance	 	= self:GetAbility():GetSpecialValueFor("chain_chance")
	self.chain_strikes	 	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_damage	 	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_radius		= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_cooldown		= self:GetAbility():GetSpecialValueFor("chain_cooldown")

	self:StartIntervalThink(0.2)
		if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_mjollnir1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_mjollnir1:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_mjollnir1:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir1:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir1:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bChainCooldown = false
end

function modifier_item_mjollnir1:OnAttackLanded(keys)

	if self.bChainCooldown == false and keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 100) <= self.chain_chance then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

modifier_item_mjollnir2 = class({})

function modifier_item_mjollnir2:IsHidden()
	return true
end

function modifier_item_mjollnir2:IsPurgable()
	return false
end

function modifier_item_mjollnir2:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir2:OnCreated()

	self.bonus_damage		 = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.chain_chance	 	= self:GetAbility():GetSpecialValueFor("chain_chance")
	self.chain_strikes	 	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_damage	 	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_radius		= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_cooldown		= self:GetAbility():GetSpecialValueFor("chain_cooldown")

	self:StartIntervalThink(0.2)
		if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_mjollnir2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_mjollnir2:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_mjollnir2:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir2:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir2:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bChainCooldown = false
end

function modifier_item_mjollnir2:OnAttackLanded(keys)

	if self.bChainCooldown == false and keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 100) <= self.chain_chance then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

modifier_item_mjollnir3 = class({})

function modifier_item_mjollnir3:IsHidden()
	return true
end

function modifier_item_mjollnir3:IsPurgable()
	return false
end

function modifier_item_mjollnir3:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir3:OnCreated()

	self.bonus_damage		 = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.chain_chance	 	= self:GetAbility():GetSpecialValueFor("chain_chance")
	self.chain_strikes	 	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_damage	 	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_radius		= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_cooldown		= self:GetAbility():GetSpecialValueFor("chain_cooldown")

	self:StartIntervalThink(0.2)
		if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_mjollnir3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_mjollnir3:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_mjollnir3:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir3:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bChainCooldown = false
end

function modifier_item_mjollnir3:OnAttackLanded(keys)

	if self.bChainCooldown == false and keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 100) <= self.chain_chance then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

modifier_item_mjollnir4 = class({})

function modifier_item_mjollnir4:IsHidden()
	return true
end

function modifier_item_mjollnir4:IsPurgable()
	return false
end

function modifier_item_mjollnir4:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir4:OnCreated()

	self.bonus_damage		 = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.chain_chance	 	= self:GetAbility():GetSpecialValueFor("chain_chance")
	self.chain_strikes	 	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_damage	 	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_radius		= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_cooldown		= self:GetAbility():GetSpecialValueFor("chain_cooldown")

	self:StartIntervalThink(0.2)
		if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_mjollnir4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_mjollnir4:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_mjollnir4:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir4:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir4:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bChainCooldown = false
end

function modifier_item_mjollnir4:OnAttackLanded(keys)

	if self.bChainCooldown == false and keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 100) <= self.chain_chance then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
	end
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

modifier_item_mjollnir5 = class({})

function modifier_item_mjollnir5:IsHidden()
	return true
end

function modifier_item_mjollnir5:IsPurgable()
	return false
end

function modifier_item_mjollnir5:RemoveOnDeath()	
	return false 
end

function modifier_item_mjollnir5:OnCreated()

	self.bonus_damage		 = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.chain_chance	 	= self:GetAbility():GetSpecialValueFor("chain_chance")
	self.chain_strikes	 	= self:GetAbility():GetSpecialValueFor("chain_strikes")
	self.chain_damage	 	= self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chain_radius		= self:GetAbility():GetSpecialValueFor("chain_radius")
	self.chain_cooldown		= self:GetAbility():GetSpecialValueFor("chain_cooldown")

	self:StartIntervalThink(0.2)
		if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_mjollnir5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_mjollnir5:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_mjollnir5:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_mjollnir5:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_mjollnir5:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bChainCooldown = false
end

function modifier_item_mjollnir5:OnAttackLanded(keys)

	if self.bChainCooldown == false and keys.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.prock and not self:GetParent():IsIllusion() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and self:GetParent():GetTeamNumber() ~= keys.target:GetTeamNumber() and RandomInt(1, 100) <= self.chain_chance then
		
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_mjollnir_lua_strike", {
			starting_unit_entindex	= keys.target:entindex()
		})
		
		self.bChainCooldown = true
		
		self:StartIntervalThink(self.chain_cooldown)
	end
end