local AssetCounterService = game:GetService("AssetCounterService")
local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
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
local enduranceCount = source(0)
local energyCount = source(0)


local bar = function(props:{
	Color: Color3,
	Color2: Color3,
	Color3: Color3,
	Color4: Color3,
	Position: UDim2,
	Counter: () -> number,
	Text: string,
})
	local barSize = derive(function()
		return UDim2.fromScale(props.Counter() / 60, 1)
	end)
	local statText = derive(function()
		return `{props.Counter()}`
	end)

	local Label = create "TextLabel" {
		Size = UDim2.fromScale(125 / 1920, 37 / 1080),
		Position = props.Position + UDim2.fromScale(-470 / 1920, -3 / 1080),
		BackgroundTransparency = 1,
		Text = props.Text,
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		FontFace = Font.fromName "ComicNeueAngular",
		create "UIGradient" {
			Color = ColorSequence.new {
				ColorSequenceKeypoint.new(0, props.Color4),
				ColorSequenceKeypoint.new(0.5, props.Color),
				ColorSequenceKeypoint.new(1, props.Color4),
			},
		},
	}
	tweenGradient(Label.UIGradient)
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Label,
		create "TextLabel" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = props.Position,
			BackgroundTransparency = 1,
			TextColor3 = props.Color,
			Text = statText,
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "CanvasGroup" {
			Size = UDim2.fromScale(500 / 1920, 23 / 1080),
			Position = props.Position + UDim2.fromScale(-434/1920,52/1080),--UDim2.fromScale(166 / 1920, 600 / 1080),
			BackgroundTransparency = 1,
			create "UICorner" {
				CornerRadius = UDim.new(1, 0),
			},
			create "UIStroke" {
				Thickness = 3,
				Color = props.Color,
			},
			create "Frame" {
				Name = "Frame",
				Size = barSize,
				BackgroundColor3 = props.Color3,
			},
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = props.Position + UDim2.fromScale(-30/1920,0),--UDim2.fromScale(570 / 1920, 548 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "-",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0, props.Color),
					ColorSequenceKeypoint.new(1, props.Color2),
				},
			},
			Activated = function()
				if props.Counter() > 0 and pointsRemaining() < 60 then
					props.Counter(props.Counter() - 1)
					pointsRemaining(pointsRemaining() + 1)
				end
			end,
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = props.Position + UDim2.fromScale(30/1920,0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "+",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0, props.Color),
					ColorSequenceKeypoint.new(1, props.Color2),
				},
			},
			Activated = function()
				if props.Counter() < 60 and pointsRemaining() > 0 then
					props.Counter(props.Counter() + 1)
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
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(107, 92, 92),
		BackgroundTransparency = 1,
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
			Activated = function()
				vide_sources.InStatMenu(false)
			end,
			create "TextLabel" {
				Text = "Save",
				TextScaled = true,
				TextColor3 = Color3.new(1,1,1),
				FontFace = Font.fromName "ComicNeueAngular",
				Size = UDim2.fromScale(1,1),
				BackgroundTransparency = 1,
			}
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
		bar({
			Color = Color3.new(1,0,0),
			Color2 = Color3.new(0.32549, 0, 0),
			Color3 = Color3.new(0.694118, 0, 0),
			Color4 = Color3.new(0.454902, 0, 0),
			Position = UDim2.fromScale(600 / 1920, 548 / 1080),
			Text = "Strength",
			Counter = strengthCount,
		}),
		bar({
			Color = Color3.new(0, 1, 0.05098),
			Color2 = Color3.new(0.054902, 0.32549, 0),
			Color3 = Color3.new(0.113725, 0.694118, 0),
			Color4 = Color3.new(0, 0.454902, 0),
			Position = UDim2.fromScale(600 / 1920, 678 / 1080),
			Text = "Endurance",
			Counter = enduranceCount,
		}),
		bar({
			Color = Color3.new(0.984314, 1, 0),
			Color2 = Color3.new(0.447059, 0.439216, 0),
			Color3 = Color3.new(0.760784, 0.772549, 0),
			Color4 = Color3.new(0.537255, 0.545098, 0),
			Position = UDim2.fromScale(600 / 1920, 808 / 1080),
			Text = "Energy",
			Counter = energyCount,
		}),
	}
end
