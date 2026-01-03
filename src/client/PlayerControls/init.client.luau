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

	local lv = Instance.new "LinearVelocity"
	lv.Attachment0 = character.PrimaryPart:FindFirstChildOfClass "Attachment"
	lv.VectorVelocity = if humanoid.MoveDirection
		then humanoid.MoveDirection
		else character.PrimaryPart.CFrame.LookVector
	lv.VectorVelocity *= Vector3.new(1, 0, 1)
	lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	lv.MaxAxesForce = Vector3.new(1, 0, 1) * math.huge
	lv.VectorVelocity += character.PrimaryPart.AssemblyLinearVelocity
	Debris:AddItem(lv, 0.1)
	lv.Parent = character.PrimaryPart
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
