-- Cleanup: Removes old UI if the script is ran again
if game:GetService("CoreGui"):FindFirstChild("BridgeToggleGui") then
    game:GetService("CoreGui").BridgeToggleGui:Destroy()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZanoLeafVN/KavoMobileUI/main/KavoMobile.lua"))()
local Window = Library.CreateLib("Bridge For Brainrot | Wet hub", "BloodTheme")

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local searchTerm = ""
local NORMAL_TEXT = "grab"

-- Updated Helper Function with Retry Logic
local function stealBrainrot(targetSmallText)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local originalCFrame = hrp.CFrame
    local matches = {}

    -- Find matching prompts
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if string.lower(obj.ObjectText) == string.lower(targetSmallText) and string.lower(obj.ActionText) == NORMAL_TEXT then
                table.insert(matches, obj)
            end
        end
    end

    if #matches > 0 then
        local randomPrompt = matches[math.random(1, #matches)]
        local targetPart = randomPrompt.Parent
        if not targetPart:IsA("BasePart") then return end

        -- Smooth TP to target
        local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)})
        tween:Play()
        tween.Completed:Wait()

        -- Freeze character
        hrp.Anchored = true
        
        -- Retry Loop: Tries 2 times
        for i = 1, 2 do
            print("Attempting " .. targetSmallText .. " - Try #" .. i)
            
            task.wait(0.2)
            randomPrompt:InputHoldBegin()
            task.wait(randomPrompt.HoldDuration)
            randomPrompt:InputHoldEnd()
            
            -- Wait a moment to see if the item was taken/prompt disappeared
            task.wait(0.5)
            
            -- If the prompt is gone or disabled, we succeeded, so stop retrying
            if not randomPrompt.Parent or not randomPrompt.Enabled then
                break
            end
        end
        
        -- Final buffer before returning
        task.wait(0.5)
        hrp.Anchored = false
        hrp.CFrame = originalCFrame
        print("Completed sequence for: " .. targetSmallText)
    else
        print("Not found: " .. targetSmallText)
    end
end

-- TAB 1: PRESETS
local Tab = Window:NewTab("Stealing")
local SectionSteal = Tab:NewSection("Steals Brainrots")
SectionSteal:NewLabel("BETA VERSION")

SectionSteal:NewTextBox("BRAINROT NAME", "Type name and press ENTER", function(txt)
    searchTerm = txt
    if txt ~= "" then
        stealBrainrot(txt)
    end
end)

SectionSteal:NewButton("GO FIND! ✅", "Searches for that brainrot", function()
    if searchTerm ~= "" then
        stealBrainrot(searchTerm)
    end
end)

SectionSteal:NewButton("Steal Garama", "Steals that brainrot", function() 
    stealBrainrot("garama and madundung") 
end)

SectionSteal:NewButton("Steal Dul Dul Dul", "Steals that brainrot", function() 
    stealBrainrot("dul dul dul") 
end)

SectionSteal:NewButton("Steal Los Matteos", "Steals that brainrot", function() 
    stealBrainrot("los matteos") 
end)

--- // DRAGGABLE TOGGLE BUTTON // ---

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "BridgeToggleGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "B"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24.000
ToggleButton.Active = true
ToggleButton.Draggable = false -- Using custom logic for better mobile support

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

-- Toggle Click
ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- Custom Dragging Logic (Supports Mouse & Touch)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
