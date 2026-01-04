local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local rocko = workspace.RockoTheBot
local PP = rocko.ProximityPrompt

PP.Triggered:Connect(function()
	vide_sources.InStatMenu(true)
end)
