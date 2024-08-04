-- Load external library for GUI (replace URL with actual library source)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Create a customizable GUI window
local Window = OrionLib:MakeWindow({
    Name = "Whiteware public",
    HidePremium = false,
    IntroEnabled = false,
    IntroText = "Welcome to my script!",
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    Drag = true  -- Enabling draggable window
})

-- Global variables for toggling functionalities
_G.Autoblock = false
_G.Autohit = false
_G.AutoHatch = false
_G.SelectCrates = "Swords"
_G.InfiniteJump = false
_G.AutohitRange = 50  -- Default range for Autohit
_G.ReachExtenderEnabled = false
_G.ReachExtenderDistance = 100  -- Default reach extender distance
_G.BlockCooldown = 0.2  -- Default block cooldown in seconds
_G.WalkSpeed = 16  -- Default walk speed in Roblox

-- Function for Autoblock functionality
function Autoblock()
    while _G.Autoblock do
        local args = { [1] = true }
        game:GetService("ReplicatedStorage").Remotes.Character.Block:FireServer(unpack(args))
        wait(_G.BlockCooldown)  -- Use block cooldown from _G
        args = { [1] = false }
        game:GetService("ReplicatedStorage").Remotes.Character.Block:FireServer(unpack(args))
        wait(0.001)
    end
end

-- Function for AutoHatch functionality
function AutoHatch()
    while _G.AutoHatch do
        game:GetService("ReplicatedStorage").Remotes.Profile.Purchase:FireServer(_G.SelectCrates, 1)
        wait(0.1) -- Adding a small wait to prevent excessive looping
    end
end

-- Function for changing walkspeed
function ChangeWalkspeed(newSpeed)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = newSpeed
    end
end

