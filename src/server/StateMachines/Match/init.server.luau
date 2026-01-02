local ReplicatedStorage = game:GetService "ReplicatedStorage"
local robloxstatemachine = require(ReplicatedStorage.Packages.robloxstatemachine)

robloxstatemachine.new("Idle", robloxstatemachine:LoadDirectory(script.States), {})
