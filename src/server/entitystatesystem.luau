--[=[
	@module EntityStateSystem
	Manages any entity (NPC or player) that is capable
	of administering or receiving damage or status effects.
]=]

local RunService = game:GetService "RunService"

local ESS = {}

--[=[
	A team that an entity belongs to. Damage or
	status effects should assert that the receiving
	entity belongs to a separate team before applying
	negative effects. Or, should assert that the entity
	belongs to the same team before applying positive
	effects. Entities may be in multiple teams.
]=]
export type Team = number
ESS.Teams = {
	NEUTRAL = 0,
}

--[=[
	An effect applied to an entity. The effect
	has a startup function called once, and
	an update function called per frame.

	The startup function is given a destruction hook
	to be called to remove the effect upon completion.
	Both startup and update functions may return a number
	to inflict damage to the entity.
]=]
export type Effect = {
	owner: Team,
	startup: (Entity, () -> ()) -> number?,
	update: (number) -> number?,
}

--[=[
	@class PropertyStream
	A collection of transformations done on an entity Humanoid's
	properties or attributes. Asserts that humanoid properties are
	correct upon applying or removing effects that alter the humanoid.
]=]
ESS.PropertyStream = {}
ESS.PropertyStream.__index = ESS.PropertyStream
type PropertyStreamData<T> = {
	humanoid: Humanoid,
	property_name: string,
	base_value: T,
	_transforms: {
		[string]: (T) -> T,
	},
}
export type PropertyStream<T> = typeof(setmetatable({} :: PropertyStreamData<T>, ESS.PropertyStream))

--[=[
	Creates a new property stream to track a Humanoid property.

	@param humanoid -- The humanoid this property stream is tracking.
	@param name -- The name of the property/attribute the property stream is tracking.
	@return PropertyStream<T> -- The new property stream.
	@error Nonexistent Property -- The property to track does not exist.
]=]
function ESS.PropertyStream.CreatePropertyStream<T>(humanoid: Humanoid, name: string): PropertyStream<T>
	if not humanoid[name] and not humanoid:GetAttribute(name) then
		error(`Nonexistent Property: Property/Attribute {name} does not exist.`)
	end

	local self = {}
	setmetatable(self, ESS.PropertyStream)

	self.humanoid = humanoid
	self.property_name = name
	self._base_value = if humanoid[name] then humanoid[name] else humanoid:GetAttribute(name)
	self._transforms = {}

	return self
end

--[=[
	Adds a new transform function to the property stream.
	
	@param transform -- The transform function to add.
	@return A unique identifier to access the transform with.
]=]
function ESS.PropertyStream.AddTransform<T>(self: PropertyStream<T>, transform: (T) -> T): string
	local idx = 1
	for i, t in self._transforms do
		if tonumber(i) >= idx then
			idx = tonumber(i) + 1
		end
	end
	self._transforms[tostring(idx)] = transform
	self:RenderTransforms()
	return tostring(idx)
end

--[=[
	Removes a transform function from the property stream.
	
	@param identifier -- The unique identifier of the transform function.
	@error Nonexistent Transform -- The given identifier is not associated with any transform function.
]=]
function ESS.PropertyStream.RemoveTransform<T>(self: PropertyStream<T>, identifier: string)
	if self._transforms[identifier] then
		self._transforms[identifier] = nil
	else
		error(`Nonexistent Transform: No transform function is associated with {identifier}.`)
	end
	self:RenderTransforms()
end

--[=[
	Renders all of the current transform functions and sets
	the humanoid's property/attribute to the result.
]=]
function ESS.PropertyStream.RenderTransforms<T>(self: PropertyStream<T>)
	local result = self._base_value
	for _, transform in self._transforms do
		result = transform(result)
	end
	if self.humanoid[self.property_name] then
		self.humanoid[self.property_name] = result
	else
		self.humanoid:SetAttribute(self.property_name, result)
	end
end

--[=[
	@class Entity
	An entity capable of administering or receiving
	damage or status effects.
]=]
ESS.Entity = {}
ESS.Entity.__index = ESS.Entity
type EntityData = {
	_humanoid: Humanoid,
	_teams: { Team },
	_effects: { Effect },
	_property_streams: { PropertyStream<unknown> },
	_connections: { RBXScriptConnection },
}
export type Entity = typeof(setmetatable({} :: EntityData, ESS.Entity))

-- keep track of all entities
local entity_dict: { [Humanoid]: Entity } = {}

--[=[
	@return Entity? -- The entity registered to the humanoid, if any.
]=]
function ESS.Entity.GetEntity(humanoid: Humanoid): Entity?
	return entity_dict[humanoid]
end

