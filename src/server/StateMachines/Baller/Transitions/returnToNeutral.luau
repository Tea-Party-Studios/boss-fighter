local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local ReturnToNeutral = Transition.new "Neutral"

function ReturnToNeutral:OnDataChanged(data)
	if data.endState then
		data.endState = nil
		return true
	end
	return false
end

return ReturnToNeutral
