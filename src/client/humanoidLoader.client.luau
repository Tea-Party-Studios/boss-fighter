local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local Player = Players.LocalPlayer

Player.CharacterAdded:Connect(function(a0: Model)
	local humanoid: Humanoid = a0:WaitForChild "Humanoid"
	vide_sources.Humanoid(humanoid)
	vide_sources.Mouse(Player:GetMouse())
	local cn
	cn = humanoid.Died:Connect(function()
		vide_sources.Humanoid(nil)
		cn:Disconnect()
	end)
end)
