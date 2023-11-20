modifier_following_effect_3 = class({})

function modifier_following_effect_3:IsHidden()
	return true
end

function modifier_following_effect_3:IsPurgable()
	return false
end

function modifier_following_effect_3:IsPermanent()
	return true
end

function modifier_following_effect_3:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient_glow.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_following_effect_3:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end
