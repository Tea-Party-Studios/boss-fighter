local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ServerScriptService = game:GetService "ServerScriptService"
local TweenService = game:GetService "TweenService"
local ballerConfig = require(ReplicatedStorage.Config.ballerConfig)
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local Spike = State.new "Spike"
Spike.Transitions = { require(Baller.Transitions.returnToNeutral) }

function Spike:OnEnter(data: { baller: Model })
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero
	data.baller.PrimaryPart.Anchored = true
	data.timer = 0
	TweenService:Create(
		data.baller.PrimaryPart,
		TweenInfo.new(ballerConfig.Spike.JumpDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = data.baller.PrimaryPart.CFrame + Vector3.yAxis * ballerConfig.Spike.JumpHeight }
	):Play()
end

function justCrossed(threshold, currentTime, dt)
	return currentTime > threshold and currentTime - dt < threshold
end

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = { workspace.BallerMap }
raycastParams.FilterType = Enum.RaycastFilterType.Include

function Spike:OnHeartbeat(data, dt)
	data.timer += dt
	if justCrossed(ballerConfig.Spike.JumpDuration, data.timer, dt) then
		local target = data.target
		local bossPos: Vector3 = data.baller.Torso.Position

		local targetPos = target:GetPivot().Position

		local direction = (targetPos - bossPos).Unit
		local velocity = direction * ballerConfig.Spike.BallSpeed
		local pos = bossPos

		zap.SpikeProjectile.FireAll(workspace:GetServerTimeNow(), bossPos, velocity, target)
		data.heartbeat = RunService.Heartbeat:Connect(function(dt: number)
			local nextPos = pos + velocity * dt
			local raycastResult = workspace:Raycast(pos, nextPos - pos, raycastParams)

			local damagedCharacters = {}

			if raycastResult then
				print "damaging explosion!!"
				for _, playerPart in workspace:GetPartBoundsInRadius(nextPos, ballerConfig.Spike.ExplosionRadius) do
					if not Players:GetPlayerFromCharacter(playerPart.Parent) then
						continue
					end
					if damagedCharacters[playerPart.Parent] then
						continue
					end
					damagedCharacters[playerPart.Parent] = true
					playerPart.Parent.Humanoid:TakeDamage(ballerConfig.Spike.ExplosionDamage)
				end
				data.heartbeat:Disconnect()
			end
			pos = nextPos
		end)
	elseif justCrossed(ballerConfig.Spike.AirTime, data.timer, dt) then
		TweenService:Create(
			data.baller.PrimaryPart,
			TweenInfo.new(ballerConfig.Spike.JumpDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ CFrame = data.baller.PrimaryPart.CFrame - Vector3.yAxis * ballerConfig.Spike.JumpHeight }
		):Play()
	elseif justCrossed(ballerConfig.Spike.AirTime + ballerConfig.Spike.JumpDuration, data.timer, dt) then
		data.baller.PrimaryPart.Anchored = false
		data.endState = true
	end
end

function Spike:OnLeave(data)
	if data.heartbeat then
		data.heartbeat:Disconnect()
	end
end

return Spike
