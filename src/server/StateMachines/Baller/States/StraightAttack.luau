local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local StraightAttack = State.new "StraightAttack"
StraightAttack.Transitions = { require(Baller.Transitions.returnToNeutral) }

function StraightAttack:OnEnter(data)
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero

	local target = data.players[1].Character :: Model
	local bossPos: Vector3 = data.baller.Torso.Position

	local angle = math.rad(math.random(40, 70))

	local targetPos = target:GetPivot().Position
	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * 4

	local direction = (targetPos - bossPos).Unit
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile.Parent = workspace
	projectile.Anchored = true
	projectile.Position = bossPos
	projectile.Material = Enum.Material.SmoothPlastic

	local SPEED = 50
	local velocity = direction * SPEED
	local pos = bossPos
	print "straightShot"
	local cn = RunService.Heartbeat:Connect(function(dt: number)
		local nextPos = pos + velocity * dt
		pos = nextPos
		projectile.CFrame = CFrame.new(pos, pos + velocity)
	end)

	projectile.Touched:Connect(function(part: BasePart)
		if part.Name ~= "HumanoidRootPart" then
			return
		end
		if not Players:GetPlayerFromCharacter(part.Parent) then
			return
		end
		print "hit straight!"
		part.Parent.Humanoid:TakeDamage(10)
	end)

	task.delay(4, function()
		cn:Disconnect()
		projectile:Destroy()
	end)
	task.delay(4, function()
		data.endState = true
	end)
end

function StraightAttack:OnHeartbeat(data, dt)
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
end

return StraightAttack
