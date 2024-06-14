-- Check if the current game's PlaceId matches the target game
if game.PlaceId == 5922311258 then
    -- List of admin user IDs (replace with actual IDs)
    local adminList = {
        6146262434,  -- Replace with actual user ID
        987654321,   -- Replace with actual user ID
        111111111,   -- Replace with actual user ID
        222222222,   -- Replace with actual user ID
        333333333,   -- Replace with actual user ID
        444444444,   -- Replace with actual user ID
        555555555,   -- Replace with actual user ID
        666666666,   -- Replace with actual user ID
        777777777,   -- Replace with actual user ID
        888888888    -- Replace with actual user ID
    }

    local player = game.Players.LocalPlayer
    local isAdmin = false

    -- Check if player is in admin list
    for _, userId in ipairs(adminList) do
        if player.UserId == userId then
            isAdmin = true
            break
        end
    end

    if isAdmin then
        -- Load external library for GUI (replace URL with actual library source)
        local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
        
        -- Create a customizable GUI window
        local Window = OrionLib:MakeWindow({
            Name = "fight park private script made by (whitey_plays)",
            HidePremium = false,
            IntroEnabled = false,
            IntroText = "fight park",
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

        -- Function for Autoblock functionality
        function Autoblock()
            while _G.Autoblock do
                local args = { [1] = true }
                game:GetService("ReplicatedStorage").Remotes.Character.Block:FireServer(unpack(args))
                wait(0.2)
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

        -- Function for Autohit functionality
        function Autohit()
            while _G.Autohit do
                local players = game:GetService("Players"):GetPlayers()
                local playerCharacter = game.Players.LocalPlayer.Character
                local range = _G.AutohitRange  -- Use range variable from _G

                for _, targetPlayer in ipairs(players) do
                    if targetPlayer ~= player then
                        local targetCharacter = targetPlayer.Character
                        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                            local distance = (playerCharacter.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude
                            local reachDistance = _G.ReachExtenderEnabled and _G.ReachExtenderDistance or range
                            if distance <= reachDistance then
                                local args_swing = { [1] = 1 }
                                game:GetService("ReplicatedStorage").Remotes.Character.Swing:FireServer(unpack(args_swing))

                                local args_hit = { [1] = targetPlayer }
                                game:GetService("ReplicatedStorage").Remotes.Character.Hit:FireServer(unpack(args_hit))
                            end
                        end
                    end
                end
                wait() -- Yield to avoid excessive looping
            end
        end

        -- Function for InfiniteJump functionality
        function InfiniteJump()
            local InfiniteJumpEnabled = true
            game:GetService("UserInputService").JumpRequest:connect(function()
                if InfiniteJumpEnabled then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
                end
            end)
        end

        -- Function for changing walkspeed
        function ChangeWalkspeed(newSpeed)
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = newSpeed
            end
        end

        -- Create tabs and controls in the GUI window
        local Blocktab = Window:MakeTab({
            Name = "Auto Block (fight park)",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

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

        local Hittab = Window:MakeTab({
            Name = "Auto Hit (fight park)",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

        Hittab:AddToggle({
            Name = "Autohit",
            Default = false,
            Callback = function(Value)
                _G.Autohit = Value
                if _G.Autohit then
                    spawn(Autohit)
                end
            end
        })

        Hittab:AddToggle({
            Name = "Reach Extender",
            Default = false,
            Callback = function(Value)
                _G.ReachExtenderEnabled = Value
            end
        })

        Hittab:AddSlider({
            Name = "Reach Extender Distance",
            Min = 10,
            Max = 500,
            Default = 100,
            Callback = function(Value)
                _G.ReachExtenderDistance = Value
            end
        })

        Hittab:AddTextbox({
            Name = "Textbox",
            Default = "default box input",
            TextDisappear = true,
            Callback = function(Value)
                print(Value)
                -- Additional logic related to the textbox input can be added here
            end	  
        })

        -- Function for toggling Reach Extender
        local function ToggleReachExtender()
            _G.ReachExtenderEnabled = not _G.ReachExtenderEnabled
            -- Additional logic can be added here if needed
        end

        -- Add text button for Toggle Reach Extender
        Hittab:AddButton({
            Name = "Toggle Reach Extender",
            Callback = function()
                ToggleReachExtender()
            end
        })

        local Hatchtab = Window:MakeTab({
            Name = "Hatch (fight park)",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

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

        Hatchtab:AddDropdown({
            Name = "Select Crates",
            Default = "Swords",
            Options = {"Swords", "Shields"},
            Callback = function(Value)
                _G.SelectCrates = Value
            end
        })

        local Misctab = Window:MakeTab({
            Name = "Misc (fight park)",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

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

        -- Initialize the GUI window
        OrionLib:Init()
    else
        print("You are not an admin.")
    end
else
    print("This script is intended for a different game.")
end
