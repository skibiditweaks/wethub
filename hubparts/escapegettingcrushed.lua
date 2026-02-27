local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- UNIQUE NAME CHECK
local UniqueName = "WetHub_Escape_V3"
if PlayerGui:FindFirstChild(UniqueName) then
    PlayerGui[UniqueName]:Destroy()
end

-- State Management
local isClosing = false
local godmodeEnabled = false
local noclipConnection

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
hubTitle.Text = "WET HUB - ESCAPE GETTING CRUSHED"
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
    if noclipConnection then noclipConnection:Disconnect() end
    hubFrame:TweenSize(UDim2.new(0,0,0,0), "In", "Back", 0.5, true, function() 
        screenGui:Destroy() 
    end)
end)

-----------------------------------------------------------
-- CORE LOGIC (GODMODE + NOCLIP)
-----------------------------------------------------------
local function updateGodmode()
    -- Handle Map Parts (Touch Interest)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            if string.find(name, "kill") or string.find(name, "lava") or part.Material == Enum.Material.Neon then
                part.CanTouch = not godmodeEnabled
            end
        end
    end

    -- Handle Noclip (Character Collision)
    if godmodeEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local function smoothTP()
    local targetCFrame = CFrame.new(-3195.241455078125, 47.006614685058594, 4.265088081359863, -0.6651068329811096, -2.675486854286646e-08, -0.7467482089996338, -2.2908292152123977e-08, 1, -1.5424753030401916e-08, 0.7467482089996338, 6.847617139982276e-09, -0.6651068329811096)
    local character = LP.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local tween = TweenService:Create(character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = targetCFrame})
        tween:Play()
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

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 440, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = scrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

CreateButton("Enable", function(btn)
    godmodeEnabled = not godmodeEnabled
    updateGodmode()
    btn.Text = godmodeEnabled and "Disable" or "Enable"
end)

CreateButton("TP to good part", function()
    smoothTP()
end)

-- Entrance Animation
hubFrame:TweenSizeAndPosition(UDim2.new(0, 500, 0, 200), UDim2.new(0.5, -250, 0.4, -100), "Out", "Back", 0.6, true)
