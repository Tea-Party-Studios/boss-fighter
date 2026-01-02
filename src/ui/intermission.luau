local ReplicatedStorage = game:GetService "ReplicatedStorage"
local RunService = game:GetService "RunService"
local vide = require(ReplicatedStorage.Packages.vide)
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local create = vide.create
local derive = vide.derive
local action = vide.action
local cleanup = vide.cleanup

local countdown = function(seconds: number)
	--vide_sources.IntermissionTime(seconds)
	return action(function()
		local timer = 0
		local cn
		cn = RunService.Heartbeat:Connect(function(delta)
			timer += delta
			if timer >= 1 then
				timer -= 1
				vide_sources.IntermissionTime(vide_sources.IntermissionTime() - 1)
				if vide_sources.IntermissionTime() == 0 then
					cn:Disconnect()
				end
			end
		end)
		cleanup(cn)
	end)
end

local function Button()
	vide_sources.IntermissionTime(10)
	local IntermissionText = derive(function()
		local time_left = vide_sources.IntermissionTime()
		if time_left > 0 then
			return `Time until match starts: {time_left}`
		end
		return "Match starting..."
	end)
	local intermissionDisplay = create "TextLabel" {
		BackgroundTransparency = 0.5,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextScaled = true,
		Position = UDim2.fromScale(0.5, 0.05),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromScale(0.3, 0.1),
		Text = IntermissionText,
		create "UICorner" {
			CornerRadius = UDim.new(0.3, 0),
		},
		countdown(10),
	}

	return intermissionDisplay
end

return Button
