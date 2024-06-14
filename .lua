if game.PlaceId == 5922311258 then
    local adminList = {
        6146262434,  -- Replace with actual user ID
        10929201,  -- Replace with actual user ID
        111111111,  -- Replace with actual user ID
        1886028580,  -- Replace with actual user ID
        333333333,  -- Replace with actual user ID
        444444444,  -- Replace with actual user ID
        555555555,  -- Replace with actual user ID
        666666666,  -- Replace with actual user ID
        777777777,  -- Replace with actual user ID
        888888888   -- Replace with actual user ID
    }

    local player = game.Players.LocalPlayer
    local isAdmin = false

    for _, userId in ipairs(adminList) do
        if player.UserId == userId then
            isAdmin = true
            break
        end
    end

    if isAdmin then
        local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
        local Window = OrionLib:MakeWindow({
            Name = "fight park private script made by (whitey_plays)",
            HidePremium = false,
            IntroEnabled = false,
            IntroText = "fight park",
            SaveConfig = true,
            ConfigFolder = "OrionTest",
            Drag = true  -- Enabling draggable window
        })

        _G.Autoblock = false
        _G.Autohit = false
        _G.AutoHatch = false
        _G.SelectCrates = "Swords"

        function Autoblock()
            while _G.Autoblock do
                local args = {
                    [1] = true
                }
                game:GetService("ReplicatedStorage").Remotes.Character.Block:FireServer(unpack(args))
                wait(0.2)
                args = {
                    [1] = false
                }
                game:GetService("ReplicatedStorage").Remotes.Character.Block:FireServer(unpack(args))
                wait(0.001)
            end
        end

        function AutoHatch()
            while _G.AutoHatch do
                game:GetService("ReplicatedStorage").Remotes.Profile.Purchase:FireServer(_G.SelectCrates, 1)
                wait(0.1) -- Adding a small wait to prevent excessive looping
            end
        end

        function Autohit()
            while _G.Autohit do
                local players = game:GetService("Players"):GetPlayers()
                local playerCharacter = game.Players.LocalPlayer.Character
                local range = 50

                for _, player in ipairs(players) do
                    local targetCharacter = player.Character

                    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                        local distance = (playerCharacter.HumanoidRootPart.Position - targetCharacter.HumanoidRootPart.Position).Magnitude

                        if distance <= range then
                            local args_swing = {
                                [1] = 1
                            }
                            game:GetService("ReplicatedStorage").Remotes.Character.Swing:FireServer(unpack(args_swing))

                            local args_hit = {
                                [1] = player
                            }
                            game:GetService("ReplicatedStorage").Remotes.Character.Hit:FireServer(unpack(args_hit))
                        end
                    end
                end
                wait() -- Yield to avoid excessive looping
            end
        end

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

        OrionLib:Init()
    else
        print("You are not an admin.")
    end
end
