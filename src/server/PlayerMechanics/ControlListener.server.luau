local ServerScriptService = game:GetService "ServerScriptService"
local zap = require(ServerScriptService.Server.zap)

function onRoll(player)
	print(`Roll received from {player.Name}`)
	local character: Model? = player.Character
	local humanoid: Humanoid? = if character then character:FindFirstChildOfClass "Humanoid" else nil
	assert(humanoid, `{player.Name} sent roll with no character.`)
	local stamina: number = humanoid:GetAttribute "Stamina"
	assert(stamina >= 20, `{player.Name} rolling with insufficient stamina.`)
	humanoid:SetAttribute("Stamina", math.max(0, stamina - 20))
end

function onParry(player)
	print(`Parry received from {player.Name}`)
end

zap.PlayerRoll.SetCallback(onRoll)
zap.PlayerParry.SetCallback(onParry)
