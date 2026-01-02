local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create

return function()
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(107, 92, 92),
		BackgroundTransparency = 0,
		create "Frame" {
			Size = UDim2.fromScale(1800 / 1920, 900 / 1080),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.36,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			create "UIStroke" {
				Thickness = 2,
				Color = Color3.new(1, 1, 1),
			},
		},
		create "ImageButton" {
			Image = "rbxassetid://100552236979659",
			Size = UDim2.fromScale(220 / 1920, 37 / 1080),
			Position = UDim2.fromScale(850 / 1920, 903 / 1080),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = "rbxassetid://116531422214615",
			Size = UDim2.fromScale(600 / 1920, 800 / 1080),
			Position = UDim2.fromScale(100 / 1920, 140 / 1080),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = "rbxassetid://116531422214615",
			Size = UDim2.fromScale(600 / 1920, 800 / 1080),
			Position = UDim2.fromScale(1220 / 1920, 140 / 1080),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = "rbxassetid://92472141862203",
			Size = UDim2.fromScale(560 / 1920, 7 / 1080),
			Position = UDim2.fromScale(120 / 1920, 448 / 1080),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = "rbxassetid://92472141862203",
			Size = UDim2.fromScale(560 / 1920, 7 / 1080),
			Position = UDim2.fromScale(1240 / 1920, 448 / 1080),
			BackgroundTransparency = 1,
		},
		create "TextLabel" {
			Size = UDim2.fromScale(420 / 1920, 236 / 1080),
			BackgroundTransparency = 1,
			Text = "Expend points to enforce core attributes of Strength, Endurance, and Energy. \z
			Spend your points wisely, you have only a limited amount to spare",
			Position = UDim2.fromScale(191 / 1920, 176 / 1080),
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "TextLabel" {
			Size = UDim2.fromScale(420 / 1920, 236 / 1080),
			BackgroundTransparency = 1,
			Text = "Expend points to learn new abilities and equip special weapons. \z
			Spend your points wisely, you only have a limited amount to spare",
			Position = UDim2.fromScale(1311 / 1920, 176 / 1080),
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
	}
end
