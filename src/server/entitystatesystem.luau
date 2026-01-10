--[[
System that maintains entity state and handles
applying damage and status effects to entities.
--]]

local RunService = game:GetService "RunService"

local ESS = {}

--[[
EffectResult is the result of
a status effect or attack.
Holds the differences in humanoid attributes
for the entity to handle.
--]]
export type EffectResult = {
	dhealth: number,
	dstamina: number,
}

--[[
Generic entity type.
--]]
export type Entity = {
	humanoid: Humanoid,
	entityState: number,
	appliedEffects: { StatusEffect },
	effectHandler: (Entity, EffectResult) -> (),
}

--[[
StatusEffect type has name,
startup function that is called once when effect is applied,
an update function called every frame,
and a hook to be called to destroy the effect once completed.
--]]
export type StatusEffect = {
	name: string,
	startup: (Entity) -> EffectResult,
	update: (Entity, number, () -> ()) -> EffectResult,
}

--[[
Possible states for an entity to be in.
--]]
ESS.EntityState = table.freeze(setmetatable({
	NEUTRAL = 1,
	INVULNERABLE = 2,
}, {
	__index = function(idx)
		error(`Attempt to reference nonexistent Entity State: {idx}`)
	end,
}))

ESS._entities = {} :: {
	[Humanoid]: Entity,
}

--[[
Default effect handler for registered entities.
--]]
function ESS.DefaultEffectHandler(entity: Entity, effect: EffectResult)
	local humanoid = entity.humanoid
	if entity.entityState == ESS.EntityState.INVULNERABLE then
		-- apply only positive effects
		if effect.dhealth > 0 then
			humanoid.Health += effect.dhealth
		end
		if effect.dstamina > 0 then
			humanoid:SetAttribute("Stamina", humanoid:GetAttribute "Stamina" + effect.dstamina)
		end
		return
	end
	humanoid:TakeDamage(-effect.dhealth)
	humanoid:SetAttribute(
		"Stamina",
		math.clamp(humanoid:GetAttribute "Stamina" + effect.dstamina, 0, humanoid:GetAttribute "MaxStamina")
	)
end

--[[
Registers a humanoid to be an entity capable
of handling damage and status effects.
--]]
function ESS.RegisterEntity(humanoid: Humanoid, effectHandler: ((Entity, EffectResult) -> ())?)
	ESS._entities[humanoid] = {
		humanoid = humanoid,
		entityState = ESS.EntityState.NEUTRAL,
		appliedEffects = {},
		effectHandler = if effectHandler then effectHandler else ESS.DefaultEffectHandler,
	}

	-- automatically unregister on humanoid death
	humanoid.Died:Connect(function()
		ESS.UnregisterEntity(humanoid)
	end)
	humanoid.Destroying:Connect(function()
		ESS.UnregisterEntity(humanoid)
	end)
end

function ESS.UnregisterEntity(humanoid: Humanoid)
	ESS._entities[humanoid] = nil
end

function ESS.GetEntityFromHumanoid(humanoid: Humanoid): Entity?
	return ESS._entities[humanoid]
end

function ESS.ApplyEffect(entity: Entity, effect: StatusEffect)
	table.insert(entity.appliedEffects, effect)
	entity:effectHandler(effect.startup(entity))
end

function onUpdate(dt: number)
	for hum, entity in ESS._entities do
		for _, effect in entity.appliedEffects do
			entity:effectHandler(effect.update(entity, dt, function()
				table.remove(entity.appliedEffects, table.find(entity.appliedEffects, effect))
			end))
		end
	end
end

RunService.Heartbeat:Connect(onUpdate)

return ESS
