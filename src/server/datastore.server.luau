local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local LyraStore = require(ReplicatedStorage.Shared.LyraStore)

local store = LyraStore.store

-- Load data when players join
Players.PlayerAdded:Connect(function(player)
	store:loadAsync(player)
end)

-- Save and clean up when they leave
Players.PlayerRemoving:Connect(function(player)
	store:unloadAsync(player)
end)

game:BindToClose(function()
	store:closeAsync()
end)
