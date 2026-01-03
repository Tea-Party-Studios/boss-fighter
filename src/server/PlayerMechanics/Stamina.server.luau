local Players = game:GetService "Players"
local RunService = game:GetService "RunService"

local characterConnections = {}

function onCharacterAdded(player: Player, character: Model)
	local humanoid: Humanoid? = character:WaitForChild "Humanoid"
	assert(humanoid, `Cannot find humanoid for {player.Name}'s character`)

	local connection = RunService.Heartbeat:Connect(function(delta: number)
		local stamina: number = humanoid:GetAttribute "Stamina"
		local maxStamina: number = humanoid:GetAttribute "MaxStamina"

		if stamina < maxStamina then
			humanoid:SetAttribute("Stamina", math.min(stamina + 10 * delta, maxStamina))
		end
	end)

	humanoid.Died:Connect(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end)
	humanoid.Destroying:Connect(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

function onPlayerAdded(player: Player)
	characterConnections[player] = player.CharacterAdded:Connect(function(character: Model)
		onCharacterAdded(player, character)
	end)
end

function onPlayerRemoving(player: Player)
	if characterConnections[player] then
		characterConnections[player]:Disconnect()
		characterConnections[player] = nil
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
