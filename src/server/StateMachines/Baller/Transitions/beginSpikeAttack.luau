local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local BeginSpikeAttack = Transition.new "Spike"

function BeginSpikeAttack:OnDataChanged(data)
	if data.nextState == "SpikeAttack" then
		data.nextState = nil
		return true
	end
	return false
end

return BeginSpikeAttack
