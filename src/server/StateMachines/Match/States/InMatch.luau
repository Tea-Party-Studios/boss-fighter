local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local PlayerIsAlive = require(ReplicatedStorage.Shared.PlayerIsAlive)
local Match = script.Parent.Parent
local State = robloxstatemachine.State

local InMatch = State.new "InMatch"
InMatch.Transitions = { require(Match.Transitions.PlayersDied) }

local function allEligiblePlayers(players: { Player })
	local output = {}
	for _, p in players do
		table.insert(output, p)
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
			cframe *= CFrame.new(Part.Size.X * (math.random() - 0.5), 2.5, Part.Size.Z * (math.random() - 0.5))

			return cframe
		end
		p.Character:PivotTo(getRandomPositionInPart(arena.PlayerRange))
	end

	data.players = eligiblePlayers
	data.arena = arena

	--TODO: Summon the boss
end

function InMatch:OnHeartbeat(data)
	data.players = allEligiblePlayers(data.players)
end

function InMatch:OnLeave(data)
	data.arena:Destroy()
end

return InMatch
