LinkLuaModifier( "modifier_riki_tricks_of_the_trade_can_move", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_can_move", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_lua", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_intrinsic_lua", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
riki_tricks_of_the_trade_lua = class({})

function riki_tricks_of_the_trade_lua:GetAbilityTextureName()
	return "riki_tricks_of_the_trade"
end
function riki_tricks_of_the_trade_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function riki_tricks_of_the_trade_lua:GetIntrinsicModifierName()
	return "modifier_riki_tricks_of_the_trade_intrinsic_lua"
end
function riki_tricks_of_the_trade_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int9") then
		return 0.1
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int6") then
		return self.BaseClass.GetCooldown(self, level) / 2
	end
	return self.BaseClass.GetCooldown(self, level)
end

function riki_tricks_of_the_trade_lua:GetBehavior()
	if self:GetCaster():FindModifierByName("npc_dota_hero_riki_str12") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function riki_tricks_of_the_trade_lua:GetChannelTime()
	return self:GetSpecialValueFor("channel_duration")
end

function riki_tricks_of_the_trade_lua:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") 
end

function riki_tricks_of_the_trade_lua:OnAbilityPhaseStart()
	if self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
        self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
        self:GetCaster():SetCursorCastTarget(nil)
        self:GetCaster():CastAbilityOnPosition(self:GetCaster():GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
    end
	return true
end

function riki_tricks_of_the_trade_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Riki.TricksOfTheTrade.Cast")
	self:GetCaster():EmitSound("Hero_Riki.TricksOfTheTrade")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_riki_tricks_of_the_trade_lua", {})
end

function riki_tricks_of_the_trade_lua:OnChannelFinish()
	local caster = self:GetCaster()
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	caster:RemoveModifierByName("modifier_riki_tricks_of_the_trade_lua")
end