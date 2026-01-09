local ReplicatedStorage = game:GetService "ReplicatedStorage"
local LyraStore = require(ReplicatedStorage.Shared.LyraStore)
local zap = require(script.Parent.zap)

zap.UpdateStats.SetCallback(function(Player: Player, NewStats: { endurance: number, energy: number, strength: number })
	LyraStore.setStats(Player, NewStats)
end)
