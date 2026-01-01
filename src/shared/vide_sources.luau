local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

return {
	InIntermission = source(false),
	IntermissionTime = source(0),
}
