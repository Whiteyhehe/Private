-- Check if the current game's PlaceId matches the target game
if game.PlaceId == 5922311258 then
    -- List of admin user IDs (replace with actual IDs)
    local adminList = {
        1234567890,  -- Replace with actual admin UserIds
        -- Add more admin UserIds as needed
    }
    
    -- List of owner user IDs (replace with actual IDs)
    local ownerList = {
        1886028580,   -- Replace with actual owner UserIds
        -- Add more owner UserIds as needed
    }
    
    local player = game.Players.LocalPlayer
    local isAdmin = false
    local isOwner = false

    -- Check if player is in admin or owner list
    for _, userId in ipairs(adminList) do
        if player.UserId == userId then
            isAdmin = true
            break
        end
    end

    for _, userId in ipairs(ownerList) do
        if player.UserId == userId then
            isOwner = true
            break
        end
    end

    if isAdmin or isOwner then
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
        _G.BlockCooldown = 0.2  -- Default block cooldown in seconds
        _G.HitCooldown = 0.5  -- Default hit cooldown in seconds
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

        -- Function for Autohit functionality (fast execution)
        local function Autohit()
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
                            wait(_G.HitCooldown)  -- Use hit cooldown from _G
                        end
                    end
                end
            end
        end

        -- Function for faster Autohit execution using RunService
        local function FastAutohit()
            game:GetService("RunService").Stepped:connect(function()
                if _G.Autohit then
                    Autohit()
                end
            end)
        end

        -- Function for executing Autohit multiple times
        function ExecuteAutohitManyTimes(count)
            for i = 1000000, count do
                Autohit()
            end
        end

        -- Function for InfiniteJump functionality
        function InfiniteJump()
            local InfiniteJumpEnabled = true
            game:GetService("UserInputService").JumpRequest:Connect(function()
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

        -- Function to find an admin player by their UserId
        local function findAdminPlayer(userId)
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.UserId == userId then
                    return player
                end
            end
            return nil
        end

        -- Function to teleport an admin to the player
        function TeleportAdmin(adminPlayer)
            local adminCharacter = adminPlayer.Character
            local playerCharacter = player.Character
            if adminCharacter and playerCharacter then
                adminCharacter:SetPrimaryPartCFrame(playerCharacter.PrimaryPart.CFrame)
            end
        end

        -- Function to kill an admin
        function KillAdmin(adminPlayer)
            local adminHumanoid = adminPlayer.Character and adminPlayer.Character:FindFirstChildOfClass("Humanoid")
            if adminHumanoid then
                adminHumanoid.Health = 0
            end
        end

        -- Function to kick an admin
        function KickAdmin(adminPlayer)
            game:GetService("Players"):Kick(adminPlayer)
        end

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
                if _G.Autohit then
                    FastAutohit()  -- Start fast execution
                end
            end
        })

        -- Add Execute Autohit button
        Hittab:AddButton({
            Name = "Execute Autohit",
            Text = "Execute Autohit",
            Callback = function()
                ExecuteAutohitManyTimes(50)  -- Adjust the count as needed
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

        -- Add Range Extender Textbox
        Hittab:AddTextbox({
            Name = "Range Extender Distance",
            Default = tostring(_G.ReachExtenderDistance),
            TextDisappear = true,
            Callback = function(Value)
                local distance = tonumber(Value)
                if distance then
                    _G.ReachExtenderDistance = distance
                else
                    print("Invalid range extender distance input:", Value)
                end
            end
        })

        -- Add Hit Cooldown textbox
        Hittab:AddTextbox({
            Name = "Hit Cooldown",
            Default = tostring(_G.HitCooldown),
            TextDisappear = true,
            Callback = function(Value)
                local cooldown = tonumber(Value)
                if cooldown then
                    _G.HitCooldown = cooldown
                else
                    print("Invalid hit cooldown input:", Value)
                end
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
            Options = {"Swords", "Shields", "Gems"},  -- Example options
            Default = "Swords",  -- Default selection
            Callback = function(Value)
                _G.SelectCrates = Value
            end
        })

        -- Create Miscellaneous tab
        local MiscTab = Window:MakeTab({
            Name = "Miscellaneous",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

        -- Add Infinite Jump toggle
        MiscTab:AddToggle({
            Name = "Infinite Jump",
            Default = false,
            Callback = function(Value)
                _G.InfiniteJump = Value
                if _G.InfiniteJump then
                    InfiniteJump()
                end
            end
        })

        -- Add Walkspeed slider
        MiscTab:AddSlider({
            Name = "Walkspeed",
            Min = 10,
            Max = 100,
            Default = _G.WalkSpeed,
            Callback = function(Value)
                _G.WalkSpeed = Value
                ChangeWalkspeed(Value)
            end
        })

        -- Add credits
        local InfoTab = Window:MakeTab({
            Name = "Info",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

        -- Add credits textbox
        InfoTab:AddTextbox({
            Name = "Credits",
            Text = "Made by whitey plays  im roolboxes thanks for credits ofc",
            TextDisappear = false
        })

        -- Function to find an admin player by their UserId
        local function findAdminPlayer(userId)
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.UserId == userId then
                    return player
                end
            end
            return nil
        end

        -- Function to teleport an admin to the player
        function TeleportAdmin(adminPlayer)
            local adminCharacter = adminPlayer.Character
            local playerCharacter = player.Character
            if adminCharacter and playerCharacter then
                adminCharacter:SetPrimaryPartCFrame(playerCharacter.PrimaryPart.CFrame)
            end
        end

        -- Function to kill an admin
        function KillAdmin(adminPlayer)
            local adminHumanoid = adminPlayer.Character and adminPlayer.Character:FindFirstChildOfClass("Humanoid")
            if adminHumanoid then
                adminHumanoid.Health = 0
            end
        end

        -- Function to kick an admin
        function KickAdmin(adminPlayer)
            game:GetService("Players"):Kick(adminPlayer)
        end

    end
end
                
