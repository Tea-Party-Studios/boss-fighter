local Debris = game:GetService "Debris"
local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
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

	local arena = ReplicatedStorage.Shared.models.Arena:Clone()
	arena.Parent = workspace
	for _, p in eligiblePlayers do
		local function getRandomPositionInPart(Part: BasePart)
			local cframe = Part.CFrame
			--2.5 on the yAxis is half the height of a character,maybe we can calculate it if it matters later
			cframe *= CFrame.new(Part.Size.X * (math.random() - 0.5), 2.5, Part.Size.Z * (math.random() - 0.5))
			return cframe
		end
		p.Character:PivotTo(getRandomPositionInPart(arena.PlayerRange))
	end

	--TODO: Summon the boss
	local boss = Instance.new "Part"
	boss.Position = arena.BossSpawn.WorldPosition
	boss.Parent = workspace
	boss.Color = Color3.new(0.270588, 0.866667, 0.035294)
	Debris:AddItem(boss, 10)

	data.players = eligiblePlayers
	data.arena = arena
	data.boss = boss
end

function InMatch:OnHeartbeat(data)
	data.players = allEligiblePlayers(data.players)
	if data.boss.Parent ~= workspace then
		data.boss = nil
	end
end

function InMatch:OnLeave(data)
	data.arena:Destroy()
end

return InMatch
