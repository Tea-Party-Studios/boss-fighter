local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local PlayersDied = Transition.new "Idle"

function PlayersDied:OnDataChanged(data)
	return #data.combatants == 0
end

return PlayersDied
