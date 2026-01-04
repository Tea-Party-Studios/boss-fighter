local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create
local source = vide.source
local derive = vide.derive

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end

local pointsRemaining = source(60)
local strengthCount = source(0)

local bar = function()
	local barSize = derive(function()
		return UDim2.fromScale(strengthCount() / 60, 1)
	end)
	local strengthText = derive(function()
		return `{strengthCount()}`
	end)
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		create "TextLabel" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(600 / 1920, 548 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 0, 0),
			Text = strengthText,
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "CanvasGroup" {
			Size = UDim2.fromScale(500 / 1920, 23 / 1080),
			Position = UDim2.fromScale(166 / 1920, 600 / 1080),
			BackgroundTransparency = 1,
			create "UICorner" {
				CornerRadius = UDim.new(1, 0),
			},
			create "UIStroke" {
				Thickness = 3,
				Color = Color3.new(1, 0, 0),
			},
			create "Frame" {
				Name = "Frame",
				Size = barSize,
				BackgroundColor3 = Color3.new(0.694118, 0, 0),
			},
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(570 / 1920, 548 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "-",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0, Color3.new(0.972549, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.new(0.32549, 0, 0)),
				},
			},
			Activated = function()
				if strengthCount() > 0 and pointsRemaining() < 60 then
					strengthCount(strengthCount() - 1)
					pointsRemaining(pointsRemaining() + 1)
				end
			end,
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(630 / 1920, 548 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "+",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0, Color3.new(0.972549, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.new(0.32549, 0, 0)),
				},
			},
			Activated = function()
				if strengthCount() < 60 and pointsRemaining() > 0 then
					strengthCount(strengthCount() + 1)
					pointsRemaining(pointsRemaining() - 1)
				end
			end,
		},
	}
end

return function()
	local pointsText = derive(function()
		return `Free Points: {pointsRemaining()}`
	end)
	local freePoints = create "TextLabel" {
		Size = UDim2.fromScale(170 / 1920, 45 / 1080),
		Position = UDim2.fromScale(326 / 1920, 477 / 1080),
		Text = pointsText,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(67, 32, 222),
		BackgroundTransparency = 1,
		FontFace = Font.fromName "ComicNeueAngular",
	}

	local strengthLabel = create "TextLabel" {
		Name = "strength",
		Size = UDim2.fromScale(125 / 1920, 37 / 1080),
		Position = UDim2.fromScale(130 / 1920, 545 / 1080),
		BackgroundTransparency = 1,
		Text = "Strength",
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		FontFace = Font.fromName "ComicNeueAngular",
		create "UIGradient" {
			Color = ColorSequence.new {
				ColorSequenceKeypoint.new(0, Color3.new(0.454902, 0, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0.972549, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0.454902, 0, 0)),
			},
		},
	}
	tweenGradient(strengthLabel.UIGradient)
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
		freePoints,
		strengthLabel,
		bar(),
	}
end
