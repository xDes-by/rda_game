function CastSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	ability.spirits_startTime		= GameRules:GetGameTime()
	ability.spirits_numSpirits		= 0		-- Use this rather than "#spirits_spiritsSpawned"
	ability.spirits_spiritsSpawned	= {}
	caster.spirits_radius			= event.default_radius
	caster.spirits_movementFactor	= 0		-- Changed by the toggle abilities

end

function ThinkSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local numSpiritsMax	= event.num_spirits

	local casterOrigin	= caster:GetAbsOrigin()

	local elapsedTime	= GameRules:GetGameTime() - ability.spirits_startTime

	--------------------------------------------------------------------------------
	-- Validate the number of spirits summoned
	--
	local idealNumSpiritsSpawned = elapsedTime / event.spirit_summon_interval
	idealNumSpiritsSpawned = math.min( idealNumSpiritsSpawned, numSpiritsMax )

	if ability.spirits_numSpirits < idealNumSpiritsSpawned then

		-- Spawn a new spirit
		local newSpirit = CreateUnitByName( "npc_dota_wisp_spirit", casterOrigin, false, caster, caster, caster:GetTeam() )

		-- Create particle FX
		local pfx = ParticleManager:CreateParticle( event.spirit_particle_name, PATTACH_ABSORIGIN_FOLLOW, newSpirit )
		newSpirit.spirit_pfx = pfx

		-- Update the state
		local spiritIndex = ability.spirits_numSpirits + 1
		newSpirit.spirit_index = spiritIndex
		ability.spirits_numSpirits = spiritIndex
		ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

		-- Apply the spirit modifier
		ability:ApplyDataDrivenModifier( caster, newSpirit, event.spirit_modifier, {} )

	end


	local currentRadius	= caster.spirits_radius
	local deltaRadius = caster.spirits_movementFactor * event.spirit_movement_rate * event.think_interval
	currentRadius = currentRadius + deltaRadius
	currentRadius = math.min( math.max( currentRadius, event.min_range ), event.max_range )

	caster.spirits_radius = currentRadius

	--------------------------------------------------------------------------------
	-- Update the spirits' positions
	--
	local currentRotationAngle	= elapsedTime * event.spirit_turn_rate
	local rotationAngleOffset	= 360 / event.num_spirits

	local numSpiritsAlive = 0

	for k,v in pairs( ability.spirits_spiritsSpawned ) do

		numSpiritsAlive = numSpiritsAlive + 1

		-- Rotate
		local rotationAngle = currentRotationAngle - rotationAngleOffset * ( k - 1 )
		local relPos = Vector( 0, currentRadius, 0 )
		relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

		local absPos = GetGroundPosition( relPos + casterOrigin, v )

		v:SetAbsOrigin( absPos )

		-- Update particle
		ParticleManager:SetParticleControl( v.spirit_pfx, 1, Vector( currentRadius, 0, 0 ) )

	end

	if ability.spirits_numSpirits == numSpiritsMax and numSpiritsAlive == 0 then
		-- All spirits have been exploded.
		caster:RemoveModifierByName( event.caster_modifier )
		return
	end
end


function EndSpirits( event )
	
	local caster	= event.caster
	local ability	= event.ability

	local spiritModifier	= event.spirit_modifier

	-- Destroy all spirits
	for k,v in pairs( ability.spirits_spiritsSpawned ) do
		v:RemoveModifierByName( spiritModifier )
	end

	-- Disable the toggle abilities
	caster:SwapAbilities( event.empty1_ability, event.spirits_in_ability, true, false )
	caster:SwapAbilities( event.empty2_ability, event.spirits_out_ability, true, false )

	-- Reset the toggle states.
	--ResetToggleState( caster, event.spirits_in_ability )
	--ResetToggleState( caster, event.spirits_out_ability )

end


function ToggleOn( event )
	local caster	= event.caster

	-- Make sure that the opposite ability is toggled off.
	--ResetToggleState( caster, event.opposite_ability )

	-- Change the movement factor
	caster.spirits_movementFactor = event.spirit_movement
end


function ToggleOff( event )
	event.caster.spirits_movementFactor = 0
end


function OnCreatedSpirit( event )
	
	local spirit = event.target
	local ability = event.ability

	-- Set the spirit to caster
	ability:ApplyDataDrivenModifier( spirit, spirit, event.additionalModifier, {} )

end


function OnDestroySpirit( event )

	local spirit	= event.target
	local ability	= event.ability
	
	ParticleManager:DestroyParticle( spirit.spirit_pfx, false )

	--Create vision
	ability:CreateVisibilityNode( spirit:GetAbsOrigin(), event.vision_radius, event.vision_duration )

	 --Kill
	spirit:ForceKill( true )

end


 function ExplodeSpirit( event )
	
	--local spirit	= event.caster		-- We have set the spirit to the caster
	--local ability	= event.ability

	--if not spirit.spirit_isExploded then

		--spirit.spirit_isExploded = true

		 --Remove from the list of spirits
		--ability.spirits_spiritsSpawned[spirit.spirit_index] = nil

		-- Remove the spirit modifier
		--spirit:RemoveModifierByName( event.spirit_modifier )

		-- Fire the hit sound
		--StartSoundEvent( event.explosion_sound, spirit )

	--end

end