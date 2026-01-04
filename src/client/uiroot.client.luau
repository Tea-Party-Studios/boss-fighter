local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local Intermission = require(ReplicatedStorage.UI.Intermission)
local StatMenu = require(ReplicatedStorage.UI.StatMenu)

local mount = vide.mount
local create = vide.create
local show = vide.show

mount(function()
	return create "ScreenGui" {
		StatMenu(),
		show(vide_sources.InIntermission, Intermission),
		IgnoreGuiInset = true,
	}
end, Players.LocalPlayer.PlayerGui)
