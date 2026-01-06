local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide = require(ReplicatedStorage.Packages.vide)
local RunService = game:GetService "RunService"
local match = require(ReplicatedStorage.Config.match)
local create = vide.create
local derive = vide.derive
local action = vide.action
local cleanup = vide.cleanup
local source = vide.source

local countdown = function(time_source)
	return action(function()
		local timer = 0
		local cn
		cn = RunService.Heartbeat:Connect(function(delta)
			timer += delta
			if timer >= 1 then
				timer -= 1
				time_source(time_source() - 1)
				if time_source() == 0 then
					cn:Disconnect()
				end
			end
		end)
		cleanup(cn)
	end)
end

local function Intermission()
	local intermissionTime = source(match.IntermissionTime)
	local IntermissionText = derive(function()
		local time_left = intermissionTime()
		if time_left > 0 then
			return `Time until match starts: {time_left}`
		end
		return "Match starting..."
	end)

	return create "TextLabel" {
		Text = IntermissionText,
		BackgroundTransparency = 0.5,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextScaled = true,
		Position = UDim2.fromScale(0.5, 0.05),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromScale(0.3, 0.1),
		countdown(intermissionTime),
	}
end

return Intermission
