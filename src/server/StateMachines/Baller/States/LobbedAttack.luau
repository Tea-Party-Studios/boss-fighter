local Debris = game:GetService "Debris"
local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ServerScriptService = game:GetService "ServerScriptService"
local ballerConfig = require(ReplicatedStorage.Config.ballerConfig)
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local LobbedAttack = State.new "LobbedAttack"
LobbedAttack.Transitions = { require(Baller.Transitions.returnToNeutral) }

function LobbedAttack:OnEnter(data)
	--tell every client to prepare the attack
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero

	local target = data.target
	local bossPos: Vector3 = data.baller.Torso.Position

	local angle = math.rad(math.random(ballerConfig.Lob.MinAngle, ballerConfig.Lob.MaxAngle))

	local targetPos = target:GetPivot().Position
	local tx = (targetPos * Vector3.new(1, 0, 1) - bossPos * Vector3.new(1, 0, 1)).Magnitude
	local ty = targetPos.Y - bossPos.Y

	local d = math.tan(angle)
	local a = (d * tx - ty) / -math.pow(tx, 2)
	if a > 0 then
		a = -1
	end

	local direction = ((targetPos - bossPos) * Vector3.new(1, 0, 1)).Unit

	local initialVelocity = math.sqrt((-d / a) / math.sin(2 * angle))
	local velocity = initialVelocity * math.sin(angle) * Vector3.yAxis + initialVelocity * math.cos(angle) * direction
	local pos = bossPos

	local dmg = false
	local dtCoefficient = ballerConfig.Lob.HorizontalSpeedCoefficient
	local gravity = dtCoefficient * dtCoefficient

	zap.LobbedProjectile.FireAll(workspace:GetServerTimeNow(), bossPos, velocity, target)

	velocity *= dtCoefficient

	data.heartbeat = RunService.Heartbeat:Connect(function(dt: number)
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

		velocity = stepVelocity

		--local p = Instance.new("Part", workspace)
		--p.CanCollide = false
		--p.Size = 1 * Vector3.one
		--p.Position = pos
		--p.Anchored = true
		--p.Color = Color3.new(0.839216, 0.047059, 0.047059)
		--Debris:AddItem(p, 1.3)

		if dmg then
			return
		end
		for _, part in workspace:GetPartBoundsInRadius(pos, ballerConfig.BallDiameter / 2) do
			if not Players:GetPlayerFromCharacter(part.Parent) then
				continue
			end
			print "hit lobbed server!"
			part.Parent.Humanoid:TakeDamage(ballerConfig.Lob.Damage)
			dmg = true
			break
		end
	end)

	--[[projectile.Touched:Connect(function(part: BasePart)
		if part.Name ~= "HumanoidRootPart" then
			return
		end
		if not Players:GetPlayerFromCharacter(part.Parent) then
			return
		end
		print "hit lobbed!"
		part.Parent.Humanoid:TakeDamage(10)
	end)]]
end

function justCrossed(threshold, currentTime, dt)
	return currentTime > threshold and currentTime - dt < threshold
end

function LobbedAttack:OnHeartbeat(data, dt)
	data.timer += dt
	local target: Model = data.target
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

	if justCrossed(4, data.timer, dt) then
		data.endState = true
	end
end

function LobbedAttack:OnLeave(data)
	if data.heartbeat then
		data.heartbeat:Disconnect()
	end
end

return LobbedAttack
