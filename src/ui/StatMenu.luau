local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Ability = require(script.Parent.Ability)
local StatBar = require(script.Parent.StatBar)
local Tooltip = require(script.Parent.Tooltip)
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local create = vide.create
local derive = vide.derive
local show = vide.show
local source = vide.source

local mousePos = source(UDim2.fromOffset(0, 0))

local mainFrame = function(x, y)
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
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
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
		create "TextLabel" { --Weapons
			Size = UDim2.fromScale(144 / x, 65 / y),
			Position = UDim2.fromScale(1220 / x, 620 / y),
			BackgroundTransparency = 1,
			Text = "Weapons",
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Font.fromName "ComicNeueAngular",
		},
	}
end

return function(props: {
	statChange: () -> (),
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

	local hoveredAbility = source(nil)

	local isHovering = derive(function()
		return hoveredAbility() ~= nil
	end)

	return create "Frame" { --background
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(107, 92, 92),
		BackgroundTransparency = 1,
		show(isHovering, function()
			return Tooltip {
				Name = hoveredAbility().Name,
				Desc = hoveredAbility().Desc,
				Position = mousePos,
			}
		end),
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
				AspectRatio = 1800 / 900,
			},
			mainFrame(1800, 900),
			create "ScrollingFrame" { --abilities frame
				Size = UDim2.fromScale(405 / 1800, 120 / 900),
				Position = UDim2.fromScale(1265 / 1800, 485 / 900),
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollBarThickness = 0,
				ScrollBarImageTransparency = 1,
				CanvasSize = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				create "UIPadding" {
					PaddingTop = UDim.new(0.02, 0),
					PaddingLeft = UDim.new(0.01, 0),
				},
				create "UIGridLayout" {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					CellPadding = UDim2.fromScale(15 / 1800, 10 / 900),
					CellSize = UDim2.fromScale(100 / 1800, 100 / 900),
				},
				Ability { --fireball
					Image = "rbxassetid://134939278277864",
					Size = UDim2.fromScale(75.5 / 90, 86.5 / 90),
					Position = UDim2.fromScale(9.5 / 90, 3.6 / 90),
					Color1 = Color3.fromRGB(222, 0, 0),
					Color2 = Color3.fromRGB(254, 161, 4),
					Name = "Fireball",
					Desc = "It's hot... and you can throw it",
					Hovered = hoveredAbility,
					positionSource = mousePos,
				},
				Ability { --heal
					Image = "rbxassetid://78192358807215",
					Size = UDim2.fromScale(88.5 / 90, 78.5 / 90),
					Position = UDim2.fromScale(0.5 / 90, 0 / 90),
					Color1 = Color3.fromRGB(26, 222, 0),
					Color2 = Color3.fromRGB(216, 254, 4),
					Name = "Heal",
					Desc = "Click on your teammates to heal them",
					Hovered = hoveredAbility,
					positionSource = mousePos,
				},
			},
			create "ImageButton" { --save button
				Image = "rbxassetid://100552236979659",
				Size = UDim2.fromScale(220 / 1800, 37 / 900),
				Position = UDim2.fromScale(795 / 1800, 818 / 900),
				BackgroundTransparency = 1,
				Activated = function()
					vide_sources.InStatMenu(false)
					props.statChange { endurance = enduranceCount(), strength = strengthCount(), energy = energyCount() }
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
			StatBar { --strength bar
				PrimaryColor = Color3.new(1, 0, 0),
				PlusMinusColor = Color3.new(0.32549, 0, 0),
				FillColor = Color3.new(0.694118, 0, 0),
				GradientDarkColor = Color3.new(0.454902, 0, 0),
				Position = UDim2.fromScale(545 / 1800, 458 / 900),
				Text = "Strength",
				RemainingPoints = pointsRemaining,
				Counter = strengthCount,
			},
			StatBar { --endurance bar
				PrimaryColor = Color3.new(0, 1, 0.05098),
				PlusMinusColor = Color3.new(0.054902, 0.32549, 0),
				FillColor = Color3.new(0.113725, 0.694118, 0),
				GradientDarkColor = Color3.new(0, 0.454902, 0),
				Position = UDim2.fromScale(545 / 1800, 588 / 900),
				Text = "Endurance",
				RemainingPoints = pointsRemaining,
				Counter = enduranceCount,
			},
			StatBar { --energy bar
				PrimaryColor = Color3.new(0.984314, 1, 0),
				PlusMinusColor = Color3.new(0.447059, 0.439216, 0),
				FillColor = Color3.new(0.760784, 0.772549, 0),
				GradientDarkColor = Color3.new(0.537255, 0.545098, 0),
				Position = UDim2.fromScale(545 / 1800, 718 / 900),
				Text = "Energy",
				RemainingPoints = pointsRemaining,
				Counter = energyCount,
			},
			freePoints, --free points
		},
	}
end
