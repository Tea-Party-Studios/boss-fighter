local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create
local source = vide.source
local effect = vide.effect
local derive = vide.derive

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end


local pointsRemaining = source(60)
local strengthCount = source(0)
<<<<<<< HEAD
local enduranceCount = source(0)
local energyCount = source(0)

local function strengthCounter()
	local strengthFrame = create "Frame" {
		Size = UDim2.fromScale(1,1),
<<<<<<< HEAD
=======
=======
>>>>>>> d5f4a6758fce40febd8c390ecc31ede4def0096d

local bar = function()
	local barSize = derive(function()
		return UDim2.fromScale(strengthCount() / 60, 1)
	end)
	local strengthText = derive(function()
		return `{strengthCount()}`
	end)
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
<<<<<<< HEAD
=======
>>>>>>> 830401cbfcde961e13a5ad15c6db1ad875ed55da
>>>>>>> d5f4a6758fce40febd8c390ecc31ede4def0096d
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
				Size = UDim2.fromScale(strengthCount()/60, 1),
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

<<<<<<< HEAD
local function enduranceCounter()
	local enduranceFrame = create "Frame" {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		create "TextLabel" {
				Size = UDim2.fromScale(40 / 1920, 40 / 1080),
				Position = UDim2.fromScale(600 / 1920, 668 / 1080),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(0, 1, 0.05098),
				Text = tostring(energyCount()),
				TextScaled = true,
				FontFace = Font.fromName "ComicNeueAngular",

			},
		
		create "CanvasGroup" {
			Size = UDim2.fromScale(500 / 1920, 23 / 1080),
			Position = UDim2.fromScale(166 / 1920, 725 / 1080),
			BackgroundTransparency = 1,
			create "UICorner" {
				CornerRadius = UDim.new(1,0)
			},
			create "UIStroke" {
				Thickness = 3,
				Color = Color3.new(0, 1, 0.05098),
			},
			create "Frame" {
				Name = "Frame",
				Size = UDim2.fromScale(energyCount()/60, 1),
				BackgroundColor3 = Color3.new(0.047059, 0.568627, 0),
			},
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(570 / 1920, 668 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1,1,1),
			Text = "-",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0,Color3.new(0, 1, 0.05098)),
					ColorSequenceKeypoint.new(1,Color3.new(0, 0.427451, 0)),
				},
			},
			Activated = function()
				if energyCount() > 0 and pointsRemaining() < 60 then
					energyCount(energyCount()-1)
					pointsRemaining(pointsRemaining()+1)
				end
			end
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(630 / 1920, 668 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1,1,1),
			Text = "+",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0,Color3.new(0, 1, 0.05098)),
					ColorSequenceKeypoint.new(1,Color3.new(0, 0.427451, 0)),
				},
			},
			Activated = function()
				if energyCount() < 60 and pointsRemaining() > 0 then
					energyCount(energyCount()+1)
					pointsRemaining(pointsRemaining()-1)
				end
			end
		}
	}

	return enduranceFrame
end

local function energyCounter()
	local energyFrame = create "Frame" {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		create "TextLabel" {
				Size = UDim2.fromScale(40 / 1920, 40 / 1080),
				Position = UDim2.fromScale(600 / 1920, 803 / 1080),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(0.984314, 1, 0),
				Text = tostring(enduranceCount()),
				TextScaled = true,
				FontFace = Font.fromName "ComicNeueAngular",

			},
		
		create "CanvasGroup" {
			Size = UDim2.fromScale(500 / 1920, 23 / 1080),
			Position = UDim2.fromScale(166 / 1920, 855 / 1080),
			BackgroundTransparency = 1,
			create "UICorner" {
				CornerRadius = UDim.new(1,0)
			},
			create "UIStroke" {
				Thickness = 3,
				Color = Color3.new(0.984314, 1, 0),
			},
			create "Frame" {
				Name = "Frame",
				Size = UDim2.fromScale(enduranceCount()/60, 1),
				BackgroundColor3 = Color3.new(0.658824, 0.615686, 0),
			},
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(570 / 1920, 803 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1,1,1),
			Text = "-",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0,Color3.new(1, 0.984314, 0)),
					ColorSequenceKeypoint.new(1,Color3.new(0.690196, 0.701961, 0)),
				},
			},
			Activated = function()
				if enduranceCount() > 0 and pointsRemaining() < 60 then
					enduranceCount(enduranceCount()-1)
					pointsRemaining(pointsRemaining()+1)
				end
			end
		},
		create "TextButton" {
			Size = UDim2.fromScale(40 / 1920, 40 / 1080),
			Position = UDim2.fromScale(630 / 1920, 803 / 1080),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1,1,1),
			Text = "+",
			TextScaled = true,
			FontFace = Font.fromName "ComicNeueAngular",
			create "UIGradient" {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0,Color3.new(1, 0.984314, 0)),
					ColorSequenceKeypoint.new(1,Color3.new(0.690196, 0.701961, 0)),
				},
			},
			Activated = function()
				if enduranceCount() < 60 and pointsRemaining() > 0 then
					enduranceCount(enduranceCount()+1)
					pointsRemaining(pointsRemaining()-1)
				end
			end
		}
	}
	return energyFrame
end


=======
>>>>>>> 830401cbfcde961e13a5ad15c6db1ad875ed55da
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
<<<<<<< HEAD
	local enduranceLabel = create "TextLabel" {
		Name = "endurance",
		Size = UDim2.fromScale(125 / 1920, 37 / 1080),
		Position = UDim2.fromScale(130 / 1920, 665 / 1080),
		BackgroundTransparency = 1,
		Text = "Endurance",
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		FontFace = Font.fromName "ComicNeueAngular",
		create "UIGradient" {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0,Color3.new(0.015686, 0.454902, 0)),
				ColorSequenceKeypoint.new(0.5,Color3.new(0.082353, 0.972549, 0)),
				ColorSequenceKeypoint.new(1,Color3.new(0.015686, 0.454902, 0)),
			},
		}
	}
	local energyLabel = create "TextLabel" {
		Name = "energy",
		Size = UDim2.fromScale(125 / 1920, 37 / 1080),
		Position = UDim2.fromScale(130 / 1920, 795 / 1080),
		BackgroundTransparency = 1,
		Text = "Energy",
		TextColor3 = Color3.new(1, 1, 1),
		TextScaled = true,
		FontFace = Font.fromName "ComicNeueAngular",
		create "UIGradient" {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0,Color3.new(0.556863, 0.568627, 0)),
				ColorSequenceKeypoint.new(0.5,Color3.new(1, 0.984314, 0)),
				ColorSequenceKeypoint.new(1,Color3.new(0.556863, 0.568627, 0)),
			},
		}
	}
	local strengthFrame = strengthCounter()
	local enduranceFrame = enduranceCounter()
	local energyFrame = energyCounter()
=======
>>>>>>> 830401cbfcde961e13a5ad15c6db1ad875ed55da
	tweenGradient(strengthLabel.UIGradient)
	tweenGradient(enduranceLabel.UIGradient)
	tweenGradient(energyLabel.UIGradient)
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
<<<<<<< HEAD
		enduranceLabel,
		energyLabel,
		strengthFrame,
		enduranceFrame,
		energyFrame,
<<<<<<< HEAD
		bar(),
=======
=======
		bar(),
>>>>>>> 830401cbfcde961e13a5ad15c6db1ad875ed55da
>>>>>>> d5f4a6758fce40febd8c390ecc31ede4def0096d
	}
end
