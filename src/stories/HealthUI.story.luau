local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local ui_labs = require(ReplicatedStorage.Packages["ui-labs"])
local HealthUI = require(ReplicatedStorage.UI.HealthUI)

local controls = {
	DeviceCanvas = ui_labs.EnumList(
		{ Mobile = UDim2.fromOffset(812, 375), Desktop = UDim2.fromOffset(1920, 1080) },
		"Desktop"
	),
	Health = ui_labs.Slider(100, 0, 100),
	Stamina = ui_labs.Slider(100, 0, 100),
}
local mockHumanoid = Instance.new "Humanoid"
mockHumanoid:SetAttribute("Stamina", 50)
local humanoidSource = vide.source(mockHumanoid)

local story = {
	vide = vide,
	controls = controls,
	story = function(props)
		vide.effect(function()
			mockHumanoid.Health = props.controls.Health()
		end)
		vide.effect(function()
			mockHumanoid:SetAttribute("Stamina", props.controls.Stamina())
		end)
		return vide.create "Frame" {
			Size = props.controls.DeviceCanvas,
			BackgroundTransparency = 0.2,
			HealthUI {
				humanoidSource = humanoidSource,
			},
		}
	end,
}

return story
