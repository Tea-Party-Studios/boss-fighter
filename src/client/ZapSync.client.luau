local ReplicatedStorage = game:GetService "ReplicatedStorage"
local vide_sources = require(ReplicatedStorage.Shared.vide_sources)
local zap = require(ReplicatedStorage.Shared.zap)

zap.PlayerSync.SetCallback(
	function(Value: { current_stats: { endurance: number, energy: number, strength: number }?, wins: number? })
		print(Value.wins)
		if Value.current_stats then
			vide_sources.Stats.enduranceCount(Value.current_stats.endurance)
			vide_sources.Stats.strengthCount(Value.current_stats.strength)
			vide_sources.Stats.energyCount(Value.current_stats.energy)
		end
	end
)

zap.InIntermission.SetCallback(function(InIntermission: boolean)
	vide_sources.InIntermission(InIntermission)
end)
