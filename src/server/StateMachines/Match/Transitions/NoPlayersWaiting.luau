local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local PlayerIsAlive = require(ReplicatedStorage.Shared.PlayerIsAlive)

local Transition = robloxstatemachine.Transition

local NoPlayersWaiting = Transition.new "Idle"

function NoPlayersWaiting:OnDataChanged(data)
	for _, player in Players:GetPlayers() do
		if PlayerIsAlive(player) then
			return false
		end
	end
	return true
end

return NoPlayersWaiting
