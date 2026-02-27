local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- UNIQUE NAME CHECK
local UniqueName = "WetHub_AdoptMe_V3"
if PlayerGui:FindFirstChild(UniqueName) then
    PlayerGui[UniqueName]:Destroy()
end

-- State Management
local isClosing = false
local flyRideEnabled = false
local loopThread

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = UniqueName
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Main Hub Frame
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 0, 0, 0)
hubFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
hubFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
hubFrame.BorderSizePixel = 0
hubFrame.Active = true
hubFrame.Draggable = true 
hubFrame.ClipsDescendants = true
hubFrame.Parent = screenGui

Instance.new("UICorner", hubFrame).CornerRadius = UDim.new(0, 15)

local hubGlow = Instance.new("UIStroke")
hubGlow.Thickness = 2.5
hubGlow.Color = Color3.fromRGB(255, 255, 255)
hubGlow.Transparency = 0.15
hubGlow.Parent = hubFrame

-----------------------------------------------------------
-- TITLE SECTION
-----------------------------------------------------------
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, -60, 0, 45) 
titleContainer.Position = UDim2.new(0, 15, 0, 10)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = hubFrame

local hubTitle = Instance.new("TextLabel")
hubTitle.Size = UDim2.new(1, 0, 1, 0)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "WET HUB - ADOPT ME"
hubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
hubTitle.TextSize = 16
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextXAlignment = Enum.TextXAlignment.Left
hubTitle.Parent = titleContainer

local waterGradient = Instance.new("UIGradient")
waterGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 230, 255)) 
})
waterGradient.Rotation = 90
waterGradient.Parent = hubTitle

-----------------------------------------------------------
-- CLOSE BUTTON
-----------------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = hubFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    isClosing = true
    flyRideEnabled = false -- Stop loop on close
    hubFrame:TweenSize(UDim2.new(0,0,0,0), "In", "Back", 0.5, true, function() 
        screenGui:Destroy() 
    end)
end)

-----------------------------------------------------------
-- ADOPT ME LOGIC
-----------------------------------------------------------
local function updateInventory(state)
    local success, err = pcall(function()
        local clientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
        local playerData = clientData.get_data()[tostring(game.Players.LocalPlayer)]
        if playerData and playerData.inventory and playerData.inventory.pets then
            for i, v in pairs(playerData.inventory.pets) do
                v.properties.rideable = state
                v.properties.flyable = state
            end
        end
    end)
    if not success then warn("Wet Hub Error: " .. err) end
end

local function toggleFlyRide(btn)
    flyRideEnabled = not flyRideEnabled
    
    if flyRideEnabled then
        btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        btn.Text = "MAKE FLY & RIDE: ON"
        
        -- Start Loop
        loopThread = task.spawn(function()
            while flyRideEnabled do
                updateInventory(true)
                task.wait(1)
            end
        end)
    else
        btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btn.Text = "MAKE FLY & RIDE: OFF"
        updateInventory(false)
    end
end

-----------------------------------------------------------
-- BUTTON LIST
-----------------------------------------------------------
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -70) 
scrollFrame.Position = UDim2.new(0, 0, 0, 65) 
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.Parent = hubFrame

local layout = Instance.new("UIListLayout", scrollFrame)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 12)

local function CreateToggleButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 440, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Default Red
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = scrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

CreateToggleButton("MAKE FLY & RIDE: OFF", function(btn)
    toggleFlyRide(btn)
end)

-- Entrance Animation
hubFrame:TweenSizeAndPosition(UDim2.new(0, 500, 0, 150), UDim2.new(0.5, -250, 0.4, -75), "Out", "Back", 0.6, true)
