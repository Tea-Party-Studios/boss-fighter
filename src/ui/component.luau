local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create
local source = vide.source
local count = source(0)

return function()
	return create "Frame" {
		Size = UDim2.fromScale(0.5, 0.2),
		BackgroundColor3 = Color3.new(0.403922, 0.780392, 0.094118),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 0.9),
		create "TextButton" {
			Text = tostring(count()),
			Size = UDim2.fromScale(1, 1),
			TextScaled = true,
			Activated = function()
				count(count() + 1)
			end,
		},
	}
end
