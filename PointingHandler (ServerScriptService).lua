local PointingEvent = game.ReplicatedStorage:WaitForChild("PointTo")

local playerPointCount = {}

game.Players.PlayerAdded:Connect(function(player)
	playerPointCount[player] = 0
	print("Player Added")
end)

PointingEvent.OnServerEvent:Connect(function(otherplayer)
	print("Pointing Event Fired")
	task.wait(0.1) -- Small delay to allow character loading
	local otherCharacter = otherplayer.Character
	if not otherCharacter then
		return
	end

	
	playerPointCount[otherplayer]+=1
	
	local otherGui = otherCharacter.Head:FindFirstChild("BillboardGui")
	otherGui.TextLabel.Text = playerPointCount[otherplayer]
	
end)
