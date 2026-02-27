local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- UNIQUE NAME CHECK
local UniqueName = "WetHub_V3_Exclusive"
if PlayerGui:FindFirstChild(UniqueName) then
    warn("Wet Hub is already running!")
    return 
end

local FilePath = "WetHub_Settings.json"

-- State Management
local isClosing = false
local creditsOpen = false
local settingsOpen = false
local rainbowEnabled = false
local rainbowConnection
local scriptButtons = {} 

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
-- CLOSE LOGIC FUNCTION
-----------------------------------------------------------
local function CloseMainUI()
    if isClosing then return end
    isClosing = true
    if rainbowConnection then rainbowConnection:Disconnect() end
    hubFrame:TweenSize(UDim2.new(0,0,0,0), "In", "Back", 0.5, true, function() 
        screenGui:Destroy() 
    end)
end

-----------------------------------------------------------
-- USER PROFILE SECTION
-----------------------------------------------------------
local profileContainer = Instance.new("Frame")
profileContainer.Size = UDim2.new(0, 180, 0, 45)
profileContainer.Position = UDim2.new(0, 15, 0, 10)
profileContainer.BackgroundTransparency = 1
profileContainer.Parent = hubFrame

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 40, 0, 40)
avatarImg.Position = UDim2.new(0, 0, 0.5, -20)
avatarImg.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatarImg.Parent = profileContainer
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -50, 1, 0)
welcomeLabel.Position = UDim2.new(0, 45, 0, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = LP.DisplayName or LP.Name
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.TextSize = 14
welcomeLabel.Font = Enum.Font.GothamMedium
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
welcomeLabel.Parent = profileContainer

-----------------------------------------------------------
-- TOPBAR BUTTONS
-----------------------------------------------------------
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 150, 0, 35)
btnContainer.Position = UDim2.new(1, -160, 0, 12)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = hubFrame

local btnLayout = Instance.new("UIListLayout")
btnLayout.Parent = btnContainer
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.Padding = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = btnContainer
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 35, 0, 35)
settingsBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
settingsBtn.Text = "⚙️"
settingsBtn.TextSize = 18
settingsBtn.Parent = btnContainer
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 8)

local creditsBtn = Instance.new("TextButton")
creditsBtn.Size = UDim2.new(0, 35, 0, 35)
creditsBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
creditsBtn.Text = "📜"
creditsBtn.TextSize = 18
creditsBtn.Parent = btnContainer
Instance.new("UICorner", creditsBtn).CornerRadius = UDim.new(0, 8)

-----------------------------------------------------------
-- SEARCH BAR SECTION
-----------------------------------------------------------
local searchBarFrame = Instance.new("Frame")
searchBarFrame.Size = UDim2.new(0, 340, 0, 35)
searchBarFrame.Position = UDim2.new(0, 15, 0, 65)
searchBarFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBarFrame.Parent = hubFrame
Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(0, 8)

local searchIcon = Instance.new("TextLabel")
searchIcon.Size = UDim2.new(0, 35, 1, 0)
searchIcon.Text = "🔍"
searchIcon.BackgroundTransparency = 1
searchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
searchIcon.TextSize = 14
searchIcon.Parent = searchBarFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -45, 1, 0)
searchBox.Position = UDim2.new(0, 35, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Search scripts in Wet Hub..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 14
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = searchBarFrame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 65, 0, 35)
clearBtn.Position = UDim2.new(0, 365, 0, 65)
clearBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.Visible = false
clearBtn.Parent = hubFrame
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 8)

-----------------------------------------------------------
-- POPUP FACTORY
-----------------------------------------------------------
local popupStrokes = {} 

local function CreatePopup(name, titleText)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.ClipsDescendants = true
    frame.Visible = false
    frame.ZIndex = 10
    frame.Parent = hubFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local s = Instance.new("UIStroke", frame)
    s.Color = Color3.fromRGB(255, 255, 255)
    s.Thickness = 2
    table.insert(popupStrokes, s)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 50)
    t.Text = titleText
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    t.TextSize = 20
    t.ZIndex = 11
    t.Parent = frame

    local c = Instance.new("TextButton")
    c.Size = UDim2.new(0, 30, 0, 30)
    c.Position = UDim2.new(1, -40, 0, 10)
    c.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    c.Text = "X"
    c.TextColor3 = Color3.fromRGB(255, 255, 255)
    c.Font = Enum.Font.GothamBold
    c.ZIndex = 15
    c.Parent = frame
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 5)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -60)
    content.Position = UDim2.new(0, 0, 0, 55)
    content.BackgroundTransparency = 1
    content.ZIndex = 11
    content.Parent = frame
    
    local list = Instance.new("UIListLayout", content)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Padding = UDim.new(0, 8)

    return frame, c, content
