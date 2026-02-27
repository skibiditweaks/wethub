local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local holdingRightClick = false
local lockConnection = nil

-- SETTINGS
local MAX_DISTANCE = 1000 -- max distance to search
local SMOOTHNESS = 0.60 -- lower = smoother

-- Get closest player torso to center of screen
local function getClosestTarget()
	local closestTarget = nil
	local shortestDistance = math.huge
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
			local torso = otherPlayer.Character:FindFirstChild("HumanoidRootPart") 
				or otherPlayer.Character:FindFirstChild("UpperTorso") 
				or otherPlayer.Character:FindFirstChild("Torso")
			
			if humanoid and torso and humanoid.Health > 0 then
				local screenPoint, onScreen = camera:WorldToViewportPoint(torso.Position)
				
				if onScreen then
					local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
					local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
					
					local worldDistance = (camera.CFrame.Position - torso.Position).Magnitude
					
					if worldDistance <= MAX_DISTANCE and distanceFromCenter < shortestDistance then
						shortestDistance = distanceFromCenter
						closestTarget = torso
					end
				end
			end
		end
	end
	
	return closestTarget
end

-- Start locking camera
local function startLock()
	lockConnection = RunService.RenderStepped:Connect(function()
		local target = getClosestTarget()
		
		if target then
			local currentCFrame = camera.CFrame
			local newCFrame = CFrame.new(currentCFrame.Position, target.Position)
			
			camera.CFrame = currentCFrame:Lerp(newCFrame, SMOOTHNESS)
		end
	end)
end

-- Stop locking camera
local function stopLock()
	if lockConnection then
		lockConnection:Disconnect()
		lockConnection = nil
	end
end

-- Input detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holdingRightClick = true
		startLock()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holdingRightClick = false
		stopLock()
	end
end)
