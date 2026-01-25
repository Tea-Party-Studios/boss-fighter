local Debris = game:GetService "Debris"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local zap = require(ReplicatedStorage.Shared.zap)

local function evaluate_position(pos: Vector3, velocity: Vector3, dt: number)
	return pos + velocity * dt
end

zap.DisplayProjectile.SetCallback(function(sentTime: number, spawn: Vector3, velocity: Vector3)
	print(workspace:GetServerTimeNow() - sentTime)
	--add a bit of extra lag compensation to be safe except this is currently a teleport (maybe a speed up instead)
	--local pos = spawn + velocity * ((workspace:GetServerTimeNow() - sentTime) * 2 + 0.01)
	local pos = evaluate_position(spawn, velocity, (workspace:GetServerTimeNow() - sentTime) * 2 + 0.01)

	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * 4
	projectile.CanCollide = false
	projectile.Color = Color3.new(0, 0, 1)
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

local function evaluate_lobbed_position(
	pos: Vector3,
	velocity: Vector3,
	dt: number,
	dtCoefficient: number,
	target: Model
)
	dt *= dtCoefficient
	local stepVelocity = velocity - Vector3.yAxis * dt
	local stepDisplacement = (velocity + stepVelocity) / 2 * dt
	local nextPos = pos + stepDisplacement
	pos = nextPos

	--homing code
	if target then
		local targetPos = target.PrimaryPart.Position
		local targetYDistance = targetPos.Y - pos.Y
		local root = velocity.Y * velocity.Y - 2 * targetYDistance
		if not (targetYDistance > 0 and velocity.Y < 0) then
			if root >= 0 then
				local time = velocity.Y + math.sqrt(root)
				local hit_position = nextPos * Vector3.new(1, 0, 1)
					+ stepVelocity * Vector3.new(1, 0, 1) * time
					+ targetPos.Y * Vector3.yAxis
				--debug place a part there
				local p = Instance.new("Part", workspace)
				p.CanCollide = false
				p.Size = 0.2 * Vector3.one
				p.Position = hit_position
				p.Anchored = true
				p.Color = Color3.new(0.788235, 0.839216, 0.047059)
				Debris:AddItem(p, 0)
				stepVelocity += (targetPos - hit_position) * dt
				--stepVelocity += (hit_position - targetPos) * dt
			end
		end
	end

	return nextPos, stepVelocity
end
zap.LobbedProjectile.SetCallback(
	function(sentTime: number, spawn: Vector3, init_velocity: Vector3, dtCoefficient: number, target: Model)
		--by the time (workspace:GetServerTimeNow() - sentTime) * 2 + 0.01
		local pos, velocity = evaluate_lobbed_position(
			spawn,
			init_velocity,
			(workspace:GetServerTimeNow() - sentTime) * 2 + 0.01,
			dtCoefficient,
			target
		)

		local projectile = Instance.new "Part"
		projectile.Shape = Enum.PartType.Ball
		projectile.Size = Vector3.one * 4
		projectile.CanCollide = false
		projectile.Color = Color3.new(0, 0, 1)
		projectile.Parent = workspace
		projectile.Anchored = true
		projectile.Position = pos
		projectile.Material = Enum.Material.SmoothPlastic

		local cn = RunService.Heartbeat:Connect(function(dt: number)
			pos, velocity = evaluate_lobbed_position(pos, velocity, dt, dtCoefficient, target)
			projectile.CFrame = CFrame.new(pos, pos + velocity)
		end)
		task.delay(4, function()
			cn:Disconnect()
			projectile:Destroy()
		end)
	end
)
