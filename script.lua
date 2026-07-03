-- =============================================
-- DEATHNESS UE V4.5 - IMPROVED PRIVATE BUILD
-- Strict Key: Presurefixhd
-- =============================================

local function SecureFetch(url)
    local success, result = pcall(function()
        if game and game.HttpGet then return game:HttpGet(url, true) end
        if request then return request({Url=url,Method="GET"}).Body end
        if http and http.request then return http.request({Url=url,Method="GET"}).Body end
    end)
    return success and result or nil
end

local Rayfield = loadstring(SecureFetch("https://sirius.menu/rayfield"))()
if not Rayfield then warn("Rayfield failed to load") return end

local Window = Rayfield:CreateWindow({
    Name = "KEY SYSTEM | Deathness UE V4.5",
    LoadingTitle = "Deathness UE",
    LoadingSubtitle = "Private Key Only",
    KeySystem = true,
    KeySettings = {
        Title = "Deathness UE Private Key",
        Subtitle = "Enter Key",
        Note = "Key required EVERY TIME the script loads",
        FileName = "DeathnessPrivateKey",
        SaveKey = false,          -- ← THIS IS THE FIX
        GrabKeyFromSite = false,
        Key = {"Presurefixhd"}
    }
})

setclipboard("https://discord.gg/Hhrpe3X559")
setclipboard("Presurefixhd")

task.spawn(function()
    repeat task.wait(0.5) until Window
    Rayfield:Destroy()

    local MainRayfield = loadstring(SecureFetch("https://sirius.menu/rayfield"))()
    local MainWindow = MainRayfield:CreateWindow({
        Name = "Deathness UE V4.5 🔥",
        LoadingTitle = "Loading Core Engine...",
        LoadingSubtitle = "Private Build"
    })

    local CombatTab = MainWindow:CreateTab("Combat", 6026568198)
    local VoidTab   = MainWindow:CreateTab("Void", 4483362458)
    local AdvTab    = MainWindow:CreateTab("Advanced", 6031097228)

    -- Services
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    LocalPlayer.CharacterAdded:Connect(function(new) 
        Character = new 
        HRP = new:WaitForChild("HumanoidRootPart") 
    end)

    -- ===================== CONFIG =====================
    local config = {
        aimbotEnabled = false,
        aimSmooth = 50,
        visibleOnly = true,
        targetPart = "Head",

        silentAimEnabled = false,
        hitChance = 100,
        silentTargetPart = "Head",

        voidActive = false,
        fakeDesyncActive = false,
        meowDesyncActive = false,
        voidSpamTime = 0.1,
        fakePosition = nil,
    }

    local connections = {}
    local lastVoid = 0

    -- ===================== AIMBOT =====================
    local function GetClosestPlayer()
        local closest, dist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                local part = plr.Character:FindFirstChild(config.targetPart) or root
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if distance < dist then
                            dist = distance
                            closest = plr
                        end
                    end
                end
            end
        end
        return closest
    end

    connections.aimbot = RunService.RenderStepped:Connect(function()
        if not config.aimbotEnabled then return end
        local target = GetClosestPlayer()
        if not target or not target.Character then return end

        local aimPart = target.Character:FindFirstChild(config.targetPart) or target.Character:FindFirstChild("HumanoidRootPart")
        if aimPart then
            local targetPos = aimPart.Position
            local direction = (targetPos - Camera.CFrame.Position).Unit
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction), config.aimSmooth / 100)
        end
    end)

    -- ===================== SILENT AIM =====================
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if config.silentAimEnabled and method == "FireServer" and (self.Name:lower():find("bullet") or self.Name:lower():find("shoot")) then
            if math.random(1,100) <= config.hitChance then
                local target = GetClosestPlayer()
                if target and target.Character then
                    local part = target.Character:FindFirstChild(config.silentTargetPart) or target.Character:FindFirstChild("Head")
                    if part then
                        args[1] = part.Position + Vector3.new(math.random(-1,1), math.random(-0.5,0.5), math.random(-1,1))
                    end
                end
            end
        end

        return oldNamecall(self, unpack(args))
    end)

    setreadonly(mt, true)

    -- ===================== DESYNC =====================
    local function UpdateDesync()
        for _, v in pairs(connections) do 
            if v ~= connections.aimbot then v:Disconnect() end 
        end

        if config.voidActive or config.fakeDesyncActive or config.meowDesyncActive then
            connections.desync = RunService.Heartbeat:Connect(function()
                local now = tick()
                if config.voidActive and now - lastVoid >= config.voidSpamTime then
                    lastVoid = now
                    if HRP then
                        config.fakePosition = HRP.CFrame
                        local offset = Vector3.new(math.random(-20000000,20000000), math.random(10000000,40000000), math.random(-20000000,20000000))
                        HRP.CFrame = HRP.CFrame + offset

                        task.delay(0.05, function()
                            if HRP and config.fakePosition then HRP.CFrame = config.fakePosition end
                        end)
                    end
                end
            end)
        end
    end

    -- ===================== UI =====================
    CombatTab:CreateSection("Aimbot")
    CombatTab:CreateToggle({Name = "Aimbot", CurrentValue = config.aimbotEnabled, Callback = function(v) config.aimbotEnabled = v end})
    CombatTab:CreateSlider({Name = "Smooth %", Range = {1, 100}, Increment = 1, CurrentValue = config.aimSmooth, Callback = function(v) config.aimSmooth = v end})
    CombatTab:CreateToggle({Name = "Visible Only", CurrentValue = config.visibleOnly, Callback = function(v) config.visibleOnly = v end})
    CombatTab:CreateDropdown({Name = "Target Part", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, CurrentOption = {"Head"}, Callback = function(opt) config.targetPart = opt[1] end})

    CombatTab:CreateSection("Silent Aim")
    CombatTab:CreateToggle({Name = "Silent Aim", CurrentValue = config.silentAimEnabled, Callback = function(v) config.silentAimEnabled = v end})
    CombatTab:CreateSlider({Name = "Hit Chance %", Range = {1, 100}, Increment = 1, CurrentValue = config.hitChance, Callback = function(v) config.hitChance = v end})
    CombatTab:CreateDropdown({Name = "Silent Target", Options = {"Head", "UpperTorso"}, CurrentOption = {"Head"}, Callback = function(opt) config.silentTargetPart = opt[1] end})

    VoidTab:CreateSection("Desync Systems")
    VoidTab:CreateToggle({Name = "Void Protocol", CurrentValue = config.voidActive, Callback = function(v) config.voidActive = v UpdateDesync() end})
    VoidTab:CreateToggle({Name = "Fake Desync", CurrentValue = config.fakeDesyncActive, Callback = function(v) config.fakeDesyncActive = v UpdateDesync() end})
    VoidTab:CreateToggle({Name = "Meow Desync", CurrentValue = config.meowDesyncActive, Callback = function(v) config.meowDesyncActive = v UpdateDesync() end})
    VoidTab:CreateSlider({Name = "Void Spam Time (s)", Range = {0.01, 1.00}, Increment = 0.01, CurrentValue = config.voidSpamTime, Callback = function(v) config.voidSpamTime = v end})

    AdvTab:CreateSection("Info")
    AdvTab:CreateLabel("Fake Position: Opponents appear frozen on last seen position")

    MainRayfield:Notify({Title = "Deathness UE V4.5", Content = "Loaded Successfully - Private Build", Duration = 4})
end)
