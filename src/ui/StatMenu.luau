local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local create = vide.create
local derive = vide.derive

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end

local bar = function(props: {
	Color: Color3,
	Color2: Color3,
	Color3: Color3,
	Color4: Color3,
	Position: UDim2,
	Counter: () -> number,
	RemainingPoints: () -> number,
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
			Position = props.Position + UDim2.fromScale(-434 / 1920, 52 / 1080), --UDim2.fromScale(166 / 1920, 600 / 1080),
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
			Position = props.Position + UDim2.fromScale(-30 / 1920, 0), --UDim2.fromScale(570 / 1920, 548 / 1080),
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
				if props.Counter() > 0 then
					props.Counter(props.Counter() - 1)
				end
			end,
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = props.Position + UDim2.fromScale(30 / 1920, 0),
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
				if props.RemainingPoints() > 0 then
					props.Counter(props.Counter() + 1)
				end
			end,
		},
	}
end

local abilities = function(props: {
	Image: string,
	Size: UDim2,
	Position: UDim2,
})
	return create "TextButton" {
		Size = UDim2.fromScale(90/1800,90/900),
		BackgroundColor3 = Color3.fromRGB(123, 123, 123),
		BackgroundTransparency = 1,
		Text = "",
		create "UIStroke" {
			Thickness = 3,
			Color = Color3.new(0.745098, 0.745098, 0.745098),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

		},
		create "UIAspectRatioConstraint" {
			AspectRatio = 1
		},
		Activated = function()
			print("clicked ability")
		end,
		create "ImageLabel" {
			Image = props.Image,
			Size = props.Size,
			Position = props.Position,
			BackgroundTransparency = 1,
		},
	}
end

