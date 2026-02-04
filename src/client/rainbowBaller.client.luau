local CollectionService = game:GetService "CollectionService"
local RunService = game:GetService "RunService"
local TweenService = game:GetService "TweenService"

local tweenInfo = TweenInfo.new(
	2, -- Time
	Enum.EasingStyle.Linear, -- EasingStyle
	Enum.EasingDirection.Out, -- EasingDirection
	-1, -- RepeatCount (when less than zero the tween will loop indefinitely)
	true, -- Reverses (tween will reverse once reaching its goal)
	0 -- DelayTime
)

local hue = 0

RunService.Heartbeat:Connect(function(dt: number)
	local parts = CollectionService:GetTagged "Rainbow"
	hue = (hue + dt * 0.2) % 1
	for _, p: BasePart in parts do
		p.Color = Color3.fromHSV(hue, 1, 1)
	end
end)