end

local creditsFrame, closeCreds, credContent = CreatePopup("CreditsFrame", "CREDITS")
local credLabel = Instance.new("TextLabel")
credLabel.Size = UDim2.new(0, 300, 0, 100)
credLabel.Text = "@ventanita_mango - Developer\n@simulators2134 - Script Ideas"
credLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
credLabel.Font = Enum.Font.GothamMedium
credLabel.BackgroundTransparency = 1
credLabel.TextSize = 16
credLabel.ZIndex = 12
credLabel.Parent = credContent

local settingsFrame, closeSett, settContent = CreatePopup("SettingsFrame", "SETTINGS")

-- Rainbow Toggle
local toggleContainer = Instance.new("Frame", settContent)
toggleContainer.Size = UDim2.new(0, 300, 0, 40)
toggleContainer.BackgroundTransparency = 1
toggleContainer.ZIndex = 12

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(0, 100, 1, 0)
toggleLabel.Text = "Rainbow UI"
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.Font = Enum.Font.GothamMedium
toggleLabel.TextSize = 14
toggleLabel.BackgroundTransparency = 1
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.ZIndex = 12
toggleLabel.Parent = toggleContainer

local toggleBG = Instance.new("TextButton")
toggleBG.Size = UDim2.new(0, 45, 0, 22)
toggleBG.Position = UDim2.new(1, -45, 0.5, -11)
toggleBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBG.Text = ""
toggleBG.ZIndex = 12
toggleBG.Parent = toggleContainer
Instance.new("UICorner", toggleBG).CornerRadius = UDim.new(1, 0)

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 18, 0, 18)
toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.ZIndex = 13
toggleCircle.Parent = toggleBG
Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

-- Server Info
local infoTitle = Instance.new("TextLabel", settContent)
infoTitle.Size = UDim2.new(0, 300, 0, 25)
infoTitle.Text = "SERVER INFO"
infoTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 13
infoTitle.BackgroundTransparency = 1
infoTitle.ZIndex = 12

local infoList = Instance.new("TextLabel", settContent)
infoList.Size = UDim2.new(0, 300, 0, 65)
infoList.Text = "PING: Loading...\nFPS: Loading...\nPLAYERS: 0"
infoList.TextColor3 = Color3.fromRGB(255, 255, 255)
infoList.Font = Enum.Font.GothamMedium
infoList.TextSize = 13
infoList.BackgroundTransparency = 1
infoList.LineHeight = 1.4
infoList.ZIndex = 12

local rejoinBtn = Instance.new("TextButton", settContent)
rejoinBtn.Size = UDim2.new(0, 120, 0, 30)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 13
rejoinBtn.ZIndex = 12
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", rejoinBtn).Color = Color3.fromRGB(60, 60, 60)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)

-----------------------------------------------------------
-- RAINBOW LOGIC
-----------------------------------------------------------
local function UpdateRainbow()
    if rainbowEnabled then
        if rainbowConnection then rainbowConnection:Disconnect() end
        rainbowConnection = RunService.RenderStepped:Connect(function()
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 0.8, 1)
            hubGlow.Color = color
            for _, stroke in pairs(popupStrokes) do
                stroke.Color = color
            end
        end)
    else
        if rainbowConnection then rainbowConnection:Disconnect() end
        hubGlow.Color = Color3.fromRGB(255, 255, 255)
        for _, stroke in pairs(popupStrokes) do
            stroke.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if settingsFrame.Visible then
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local playerCount = #Players:GetPlayers()
            infoList.Text = string.format("PING: %dms\nFPS: %d\nPLAYERS: %d", ping, fps, playerCount)
        end
    end
end)

toggleBG.MouseButton1Click:Connect(function()
    rainbowEnabled = not rainbowEnabled
    local goalPos = rainbowEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    local goalColor = rainbowEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(40, 40, 40)
    TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = goalPos}):Play()
    TweenService:Create(toggleBG, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
    UpdateRainbow()
    if writefile then pcall(function() writefile(FilePath, HttpService:JSONEncode({Rainbow = rainbowEnabled})) end) end
end)

-----------------------------------------------------------
-- SEARCH LOGIC
-----------------------------------------------------------
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = searchBox.Text:lower()
    clearBtn.Visible = (text ~= "")
    for _, item in pairs(scriptButtons) do
        item.Button.Visible = item.Name:find(text) ~= nil
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    searchBox.Text = ""
end)

