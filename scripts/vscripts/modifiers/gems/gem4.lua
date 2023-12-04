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
	self.bonus = {150,300,450,600,750,900,1050,1200,1350,1500,2000}
	if not IsServer() then
		return
	end
	self.tbl_origin = {}
	self.tbl_current = {}
	local ability = EntIndexToHScript(data.ability)
	local gem_bonus = data.gem_bonus
	self.tbl_origin[ability] = (gem_bonus or 0)
	self:SetHasCustomTransmitterData( true )
	self:StartIntervalThink(1)
end

function modifier_gem4:OnRefresh(data)
	if not IsServer() then
		return
	end
	if not data.ability then
		return
	end
	local gem_bonus = data.gem_bonus
	local ability = EntIndexToHScript(data.ability)
	if self.tbl_origin[ability] then
		self.tbl_origin[ability] = self.tbl_origin[ability] + (gem_bonus or 0)
	else
		self.tbl_origin[ability] = (gem_bonus or 0)
	end
end

function modifier_gem4:OnIntervalThink()
	local t = {}
	for ability,gem_bonus in pairs(self.tbl_origin) do
		if ability:IsNull() or (ability:GetItemSlot() > 5 or ability:GetItemSlot() == -1) then --проверяем предмет в инвентаре
			self.tbl_current[ability] = 0 -- убираем бонус, если не нашли предмета
		else
			self.tbl_current[ability] = self.tbl_origin[ability] -- возвращаем бонус если предмет вернулся в инвентарьь
		end
		if self.tbl_current[ability] ~= 0 then
			local bonus_per_stone = self.bonus[ability:GetLevel()] / (self.bonus[ability:GetLevel()] + self.tbl_current[ability])
			local item_bonus = bonus_per_stone * self.bonus[ability:GetLevel()] * ability:GetLevel()
			table.insert( t, item_bonus)
		end
	end

	self.value_bonus_to_return = 0
	for _,v in pairs(t) do
		self.value_bonus_to_return = self.value_bonus_to_return + v
	end
	self:SendBuffRefreshToClients()
end

function modifier_gem4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_gem4:GetModifierBaseAttack_BonusDamage()
	return self.value_bonus_to_return
end

function modifier_gem4:AddCustomTransmitterData()
	return {
		value_bonus_to_return = self.value_bonus_to_return
	}
end

function modifier_gem4:HandleCustomTransmitterData( data )
	self.value_bonus_to_return = data.value_bonus_to_return
end

function modifier_gem4:OnTooltip()
	return self.value_bonus_to_return
end