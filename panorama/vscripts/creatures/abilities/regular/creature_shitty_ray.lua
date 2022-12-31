LinkLuaModifier("modifier_creature_shitty_ray", "creatures/abilities/regular/creature_shitty_ray", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_shitty_ray_attack_animation", "creatures/abilities/regular/creature_shitty_ray", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_shitty_ray_debuff", "creatures/abilities/regular/creature_shitty_ray", LUA_MODIFIER_MOTION_NONE)

creature_shitty_ray = class({})

function creature_shitty_ray:GetIntrinsicModifierName()
	return "modifier_creature_shitty_ray"
end



modifier_creature_shitty_ray = class({})

function modifier_creature_shitty_ray:IsHidden() return true end
function modifier_creature_shitty_ray:IsDebuff() return false end
function modifier_creature_shitty_ray:IsPurgable() return false end
function modifier_creature_shitty_ray:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_shitty_ray:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_creature_shitty_ray:OnRefresh(keys)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.as_slow = self:GetAbility():GetSpecialValueFor("as_slow")
end

function modifier_creature_shitty_ray:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
	end
end

function modifier_creature_shitty_ray:OnAttackStart(keys)
	if keys.attacker and keys.attacker == self:GetParent() then
		keys.attacker:AddNewModifier(keys.attacker, nil, "modifier_creature_shitty_ray_attack_animation", {duration = 0.2})
	end
end

function modifier_creature_shitty_ray:GetModifierProcAttack_Feedback(keys)
	if keys.attacker and keys.target then
		keys.target:EmitSound("WizardBossWizard.Hit")
		if self:GetAbility() and self:GetAbility():IsCooldownReady() then
			if not (keys.target:HasModifier("modifier_creature_shitty_ray_debuff") or keys.target:HasModifier("modifier_creature_crappy_ray_debuff") or keys.target:HasModifier("modifier_creature_crummy_ray_debuff")) then
				self:GetAbility():UseResources(true, true, true)
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_creature_shitty_ray_debuff", {duration = self.duration, as_slow = self.as_slow})
			end
		end
	end
end



modifier_creature_shitty_ray_debuff = class({})

function modifier_creature_shitty_ray_debuff:IsHidden() return false end
function modifier_creature_shitty_ray_debuff:IsDebuff() return true end
function modifier_creature_shitty_ray_debuff:IsPurgable() return true end

function modifier_creature_shitty_ray_debuff:OnCreated(keys)
	if IsClient() then return end

	self:SetStackCount(keys.as_slow or 0)
end

function modifier_creature_shitty_ray_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_shitty_ray_debuff:GetModifierAttackSpeedBonus_Constant()
	return (-1) * self:GetStackCount()
end



modifier_creature_shitty_ray_attack_animation = class({})

function modifier_creature_shitty_ray_attack_animation:IsHidden() return true end
function modifier_creature_shitty_ray_attack_animation:IsDebuff() return false end
function modifier_creature_shitty_ray_attack_animation:IsPurgable() return false end
function modifier_creature_shitty_ray_attack_animation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_shitty_ray_attack_animation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end

function modifier_creature_shitty_ray_attack_animation:GetOverrideAnimation()
	return ACT_DOTA_DIE
end

function modifier_creature_shitty_ray_attack_animation:GetOverrideAnimationRate()
	return 1.5
end
