local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local create = vide.create
local source = vide.source
local derive = vide.derive

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end

--rbxassetid://133480889898713
--rbxassetid://86693771757550
--rbxassetid://90273910497543
--rbxassetid://105124268814587
--rbxassetid://111987314840890
return function()
	local streaks = create "ImageLabel" {
		Image = "rbxassetid://111987314840890",
		Size = UDim2.fromScale(500 / 770, 181 / 278),
		Position = UDim2.fromScale(220.5 / 770, 106.5 / 278),
		BackgroundTransparency = 1,
		create "UIGradient" {
			Color = ColorSequence.new {
				ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.4, Color3.new(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
			},
		},
	}
	tweenGradient(streaks.UIGradient)
	return create "Frame" {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(107, 92, 92),
		BackgroundTransparency = 1,

		--rbxassetid://72161129644540
		--rbxassetid://115296268432934
		--rbxassetid://98768423323270

		create "Frame" {
			Size = UDim2.fromScale(770 / 1920, 278 / 1080),
			Position = UDim2.fromScale(35 / 1920, 47 / 1080),
			BackgroundTransparency = 1,
			create "UIAspectRatioConstraint" {
				AspectRatio = 770 / 278,
			},
			create "ImageLabel" {
				Image = "rbxassetid://98768423323270",
				Size = UDim2.fromScale(206 / 770, 206 / 278),
				Position = UDim2.fromScale(46 / 770, 72 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
			},

			create "ImageLabel" {
				Image = "rbxassetid://90501692272226",
				Size = UDim2.fromScale(510 / 770, 33.5 / 278),
				Position = UDim2.fromScale(250 / 770, 158 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
			},
			create "ImageLabel" {
				Image = "rbxassetid://125573192752371",
				Size = UDim2.fromScale(535 / 770, 29 / 278),
				Position = UDim2.fromScale(209 / 770, 207 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
			},
			streaks,
		},
	}
end
--stam
--rbxassetid://125573192752371
--save
--rbxassetid://86837866908229

--health
--rbxassetid://90501692272226
--save
--rbxassetid://86837866908229
