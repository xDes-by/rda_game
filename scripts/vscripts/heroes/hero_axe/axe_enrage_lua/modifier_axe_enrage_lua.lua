modifier_axe_enrage_lua = class({})

function modifier_axe_enrage_lua:IsHidden()
	return false
end

function modifier_axe_enrage_lua:IsDebuff()
	return false
end

function modifier_axe_enrage_lua:IsPurgable()
	return false
end
if IsServer() then
function modifier_axe_enrage_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.base_str = self:GetAbility():GetSpecialValueFor("bonus_str") * (self.caster:GetStrength()/100)
	self.damage = self:GetCaster():GetAttackDamage()--/2 
	tru = 0
	
	local abil = self.caster:FindAbilityByName("npc_dota_hero_axe_str11")
		if abil ~= nil then 
		self.base_str = self:GetAbility():GetSpecialValueFor("bonus_str") * (self.caster:GetStrength()/100) * 2
		end
	
	local abil = self.caster:FindAbilityByName("npc_dota_hero_axe_str_last")
		if abil ~= nil then 
		self.base_str = self.base_str * 5
		end
	end
end

function modifier_axe_enrage_lua:OnRefresh( kv )
tru = 0
end

function modifier_axe_enrage_lua:OnDestroy( kv )
end
--------------------------------------------------------------------------------

function modifier_axe_enrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_axe_enrage_lua:GetModifierPreAttack_BonusDamage( params )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_str10") ~= nil then 
	tru = 1
	da = (self.damage * tru)/2
	end
	return da
end

function modifier_axe_enrage_lua:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction
end

function modifier_axe_enrage_lua:GetModifierModelScale( params )
	return 45
end

function modifier_axe_enrage_lua:GetModifierBonusStats_Strength( params )

	return self.base_str
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_enrage_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_axe_enrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end