local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local Neutral = State.new "Neutral"
Neutral.Transitions = {
	require(Baller.Transitions.beginLobbedAttack),
	require(Baller.Transitions.beginStraightAttack),
	require(Baller.Transitions.beginSpikeAttack),
}

function Neutral:OnEnter(data)
	data.timer = 0
end

function Neutral:OnHeartbeat(data, dt)
	data.timer += dt
	local target: Model = data.players[1].Character
	local targetPos = target:GetPivot().Position
	local baller: Model = data.baller
	local ballerPos = baller:GetPivot().Position
	--look at the character
	baller.AlignOrientation.CFrame = CFrame.lookAt(ballerPos, targetPos)

	--try to move to some range away from the targetted player
	local dist = (ballerPos - targetPos).Magnitude

	if dist < 40 then
		baller.MovementVelocity.PlaneVelocity = Vector2.new(0, -2)
	elseif dist > 100 then
		baller.MovementVelocity.PlaneVelocity = Vector2.new(0, 2)
	end
	if data.timer > 1 then
		data.timer -= 1
		if math.random() < 1 then
			data.nextState = "SpikeAttack"
		else
			data.nextState = "StraightAttack"
		end
	end
end

return Neutral
