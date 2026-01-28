local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local ServerScriptService = game:GetService "ServerScriptService"
local ballerConfig = require(ReplicatedStorage.Config.ballerConfig)
local zap = require(ServerScriptService.Server.zap)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local Baller = script.Parent.Parent
local State = robloxstatemachine.State

local StraightAttack = State.new "StraightAttack"
StraightAttack.Transitions = { require(Baller.Transitions.returnToNeutral) }

function StraightAttack:OnEnter(data)
	data.timer = 0
	data.baller.MovementVelocity.PlaneVelocity = Vector2.zero

	local target = data.target
	local bossPos: Vector3 = data.baller.Torso.Position

	local targetPos = target:GetPivot().Position

	local direction = (targetPos - bossPos).Unit
	local velocity = direction * ballerConfig.Straight.BallSpeed
	local pos = bossPos

	print(workspace:GetServerTimeNow())
	zap.StraightProjectile.FireAll(workspace:GetServerTimeNow(), bossPos, velocity, target)

	local dmg = false
	data.heartbeat = RunService.Heartbeat:Connect(function(dt: number)
		local nextPos = pos + velocity * dt
		pos = nextPos
		if dmg then
			return
		end
		for _, part in workspace:GetPartBoundsInRadius(pos, ballerConfig.BallDiameter / 2) do
			if not Players:GetPlayerFromCharacter(part.Parent) then
				return
			end
			print "hit straight!"
			part.Parent.Humanoid:TakeDamage(ballerConfig.Straight.Damage)
			dmg = true
			break
		end
	end)
end

function justCrossed(threshold, currentTime, dt)
	return currentTime > threshold and currentTime - dt < threshold
end

function StraightAttack:OnHeartbeat(data, dt)
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

function StraightAttack:OnLeave(data)
	if data.heartbeat then
		data.heartbeat:Disconnect()
	end
end

return StraightAttack
