local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local ServerScriptService = game:GetService "ServerScriptService"
local zap = require(ServerScriptService.Server.zap)
local Lyra = require(ReplicatedStorage.Packages.Lyra)
local t = require(ReplicatedStorage.Packages.t)
local LyraStore = {}

local template = {
	wins = 0,
}

local schema = t.strictInterface {
	wins = t.number,
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

	-- Send changes to client
	zap.PlayerSync.Fire(player, changes)
end

LyraStore.store = Lyra.createPlayerStore {
	name = "PlayerData",
	template = template,
	schema = schema,
	changedCallbacks = { syncWithClient },
}
return LyraStore
