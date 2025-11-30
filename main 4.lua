-- Roblox Fly Script with UI
-- Made by dex2000____
 
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
 
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
 
-- Settings
local flyEnabled = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local currentSpeed = 16
local flyHeight = 2
local lowHealthThreshold = 0.4 -- 40% health
local isUIMinimized = false
 
-- Fly variables
local flying = false
local currentTarget = nil
local flyConnection = nil
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
 
-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui
 
-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0, 0) -- Dark red
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.new(0, 0, 1) -- Blue border
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
 
-- Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.new(0.3, 0, 0)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true
titleBar.Parent = mainFrame
 
-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "SentryHub Aura Battles"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar
 
-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0.3, 0, 1, 0)
minimizeButton.Position = UDim2.new(0.7, 0, 0, 0)
minimizeButton.BackgroundColor3 = Color3.new(0.5, 0, 0)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 16
minimizeButton.Parent = titleBar
 
-- Content Frame (for minimizing)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0, 275)
contentFrame.Position = UDim2.new(0, 0, 0, 25)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame
 
-- Made by label
local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(1, 0, 0, 18)
madeBy.Position = UDim2.new(0, 0, 0, 0)
madeBy.BackgroundTransparency = 1
madeBy.TextColor3 = Color3.new(0, 1, 1)
madeBy.Text = "Made by dex2000____"
madeBy.Font = Enum.Font.SourceSans
madeBy.TextSize = 12
madeBy.Parent = contentFrame
 
-- Discord Link
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, 0, 0, 35)
discordLabel.Position = UDim2.new(0, 0, 0, 18)
discordLabel.BackgroundTransparency = 1
discordLabel.TextColor3 = Color3.new(1, 1, 0)
discordLabel.Text = "Join our discord server for more information\nhttps://discord.gg/BXEGMV44G"
discordLabel.Font = Enum.Font.SourceSans
discordLabel.TextSize = 11
discordLabel.TextWrapped = true
discordLabel.Parent = contentFrame
 
-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0.9, 0, 0, 25)
flyToggle.Position = UDim2.new(0.05, 0, 0, 60)
flyToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
flyToggle.TextColor3 = Color3.new(1, 1, 1)
flyToggle.Text = "Fly: OFF"
flyToggle.Font = Enum.Font.SourceSansBold
flyToggle.TextSize = 14
flyToggle.Parent = contentFrame
 
-- Noclip Toggle
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0.9, 0, 0, 25)
noclipToggle.Position = UDim2.new(0.05, 0, 0, 90)
noclipToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
noclipToggle.TextColor3 = Color3.new(1, 1, 1)
noclipToggle.Text = "Noclip: OFF"
noclipToggle.Font = Enum.Font.SourceSansBold
noclipToggle.TextSize = 14
noclipToggle.Parent = contentFrame
 
-- Infinite Jump Toggle
local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0.9, 0, 0, 25)
jumpToggle.Position = UDim2.new(0.05, 0, 0, 120)
jumpToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
jumpToggle.TextColor3 = Color3.new(1, 1, 1)
jumpToggle.Text = "Inf Jump: OFF"
jumpToggle.Font = Enum.Font.SourceSansBold
jumpToggle.TextSize = 14
jumpToggle.Parent = contentFrame
 
-- Speed Changer Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 150)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Text = "Speed: " .. currentSpeed
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 14
speedLabel.Parent = contentFrame
 
-- Speed Slider
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0.9, 0, 0, 25)
speedSlider.Position = UDim2.new(0.05, 0, 0, 175)
speedSlider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.Text = tostring(currentSpeed)
speedSlider.PlaceholderText = "Speed (1-50)"
speedSlider.Font = Enum.Font.SourceSans
speedSlider.TextSize = 12
speedSlider.Parent = contentFrame
 
-- Apply Speed Button
local applySpeed = Instance.new("TextButton")
applySpeed.Size = UDim2.new(0.9, 0, 0, 25)
applySpeed.Position = UDim2.new(0.05, 0, 0, 205)
applySpeed.BackgroundColor3 = Color3.new(0, 0, 0.8)
applySpeed.TextColor3 = Color3.new(1, 1, 1)
applySpeed.Text = "Apply Speed"
applySpeed.Font = Enum.Font.SourceSansBold
applySpeed.TextSize = 14
applySpeed.Parent = contentFrame
 
-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 45)
statusLabel.Position = UDim2.new(0.05, 0, 0, 235)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(0, 1, 1)
statusLabel.Text = "Status: Ready"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = contentFrame
 
-- Functions
local function findLowHealthPlayer()
    local lowestHealth = math.huge
    local targetPlayer = nil
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherHumanoid and otherRoot and otherHumanoid.Health > 0 then
                local healthPercent = otherHumanoid.Health / otherHumanoid.MaxHealth
                
                if healthPercent <= lowHealthThreshold and healthPercent < lowestHealth then
                    lowestHealth = healthPercent
                    targetPlayer = otherPlayer
                end
            end
        end
    end
    
    return targetPlayer
end
 
local function instantTeleportToTarget(target)
    if not target or not target.Character then 
        statusLabel.Text = "Target not found!"
        return false
    end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        statusLabel.Text = "Target root part not found!"
        return false
    end
    
    -- Instant teleport directly above the target
    local targetPosition = targetRoot.Position + Vector3.new(0, flyHeight, 0)
    rootPart.CFrame = CFrame.new(targetPosition)
    
    statusLabel.Text = "Teleported to: " .. target.Name
    return true
