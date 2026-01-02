local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local PlayersDied = Transition.new "Idle"

function PlayersDied:OnDataChanged(data)
	return not data.boss
end

return PlayersDied
