local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local PointingEvent = game:GetService("ReplicatedStorage").PointTo

local MAX_MOUSE_DISTANCE = 1000
local MAX_LASER_DISTANCE = 500

local function getWorldMousePosition()
	local mouseLocation = UserInputService:GetMouseLocation()

	-- Create a ray from the 2D mouseLocation
	local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

	-- The unit direction vector of the ray multiplied by a maximum distance
	local directionVector = screenToWorldRay.Direction * MAX_MOUSE_DISTANCE

	-- Raycast from the ray's origin towards its direction
	local raycastResult = workspace:Raycast(screenToWorldRay.Origin, directionVector)

	if raycastResult then
		-- Return the 3D point of intersection directly
		return raycastResult.Position
	else
		-- No object was hit so calculate the position at the end of the ray
		return screenToWorldRay.Origin + directionVector
	end
end

local function checkForHit()
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		local mouseLocation = getWorldMousePosition()

		-- Calculate a normalised direction vector and multiply by laser distance
		local targetDirection = mouseLocation - workspace.CurrentCamera.Focus.Position  -- Use subtraction directly
		local directionVector = targetDirection.Unit * MAX_LASER_DISTANCE  -- Access Unit after subtraction

		-- Ignore the player's character to prevent them from damaging themselves
		local weaponRaycastParams = RaycastParams.new()
		weaponRaycastParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
		local weaponRaycastResult = workspace:Raycast(workspace.CurrentCamera.Focus.Position, directionVector, weaponRaycastParams)

		-- Determine the hit position
		local hitPosition
		if weaponRaycastResult then
			-- Access the hit position directly from raycastResult
			hitPosition = weaponRaycastResult.Position

			-- Check if a character was hit
			local characterModel = weaponRaycastResult.Instance:FindFirstAncestorOfClass("Model")
			if characterModel then
				local humanoid = characterModel:FindFirstChild("Humanoid")
				if humanoid and humanoid ~= Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
					-- Hit a different player's character (not self)
					print("Player Hit!")
					PointingEvent:FireServer(humanoid)
				end
			end
		end
	end
end

-- Continuously check for mouse clicks
UserInputService.InputBegan:Connect(checkForHit)