local mainFrame = function(x,y)
	return create "Frame" {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		create "ImageLabel" { --left box
			Image = "rbxassetid://116531422214615",
			Size = UDim2.fromScale(600 / x, 800 / y),
			Position = UDim2.fromScale(45 / x, 50 / y), -- -55, -90
			BackgroundTransparency = 1,
		},
		create "ImageLabel" { --right box
			Image = "rbxassetid://116531422214615",
			Size = UDim2.fromScale(600 / x, 800 / y),
			Position = UDim2.fromScale(1165 / x, 50 / y),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" { --left bar 
			Image = "rbxassetid://92472141862203",
			Size = UDim2.fromScale(560 / x, 7 / y),
			Position = UDim2.fromScale(65 / x, 358 / y),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" { --right bar
			Image = "rbxassetid://92472141862203",
			Size = UDim2.fromScale(560 / x, 7 / y),
			Position = UDim2.fromScale(1185 / x, 358 / y),
			BackgroundTransparency = 1,
		},
		create "TextLabel" { --core attributes desc 
			Size = UDim2.fromScale(420 / x, 236 / y),
			Position = UDim2.fromScale(136 / x, 86 / y),
			BackgroundTransparency = 1,
			Text = "Expend points to enforce core attributes of Strength, Endurance, and Energy. \z
			Spend your points wisely, you have only a limited amount to spare",
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "TextLabel" { --abilities/weapons desc
			Size = UDim2.fromScale(420 / x, 236 / y),
			Position = UDim2.fromScale(1256 / x, 86 / y),
			BackgroundTransparency = 1,
			Text = "Expend points to learn new abilities and equip special weapons. \z
			Spend your points wisely, you only have a limited amount to spare",
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "TextLabel" { --Abilities
			Size = UDim2.fromScale(144 / x, 65 / y),
			Position = UDim2.fromScale(1220 / x, 417 / y),
			BackgroundTransparency = 1,
			Text = "Abilities",
			TextScaled = true,
			TextColor3 = Color3.new(1,1,1),
			FontFace = Font.fromName "ComicNeueAngular",
		}
	}
end


return function(props: {
	statChange: () -> ()
})
	local energyCount = vide_sources.Stats.energyCount
	local strengthCount = vide_sources.Stats.strengthCount
	local enduranceCount = vide_sources.Stats.enduranceCount
	local pointsRemaining = derive(function()
		return 60 - strengthCount() - enduranceCount() - energyCount()
	end)
	local pointsText = derive(function()
		return `Free Points: {pointsRemaining()}`
	end)
	local freePoints = create "TextLabel" { --free points
		Size = UDim2.fromScale(170 / 1800, 45 / 900),
		Position = UDim2.fromScale(271 / 1800, 387 / 900),
		Text = pointsText,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(67, 32, 222),
		BackgroundTransparency = 1,
		FontFace = Font.fromName "ComicNeueAngular",
	}


	return create "Frame" { --background
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(107, 92, 92),
		BackgroundTransparency = 1,
		create "Frame" { --main frame 
			Size = UDim2.fromScale(1800 / 1920, 900 / 1080),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.36,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			create "UIStroke" {
				Thickness = 2,
				Color = Color3.new(1, 1, 1),
			},
			create "UIAspectRatioConstraint" {
				AspectRatio = 1800/900
			},
			mainFrame(1800, 900),
			--create "Frame" {
			--	Size = UDim2.fromScale(90/1800,90/900),
			--	Position = UDim2.fromScale(1350/1800,492/900)
			--},
			create "ScrollingFrame" {
				Size = UDim2.fromScale(405/1800,120/900),
				Position = UDim2.fromScale(1265/1800,460/900),
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollBarThickness = 0,
				ScrollBarImageTransparency = 1,
				CanvasSize = UDim2.fromScale(1,1),
				BackgroundTransparency = 1,
				create "UIPadding" {
					PaddingTop = UDim.new(0.02,0),
					PaddingLeft = UDim.new(0.01,0),
				},
				create "UIGridLayout" {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					CellPadding = UDim2.fromScale(10/1800,10/900),
					CellSize = UDim2.fromScale(90/1800,90/900),
					
				},
				abilities({
					Image = "rbxassetid://134939278277864",
					Size = UDim2.fromScale(75.5/90,86.5/90),
					Position = UDim2.fromScale(9.5/90,5/90),
				}),
				abilities({
					Image = "rbxassetid://78192358807215",
					Size = UDim2.fromScale(88.5/90,78.5/90),
					Position = UDim2.fromScale(0.5/90,-0.5/90),
				}),
			},
			create "ImageButton" { --save button
				Image = "rbxassetid://100552236979659",
				Size = UDim2.fromScale(220 / 1800, 37 / 900),
				Position = UDim2.fromScale(795 / 1800, 818 / 900),
				BackgroundTransparency = 1,
				Activated = function()
					vide_sources.InStatMenu(false)
					props.statChange({ endurance = enduranceCount(), strength = strengthCount(), energy = energyCount() })
				end,
				create "TextLabel" {
					Text = "Save",
					TextScaled = true,
					TextColor3 = Color3.new(1, 1, 1),
					FontFace = Font.fromName "ComicNeueAngular",
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
				},
			},
			bar { --strength bar
				Color = Color3.new(1, 0, 0),
				Color2 = Color3.new(0.32549, 0, 0),
				Color3 = Color3.new(0.694118, 0, 0),
				Color4 = Color3.new(0.454902, 0, 0),
				Position = UDim2.fromScale(545 / 1800, 458 / 900),
				Text = "Strength",
				RemainingPoints = pointsRemaining,
				Counter = strengthCount,
			},
			bar { --endurance bar
				Color = Color3.new(0, 1, 0.05098),
				Color2 = Color3.new(0.054902, 0.32549, 0),
				Color3 = Color3.new(0.113725, 0.694118, 0),
				Color4 = Color3.new(0, 0.454902, 0),
				Position = UDim2.fromScale(545 / 1800, 588 / 900),
				Text = "Endurance",
				RemainingPoints = pointsRemaining,
				Counter = enduranceCount,
			},
			bar { --energy bar 
				Color = Color3.new(0.984314, 1, 0),
				Color2 = Color3.new(0.447059, 0.439216, 0),
				Color3 = Color3.new(0.760784, 0.772549, 0),
				Color4 = Color3.new(0.537255, 0.545098, 0),
				Position = UDim2.fromScale(545 / 1800, 718 / 900),
				Text = "Energy",
				RemainingPoints = pointsRemaining,
				Counter = energyCount,
			},
			freePoints, --free points
			},
		}
end
