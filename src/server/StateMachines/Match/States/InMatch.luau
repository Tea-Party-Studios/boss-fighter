local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)
local PlayerIsAlive = require(ReplicatedStorage.Shared.PlayerIsAlive)
local Match = script.Parent.Parent
local State = robloxstatemachine.State

local InMatch = State.new "InMatch"
InMatch.Transitions = { require(Match.Transitions.PlayersDied) }

function InMatch:OnEnter(data)
	local eligiblePlayers = {}

	for _, p in Players:GetPlayers() do
		if p.Character and p.Character.Humanoid.Health > 0 then
			table.insert(eligiblePlayers, p)
		end
	end

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

	data.combatants = eligiblePlayers
	data.arena = arena

	--summon an enemy
end

function InMatch:OnHeartbeat(data)
	local new_combatants = {}
	for i, p: Player in data.combatants do
		if PlayerIsAlive(p) then
			table.insert(new_combatants, p)
		end
	end
	data.combatants = new_combatants
end

function InMatch:OnLeave(data)
	data.arena:Destroy()
end

return InMatch
