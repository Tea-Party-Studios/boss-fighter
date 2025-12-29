local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local PlayerIsAlive = require(ReplicatedStorage.Shared.PlayerIsAlive)

local Transition = robloxstatemachine.Transition

local PlayersWaiting = Transition.new "Intermission"

function PlayersWaiting:OnDataChanged(data)
	for _, player in Players:GetPlayers() do
		if PlayerIsAlive(player) then
			return true
		end
	end
	return false
end

return PlayersWaiting
