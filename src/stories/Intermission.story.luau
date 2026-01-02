local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local ui_labs = require(ReplicatedStorage.Packages["ui-labs"])
local intermission = require(ReplicatedStorage.UI.intermission)

local controls = {
	DeviceCanvas = ui_labs.EnumList(
		{ Mobile = UDim2.fromOffset(812, 375), Desktop = UDim2.fromOffset(1920, 1080) },
		"Desktop"
	),
}

local story = {
	vide = vide,
	controls = controls,
	story = function(props)
		return vide.create "Frame" {
			Size = props.controls.DeviceCanvas,
			BackgroundTransparency = 0.2,
			intermission,
		}
	end,
}

return story
