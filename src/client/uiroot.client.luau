local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local zap = require(ReplicatedStorage.Shared.zap)
local Intermission = require(ReplicatedStorage.UI.Intermission)
local StatMenu = require(ReplicatedStorage.UI.StatMenu)
local HealthUI = require(ReplicatedStorage.UI.HealthUI)

local mount = vide.mount
local create = vide.create
local show = vide.show

mount(function()
	return create "ScreenGui" {
		show(vide_sources.InStatMenu, function()
			return StatMenu {
				statChange = zap.UpdateStats.Fire,
			}
		end),
		show(vide_sources.InIntermission, Intermission),
		show(vide_sources.Humanoid, function()
			return HealthUI {
				humanoidSource = vide_sources.Humanoid,
			}
		end),
		IgnoreGuiInset = true,
	}
end, Players.LocalPlayer.PlayerGui)
