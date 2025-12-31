local ReplicatedStorage = game:GetService "ReplicatedStorage"
local zap = require(ReplicatedStorage.Shared.zap)

zap.PlayerSync.SetCallback(function(Value: { wins: number })
	print(Value.wins)
end)
