local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local IntermissionFinished = Transition.new "InMatch"

function IntermissionFinished:OnDataChanged(data)
	return data.timer < 0
end

return IntermissionFinished
