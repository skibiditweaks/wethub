local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WetHub_Wide"
screenGui.Parent = LP:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Hub Frame (WIDER VERSION)
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 450, 0, 320) -- Width increased to 450
hubFrame.Position = UDim2.new(0.5, -225, 0.4, -160)
hubFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
hubFrame.BorderSizePixel = 0
hubFrame.Active = true
hubFrame.Draggable = true 
hubFrame.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 15)
hubCorner.Parent = hubFrame

local hubGlow = Instance.new("UIStroke")
hubGlow.Thickness = 2.5
hubGlow.Color = Color3.fromRGB(255, 255, 255)
hubGlow.Transparency = 0.15
hubGlow.Parent = hubFrame

-- Topbar Title
local topBar = Instance.new("TextLabel")
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.BackgroundTransparency = 1
topBar.Text = "WET HUB - STEAL A BRAINROT"
topBar.TextColor3 = Color3.fromRGB(255, 255, 255)
topBar.TextSize = 22
topBar.Font = Enum.Font.GothamBold
topBar.Parent = hubFrame

--- Layout Helper ---
local layout = Instance.new("UIListLayout")
layout.Parent = hubFrame
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)

-- Padding for the topbar
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.Parent = hubFrame

-----------------------
-- SECTION: STEALING --
-----------------------
local stealTitle = Instance.new("TextLabel")
stealTitle.Size = UDim2.new(0.9, 0, 0, 30)
stealTitle.BackgroundTransparency = 1
stealTitle.Text = "STEALING FEATURES"
stealTitle.TextColor3 = Color3.fromRGB(160, 160, 160)
stealTitle.TextSize = 13
stealTitle.Font = Enum.Font.GothamBold
stealTitle.LayoutOrder = 1
stealTitle.Parent = hubFrame

local instaBtn = Instance.new("TextButton")
instaBtn.Size = UDim2.new(0, 380, 0, 45) -- Wider Buttons
instaBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
instaBtn.Text = "Insta-Steal"
instaBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
instaBtn.Font = Enum.Font.GothamBold
instaBtn.TextSize = 15
instaBtn.LayoutOrder = 2
instaBtn.Parent = hubFrame

Instance.new("UICorner", instaBtn).CornerRadius = UDim.new(0, 10)

---------------------
-- SECTION: SAFETY --
---------------------
local safetyTitle = Instance.new("TextLabel")
safetyTitle.Size = UDim2.new(0.9, 0, 0, 30)
safetyTitle.BackgroundTransparency = 1
safetyTitle.Text = "SAFETY"
safetyTitle.TextColor3 = Color3.fromRGB(160, 160, 160)
safetyTitle.TextSize = 13
safetyTitle.Font = Enum.Font.GothamBold
safetyTitle.LayoutOrder = 3
safetyTitle.Parent = hubFrame

local afkBtn = Instance.new("TextButton")
afkBtn.Size = UDim2.new(0, 380, 0, 45) -- Wider Buttons
afkBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
afkBtn.Text = "AFK Protector"
afkBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
afkBtn.Font = Enum.Font.GothamBold
afkBtn.TextSize = 15
afkBtn.LayoutOrder = 4
afkBtn.Parent = hubFrame

Instance.new("UICorner", afkBtn).CornerRadius = UDim.new(0, 10)

-------------------------
-- FUNCTIONALITY LOGIC --
-------------------------

local function LoadBaseProtector()
    -- This spawns the smaller, rounded protector UI you liked
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 230, 0, 190)
    mainFrame.Position = UDim2.new(0.5, -115, 0.4, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true 
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame

    local glowStroke = Instance.new("UIStroke")
    glowStroke.Thickness = 3
    glowStroke.Color = Color3.fromRGB(255, 255, 255)
    glowStroke.Transparency = 0.1
    glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glowStroke.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "WET BASE PROTECTOR"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 190, 0, 45)
    toggleBtn.Position = UDim2.new(0.5, -95, 0, 60)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "LEAVE: OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = mainFrame

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

    local counterLabel = Instance.new("TextLabel")
    counterLabel.Size = UDim2.new(1, 0, 0, 40)
    counterLabel.Position = UDim2.new(0, 0, 0, 125)
    counterLabel.BackgroundTransparency = 1
    counterLabel.Text = "Player Counter: " .. #Players:GetPlayers()
    counterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    counterLabel.Font = Enum.Font.GothamMedium
    counterLabel.TextSize = 13
    counterLabel.Parent = mainFrame

    local leaveEnabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        leaveEnabled = not leaveEnabled
        toggleBtn.Text = leaveEnabled and "LEAVE: ON" or "LEAVE: OFF"
        toggleBtn.BackgroundColor3 = leaveEnabled and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(220, 60, 60)
    end)

    task.spawn(function()
        while task.wait(1) do
            if not mainFrame or not mainFrame.Parent then break end
            local count = #Players:GetPlayers()
            counterLabel.Text = "Player Counter: " .. count
            if leaveEnabled and count > 1 then
                LP:Kick("WET BASE PROTECTOR: Somebody joined")
            end
        end
    end)
end

-- Button Triggers
instaBtn.MouseButton1Click:Connect(function()
    print("Insta-Steal Activated")
end)

afkBtn.MouseButton1Click:Connect(function()
    hubFrame:Destroy() -- Removes the wide Hub
    LoadBaseProtector() -- Spawns the protector UI
end)
