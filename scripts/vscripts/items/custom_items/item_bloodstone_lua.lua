item_bloodstone_lua1 = item_bloodstone_lua1 or class({})
item_bloodstone_lua2 = item_bloodstone_lua1 or class({})
item_bloodstone_lua3 = item_bloodstone_lua1 or class({})
item_bloodstone_lua4 = item_bloodstone_lua1 or class({})
item_bloodstone_lua5 = item_bloodstone_lua1 or class({})
item_bloodstone_lua6 = item_bloodstone_lua1 or class({})
item_bloodstone_lua7 = item_bloodstone_lua1 or class({})
item_bloodstone_lua8 = item_bloodstone_lua1 or class({})

LinkLuaModifier("modifier_item_bloodstone_lua", 'items/custom_items/item_bloodstone_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_blodstone_active_lua", 'items/custom_items/item_bloodstone_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_bloodstone_lua1:GetIntrinsicModifierName()
	return "modifier_item_bloodstone_lua"
end

function item_bloodstone_lua1:GetManaCost()
	if self and not self:IsNull() and self.GetCaster and self:GetCaster() ~= nil then
	return self:GetCaster():GetMaxMana() * 0.3
	end
end

function item_bloodstone_lua1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_blodstone_active_lua", {duration = 2})
end

----------------------------------------------------------------------------------

modifier_item_bloodstone_lua = class({})

function modifier_item_bloodstone_lua:IsHidden()
	return true
end

function modifier_item_bloodstone_lua:IsPurgable()
	return false
end

function modifier_item_bloodstone_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_bloodstone_lua:OnCreated()
	
	

	self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor("mana_regen_multiplier")
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	self.creep_lifesteal= self:GetAbility():GetSpecialValueFor("creep_lifesteal")

end

function modifier_item_bloodstone_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

		MODIFIER_EVENT_ON_TAKEDAMAGE

	}
end

function modifier_item_bloodstone_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_bloodstone_lua:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_bloodstone_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_bloodstone_lua:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_item_bloodstone_lua:GetModifierMPRegenAmplify_Percentage()
	return self.mana_regen_multiplier
end

function modifier_item_bloodstone_lua:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		
				all_cleaves = {"item_bfury_lua1","item_bfury_lua2","item_bfury_lua3","item_bfury_lua4","item_bfury_lua5","item_bfury_lua6","item_bfury_lua7",
		"item_bfury_lua1_gem1","item_bfury_lua2_gem1","item_bfury_lua3_gem1","item_bfury_lua4_gem1","item_bfury_lua5_gem1","item_bfury_lua6_gem1","item_bfury_lua7_gem1",
		"item_bfury_lua1_gem2","item_bfury_lua2_gem2","item_bfury_lua3_gem2","item_bfury_lua4_gem2","item_bfury_lua5_gem2","item_bfury_lua6_gem2","item_bfury_lua7_gem2",
		"item_bfury_lua1_gem3","item_bfury_lua2_gem3","item_bfury_lua3_gem3","item_bfury_lua4_gem3","item_bfury_lua5_gem3","item_bfury_lua6_gem3","item_bfury_lua7_gem3",
		"item_bfury_lua1_gem4","item_bfury_lua2_gem4","item_bfury_lua3_gem4","item_bfury_lua4_gem4","item_bfury_lua5_gem4","item_bfury_lua6_gem4","item_bfury_lua7_gem4",
		"item_bfury_lua1_gem5","item_bfury_lua2_gem5","item_bfury_lua3_gem5","item_bfury_lua4_gem5","item_bfury_lua5_gem5","item_bfury_lua6_gem5","item_bfury_lua7_gem5",
		"sven_bringer","sven_great_cleave_lua","item_pet_donate_cleave","luna_moon_glaive_lua","npc_dota_hero_treant_agi11","npc_dota_hero_centaur_agi11",
		"npc_dota_hero_mars_agi10","npc_dota_hero_phantom_assassin_agi11","npc_dota_hero_slark_agi9","bristleback_warpath_lua"}

		for _,current_name in pairs(all_cleaves) do
			if current_name == keys.inflictor:GetAbilityName() then
				return end
		end
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.creep_lifesteal / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.creep_lifesteal / 100), self)
			end
		end
	end
end

-----------------------------------------------------------------------

modifier_item_blodstone_active_lua = class({})

function modifier_item_blodstone_active_lua:OnCreated()
	EmitSoundOn("DOTA_Item.Bloodstone.Cast",self:GetCaster())
	self.particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)

	
	self.caster = self:GetCaster()
	self.regen = self:GetCaster():GetMaxMana() * 0.15 

end

function modifier_item_blodstone_active_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_item_blodstone_active_lua:GetModifierConstantHealthRegen()
	return self.regen
end