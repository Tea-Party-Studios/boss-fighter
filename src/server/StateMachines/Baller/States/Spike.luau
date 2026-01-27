local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ServerScriptService = game:GetService "ServerScriptService"
local TweenService = game:GetService "TweenService"
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local Spike = State.new "Spike"
Spike.Transitions = { require(Baller.Transitions.returnToNeutral) }

function Spike:OnEnter(data: { baller: Model })
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero
	data.baller.PrimaryPart.Anchored = true
	TweenService:Create(
		data.baller.PrimaryPart,
		TweenInfo.new(1, Enum.EasingStyle.Linear),
		{ CFrame = data.baller.PrimaryPart.CFrame + Vector3.yAxis * 50 }
	):Play()
	task.wait(1.5)

	local target = data.players[1].Character :: Model
	local bossPos: Vector3 = data.baller.Torso.Position

	local targetPos = target:GetPivot().Position

	local direction = (targetPos - bossPos).Unit
	local SPEED = 50
	local velocity = direction * SPEED
	local pos = bossPos

	print(workspace:GetServerTimeNow())
	zap.DisplayProjectile.FireAll(workspace:GetServerTimeNow(), bossPos, velocity, target)

	local projectile = Instance.new "Part"
	projectile.Shape = Enum.PartType.Ball
	projectile.Size = Vector3.one * 4
	projectile.CanCollide = false
	projectile.Color = Color3.new(1, 0, 0)
	projectile.Transparency = 0
	projectile.Parent = workspace
	projectile.Anchored = true
	projectile.Position = pos
	projectile.Material = Enum.Material.SmoothPlastic
	local dmg = false
	local cn = RunService.Heartbeat:Connect(function(dt: number)
		local nextPos = pos + velocity * dt
		pos = nextPos
		projectile.CFrame = CFrame.new(pos, pos + velocity)
		if dmg then
			return
		end
		for _, part in workspace:GetPartBoundsInRadius(pos, 2) do
			if not Players:GetPlayerFromCharacter(part.Parent) then
				continue
			end
			print "hit straight server!"
			part.Parent.Humanoid:TakeDamage(10)
			dmg = true
			break
		end
	end)

	--TODO: replace touched with parts in part
	--projectile.Touched:Connect(function(part: BasePart) end)

	task.delay(3, function()
		TweenService:Create(
			data.baller.PrimaryPart,
			TweenInfo.new(1, Enum.EasingStyle.Linear),
			{ CFrame = data.baller.PrimaryPart.CFrame - Vector3.yAxis * 50 }
		):Play()
		task.wait(1)
		data.baller.PrimaryPart.Anchored = false
	end)

	task.delay(4, function()
		cn:Disconnect()
		projectile:Destroy()
	end)
	task.delay(9, function()
		data.endState = true
	end)
end

return Spike
