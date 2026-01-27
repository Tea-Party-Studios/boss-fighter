local ServerScriptService = game:GetService "ServerScriptService"
local Players = game:GetService "Players"

local Sword = require(ServerScriptService.Server.abilities.default_sword)
local Heal = require(ServerScriptService.Server.abilities.heal)
local ESS = require(ServerScriptService.Server.entitystatesystem)

ESS.RegisterTeam "Players"

function onPlayerAdded(player: Player)
	local function onCharacterAdded(character: Model)
		local humanoid = character:WaitForChild "Humanoid"
		local player_entity: ESS.Entity = ESS.Entity.RegisterEntity(humanoid)
		player_entity:LeaveTeam(ESS.Teams.NEUTRAL)
		player_entity:JoinTeam(ESS.Teams.Players)
		Heal.Setup(player)
		Sword.Setup(player)
	end

	player.CharacterAdded:Connect(onCharacterAdded)
end

if #Players:GetPlayers() > 0 then
	for _, p in Players:GetPlayers() do
		onPlayerAdded(p)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
