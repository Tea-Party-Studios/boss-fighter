local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

local Transition = robloxstatemachine.Transition

local BeginNeutralAttack = Transition.new "BasicAttack"

function BeginNeutralAttack:OnDataChanged(data)
	if data.nextState == "BasicAttack" then
		data.nextState = nil
		return true
	end
	return false
end

return BeginNeutralAttack
