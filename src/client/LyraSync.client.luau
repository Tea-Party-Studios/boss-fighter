local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local zap = require(ReplicatedStorage.Shared.zap)

zap.PlayerSync.SetCallback(function(Value: { wins: number })
	print(Value.wins)
end)

zap.InIntermission.SetCallback(function(InIntermission: boolean)
	vide_sources.InIntermission(InIntermission)
end)
