modifier_gem1 = class ({})

function modifier_gem1:GetTexture()
	return "gem_icon/lifesteal"
end

function modifier_gem1:IsHidden()
	return true
end

function modifier_gem1:RemoveOnDeath()
	return false
end

function modifier_gem1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_gem1:OnCreated(kv)
	self.stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")
end

function modifier_gem1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_gem1:OnTakeDamage( keys )
	if self:GetCaster():HasModifier("modifier_gem1") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then			
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:Heal(keys.damage * self.stacks * 0.01, keys.attacker)
		-- Attack lifesteal handler
		else 
			if keys.damage_category == 1 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:Heal(keys.damage * self.stacks * 0.01, keys.attacker)
		end
	end
end
end