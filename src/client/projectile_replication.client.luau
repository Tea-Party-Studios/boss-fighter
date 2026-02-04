local Debris = game:GetService "Debris"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ballerConfig = require(ReplicatedStorage.Config.ballerConfig)
local zap = require(ReplicatedStorage.Shared.zap)

local function evaluate_position(pos: Vector3, velocity: Vector3, dt: number)
	return pos + velocity * dt
end

zap.StraightProjectile.SetCallback(function(sentTime: number, spawn: Vector3, velocity: Vector3, target: Model)
	local xSpeed = (velocity * Vector3.new(1, 0, 1)).Magnitude
	local targetXDistance = ((spawn - target.PrimaryPart.Position) * Vector3.new(1, 0, 1)).Magnitude
	local timeToTarget = targetXDistance / xSpeed
	local pingTime = (workspace:GetServerTimeNow() - sentTime) * 2
	velocity *= timeToTarget / (timeToTarget - pingTime)
	local pos = spawn

	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * ballerConfig.BallDiameter
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile:AddTag "Rainbow"
	projectile.Parent = workspace
	projectile.Anchored = true
	--print(velocity)
	projectile.Position = pos
	projectile.Material = Enum.Material.SmoothPlastic

	local cn = RunService.Heartbeat:Connect(function(dt: number)
		pos = evaluate_position(pos, velocity, dt)
		projectile.CFrame = CFrame.new(pos, pos + velocity)
	end)

	task.delay(4, function()
		cn:Disconnect()
		projectile:Destroy()
	end)
end)

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = { workspace.BallerMap }
raycastParams.FilterType = Enum.RaycastFilterType.Include

zap.SpikeProjectile.SetCallback(function(sentTime: number, spawn: Vector3, velocity: Vector3, target: Model)
	--because this projectile only ever hits the floor, you could always use a raycast instead to determine distance
	local xSpeed = (velocity * Vector3.new(1, 0, 1)).Magnitude
	local targetXDistance = ((spawn - target.PrimaryPart.Position) * Vector3.new(1, 0, 1)).Magnitude
	local timeToTarget = targetXDistance / xSpeed
	local pingTime = (workspace:GetServerTimeNow() - sentTime) * 2
	velocity *= timeToTarget / (timeToTarget - pingTime)
	local pos = spawn

	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * ballerConfig.BallDiameter
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile.Parent = workspace
	projectile.Anchored = true
	projectile:AddTag "Rainbow"
	projectile.Position = pos
	projectile.Material = Enum.Material.SmoothPlastic

	local cn
	cn = RunService.Heartbeat:Connect(function(dt: number)
		local nextPos = evaluate_position(pos, velocity, dt)
		local raycastResult = workspace:Raycast(pos, nextPos - pos, raycastParams)
		if raycastResult then
			print "making explosion"
			local explosion = Instance.new "Part"
			explosion.Shape = Enum.PartType.Ball
			explosion.Size = Vector3.one * ballerConfig.Spike.ExplosionRadius * 2
			explosion.CanCollide = false
			explosion.Color = Color3.new(1, 0, 0)
			explosion:AddTag "Rainbow"
			explosion.Parent = workspace
			explosion.Anchored = true
			explosion.Transparency = 0.7
			explosion.Material = Enum.Material.SmoothPlastic
			explosion.Position = nextPos
			Debris:AddItem(explosion, 0.5)
			projectile:Destroy()
			cn:Disconnect()
		end
		pos = nextPos
		projectile.CFrame = CFrame.new(pos, pos + velocity)
	end)

	task.delay(4, function()
		if cn then
			cn:Disconnect()
			projectile:Destroy()
		end
	end)
end)

local function evaluate_lobbed_position(pos: Vector3, velocity: Vector3, dt: number, gravity: number, target: Model)
	local stepVelocity = velocity - Vector3.yAxis * dt * gravity
	local stepDisplacement = (velocity + stepVelocity) / 2 * dt
	local nextPos = pos + stepDisplacement
	pos = nextPos

	--homing code
	if target then
		local targetPos = target.PrimaryPart.Position
		local targetYDistance = targetPos.Y - pos.Y
		local root = velocity.Y * velocity.Y - 2 * targetYDistance * gravity
		if not (targetYDistance > 0 and velocity.Y < 0) then
			if root >= 0 then
				local time = (velocity.Y + math.sqrt(root)) / gravity
				local hit_position = nextPos * Vector3.new(1, 0, 1)
					+ stepVelocity * Vector3.new(1, 0, 1) * time
					+ targetPos.Y * Vector3.yAxis

				stepVelocity += (targetPos - hit_position)
			end
		end
	end
	return nextPos, stepVelocity
end

zap.LobbedProjectile.SetCallback(function(sentTime: number, spawn: Vector3, init_velocity: Vector3, target: Model)
	local pos: Vector3, velocity: Vector3
	local dtCoefficient = ballerConfig.Lob.HorizontalSpeedCoefficient
	local xSpeed = (init_velocity * Vector3.new(1, 0, 1)).Magnitude * dtCoefficient
	local targetXDistance = ((spawn - target.PrimaryPart.Position) * Vector3.new(1, 0, 1)).Magnitude
	local timeToTarget = targetXDistance / xSpeed
	local pingTime = (workspace:GetServerTimeNow() - sentTime) * 2
	dtCoefficient *= timeToTarget / (timeToTarget - pingTime) * 1.1
	local gravity = dtCoefficient * dtCoefficient
	velocity = init_velocity * dtCoefficient
	pos, velocity = evaluate_lobbed_position(spawn, velocity, 0, gravity, target)

	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * 4
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile:AddTag "Rainbow"
	projectile.Parent = workspace
	projectile.Anchored = true
	projectile.Position = pos
	projectile.Material = Enum.Material.SmoothPlastic

	local cn = RunService.PreSimulation:Connect(function(dt: number)
		pos, velocity = evaluate_lobbed_position(pos, velocity, dt, gravity, target)
		projectile.CFrame = CFrame.new(pos, pos + velocity)
	end)
	task.delay(timeToTarget + 1, function()
		cn:Disconnect()
		projectile:Destroy()
	end)
end)
