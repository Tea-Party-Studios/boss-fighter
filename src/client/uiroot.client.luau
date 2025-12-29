local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local component = require(ReplicatedStorage.UI.component)

local mount = vide.mount
local create = vide.create

mount(function()
	return create "ScreenGui" {
		component,
		IgnoreGuiInset = true,
	}
end, Players.LocalPlayer.PlayerGui)
