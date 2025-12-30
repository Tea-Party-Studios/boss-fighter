local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Match = script.Parent.Parent

local State = robloxstatemachine.State

local Intermission = State.new "Intermission"
Intermission.Transitions =
	{ require(Match.Transitions.NoPlayersWaiting), require(Match.Transitions.IntermissionFinished) }

function Intermission:OnEnter(data)
	data.timer = 10
end

function Intermission:OnHeartbeat(data, dt)
	data.timer -= dt
end

return Intermission