--[=[
	Links a humanoid with a new entity.

	@param humanoid -- The humanoid to register with.
	@error Double Allocation -- The given humanoid is already registered with an entity.
]=]
function ESS.Entity.RegisterEntity(humanoid: Humanoid): Entity
	if entity_dict[humanoid] then
		error(`Double Allocation: {humanoid} is already registered with an entity.`)
	end
	local self = {}
	setmetatable(self, ESS.Entity)

	self._humanoid = humanoid
	self._teams = { ESS.Teams.NEUTRAL }
	self._effects = {}
	self._property_streams = {}
	self._connections = {}

	table.insert(
		self._connections,
		RunService.Heartbeat:Connect(function(dt: number)
			local total_damage = 0
			for _, effect in self._effects do
				local delta: number? = effect.update(dt)
				if delta then
					total_damage += delta
				end
			end
			self._humanoid:TakeDamage(total_damage)
		end)
	)

	return self
end

--[=[
	Destroys the entity linked to a humanoid.
	
	@param entity -- The entity to destroy.
]=]
function ESS.Entity.DeregisterEntity(entity: Entity)
	for _, connection in entity._connections do
		connection:Disconnect()
	end
	for _, team in entity._teams do
		entity:LeaveTeam(team)
	end
	entity_dict[entity._humanoid] = nil
end

--[=[
	@return The teams the entity is in.
]=]
function ESS.Entity.GetTeams(self: Entity): { Team }
	return table.clone(self._teams)
end

--[=[
	Checks whether or not the entity is within a team.

	@param team -- The team to check.
	@return boolean -- Whether the entity is in a team.
]=]
function ESS.Entity.IsInTeam(self: Entity, team: Team): boolean
	for _, t in self._teams do
		if t == team then
			return true
		end
	end
	return false
end

--[=[
	Checks whether or not the entity shares a team with
	another entity.

	@param other -- The other entity to check.
	@return boolean -- Whether the two entities share a team.
]=]
function ESS.Entity.SharesTeam(self: Entity, other: Entity): boolean
	for _, team in self._teams do
		if other:IsInTeam(team) then
			return true
		end
	end
	return false
end

--[=[
	Joins the entity to a team.

	@param team -- The team to join.
	@error Double Allocation -- The entity is already part of this team.
	@error Nonexistent Team -- The team to join is not registered with ESS.
]=]
function ESS.Entity.JoinTeam(self: Entity, team: Team)
	if self:IsInTeam(team) then
		error "Double Allocation: This entity is already in this team."
	end
	for _, t in ESS.Teams do
		if t == team then
			table.insert(self._teams, team)
			return
		end
	end
	error "Nonexistent Team: This team does not exist."
end

--[=[
	Removes the entity from a team.

	@param team -- The team to leave.
	@error Double Free -- The entity is not part of this team.
]=]
function ESS.Entity.LeaveTeam(self: Entity, team: Team)
	if not self:IsInTeam(team) then
		error "Double Free: This entity is not in this team."
	end
	table.remove(self._teams, table.find(self._teams, team))
end

--[=[
	Fetches the property stream tracking this entity's humanoid
	property/attribute, or creates one if nonexistent.

	@param name -- The name of the property/attribute to fetch.
	@return The corresponding property stream.
	@error Nonexistent Property: The given property does not exist.
	@todo Property Streams default to number properties, but should
	be able to assume any type.
]=]
function ESS.Entity.GetPropertyStream(self: Entity, name: string): PropertyStream<number>
	if not self._humanoid[name] and not self._humanoid:GetAttribute(name) then
		error(`Nonexistent Property: This entity's humanoid does not have entity/property {name}.`)
	end
	for _, stream in self._property_streams do
		if stream.property_name == name then
			return stream
		end
	end

	local stream: PropertyStream<number> = ESS.PropertyStream.CreatePropertyStream(self._humanoid, name)
	return stream
end

function ESS.Entity.ApplyEffect(self: Entity, effect: Effect)
	self._effects[tostring(effect)] = effect
	local damage: number? = effect.startup(self, function()
		self._effects[tostring(effect)] = nil
	end)
	if damage then
		self._humanoid:TakeDamage(damage)
	end
end

--[=[
	Registers a new team into ESS.
	@param team_name -- The name of the new team.
	@error Double Allocation -- The given name is not unique (already registered).
]=]
function ESS.RegisterTeam(team_name: string)
	local index: Team = 0
	for team, i in ESS.Teams do
		if team == team_name then
			error(`Double Allocation: {team_name} is already in use.`)
		end
		if index <= i then
			index = i + 1
		end
	end
	ESS.Teams[team_name] = index
end

--[=[
	Deregisters a team from ESS. Any entity within this team
	will also be removed from the team.
	@param team -- The team to deregister.
	@error Neutral Team Deregistration -- Do not attempt to deregister the default neutral team.
]=]
function ESS.DeregisterTeam(team: Team)
	if team == ESS.Teams.NEUTRAL then
		error "Neutral Team Deregistration: Do not deregister the default neutral team."
	end
	for _, entity in entity_dict do
		if entity:IsInTeam(team) then
			entity:LeaveTeam(team)
		end
	end
	for name, t in ESS.Teams do
		if team == t then
			ESS.Teams[name] = nil
		end
	end
end

return ESS
