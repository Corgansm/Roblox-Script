game.Players.PlayerAdded:Connect(function (player)
	player.CharacterAdded:Connect(function(character)
		local gui = Instance.new("BillboardGui")
		gui.Size = UDim2.new(1, 0, 1, 0)
		gui.StudsOffset = Vector3.new(0, 2, 0)
		gui.Parent = character.Head

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)

		label.BackgroundTransparency = 0
		label.Text = "0"
		label.Parent = gui
	end)
end)