-----------------------------------------------------------
-- UI CONTROLS
-----------------------------------------------------------
local blockOverlay = Instance.new("Frame")
blockOverlay.Size = UDim2.new(1, 0, 1, 0)
blockOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blockOverlay.BackgroundTransparency = 1
blockOverlay.Visible = false
blockOverlay.ZIndex = 8
blockOverlay.Parent = hubFrame

local function ManagePopup(frame, open)
    if isClosing then return end
    if open then
        blockOverlay.Visible = true
        creditsOpen = (frame == creditsFrame)
        settingsOpen = (frame == settingsFrame)
        TweenService:Create(blockOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        frame.Visible = true
        frame:TweenSizeAndPosition(UDim2.new(0, 350, 0, 320), UDim2.new(0.5, -175, 0.5, -160), "Out", "Back", 0.4, true)
    else
        creditsOpen, settingsOpen = false, false
        TweenService:Create(blockOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        frame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "In", "Back", 0.3, true, function()
            frame.Visible = false
            blockOverlay.Visible = false
        end)
    end
end

creditsBtn.MouseButton1Click:Connect(function() if not creditsOpen and not settingsOpen then ManagePopup(creditsFrame, true) end end)
settingsBtn.MouseButton1Click:Connect(function() if not settingsOpen and not creditsOpen then ManagePopup(settingsFrame, true) end end)

closeCreds.MouseButton1Click:Connect(function() ManagePopup(creditsFrame, false) end)
closeSett.MouseButton1Click:Connect(function() ManagePopup(settingsFrame, false) end)

closeBtn.MouseButton1Click:Connect(function() 
    if not creditsOpen and not settingsOpen then
        CloseMainUI()
    end
end)

-----------------------------------------------------------
-- MAIN SCRIPT BUTTONS
-----------------------------------------------------------
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -120) 
scrollFrame.Position = UDim2.new(0, 0, 0, 110) 
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.Parent = hubFrame
local layout = Instance.new("UIListLayout", scrollFrame)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 12)

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 420, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.Parent = scrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function() 
        if not isClosing and not creditsOpen and not settingsOpen then 
            callback() 
            CloseMainUI() -- AUTO CLOSE WHEN SCRIPT IS RUN
        end 
    end)
    
    table.insert(scriptButtons, {Button = btn, Name = text:lower()})
end

CreateButton("Steal A Brainrot", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditweaks/wethub/refs/heads/main/hubparts/sab.lua"))()
end)

CreateButton("Bridge For Brainrots", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditweaks/wethub/refs/heads/main/hubparts/bridgefor.lua"))()
end)

CreateButton("Aimbot (hold right click)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditweaks/wethub/refs/heads/main/hubparts/cameralock.lua"))()
end)

CreateButton("Escape Getting Crushed For Brainrots", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditweaks/wethub/refs/heads/main/hubparts/escapegettingcrushed.lua"))()
end)

CreateButton("BrookHaven (NOT MINE, MIGHT NOT WORK)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Cat558-uz/All-rights-reserved-to-packj0/main/hub%20Brook"))()
end)

CreateButton("Adopt Me (Fly & Ride Pets)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditweaks/wethub/refs/heads/main/hubparts/adoptmee.lua"))()
end)

CreateButton("Anti Aimbot (KEYBIND Z) (PC ONLY)", function()
local Toggled = true
local KeyCode = 'z'
local hip = 2.80
local val = -35





function AA()
    local oldVelocity = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(oldVelocity.X, val, oldVelocity.Z)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(oldVelocity.X, oldVelocity.Y, oldVelocity.Z)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(oldVelocity.X, val, oldVelocity.Z)
    game.Players.LocalPlayer.Character.Humanoid.HipHeight = hip
end

game:GetService('UserInputService').InputBegan:Connect(function(Key)
    if Key.KeyCode == Enum.KeyCode[KeyCode:upper()] and not game:GetService('UserInputService'):GetFocusedTextBox() then
        if Toggled then
            Toggled = false
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = hip

        elseif not Toggled then
            Toggled = true

            while Toggled do
                AA()
                task.wait()
            end
        end
    end
end)
end)

-- INITIALIZE LOAD
if isfile and isfile(FilePath) then
    pcall(function()
        local data = HttpService:JSONDecode(readfile(FilePath))
        if data.Rainbow then
            rainbowEnabled = true
            toggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
            toggleBG.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            UpdateRainbow()
        end
    end)
end

-- Entrance
hubFrame:TweenSizeAndPosition(UDim2.new(0, 500, 0, 380), UDim2.new(0.5, -250, 0.4, -190), "Out", "Back", 0.6, true)
