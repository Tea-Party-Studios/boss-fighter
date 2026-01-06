local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local ServerScriptService = game:GetService "ServerScriptService"
local zap = require(ServerScriptService.Server.zap)
local Lyra = require(ReplicatedStorage.Packages.Lyra)
local t = require(ReplicatedStorage.Packages.t)
local LyraStore = {}

local template = {
	wins = 0,
	current_stats = {
		strength = 0,
		endurance = 0,
		energy = 0,
	},
}

local schema = t.strictInterface {
	wins = t.number,
	current_stats = t.strictInterface {
		strength = t.number,
		endurance = t.number,
		energy = t.number,
	},
}

local function syncWithClient(key: string, newData, oldData)
	local player = Players:GetPlayerByUserId(tonumber(key))
	if not player then
		return
	end
	if oldData == nil then
		-- First time data is loaded
		zap.PlayerSync.Fire(player, newData)
		return
	end

	-- Send only changed data
	local changes = {}
	if newData.wins ~= oldData.wins then
		changes.wins = newData.wins
	end
	if newData.current_stats ~= oldData.current_stats then
		changes.current_stats = newData.current_stats
	end

	-- Send changes to client
	zap.PlayerSync.Fire(player, changes)
end

LyraStore.store = Lyra.createPlayerStore {
	name = "PlayerData",
	template = template,
	schema = schema,
	changedCallbacks = { syncWithClient },
}

function LyraStore.setStats(player: Player, newStats: { endurance: number, energy: number, strength: number })
	LyraStore.store:updateAsync(player, function(data): boolean
		data.current_stats = newStats
		print "saved to server"
		return true
	end)
end

return LyraStore
