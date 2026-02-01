local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

return {
	InIntermission = source(false),
	InStatMenu = source(false),
	Stats = {
		strengthCount = source(0),
		energyCount = source(0),
		enduranceCount = source(0),
	},
	Humanoid = source(nil),
	Mouse = source(nil),
}
