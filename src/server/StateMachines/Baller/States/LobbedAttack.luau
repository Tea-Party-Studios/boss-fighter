local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ServerScriptService = game:GetService "ServerScriptService"
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local LobbedAttack = State.new "LobbedAttack"
LobbedAttack.Transitions = { require(Baller.Transitions.returnToNeutral) }

function LobbedAttack:OnEnter(data)
	--tell every client to prepare the attack
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero

	local target = data.players[1].Character :: Model
	local bossPos: Vector3 = data.baller.Torso.Position

	local angle = math.rad(math.random(40, 70))

	local targetPos = target:GetPivot().Position
	local tx = (targetPos * Vector3.new(1, 0, 1) - bossPos * Vector3.new(1, 0, 1)).Magnitude
	local ty = targetPos.Y - bossPos.Y

	local d = math.tan(angle)
	local a = (d * tx - ty) / -math.pow(tx, 2)
	if a > 0 then
		a = -1
	end

	local direction = ((targetPos - bossPos) * Vector3.new(1, 0, 1)).Unit

	local timeToTarget = tx / 50
	local initialVelocity = math.sqrt((-d / a) / math.sin(2 * angle))
	local velocity = initialVelocity * math.sin(angle) * Vector3.yAxis + initialVelocity * math.cos(angle) * direction
	local pos = bossPos

	local dmg = false

	zap.LobbedProjectile.FireAll(workspace:GetServerTimeNow(), bossPos, velocity, tx / timeToTarget / 4, target)

	local cn = RunService.Heartbeat:Connect(function(dt: number)
		dt *= tx / timeToTarget / 4 --I believe this /4 was added because I assumed the gravity was 1? Idk but it works pretty well
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
					stepVelocity += (targetPos - hit_position) * dt
				end
			end
		end
		velocity = stepVelocity
		if dmg then
			return
		end
		for _, part in workspace:GetPartBoundsInRadius(pos, 2) do
			if not Players:GetPlayerFromCharacter(part.Parent) then
				continue
			end
			print "hit lobbed server!"
			part.Parent.Humanoid:TakeDamage(10)
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

	task.delay(timeToTarget + 2, function()
		cn:Disconnect()
	end)
	task.delay(4, function()
		data.endState = true
	end)
end

function LobbedAttack:OnHeartbeat(data, dt)
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

return LobbedAttack
