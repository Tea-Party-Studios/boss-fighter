--[=[
    @module Abilities
    Player weapons and abilities.
]=]

--[=[
    @class Abilities
    Base class for all abilities.
    Asserts that any ability implements a Setup
    and Destroy method.
]=]
local Abilities = {}
Abilities.__index = Abilities
export type Ability = typeof(setmetatable({}, Abilities))

--[=[
    Default setup function.
    Responsible for any instantiation an
    ability requires when given to a player.

    @param player -- The player the ability is setup for.
]=]
function Abilities.Setup(player: Player): Ability
	warn "Default setup function. Consider overriding."
	return setmetatable({}, Abilities)
end

--[=[
    Default destroy function.
    Responsible for any cleanup necessary
    when removing an ability from a player.
]=]
function Abilities.Destroy(self: Ability)
	warn "Default destroy function. Consider overriding."
end

return Abilities
