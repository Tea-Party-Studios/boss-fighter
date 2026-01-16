local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local Player = Players.LocalPlayer

Player.CharacterAdded:Connect(function(a0: Model)
	vide_sources.Humanoid(a0:WaitForChild "Humanoid")
	print(a0.Humanoid.Parent)
end)