end
 
local function startFlyingAboveTarget(target)
    if not target or not target.Character then 
        statusLabel.Text = "Target lost!"
        return false
    end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then 
        statusLabel.Text = "Target root part lost!"
        return false
    end
    
    -- Enable flying
    flying = true
    currentTarget = target
    flyVelocity.Parent = rootPart
    
    statusLabel.Text = "Flying above: " .. target.Name
    
    -- Disconnect previous connection if exists
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not targetRoot or not rootPart or not flyEnabled then
            flying = false
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = nil
            currentTarget = nil
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        
        -- Check if target is still alive and low health
        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
        if not targetHumanoid or targetHumanoid.Health <= 0 then
            statusLabel.Text = "Target died! Finding new target..."
            flying = false
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = nil
            currentTarget = nil
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        
        -- Get current target position
        local targetPosition = targetRoot.Position + Vector3.new(0, flyHeight, 0)
        
        -- Calculate distance to target
        local distance = (targetPosition - rootPart.Position).Magnitude
        
        -- If we're too far (more than 10 studs), teleport instantly
        if distance > 10 then
            rootPart.CFrame = CFrame.new(targetPosition)
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
        else
            -- If we're close, use smooth flying to maintain position
            local direction = (targetPosition - rootPart.Position).Unit
            flyVelocity.Velocity = direction * math.min(currentSpeed * 2, distance * 5)
        end
    end)
    
    return true
end
 
local function findAndFlyToTarget()
    local target = findLowHealthPlayer()
    
    if target then
        statusLabel.Text = "Found target: " .. target.Name
        -- First instant teleport to target
        if instantTeleportToTarget(target) then
            wait(0.1) -- Very small delay
            -- Then start flying above them
            startFlyingAboveTarget(target)
        end
    else
        statusLabel.Text = "No low health players found, please wait"
        flying = false
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = nil
        currentTarget = nil
    end
end
 
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyToggle.BackgroundColor3 = Color3.new(0, 0.8, 0)
        flyToggle.Text = "Fly: ON"
        statusLabel.Text = "Fly enabled - Finding players with <40% health..."
        
        -- Auto-fly to low health players
        spawn(function()
            while flyEnabled do
                if not flying then
                    findAndFlyToTarget()
                end
                wait(1) -- Check for new targets every 1 second
            end
        end)
    else
        flyToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
        flyToggle.Text = "Fly: OFF"
        flying = false
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = nil
        currentTarget = nil
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        statusLabel.Text = "Fly disabled"
    end
end
 
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipToggle.BackgroundColor3 = Color3.new(0, 0.8, 0)
        noclipToggle.Text = "Noclip: ON"
        statusLabel.Text = "Noclip enabled"
    else
        noclipToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
        noclipToggle.Text = "Noclip: OFF"
        statusLabel.Text = "Noclip disabled"
    end
end
 
local function toggleInfiniteJump()
    infiniteJumpEnabled = not infiniteJumpEnabled
    
    if infiniteJumpEnabled then
        jumpToggle.BackgroundColor3 = Color3.new(0, 0.8, 0)
        jumpToggle.Text = "Inf Jump: ON"
        statusLabel.Text = "Infinite Jump enabled"
    else
        jumpToggle.BackgroundColor3 = Color3.new(0.8, 0, 0)
        jumpToggle.Text = "Inf Jump: OFF"
        statusLabel.Text = "Infinite Jump disabled"
    end
end
 
local function applyNewSpeed()
    local newSpeed = tonumber(speedSlider.Text)
    
    if newSpeed and newSpeed >= 1 and newSpeed <= 50 then
        currentSpeed = newSpeed
        humanoid.WalkSpeed = currentSpeed
        speedLabel.Text = "Speed: " .. currentSpeed
        statusLabel.Text = "Speed set to: " .. currentSpeed
    else
        statusLabel.Text = "Invalid speed! Use 1-50"
    end
end
 
local function toggleMinimize()
    isUIMinimized = not isUIMinimized
    
    if isUIMinimized then
        contentFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 250, 0, 25)
        minimizeButton.Text = "+"
        statusLabel.Text = "UI Minimized"
    else
        contentFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 250, 0, 300)
        minimizeButton.Text = "_"
        statusLabel.Text = "UI Restored"
    end
end
 
-- Event connections
flyToggle.MouseButton1Click:Connect(toggleFly)
noclipToggle.MouseButton1Click:Connect(toggleNoclip)
jumpToggle.MouseButton1Click:Connect(toggleInfiniteJump)
applySpeed.MouseButton1Click:Connect(applyNewSpeed)
minimizeButton.MouseButton1Click:Connect(toggleMinimize)
 
-- Input handling for infinite jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
 
-- Noclip function
local function noclip()
    if noclipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end
 
-- Noclip loop
RunService.Stepped:Connect(noclip)
 
-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reapply speed after respawn
    if currentSpeed then
        humanoid.WalkSpeed = currentSpeed
    end
    
    -- Reset flying state
    flying = false
    flyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyVelocity.Parent = nil
    currentTarget = nil
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end)
 
-- Apply initial speed
humanoid.WalkSpeed = currentSpeed
statusLabel.Text = "Script loaded! Made by dex2000____"
 
print("Fly Script v2.0 loaded successfully!")
print("Made by dex2000____")
print("Discord: https://discord.gg/BXEGMV44G")