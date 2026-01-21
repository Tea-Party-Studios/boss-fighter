--[[
    Example script detailing how EntityStateSystem may be used.
]]
local ServerScriptService = game:GetService "ServerScriptService"
local Players = game:GetService "Players"

local ESS = require(ServerScriptService.Server.entitystatesystem)

local player: Player = if #Players:GetPlayers() > 0 then Players:GetPlayers()[1] else Players.PlayerAdded:Wait()
local character: Model = if player.Character then player.Character else player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild "Humanoid"

-- create an entity for the player
local player_entity: ESS.Entity = ESS.Entity.RegisterEntity(humanoid)
-- entities default to the NEUTRAL team.
-- entities typically do not hurt teammates, so it is wise to make a team for players and the boss
ESS.RegisterTeam "Players"
ESS.RegisterTeam "Boss"

player_entity:LeaveTeam(ESS.Teams.NEUTRAL)
player_entity:JoinTeam(ESS.Teams.Players)

-- the player may hit another entity. here is what the entity code may look like
for _, part in character:GetChildren() do
	if part:IsA "BasePart" then
		part.Touched:Connect(function(hit)
			local hit_model: Model? = hit:FindFirstAncestorOfClass "Model"
			local hit_humanoid: Humanoid? = if hit_model then hit_model:FindFirstChildOfClass "Humanoid" else nil
			if not hit_humanoid then
				return
			end

			-- fetch the entity of the hit humanoid
			local hit_entity: ESS.Entity? = ESS.Entity.GetEntity(hit_humanoid)
			if not hit_entity then
				return
			end

			-- before applying damage, should check to make sure they are not teammates!
			if player_entity:SharesTeam(hit_entity) then
				return
			end

			-- damage is done through a status effect that terminates immediately after startup
			hit_entity:ApplyEffect {
				owner = ESS.Teams.Players,
				startup = function(entity: ESS.Entity, destroy_hook: () -> ())
					destroy_hook() -- destroy immediately, so the update function never calls
					return 10 -- the startup and update function can  optionally return a number damage to inflict
				end,
				update = function(dt: number)
					-- this will never be called
				end,
			}
		end)
	end
end

-- outside of just straight damage, effects can do more
-- lets see a burn over time effect
-- for conciseness, the boilerplate code before ApplyEffect is omitted.

hit_entity:ApplyEffect {
	owner = ESS.Teams.Players,
	startup = function(entity: ESS.Entity, destroy_hook: () -> ())
		-- in 10 seconds, destroy the effect
		task.delay(10, destroy_hook)
	end,
	update = function(dt: number)
		-- deal 1 damage per second while effect is alive
		return 1 * dt
	end,
}

-- outside of damage, effects can safely alter humanoid properties/attributes
-- primarily this is stamina
-- let's make a walkspeed buff.

player_entity:ApplyEffect {
	owner = ESS.Teams.Players,
	startup = function(entity: ESS.Entity, destroy_hook: () -> ())
		-- streams manage all effects that transform humanoid properties
		-- they aid in confirming the safety and correctness of values even throughout
		-- effects being applied and removed
		local walkspeed_stream: ESS.PropertyStream<number> = entity:GetPropertyStream "WalkSpeed"
		-- add a transform to change the value
		-- transforms return a unique identifier to later access
		local identifier: string = walkspeed_stream:AddTransform(function(x: number)
			-- this transform function will double the entity's walkspeed
			return x * 2
		end)

		task.delay(10, function()
			-- before ending the effect, make sure to remove the transform
			walkspeed_stream:RemoveTransform(identifier)
			destroy_hook()
		end)
	end,
	update = function(dt: number)
		return 5 * dt -- take 5 damage per second for fun
	end,
}
