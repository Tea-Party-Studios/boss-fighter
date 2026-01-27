local Players = game:GetService "Players"
local ReplicatedStorage = game:GetService "ReplicatedStorage"

local Zap = require(ReplicatedStorage.Shared.zap)

local player = Players.LocalPlayer
local tool: Tool? = script.Parent
local mouse: Mouse? = nil
local equipped_thread: thread? = nil
local target: Humanoid? = nil
local selection_uis: { BillboardGui } = {}
assert(tool and tool:IsA "Tool")

function onEquipped(m: Mouse)
	local character = player.Character
	if not character then
		return
	end
	mouse = m
	local teammates: { Humanoid } = Zap.GetTeammates.Call()
	local teammate_ui_map: { [Humanoid]: BillboardGui } = {}
	for _, teammate in teammates do
		local tcharacter: Model? = teammate.Parent
		local ttorso: Part? = if tcharacter then tcharacter:FindFirstChild "Torso" else nil
		if not ttorso or tcharacter == player.Character then
			continue
		end
		local ui = Instance.new "BillboardGui"
		ui.Adornee = ttorso
		ui.Size = UDim2.fromScale(2, 2)
		ui.AlwaysOnTop = true

		local image = Instance.new "ImageLabel"
		image.Size = UDim2.fromScale(1, 1)
		image.BackgroundTransparency = 1
		image.Image = "rbxassetid://1195495135"
		image.ImageColor3 = Color3.new(1, 1, 1)
		image.Visible = false

		image.Parent = ui
		ui.Parent = ttorso
		table.insert(selection_uis, ui)
		teammate_ui_map[teammate] = ui
	end
	equipped_thread = coroutine.create(function()
		while task.wait() do
			local closest = { teammate = nil, distance = math.huge }
			for _, teammate in teammates do
				if teammate.Parent == player.Character then
					continue
				end
				local distance = player:DistanceFromCharacter(teammate.Parent.PrimaryPart.Position)
				if distance <= 1000 then
					teammate_ui_map[teammate]:FindFirstChildOfClass("ImageLabel").Visible = true
					if distance < closest.distance then
						closest = { teammate = teammate, distance = distance }
					end
				else
					teammate_ui_map[teammate]:FindFirstChildOfClass("ImageLabel").Visible = false
				end
			end
			target = closest.teammate
			if target then
				teammate_ui_map[target]:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.new(0, 1, 0)
			end
		end
	end)
	coroutine.resume(equipped_thread)
	mouse.Button1Down:Connect(function()
		if target then
			Zap.HealTarget.Fire(target)
		end
	end)
	mouse.Button1Up:Connect(function()
		Zap.StopHeal.Fire()
	end)
end

function onUnequipped()
	mouse = nil
	if equipped_thread then
		coroutine.close(equipped_thread)
		equipped_thread = nil
	end
	for _, ui in selection_uis do
		ui:Destroy()
	end
	table.clear(selection_uis)
end

--[[
function onActivated()
	assert(mouse)
	if target then
		Zap.HealTarget.Fire(target)
	end
end
--]]

tool.Equipped:Connect(onEquipped)
tool.Unequipped:Connect(onUnequipped)
--tool.Activated:Connect(onActivated)
