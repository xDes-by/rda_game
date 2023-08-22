item_pudge_heart_lua = class({})

item_pudge_heart_lua1 = item_pudge_heart_lua
item_pudge_heart_lua2 = item_pudge_heart_lua
item_pudge_heart_lua3 = item_pudge_heart_lua
item_pudge_heart_lua4 = item_pudge_heart_lua
item_pudge_heart_lua5 = item_pudge_heart_lua
item_pudge_heart_lua6 = item_pudge_heart_lua
item_pudge_heart_lua7 = item_pudge_heart_lua
item_pudge_heart_lua8 = item_pudge_heart_lua

item_pudge_heart_lua1_gem1 = item_pudge_heart_lua
item_pudge_heart_lua2_gem1 = item_pudge_heart_lua
item_pudge_heart_lua3_gem1 = item_pudge_heart_lua
item_pudge_heart_lua4_gem1 = item_pudge_heart_lua
item_pudge_heart_lua5_gem1 = item_pudge_heart_lua
item_pudge_heart_lua6_gem1 = item_pudge_heart_lua
item_pudge_heart_lua7_gem1 = item_pudge_heart_lua
item_pudge_heart_lua8_gem1 = item_pudge_heart_lua

item_pudge_heart_lua1_gem2 = item_pudge_heart_lua
item_pudge_heart_lua2_gem2 = item_pudge_heart_lua
item_pudge_heart_lua3_gem2 = item_pudge_heart_lua
item_pudge_heart_lua4_gem2 = item_pudge_heart_lua
item_pudge_heart_lua5_gem2 = item_pudge_heart_lua
item_pudge_heart_lua6_gem2 = item_pudge_heart_lua
item_pudge_heart_lua7_gem2 = item_pudge_heart_lua
item_pudge_heart_lua8_gem2 = item_pudge_heart_lua

item_pudge_heart_lua1_gem3 = item_pudge_heart_lua
item_pudge_heart_lua2_gem3 = item_pudge_heart_lua
item_pudge_heart_lua3_gem3 = item_pudge_heart_lua
item_pudge_heart_lua4_gem3 = item_pudge_heart_lua
item_pudge_heart_lua5_gem3 = item_pudge_heart_lua
item_pudge_heart_lua6_gem3 = item_pudge_heart_lua
item_pudge_heart_lua7_gem3 = item_pudge_heart_lua
item_pudge_heart_lua8_gem3 = item_pudge_heart_lua

item_pudge_heart_lua1_gem4 = item_pudge_heart_lua
item_pudge_heart_lua2_gem4 = item_pudge_heart_lua
item_pudge_heart_lua3_gem4 = item_pudge_heart_lua
item_pudge_heart_lua4_gem4 = item_pudge_heart_lua
item_pudge_heart_lua5_gem4 = item_pudge_heart_lua
item_pudge_heart_lua6_gem4 = item_pudge_heart_lua
item_pudge_heart_lua7_gem4 = item_pudge_heart_lua
item_pudge_heart_lua8_gem4 = item_pudge_heart_lua

item_pudge_heart_lua1_gem5 = item_pudge_heart_lua
item_pudge_heart_lua2_gem5 = item_pudge_heart_lua
item_pudge_heart_lua3_gem5 = item_pudge_heart_lua
item_pudge_heart_lua4_gem5 = item_pudge_heart_lua
item_pudge_heart_lua5_gem5 = item_pudge_heart_lua
item_pudge_heart_lua6_gem5 = item_pudge_heart_lua
item_pudge_heart_lua7_gem5 = item_pudge_heart_lua
item_pudge_heart_lua8_gem5 = item_pudge_heart_lua

LinkLuaModifier("modifier_item_pudge_heart_passive", 'items/custom_items/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_pudge_heart_lua:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive"
end

function item_pudge_heart_lua:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end


-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive = class({})

function modifier_item_pudge_heart_passive:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive:OnCreated( kv )
	self.parent = self:GetParent()
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_pudge_heart_passive:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_pudge_heart_passive:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_pudge_heart_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,        
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_pudge_heart_passive:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end