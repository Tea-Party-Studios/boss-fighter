--[=[
    Heal ability.
]=]

local ServerScriptService = game:GetService "ServerScriptService"
local ServerStorage = game:GetService "ServerStorage"
local TweenService = game:GetService "TweenService"

local Abilities = require(script.Parent)
local ESS = require(ServerScriptService.Server.entitystatesystem)
local Zap = require(ServerScriptService.Server.zap)

local heal_tool: Tool = ServerStorage.Abilities.Heal.Heal

local Heal = {}
Heal.__index = Heal
Heal.STAMINA_DRAIN = 5 -- per second
Heal.HEAL_AMOUNT = 10
Heal.HEAL_DELAY = 2 -- 1 heal per _ seconds
setmetatable(Heal, Abilities)

type HealData = {
	tool: Tool,
	player: Player,
	character: Model,
	humanoid: Humanoid,
	end_hook: () -> ()?,
	zap_connections: { () -> () },
	beams: { Beam },
}
export type Heal = typeof(setmetatable({} :: HealData, Heal))

--[=[
    Setup function for Heal
    Gives the ability to the player.

    @param player -- The player the sword is given to.
    @error No Character -- The player does not have an existing character.
]=]
function Heal.Setup(player: Player): Heal
	local character = player.Character
	assert(character, `No Character: {player.Name} does not have a character.`)
	local tool: Tool = heal_tool:Clone()
	local client_handle = script.client_handle:Clone()
	client_handle.Parent = tool
	tool.Parent = player.Backpack

	local self = {}
	setmetatable(self, Heal)

	self.tool = tool
	self.player = player
	self.character = character
	self.humanoid = character:FindFirstChildOfClass "Humanoid"
	self.end_hook = nil
	self.zap_connections = {}
	self.beams = {}

	table.insert(
		self.zap_connections,
		Zap.HealTarget.On(function(player: Player, target: Humanoid)
			if player ~= self.player then
				return
			end
			self:ClientActivated(target)
		end)
	)

	table.insert(
		self.zap_connections,
		Zap.StopHeal.On(function(player: Player)
			if player ~= self.player then
				return
			end
			self:ClientStopped()
		end)
	)

	return self
end

--[=[
    Destroy function for Heal
    Removes the ability from the player.
]=]
function Heal.Destroy(self: Heal)
	if self.tool then
		self.tool:Destroy()
	end
	for _, connection in self.zap_connections do
		connection()
	end
	self:ClientStopped()
end

function Heal.ClientActivated(self: Heal, target: Humanoid)
	local player_entity: ESS.Entity? = ESS.Entity.GetEntity(self.humanoid)
	local target_entity: ESS.Entity? = ESS.Entity.GetEntity(target)
	assert(target_entity and player_entity)
	assert(player_entity:SharesTeam(target_entity))

	local beamEffect: Beam = ServerStorage.Abilities.Heal.BeamEffect
	beamEffect.Attachment0 = self.character["Right Arm"].RightGripAttachment
	beamEffect.Attachment1 = target.Parent.Torso.BodyFrontAttachment

	local num_beams = 4

	local function tweenBeam(beam: Beam)
		local c0 = math.random(-5, 5)
		local c1 = math.random(-5, 5)

		local tween = TweenService:Create(beam, TweenInfo.new(1), {
			CurveSize0 = c0,
			CurveSize1 = c1,
		})
		tween.Completed:Connect(function()
			tweenBeam(beam)
		end)
		tween:Play()
	end

	for i = 1, num_beams do
		local beam: Beam = beamEffect:Clone()
		beam.Parent = self.character
		table.insert(self.beams, beam)
		tweenBeam(beam)
	end

	local elapsed_time = 0
	local num_heals = 0
	target_entity:ApplyEffect {
		owner = ESS.Teams.Players,
		startup = function(_, hook: () -> ())
			self.end_hook = hook
		end,
		update = function(dt: number)
			if target_entity._humanoid.Health >= target_entity._humanoid.MaxHealth then
				self.end_hook()
			end
			self.humanoid:SetAttribute(
				"Stamina",
				math.max(0, self.humanoid:GetAttribute "Stamina" - Heal.STAMINA_DRAIN * dt)
			)
			if self.humanoid:GetAttribute "Stamina" <= 0 then
				self.end_hook()
			end
			elapsed_time += dt
			if elapsed_time / Heal.HEAL_DELAY > num_heals + 1 then
				num_heals += 1
				return -Heal.HEAL_AMOUNT
			end
			return 0
		end,
	}
end

function Heal.ClientStopped(self: Heal)
	if self.end_hook then
		self.end_hook()
	end
	for _, beam in self.beams do
		beam:Destroy()
	end
	table.clear(self.beams)
end

function onGetTeammates(player: Player): { Humanoid }?
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	assert(humanoid)
	local player_entity: ESS.Entity? = ESS.Entity.GetEntity(humanoid)
	assert(player_entity)
	local result = {}
	for _, entity in ESS.Entity.GetEntities() do
		if player_entity:SharesTeam(entity) then
			table.insert(result, entity._humanoid)
		end
	end
	return result
end

Zap.GetTeammates.SetCallback(onGetTeammates)

return Heal
