local Debris = game:GetService "Debris"
local Players: Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local zap = require(ReplicatedStorage.Shared.zap)

local player: Player = Players.LocalPlayer
local combatContext: InputContext = script:WaitForChild "CombatContext"
local rollAction: InputAction = combatContext:WaitForChild "Roll"
local parryAction: InputAction = combatContext:WaitForChild "Parry"
assert(rollAction and parryAction, "Unable to load player controls")

function onRoll()
	print "Rolling"
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	assert(humanoid, "Player rolling with no character")

	local stamina: number = humanoid:GetAttribute "Stamina"
	if stamina < 20 then
		return
	end
	zap.PlayerRoll.Fire()

	local bv: BodyVelocity = Instance.new "BodyVelocity"
	bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
	bv.P = math.huge
	bv.Velocity = if humanoid.MoveDirection ~= Vector3.zero
		then humanoid.MoveDirection
		else character.PrimaryPart.CFrame.LookVector
	bv.Velocity *= 64
	bv.Velocity += character.PrimaryPart.AssemblyLinearVelocity
	bv.Parent = character.PrimaryPart
	Debris:AddItem(bv, 0.1)

	--[[
    -- Linear Velocity messes with network ownership or something
	local lv: LinearVelocity = Instance.new "LinearVelocity"
	lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	lv.ForceLimitsEnabled = true
	lv.Attachment0 = character.PrimaryPart:FindFirstChildOfClass "Attachment"
	lv.MaxAxesForce = Vector3.new(1, 0, 1) * math.huge
	lv.VectorVelocity = if humanoid.MoveDirection ~= Vector3.zero
		then humanoid.MoveDirection
		else character.PrimaryPart.CFrame.LookVector
	lv.VectorVelocity *= 64
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Parent = character.PrimaryPart
	Debris:AddItem(lv, 0.1)
    --]]
end

function onParry()
	print "Parrying"
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	assert(humanoid, "Player parrying with no character")

	zap.PlayerParry.Fire()
end

rollAction.Pressed:Connect(onRoll)
parryAction.Pressed:Connect(onParry)
