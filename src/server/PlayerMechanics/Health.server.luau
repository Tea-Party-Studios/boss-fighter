--[[
	Overrides default Health script for players
	to incorporate new HealthRegen, Stamina, StaminaRegen
	Humanoid attributes.
]]

-- amount of time after using stamina before regen begins
local STAMINA_REGEN_DELAY = 3 -- seconds

local Players = game:GetService "Players"
local RunService = game:GetService "RunService"

local connections: { [Player]: RBXScriptConnection } = {}

function onCharacterAdded(character: Model)
	character:WaitForChild("Health"):Destroy() -- remove default Health script
	local humanoid: Humanoid? = character:WaitForChild "Humanoid"
	assert(humanoid, `Cannot find humanoid for {character}`)

	local last_recorded_stamina = humanoid:GetAttribute "Stamina"
	local time_of_stamina_loss = 0
	local hum_connections: { RBXScriptConnection } = {}

	local function onStaminaChange()
		if humanoid:GetAttribute "Stamina" < last_recorded_stamina then
			time_of_stamina_loss = os.clock()
		end
		last_recorded_stamina = humanoid:GetAttribute "Stamina"
	end

	local function onDied()
		for _, connection in hum_connections do
			connection:Disconnect()
		end
	end

	local function onHeartbeat(dt: number)
		if os.clock() >= time_of_stamina_loss + STAMINA_REGEN_DELAY then
			humanoid:SetAttribute(
				"Stamina",
				math.min(
					humanoid:GetAttribute "MaxStamina",
					humanoid:GetAttribute "Stamina" + humanoid:GetAttribute "StaminaRegen" * dt
				)
			)
		end
		humanoid.Health += humanoid:GetAttribute "HealthRegen" * dt
	end

	table.insert(hum_connections, humanoid:GetAttributeChangedSignal("Stamina"):Connect(onStaminaChange))
	table.insert(hum_connections, humanoid.Died:Connect(onDied))
	table.insert(hum_connections, RunService.Heartbeat:Connect(onHeartbeat))
end

function onPlayerAdded(player: Player)
	connections[player] = player.CharacterAdded:Connect(onCharacterAdded)
end

function onPlayerRemoving(player: Player)
	if connections[player] then
		connections[player]:Disconnect()
		connections[player] = nil
	end
end

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
