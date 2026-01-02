local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local component = require(ReplicatedStorage.UI.component)
local intermission = require(ReplicatedStorage.UI.intermission)

local mount = vide.mount
local create = vide.create
local show = vide.show

mount(function()
	return create "ScreenGui" {
		component,
		show(vide_sources.InIntermission, intermission),
		IgnoreGuiInset = true,
	}
end, Players.LocalPlayer.PlayerGui)
