local ReplicatedStorage = game:GetService "ReplicatedStorage"
local ServerScriptService = game:GetService "ServerScriptService"
local match = require(ReplicatedStorage.Config.match)
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Match = script.Parent.Parent

local State = robloxstatemachine.State

local Intermission = State.new "Intermission"
Intermission.Transitions =
	{ require(Match.Transitions.NoPlayersWaiting), require(Match.Transitions.IntermissionFinished) }

function Intermission:OnEnter(data)
	data.timer = match.IntermissionTime
	zap.InIntermission.FireAll(true)
end

function Intermission:OnHeartbeat(data, dt)
	data.timer -= dt
end

function Intermission:OnLeave(data)
	zap.InIntermission.FireAll(false)
end

return Intermission
