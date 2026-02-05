local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create

local function tweenGradient(object: UIGradient)
	object.Rotation = -180
	local gradientInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Rotation = 180 })
	tween:Play()
end

local function Ability(props: {
	Image: string,
	Size: UDim2,
	Position: UDim2,
	Color1: Color3,
	Color2: Color3,
	Name: string,
	Desc: string,
	Hovered: () -> (),
	positionSource: (UDim2) -> (),
})
	local ability = create "TextButton" {
		Size = UDim2.fromScale(90 / 1800, 90 / 900),
		BackgroundColor3 = Color3.fromRGB(123, 123, 123),
		BackgroundTransparency = 1,
		Text = "",
		MouseEnter = function()
			props.Hovered {
				Name = props.Name,
				Desc = props.Desc,
			}
		end,
		MouseMoved = function(x, y)
			props.positionSource(UDim2.fromOffset(x, y))
		end,
		MouseLeave = function()
			props.Hovered(nil)
		end,
		create "UIStroke" {
			Thickness = 3,
			Color = Color3.new(1, 1, 1),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			create "UIGradient" {
				Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0, props.Color1),
					ColorSequenceKeypoint.new(0.25, props.Color2),
					ColorSequenceKeypoint.new(0.75, props.Color1),
					ColorSequenceKeypoint.new(1, props.Color2),
				},
			},
		},
		create "UIAspectRatioConstraint" {
			AspectRatio = 1,
		},
		Activated = function()
			print "clicked ability"
		end,
		create "ImageLabel" {
			Image = props.Image,
			Size = props.Size,
			Position = props.Position,
			BackgroundTransparency = 1,
		},
	}
	tweenGradient(ability.UIStroke.UIGradient)
	return ability
end

return Ability
