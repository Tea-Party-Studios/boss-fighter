--[=[
    Default sword weapon.
]=]

local ServerScriptService = game:GetService "ServerScriptService"
local ServerStorage = game:GetService "ServerStorage"

local Abilities = require(script.Parent)
local ESS = require(ServerScriptService.Server.entitystatesystem)
local Zap = require(ServerScriptService.Server.zap)

local sword_model: Tool = ServerStorage.Abilities.DefaultSword.ClassicSword

local DefaultSword = {}
DefaultSword.__index = DefaultSword
DefaultSword.SWING_COOLDOWN = 0.5 -- seconds
setmetatable(DefaultSword, Abilities)

type DefaultSwordData = {
	tool: Tool,
	handle: Part,
	player: Player,
	character: Model,
	humanoid: Humanoid,
	last_swung: number,
	zap_connections: { () -> () },
}
export type DefaultSword = typeof(setmetatable({} :: DefaultSwordData, DefaultSword))

--[=[
    Setup function for DefaultSword
    Gives the sword to the player.

    @param player -- The player the sword is given to.
    @error No Character -- The player does not have an existing character.
]=]
function DefaultSword.Setup(player: Player): DefaultSword
	local character = player.Character
	assert(character, `No Character: {player.Name} does not have a character.`)
	local model = sword_model:Clone()
	model.Parent = player.Backpack
	local handle: Part = model.Handle
	handle.Parent = character
	handle.Torso6D.Part1 = character:WaitForChild "Torso"
	handle.Torso6D.Enabled = true
	handle.RightArm6D.Part1 = character:WaitForChild "Right Arm"
	handle.RightArm6D.Enabled = false

	local client_handle: LocalScript = script.client_handle:Clone()

	local self = {}
	setmetatable(self, DefaultSword)

	self.tool = model
	self.handle = handle
	self.player = player
	self.character = character
	self.humanoid = character:FindFirstChildOfClass "Humanoid"
	self.last_swung = 0
	self.zap_connections = {}
	client_handle:WaitForChild("ToolReference").Value = self.tool
	client_handle:WaitForChild("Cooldown").Value = DefaultSword.SWING_COOLDOWN
	client_handle.Parent = self.handle

	table.insert(
		self.zap_connections,
		Zap.DefaultSwordHit.On(function(player: Player, hit: { Model })
			if player ~= self.player then
				return
			end
			self:ClientActivated(hit)
		end)
	)

	self.humanoid.Destroying:Connect(function()
		self:Destroy()
	end)
	return self
end

--[=[
    Destroy function for DefaultSword
    Removes the sword from the player.
]=]
function DefaultSword.Destroy(self: DefaultSword)
	if self.tool then
		self.tool:Destroy()
	end
	if self.handle then
		self.handle:Destroy()
	end
	for _, zap_connection in self.zap_connections do
		zap_connection()
	end
end

function DefaultSword.ClientActivated(self: DefaultSword, hit: { Model })
	local player_entity: ESS.Entity? = ESS.Entity.GetEntity(self.humanoid)
	assert(player_entity, "Player has no registered entity in ESS.")
	if os.clock() < self.last_swung + DefaultSword.SWING_COOLDOWN then
		return
	end
	self.last_swung = os.clock()
	for _, m in hit do
		local entity: ESS.Entity? = ESS.Entity.GetEntity(m:FindFirstChildOfClass "Humanoid")
		if
			not entity --[[or player_entity:SharesTeam(entity)]]
		then
			continue
		end
		entity:ApplyEffect {
			owner = ESS.Teams.Players,
			startup = function(e: ESS.Entity, hook: () -> ())
				hook()
				return 10
			end,
			update = function(...) end,
		}
	end
end

return DefaultSword
