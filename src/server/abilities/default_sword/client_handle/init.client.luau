local ReplicatedStorage = game:GetService "ReplicatedStorage"
local Players = game:GetService "Players"

local Zap = require(ReplicatedStorage.Shared.zap)

local player = Players.LocalPlayer
local handle: Part = script.Parent
local tool: Tool? = script:WaitForChild("ToolReference").Value
assert(handle and tool)

function onEquipped()
	handle.RightArm6D.Enabled = true
	handle.Torso6D.Enabled = false
end

function onUnequipped()
	handle.Torso6D.Enabled = true
	handle.RightArm6D.Enabled = false
end

function onActivated()
	local hit = {}
	for _, m in workspace:GetChildren() do
		if m:IsA "Model" and m:FindFirstChildOfClass "Humanoid" and m ~= player.Character then
			table.insert(hit, m)
		end
	end
	Zap.DefaultSwordHit.Fire(hit)
end

tool.Equipped:Connect(onEquipped)
tool.Unequipped:Connect(onUnequipped)
tool.Activated:Connect(onActivated)
