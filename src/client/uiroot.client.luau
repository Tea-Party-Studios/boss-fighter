local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local Intermission = require(ReplicatedStorage.UI.Intermission)
local component = require(ReplicatedStorage.UI.component)

local mount = vide.mount
local create = vide.create
local show = vide.show

mount(function()
	return create "ScreenGui" {
<<<<<<< HEAD
		component(),
		show(vide_sources.InIntermission, intermission),
=======
		show(vide_sources.InIntermission, Intermission),
		component(),
>>>>>>> 830401cbfcde961e13a5ad15c6db1ad875ed55da
		IgnoreGuiInset = true,
	}
end, Players.LocalPlayer.PlayerGui)
