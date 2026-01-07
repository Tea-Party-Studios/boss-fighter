local Debris = game:GetService "Debris"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local BasicAttack = State.new "BasicAttack"

function BasicAttack:OnEnter(data)
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero

	local target = data.players[1].Character :: Model
	local targetPos = target:GetPivot().Position
	local bossPos: Vector3 = data.baller.Torso.Position

	local angle = math.rad(math.random(2, 40))
	local gravity = workspace.Gravity
	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * 4

	--we remove 1 to account for the height difference between the players and baller
	local distance = (targetPos - bossPos).Magnitude - 1
	local direction = (targetPos - bossPos).Unit
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile.Parent = workspace
	projectile:SetNetworkOwner(nil)
	projectile.Position = bossPos

	local initialVelocity = math.sqrt(distance * gravity / math.sin(2 * angle))
	print(initialVelocity, angle)
	projectile:ApplyImpulse(
		(
			direction * Vector3.new(1, 0, 1) * initialVelocity * math.cos(angle)
			+ Vector3.yAxis * initialVelocity * math.sin(angle)
		) * projectile.AssemblyMass
	)
	Debris:AddItem(projectile, 3)
	task.delay(1.5, function()
		data.endState = true
	end)
end

BasicAttack.Transitions = { require(Baller.Transitions.returnToNeutral) }

return BasicAttack
