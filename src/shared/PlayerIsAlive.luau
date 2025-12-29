return function(player: Player): boolean
	return player.Character
		and player.Character.Parent ~= nil
		and player.Character:FindFirstChild "Humanoid"
		and player.Character.Humanoid.Health > 0
end
