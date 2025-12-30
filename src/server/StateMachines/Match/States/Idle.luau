local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Match = script.Parent.Parent
local State = robloxstatemachine.State

local Idle = State.new "Idle"
Idle.Transitions = { require(Match.Transitions.PlayersWaiting) }

return Idle
