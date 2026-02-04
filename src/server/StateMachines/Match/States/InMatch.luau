local Debris = game:GetService "Debris"
local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local ServerScriptService = game:GetService "ServerScriptService"
local States = ServerScriptService.Server.StateMachines.Baller.States
local matchConfig = require(ReplicatedStorage.Config.matchConfig)
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local PlayerIsAlive = require(ReplicatedStorage.Shared.PlayerIsAlive)
local Match = script.Parent.Parent
local State = robloxstatemachine.State

local InMatch = State.new "InMatch"
InMatch.Transitions = { require(Match.Transitions.MatchLost), require(Match.Transitions.MatchWon) }

local function allEligiblePlayers(players: { Player })
	local output = {}
	for _, p in players do
		if PlayerIsAlive(p) then
			table.insert(output, p)
		end
	end
	return output
end

function InMatch:OnEnter(data)
	local eligiblePlayers = allEligiblePlayers(Players:GetPlayers())
	for _, p in eligiblePlayers do
		local character = p.Character
		local angle = math.rad(math.random() * 360)
		local radius_percentage = math.random(0.5, 1)
		local center = CFrame.new(unpack(matchConfig.SpawnPosition))
		character:PivotTo(
			center
				+ Vector3.new(math.sin(angle) * radius_percentage, 0, math.cos(angle) * radius_percentage)
					* matchConfig.SpawnRadius
		)
		--p.Character:PivotTo(getRandomPositionInPart(arena.PlayerRange))
	end

	local boss = ReplicatedStorage.Shared.models.Baller:Clone()
	boss.Parent = workspace
	boss:PivotTo(CFrame.new(0, 50, 0))
	boss.PrimaryPart:SetNetworkOwner(nil)
	data.bossStateMachine = robloxstatemachine.new(
		"Neutral",
		robloxstatemachine:LoadDirectory(States),
		{ baller = boss, players = eligiblePlayers }
	)

	data.players = eligiblePlayers
	data.boss = boss
end

function InMatch:OnHeartbeat(data)
	for i = #data.players, 1, -1 do
		if not PlayerIsAlive(data.players[i]) then
			--player removed
			print "removed player"
			table.remove(data.players, i)
		end
	end
	if data.boss.Parent ~= workspace then
		data.bossStateMachine:Destroy()
		data.boss = nil
	else
		data.bossStateMachine:ChangeData("players", data.players)
	end
end

function InMatch:OnLeave(data)
	data.bossStateMachine:Destroy()
	Debris:AddItem(data.boss, 0)
	for _, player in data.players do
		Debris:AddItem(player.Character, 0)
	end
end

return InMatch
