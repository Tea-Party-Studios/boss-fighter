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

local function evaluate_lobbed_position(pos: Vector3, velocity: Vector3, dt: number, dtCoefficient: number)
	dt *= dtCoefficient
	local stepVelocity = velocity - Vector3.yAxis * dt
	local stepDisplacement = (velocity + stepVelocity) / 2 * dt
	local nextPos = pos + stepDisplacement
	pos = nextPos
	return nextPos, stepVelocity
end
zap.LobbedProjectile.SetCallback(
	function(sentTime: number, spawn: Vector3, init_velocity: Vector3, dtCoefficient: number)
		print "hi"

		local pos, velocity = evaluate_lobbed_position(
			spawn,
			init_velocity,
			(workspace:GetServerTimeNow() - sentTime) * 2 + 0.01,
			dtCoefficient
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
			pos, velocity = evaluate_lobbed_position(pos, velocity, dt, dtCoefficient)
			projectile.CFrame = CFrame.new(pos, pos + velocity)
		end)
		task.delay(4, function()
			cn:Disconnect()
			projectile:Destroy()
		end)
	end
)
