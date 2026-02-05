local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create

local function Tooltip(props: {
	Name: string,
	Desc: string,
	Position: () -> UDim2,
})
	local desc = create "ImageLabel" {
		Image = "rbxassetid://104819912607527",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(240 / 1800, 114 / 900),
		Position = props.Position,
		AnchorPoint = Vector2.new(1, 1),
		ZIndex = 3,

		create "UIAspectRatioConstraint" {
			AspectRatio = 240 / 114,
		},
		create "TextLabel" {
			Text = props.Name,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(160 / 240, 24 / 114),
			Position = UDim2.fromScale(0.5, 0.14),
			TextScaled = true,
			BackgroundTransparency = 1,
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "TextLabel" {
			Text = props.Desc,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(225 / 240, 70 / 114),
			Position = UDim2.fromScale(0.5, 0.61),
			TextScaled = true,
			BackgroundTransparency = 1,
			FontFace = Font.fromName "ComicNeueAngular",
			TextColor3 = Color3.new(0.913725, 0.913725, 0.913725),
		},
	}
	return desc
end

return Tooltip
