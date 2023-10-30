-------------------------------------------
--			REAPER'S SCYTHE
-------------------------------------------
necrolyte_reapers_scythe_lua = class({})
LinkLuaModifier("modifier_reapers_scythe_lua", "heroes/hero_necrolyte/necrolyte_reapers_scythe/necrolyte_reapers_scythe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_necrolyte_reapers_scythe_intrinsic_lua", "heroes/hero_necrolyte/necrolyte_reapers_scythe/modifier_necrolyte_reapers_scythe_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

function necrolyte_reapers_scythe_lua:GetAbilityTextureName()
	return "necrolyte_reapers_scythe"
end
function necrolyte_reapers_scythe_lua:GetIntrinsicModifierName()
	return "modifier_necrolyte_reapers_scythe_intrinsic_lua"
end
function necrolyte_reapers_scythe_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		if target:TriggerSpellAbsorb(self) then
			return nil
		end

		-- Cast sound
		caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")

		target:AddNewModifier(caster, self, "modifier_reapers_scythe_lua", {duration = stun_duration})
	end
end

function necrolyte_reapers_scythe_lua:GetCooldown( nLevel )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int10") then
		return 70
	end
end

function necrolyte_reapers_scythe_lua:IsHiddenWhenStolen()
	return false
end

modifier_reapers_scythe_lua = class({})

function modifier_reapers_scythe_lua:IsDebuff()
	return true
end

function modifier_reapers_scythe_lua:IsPurgable()
	return false
end

function modifier_reapers_scythe_lua:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.damage_increase = self.ability:GetSpecialValueFor("damage_increase")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_reapers_scythe_lua:OnRefresh()
		if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.damage_increase = self.ability:GetSpecialValueFor("damage_increase")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_reapers_scythe_lua:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_reapers_scythe_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_reapers_scythe_lua:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_reapers_scythe_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_reapers_scythe_lua:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_reapers_scythe_lua:IsPurgable() return false end
function modifier_reapers_scythe_lua:IsPurgeException() return false end

function modifier_reapers_scythe_lua:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

function modifier_reapers_scythe_lua:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_reapers_scythe_lua:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration=FrameTime()})
		
		if target:IsAlive() and self.ability then
			local missing_health = target:GetMaxHealth() - target:GetHealth()
			local missing_health_perc = missing_health / (target:GetMaxHealth() / 100)
			local extra_damage_perc = missing_health_perc * self.damage_increase
			local extra_damage = self.damage * (extra_damage_perc / 100)
			self.damage = self.damage + extra_damage
			local actually_dmg = ApplyDamage({attacker = caster, victim = target, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actually_dmg, nil)
		end
	end
end