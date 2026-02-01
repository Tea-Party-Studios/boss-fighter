local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create
local derive = vide.derive

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end

local function StarBar(props: {
	PrimaryColor: Color3,
	PlusMinusColor: Color3,
	FillColor: Color3,
	GradientDarkColor: Color3,
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
				ColorSequenceKeypoint.new(0, props.GradientDarkColor),
				ColorSequenceKeypoint.new(0.5, props.PrimaryColor),
				ColorSequenceKeypoint.new(1, props.GradientDarkColor),
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
			TextColor3 = props.PrimaryColor,
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
				Color = props.PrimaryColor,
			},
			create "Frame" {
				Name = "Frame",
				Size = barSize,
				BackgroundColor3 = props.FillColor,
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
					ColorSequenceKeypoint.new(0, props.PrimaryColor),
					ColorSequenceKeypoint.new(1, props.PlusMinusColor),
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
					ColorSequenceKeypoint.new(0, props.PrimaryColor),
					ColorSequenceKeypoint.new(1, props.PlusMinusColor),
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

return StarBar