-- Function for Autohit functionality
function Autohit()
    while wait() do
        if _G.Autohit then
            for i = 1, 2 do
                local players = game:GetService("Players"):GetPlayers()
                local localPlayer = game.Players.LocalPlayer
                local range = _G.AutohitRange  -- Use range variable from _G
                local closestPlayer = nil
                local closestDistance = math.huge

                -- Find the closest player
                for _, targetPlayer in ipairs(players) do
                    if targetPlayer ~= localPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (localPlayer.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = targetPlayer
                        end
                    end
                end

                -- Perform Autohit on the closest player without cooldown
                if closestPlayer and closestDistance <= range then
                    local args_swing = { [1] = 1 }
                    game:GetService("ReplicatedStorage").Remotes.Character.Swing:FireServer(unpack(args_swing))

                    local args_hit = { [1] = closestPlayer }
                    game:GetService("ReplicatedStorage").Remotes.Character.Hit:FireServer(unpack(args_hit))
                end
            end
        end
    end
end

-- Start the Autohit function
spawn(Autohit)

-- Create Autoblock tab
local Blocktab = Window:MakeTab({
    Name = "Autoblock",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add Autoblock toggle
Blocktab:AddToggle({
    Name = "Autoblock",
    Default = false,
    Callback = function(Value)
        _G.Autoblock = Value
        if _G.Autoblock then
            spawn(Autoblock)
        end
    end
})

-- Add Block Cooldown textbox
Blocktab:AddTextbox({
    Name = "Block Cooldown",
    Default = tostring(_G.BlockCooldown),
    TextDisappear = true,
    Callback = function(Value)
        local cooldown = tonumber(Value)
        if cooldown then
            _G.BlockCooldown = cooldown
        else
            print("Invalid block cooldown input:", Value)
        end
    end	  
})

-- Create Autohit tab
local Hittab = Window:MakeTab({
    Name = "Autohit",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add Autohit toggle
Hittab:AddToggle({
    Name = "Autohit",
    Default = false,
    Callback = function(Value)
        _G.Autohit = Value
    end
})

-- Add Autohit Range slider
Hittab:AddSlider({
    Name = "Autohit Range",
    Min = 10,
    Max = 500,
    Default = 50,
    Callback = function(Value)
        _G.AutohitRange = Value
    end
})

-- Add Reach Extender toggle
Hittab:AddToggle({
    Name = "Reach Extender",
    Default = false,
    Callback = function(Value)
        _G.ReachExtenderEnabled = Value
    end
})

-- Add Reach Extender Distance slider
Hittab:AddSlider({
    Name = "Reach Extender Distance",
    Min = 10,
    Max = 500,
    Default = 100,
    Callback = function(Value)
        _G.ReachExtenderDistance = Value
    end
})

-- Create AutoHatch tab
local Hatchtab = Window:MakeTab({
    Name = "AutoHatch",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add AutoHatch toggle
Hatchtab:AddToggle({
    Name = "AutoHatch",
    Default = false,
    Callback = function(Value)
        _G.AutoHatch = Value
        if _G.AutoHatch then
            spawn(AutoHatch)
        end
    end
})

-- Add Select Crates dropdown
Hatchtab:AddDropdown({
    Name = "Select Crates",
    Default = "Swords",
    Options = {"Swords", "Shields"},
    Callback = function(Value)
        _G.SelectCrates = Value
    end
})

-- Create Misc tab
local Misctab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add Walkspeed textbox
Misctab:AddTextbox({
    Name = "Walkspeed",
    Default = tostring(_G.WalkSpeed),
    TextDisappear = true,
    Callback = function(Value)
        local walkspeed = tonumber(Value)
        if walkspeed then
            _G.WalkSpeed = walkspeed
            ChangeWalkspeed(walkspeed)
        else
            print("Invalid walkspeed input:", Value)
        end
    end
})

-- Add Walkspeed Slider
Misctab:AddSlider({
    Name = "Walkspeed Slider",
    Min = 1,
    Max = 200,
    Default = 16, -- Default walk speed in Roblox is 16
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        ChangeWalkspeed(Value)
    end
})

-- Add Infinite Jump toggle
Misctab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJump = Value
        if _G.InfiniteJump then
            spawn(InfiniteJump)
        end
    end
})

-- Add Inf Jump Player functionality
local InfJumpTab = Window:MakeTab({
    Name = "Inf Jump Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local UserInputService = game:GetService("UserInputService")
local targetPlayerName = game:GetService("Players").LocalPlayer.Name
local infJumpActive = false
local playerConnections = {}

local function onJumpRequest()
    if infJumpActive then
        local targetPlayer = nil

        if targetPlayerName == "all" then
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    for i = 1, 10 do
                        local args = {
                            [1] = player.Character.HumanoidRootPart,
                            [2] = Vector3.new(-29.347702026367188, 87.36488342285156, -38.80836868286133)
                        }
                        game:GetService("ReplicatedStorage").Remotes.Knockback:FireServer(unpack(args))
                        wait(0.5)
                    end
                end
            end
        elseif targetPlayerName == "random" then
            local players = game:GetService("Players"):GetPlayers()
            local randomPlayer = players[math.random(1, #players)]
            if randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for i = 1, 10 do
                    local args = {
                        [1] = randomPlayer.Character.HumanoidRootPart,
                        [2] = Vector3.new(-29.347702026367188, 87.36488342285156, -38.80836868286133)
                    }
                    game:GetService("ReplicatedStorage").Remotes.Knockback:FireServer(unpack(args))
                    wait(0.5)
                end
            end
        else
            targetPlayer = game:GetService("Players"):FindFirstChild(targetPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for i = 1, 10 do
                    local args = {
                        [1] = targetPlayer.Character.HumanoidRootPart,
                        [2] = Vector3.new(-29.347702026367188, 87.36488342285156, -38.80836868286133)
                    }
                    game:GetService("ReplicatedStorage").Remotes.Knockback:FireServer(unpack(args))
                    wait(0.5)
                end
            end
        end
    end
end

InfJumpTab:AddTextbox({
    Name = "Target Player",
    Default = targetPlayerName,
    TextDisappear = true,
    Callback = function(Value)
        targetPlayerName = Value
    end
})

InfJumpTab:AddToggle({
    Name = "Infinite Jump Player",
    Default = false,
    Callback = function(Value)
        infJumpActive = Value
        if infJumpActive then
            if not playerConnections.jumpRequest then
                playerConnections.jumpRequest = UserInputService.JumpRequest:Connect(onJumpRequest)
            end
        else
            if playerConnections.jumpRequest then
                playerConnections.jumpRequest:Disconnect()
                playerConnections.jumpRequest = nil
            end
        end
    end
})

-- Function to enable infinite jump
function InfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfiniteJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

-- Initialize infinite jump if toggled on by default
if _G.InfiniteJump then
    spawn(InfiniteJump)
end

-- Notification for script loaded
OrionLib:MakeNotification({
    Name = "Script Loaded",
    Content = "All functionalities are ready to use!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Initialize walkspeed on script load
ChangeWalkspeed(_G.WalkSpeed)

-- Initialize GUI
OrionLib:Init()
