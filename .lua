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

        -- Function for Autohit functionality
        function Autohit(numTimes)
            for _ = 1, numTimes do
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
                wait() -- Yield to avoid excessive looping
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
                    spawn(function()
                        Autohit(1) -- Start with 1 iteration
                    end)
                end
            end
        })

        -- Add Autohit button for a million times
        Hittab:AddButton({
            Name = "Autohit 1,000,000 times",
            Callback = function()
                if _G.Autohit then
                    for _ = 1, 1000000 do
                        Autohit(1) -- Execute Autohit once per iteration
                    end
                end
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

        -- Add Hit Cooldown textbox
        Hittab:AddTextbox({
            Name = "Hit Cooldown",
            Default = tostring(_G.HitCooldown),
            TextDisappear = true,
            Callback = function
                    function(Value)
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

        -- Add Autohatch toggle
        Hatchtab:AddToggle({
            Name = "Autohatch",
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

        -- Create Owner Controls tab (visible only to owners)
        if isOwner then
            local OwnerControlstab = Window:MakeTab({
                Name = "Owner Controls",
                Icon = "rbxassetid://4483345998",
                PremiumOnly = false
            })

            -- Add Teleport Admin functionality
            OwnerControlstab:AddTextbox({
                Name = "Teleport Admin (UserID)",
                Default = "",
                TextDisappear = false,
                Callback = function(Value)
                    local userId = tonumber(Value)
                    if userId then
                        local adminPlayer = findAdminPlayer(userId)
                        if adminPlayer then
                            TeleportAdmin(adminPlayer)
                        else
                            print("Admin with UserID", userId, "not found.")
                        end
                    else
                        print("Invalid UserID input:", Value)
                    end
                end
            })

            -- Add Kill Admin functionality
            OwnerControlstab:AddTextbox({
                Name = "Kill Admin (UserID)",
                Default = "",
                TextDisappear = false,
                Callback = function(Value)
                    local userId = tonumber(Value)
                    if userId then
                        local adminPlayer = findAdminPlayer(userId)
                        if adminPlayer then
                            KillAdmin(adminPlayer)
                        else
                            print("Admin with UserID", userId, "not found.")
                        end
                    else
                        print("Invalid UserID input:", Value)
                    end
                end
            })

            -- Add Kick Admin functionality
            OwnerControlstab:AddTextbox({
                Name = "Kick Admin (UserID)",
                Default = "",
                TextDisappear = false,
                Callback = function(Value)
                    local userId = tonumber(Value)
                    if userId then
                        local adminPlayer = findAdminPlayer(userId)
                        if adminPlayer then
                            KickAdmin(adminPlayer)
                        else
                            print("Admin with UserID", userId, "not found.")
                        end
                    else
                        print("Invalid UserID input:", Value)
                    end
                end
            })

            -- Add Button to execute Autohit a million times
            OwnerControlstab:AddButton({
                Name = "Autohit 1,000,000 times",
                Callback = function()
                    if _G.Autohit then
                        for _ = 1, 1000000 do
                            Autohit(1) -- Execute Autohit once per iteration
                        end
                    end
                end
            })
        end

        -- Initialize the GUI window
        OrionLib:Init()

    else
        print("You are not an admin or owner.")
    end

else
    print("This script is intended for a different game.")
    end
