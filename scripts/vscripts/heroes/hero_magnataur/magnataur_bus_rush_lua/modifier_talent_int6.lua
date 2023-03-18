modifier_talent_int6 = {}

function modifier_talent_int6:GetTexture()
    return "magnataur_skewer"
end

function modifier_talent_int6:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
	}
end

function modifier_talent_int6:IsDebuff()
    return true
end

function modifier_talent_int6:IsPurgable()
    return true
end

function modifier_talent_int6:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end

function modifier_talent_int6:GetModifierMagicalResistanceBonus()
    return -10
end