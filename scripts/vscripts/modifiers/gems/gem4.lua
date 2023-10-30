modifier_gem4 = class ({})

function modifier_gem4:GetTexture()
	return "gem_icon/damage"
end

function modifier_gem4:IsHidden()
	return true
end

function modifier_gem4:RemoveOnDeath()
	return false
end

function modifier_gem4:OnCreated(data)
	self.parent = self:GetParent()
	if not IsServer() then
		return
	end
	self.tbl_origin = {}
	self.tbl_current = {}
	local ability = EntIndexToHScript(data.ability)
	self.tbl[ability] = gem_bonus
	self:StartIntervalThink(1)
end

function modifier_gem4:OnRefresh(data)
	if not IsServer() then
		return
	end
	local ability = EntIndexToHScript(data.ability)
	self.tbl_origin[ability] = gem_bonus
	self.tbl_current[ability] = gem_bonus
end

function modifier_gem4:OnIntervalThink()
	local total_bonus = 0
	for ability,gem_bonus in pairs(self.tbl_origin) do
		if ability then
			if not self.parent:FindItemInInventory(ability:GetAbilityName()) then --проверяем предмет в инвентаре
				self.tbl_current[ability] = 0 -- убираем бонус, если не нашли предмета
			else
				self.tbl_current[ability] = self.tbl_origin[ability] -- возвращаем бонус если предмет вернулся в инвентарьь
			end
		end
		total_bonus = total_bonus + self.tbl_current[ability]
	end
	self:SetStackCount(total_bonus)
end

function modifier_gem4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_gem4:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end