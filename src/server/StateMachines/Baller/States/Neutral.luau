local ReplicatedStorage = game:GetService "ReplicatedStorage"
local ballerConfig = require(ReplicatedStorage.Config.ballerConfig)
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
	--should look at the nearest player?
	if data.timer % 1 <= dt or not data.target then
		data.target = data.players[math.random(1, #data.players)].Character
	end
	local target: Model = data.target
	local targetPos = target:GetPivot().Position
	local baller: Model = data.baller
	local ballerPos = baller:GetPivot().Position
	--look at the character
	baller.AlignOrientation.CFrame = CFrame.lookAt(ballerPos, targetPos)

	--try to move to some range away from the targetted player
	local dist = (ballerPos - targetPos).Magnitude

	if dist < 40 then
		baller.MovementVelocity.PlaneVelocity = Vector2.new(0, -ballerConfig.BackwardWalkSpeed)
	elseif dist > 100 then
		baller.MovementVelocity.PlaneVelocity = Vector2.new(0, ballerConfig.ForwardWalkSpeed)
	end
	if data.timer > 1 then
		data.timer -= 1
		local option = math.random()
		if option < 1 / 3 then
			data.nextState = "SpikeAttack"
		elseif option < 2 / 3 then
			data.nextState = "StraightAttack"
		else
			data.nextState = "LobbedAttack"
		end
	end
end

return Neutral
