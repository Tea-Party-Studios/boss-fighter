local ReplicatedStorage = game:GetService "ReplicatedStorage"
local TweenService = game:GetService "TweenService"
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create
local action = vide.action
local cleanup = vide.cleanup

local maxHealth = 100
local maxStam = 100

local function tweenGradient(object: UIGradient)
	object.Offset = Vector2.new(-1, 0)
	local gradientInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
	local tween = TweenService:Create(object, gradientInfo, { Offset = Vector2.new(1, 0) })
	tween:Play()
end

function resizeCustomLoadingBar(sizeRatio, clipping, top)
	clipping.Size = UDim2.new(sizeRatio, clipping.Size.X.Offset, clipping.Size.Y.Scale, clipping.Size.Y.Offset)
	top.Size = UDim2.new((sizeRatio > 0 and 1 / sizeRatio) or 0, top.Size.X.Offset, top.Size.Y.Scale, top.Size.Y.Offset)
end

local function healthChanged(bar, humanoidSource: () -> Humanoid)
	return action(function()
		local connection = humanoidSource().HealthChanged:Connect(function(newHealth)
			resizeCustomLoadingBar((newHealth / maxHealth), bar.Frame, bar.Frame.ImageLabel)
		end)
		cleanup(connection)
	end)
end

local function stamChanged(bar, humanoidSource: () -> Humanoid)
	return action(function()
		local connection = humanoidSource():GetAttributeChangedSignal("Stamina"):Connect(function()
			local newStam = humanoidSource():GetAttribute "Stamina"
			resizeCustomLoadingBar((newStam / maxStam), bar.Frame, bar.Frame.ImageLabel)
		end)
		cleanup(connection)
	end)
end

return function(props: {
	humanoidSource: () -> Humanoid,
})
	local health = create "ImageLabel" { --health
		Image = "rbxassetid://136391077137942",
		Size = UDim2.fromScale(486 / 770, 22 / 278),
		Position = UDim2.fromScale(263 / 770, 164 / 278),
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		ZIndex = 3,
		create "Frame" {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			create "ImageLabel" {
				Image = "rbxassetid://136391077137942",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			},
		},
	}
	local stam = create "ImageLabel" { --stam
		Image = "rbxassetid://134111671069282",
		Size = UDim2.fromScale(506 / 770, 17 / 278),
		Position = UDim2.fromScale(223.5 / 770, 213 / 278),
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		ZIndex = 3,
		create "Frame" {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			create "ImageLabel" {
				Image = "rbxassetid://134111671069282",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			},
		},
	}
	local streaks = create "ImageLabel" { --streaks
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

		create "Frame" {
			Size = UDim2.fromScale(770 / 1920, 278 / 1080),
			Position = UDim2.fromScale(35 / 1920, 47 / 1080),
			BackgroundTransparency = 1,
			create "UIAspectRatioConstraint" {
				AspectRatio = 770 / 278,
			},
			create "ImageLabel" { -- diamond
				Image = "rbxassetid://98768423323270",
				Size = UDim2.fromScale(206 / 770, 206 / 278),
				Position = UDim2.fromScale(46 / 770, 72 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
			},

			create "ImageLabel" { --healthbar
				Image = "rbxassetid://90501692272226",
				Size = UDim2.fromScale(510 / 770, 33.5 / 278),
				Position = UDim2.fromScale(250 / 770, 158 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
			},
			create "ImageLabel" { --border
				Image = "rbxassetid://95850929541402",
				Size = UDim2.fromScale(510 / 770, 33.5 / 278),
				Position = UDim2.fromScale(250 / 770, 158 / 278),
				BackgroundTransparency = 1,
				ZIndex = 4,
			},
			create "ImageLabel" { --stambar
				Image = "rbxassetid://107570538318662",
				Size = UDim2.fromScale(532 / 770, 29 / 278),
				Position = UDim2.fromScale(209 / 770, 207 / 278),
				BackgroundTransparency = 1,
				ZIndex = 2,
				create "ImageLabel" { --border
					Image = "rbxassetid://107595386067967",
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					BackgroundTransparency = 1,
					ZIndex = 4,
				},
			},
			streaks,
			health,
			stam,
			healthChanged(health, props.humanoidSource),
			stamChanged(stam, props.humanoidSource),
		},
	}
end
